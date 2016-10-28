
# Installing package if not already installed (Stanton 2013)
EnsurePackage<-function(x)
{x <- as.character(x)
 if (!require(x,character.only=TRUE))
 {
   install.packages(pkgs=x,repos="http://cran.r-project.org")
   require(x,character.only=TRUE)
 }
}

#Identifying packages required  (Stanton 2013)
PrepareTwitter<-function()
{
  EnsurePackage("twitteR")
  EnsurePackage("stringr")
  EnsurePackage("ROAuth")
  EnsurePackage("RCurl")
  EnsurePackage("ggplot2")
  EnsurePackage("reshape")
  EnsurePackage("tm")
  EnsurePackage("RJSONIO")
  EnsurePackage("wordcloud")
  EnsurePackage("gridExtra")
  #EnsurePackage("gplots") Not required... ggplot2 is used
  EnsurePackage("plyr")
}

PrepareTwitter()

#Function to Authenticate Access to Twitter

Authentication<-function()
{
consumer_key <-"AKJsxNqX2D8uTo9orgjRirvWL"

consumer_secret <- "QOKk0ctHhbXNQ5QaipqofrZQzWM92mfkcoP60xe7HJzjSUCz6F"
access_token<-"2617540074-5l6gGJhCP8iw9DS7sVD9qsFaUGfWGO9fqlHt5Wg"
access_secret <- "VVMfNIzgPEUmCk5QyIWr5A4ZSC2Lxy7CERoUtWs4jAe0l"

 setup_twitter_oauth(consumer_key ,consumer_secret, access_token,  access_secret )
 
cred <- OAuthFactory$new(consumerKey='AKJsxNqX2D8uTo9orgjRirvWL', consumerSecret='QOKk0ctHhbXNQ5QaipqofrZQzWM92mfkcoP60xe7HJzjSUCz6F',requestURL='https://api.twitter.com/oauth/request_token',accessURL='https://api.twitter.com/oauth/access_token',authURL='https://api.twitter.com/oauth/authorize')

cred$handshake(cainfo="cacert.pem")
}

#Authentication()

#load(cred) # A credential obtained from twitter permitting access to their data - A user will need this to proceed
# Please see http://cran.r-project.org/web/packages/twitteR/vignettes/twitteR.pdf for more info on this.

#registerTwitterOAuth(credential)

shinyServer(function(input, output) {


	#TABLE
  #Search tweets and create a data frame -Stanton (2013)
	# Clean the tweets
  TweetFrame<-function(twtList)
  {
      #for (i in 2:length(dates)) {
      #tweets <- c(tweets, searchTwitter(searchTerm, since=dates[i-1], until=dates[i], n=maxTweets))
      #}
 
      df<- do.call("rbind",lapply(twtList,as.data.frame))
      #removes emoticons
	df$text <- sapply(df$text,function(row) iconv(row, "latin1", "ASCII", sub=""))
	df$text = gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", df$text)
      return (df$text)
   }

	# Function to create a data frame from tweets, Stanton 2013

	pos.words=scan('G:/Mita/Twitter Sentiment Analysis/positive-words.txt', what='character',comment.char=';')
	neg.words=scan('G:/Mita/Twitter Sentiment Analysis/negative-words.txt', what='character',comment.char=';')

	wordDatabase<-function()
	{
		pos.words<<-c(pos.words, 'Congrats', 'prizes', 'prize', 'thanks', 'thnx', 'Grt', 'gr8', 'plz', 'trending', 'recovering', 'brainstorm', 'leader')
		neg.words<<-c(neg.words, 'Fight', 'fighting', 'wtf', 'arrest', 'no', 'not')
	}

   score.sentiment <- function(sentences, pos.words, neg.words, .progress='none')
    {
	require(plyr)
	require(stringr)
	list=lapply(sentences, function(sentence, pos.words, neg.words)
	{
		sentence = gsub('[[:punct:]]',' ',sentence)
		sentence = gsub('[[:cntrl:]]','',sentence)
		sentence = gsub('\\d+','',sentence)
		sentence = gsub('\n','',sentence)

		sentence = tolower(sentence)
		word.list = str_split(sentence, '\\s+')
		words = unlist(word.list)
		pos.matches = match(words, pos.words)
		neg.matches = match(words, neg.words)
		pos.matches = !is.na(pos.matches)
		neg.matches = !is.na(neg.matches)
		pp=sum(pos.matches)
		nn = sum(neg.matches)
		score = sum(pos.matches) - sum(neg.matches)
		list1=c(score, pp, nn)
		return (list1)
	}, pos.words, neg.words)
	score_new=lapply(list, `[[`, 1)
	pp1=score=lapply(list, `[[`, 2)
	nn1=score=lapply(list, `[[`, 3)

	scores.df = data.frame(score=score_new, text=sentences)
	positive.df = data.frame(Positive=pp1, text=sentences)
	negative.df = data.frame(Negative=nn1, text=sentences)

	list_df=list(scores.df, positive.df, negative.df)
	return(list_df)
    }

 	library(reshape)
	sentimentAnalyser<-function(result)
	{
		#Creating a copy of result data frame
		test1=result[[1]]
		test2=result[[2]]
		test3=result[[3]]

		#Creating three different data frames for Score, Positive and Negative
		#Removing text column from data frame
		test1$text=NULL
		test2$text=NULL
		test3$text=NULL
		#Storing the first row(Containing the sentiment scores) in variable q
		q1=test1[1,]
		q2=test2[1,]
		q3=test3[1,]
		qq1=melt(q1, ,var='Score')
		qq2=melt(q2, ,var='Positive')
		qq3=melt(q3, ,var='Negative') 
		qq1['Score'] = NULL
		qq2['Positive'] = NULL
		qq3['Negative'] = NULL
		#Creating data frame
		table1 = data.frame(Text=result[[1]]$text, Score=qq1)
		table2 = data.frame(Text=result[[2]]$text, Score=qq2)
		table3 = data.frame(Text=result[[3]]$text, Score=qq3)
	
		#Merging three data frames into one
		table_final=data.frame(Text=table1$Text, Positive=table2$value, Negative=table3$value, Score=table1$value)
		return(table_final)
     }

	percentage<-function(table_final)
	{
		#Positive Percentage

		#Renaming
		posSc=table_final$Positive
		negSc=table_final$Negative

		#Adding column
		table_final$PosPercent = posSc/ (posSc+negSc)

		#Replacing Nan with zero
		pp = table_final$PosPercent
		pp[is.nan(pp)] <- 0
		table_final$PosPercent = pp*100

		#Negative Percentage

		#Adding column
		table_final$NegPercent = negSc/ (posSc+negSc)

		#Replacing Nan with zero
		nn = table_final$NegPercent
		nn[is.nan(nn)] <- 0
		table_final$NegPercent = nn*100

		return(table_final)
	}

	wordDatabase()

	#dates <- reactive({ as.Date(as.Date(Sys.Date()-input$noOfDays):as.Date(Sys.Date()), origin="1970-01-01") }) #SUGGESTION: Modify these dates of upto 7 days before running this program 
	#twtList<-reactive({twtList<-searchTwitter(input$searchTerm, n=input$maxTweets, since=dates()[1], until=dates()[2], lang="en") })
	
	#for (i in 3:length(dates())) {
  	#	twtList()<- c(twtList(), searchTwitter(input$searchTerm, n=input$maxTweets, since=dates()[i-1], until=dates()[i], lang="en"))
	#		}
	
	twtList<-reactive({twtList<-searchTwitter(input$searchTerm, n=input$maxTweets, lang="en") })
	tweets<-reactive({tweets<-TweetFrame(twtList() )})

	result<-reactive({result<-score.sentiment(tweets(), pos.words, neg.words, .progress='none')})
	
	table_final<-reactive({table_final<-sentimentAnalyser(  result() )})
	table_final_percentage<-reactive({table_final_percentage<-percentage(  table_final() )})
	
	output$tabledata<-renderTable(table_final_percentage())

	#TOP TRENDING TWEETS

	toptrends<-function(place)
	{
		a_trends = availableTrendLocations()
		woeid = a_trends[which(a_trends$name==place),3]
		trend = getTrends(woeid)
		trends = trend[1:2]

		#To clean data and remove Non English words: (not required)
		dat <- cbind(trends$name)
		dat2 <- unlist(strsplit(dat, split=", "))
		dat3 <- grep("dat2", iconv(dat2, "latin1", "ASCII", sub="dat2"))
		dat4 <- dat2[-dat3]
		#dat5 <- trends[,which(trends$name==dat4)]
		return(dat4)
	}

	trend_table<-reactive({trend_table<-toptrends(  input$trendingTable ) })
	output$trendtable<-renderTable(trend_table() )
	
	#TOP TRENDING TWEETS

	toptrends<-function(place)
	{
		a_trends = availableTrendLocations()
		woeid = a_trends[which(a_trends$name==place),3]
		trend = getTrends(woeid)
		trends = trend[1:2]

		#To clean data and remove Non English words: (not required)
		dat <- cbind(trends$name)
		dat2 <- unlist(strsplit(dat, split=", "))
		dat3 <- grep("dat2", iconv(dat2, "latin1", "ASCII", sub="dat2"))
		if(dat3==0)
		return(dat2)
		dat4 <- dat2[-dat3]
		
		return(dat4)
	}

	trend_table<-reactive({trend_table<-toptrends(  input$trendingTable ) })
	output$trendtable<-renderTable(trend_table() )	

	#WORDCLOUD

	wordclouds<-function(text)
	{
		library(tm)
		corpus<-Corpus(VectorSource(text))
		#corpus
		#inspect(corpus[1])
		#clean text
		clean_text <- tm_map(corpus, removePunctuation)
		#clean_text <- tm_map(clean_text, content_transformation)
		clean_text <- tm_map(clean_text, content_transformer(tolower))
		clean_text <- tm_map(clean_text, removeWords, stopwords("english"))
		clean_text <- tm_map(clean_text, removeNumbers)
		clean_text <- tm_map(clean_text, stripWhitespace)
		return(clean_text)
	}

	text_word<-reactive({text_word<-wordclouds(  tweets() ) })
	output$word<-renderPlot({wordcloud(text_word(), random.order=F,max.words=80, col=rainbow(100), scale=c(4.5,1.5))		
				})
	
	#HISTOGRAM

	output$histPos<- renderPlot({hist(table_final()$Positive, col=rainbow(10), main = "Histogram of Positive Sentiment", xlab = "Positive Score") })
	output$histNeg<- renderPlot({hist(table_final()$Negative, col=rainbow(10), main = "Histogram of Negative Sentiment", xlab = "Negative Score") })
	output$histScore<- renderPlot({hist(table_final()$Score, col=rainbow(10), main = "Histogram of Score", xlab = "Overall Score")})
	
	#PIE CHART
	
	slices <- reactive({c(sum(table_final()$Positive), sum(table_final()$Negative)) })
	labels <- c("Positive", "Negative")
	library(plotrix)
	#pie(slices(), labels = labels, col=rainbow(length(labels)), main="Sentiment Analysis")
	output$piechart<-renderPlot({pie3D(slices(), labels = labels, col=rainbow(length(labels)),explode=0.00, main="Sentiment Analysis") })
	
	#TOP TWEETERS

	# Top tweeters for a particular hashtag (Barplot)
	toptweeters<-function(tweetlist)
	{
		tweets <- twListToDF(tweetlist)
		tweets <- unique(tweets)
		# Make a table of the number of tweets per user
		d <- as.data.frame(table(tweets$screenName)) 
		d <- d[order(d$Freq, decreasing=T), ] #descending order of tweeters according to frequency of tweets
		names(d) <- c("User","Tweets")
		return (d)
	}
	
	# Plot the table above for the top 20

	d<-reactive({d<-toptweeters(  twtList() ) })
	output$tweetersplot<-renderPlot ( barplot(head(d()$Tweets, 20),  names=head(d()$User, 20), las=2, horiz=F, main="Top 20: Tweets per User", col=1) )
	output$tweeterstable<-renderTable(head(d(),20))

	#Top 10 TWEETERS

	tw1 <- reactive({ tw1 = userTimeline(input$user, n = 3200) })
	tw <- reactive({ tw = twListToDF(tw1()) })
	vec1<-reactive ({ vec1 = tw()$text })
 
	extract.hashes = function(vec){
 	
		hash.pattern = "#[[:alpha:]]+"
		have.hash = grep(x = vec, pattern = hash.pattern)
 
		hash.matches = gregexpr(pattern = hash.pattern,
                        text = vec[have.hash])
		extracted.hash = regmatches(x = vec[have.hash], m = hash.matches)
 
		df = data.frame(table(tolower(unlist(extracted.hash))))
		colnames(df) = c("tag","freq")
		df = df[order(df$freq,decreasing = TRUE),]
		return(df)
	}
 
	dat<-reactive({ dat = head(extract.hashes(vec1()),50) })
	dat2<- reactive ({ dat2 = transform(dat(),tag = reorder(tag,freq)) })

	p<- reactive ({ p = ggplot(dat2(), aes(x = tag, y = freq)) + geom_bar(stat="identity", fill = "blue")
	p + coord_flip() + labs(title = "Hashtag frequencies in the tweets of the tweeter") })
	output$tophashtagsplot <- renderPlot ({ p() })	
	


}) #shiny server

