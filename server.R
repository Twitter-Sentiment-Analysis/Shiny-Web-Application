
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

#PrepareTwitter()

# Please see http://cran.r-project.org/web/packages/twitteR/vignettes/twitteR.pdf for more info on this.

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

# Function to create a data frame from tweets

shinyServer(function(input,output) {
      output$tabledata <- renderTable(iris)

	
output$error <- renderText({ 
          "Server"
     })    

  pos.words = scan('C:/Users/hp/Documents/positive-words.txt', what='character', comment.char=';')
  neg.words = scan('C:/Users/hp/Documents/negative-words.txt', what='character', comment.char=';')
	
  #Function to load positive and negative words
  WordDatabase <- function()
  {
	pos.words <<- c(pos.words, 'Congrats', 'prizes', 'prize', 'thanks', 'thnx', 'Grt', 'gr8', 'plz', 'trending', 'recovering', 'brainstorm', 'leader')
	neg.words <<- c(neg.words, 'Fight', 'fighting', 'wtf', 'arrest', 'no', 'not')
  }

  WordDatabase()

  print("server")
  
  # Function to clean tweets, Stanton 2013
  CleanTweets<-function(tweets)
  {
    # Remove redundant spaces
    tweets <- str_replace_all(tweets," "," ")
    # Get rid of URLs
    tweets <- str_replace_all(tweets, "http://t.co/[a-z,A-Z,0-9]*{8}","")
    # Take out retweet header, there is only one
    tweets <- str_replace(tweets,"RT @[a-z,A-Z]*: ","")
    # Get rid of hash
    tweets <- str_replace_all(tweets,"#","")
    # Get rid of references to other screennames
    tweets <- str_replace_all(tweets,"@[a-z,A-Z]*","")

    sample = tweets$text
    return(sample)
	

    #return(tweets)
    
  }
  
  #Search tweets and create a data frame -Stanton (2013)
  TweetFrame<-function(searchTerm, maxTweets)
  {
    twtList<-searchTwitter(searchTerm,n=maxTweets,cainfo="cacert.pem",lang="en")
    #for (i in 2:length(dates)) {
    #tweets <- c(tweets, searchTwitter(searchTerm, since=dates[i-1], until=dates[i], n=maxTweets))
    #}

    df<- do.call("rbind",lapply(twtList,as.data.frame))
    #removes emoticons
    df$text <- sapply(df$text,function(row) iconv(row, "latin1", "ASCII", sub=""))
    return df

    #return(twtList1)
    
  }
  
  score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
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


	sentimentAnalyzer <- function()
	{

	#MOVE TO A BETTER LOCATION!!!!!!!!!!!!!!
	
	#Call the required functions
	tweets<-reactive({tweets<-TweetFrame(input$searchTerm, input$maxTweets)})
  	sample<-reactive({sample<-CleanTweets( tweets() )})

	print("sample")
	# Apply the function
	result = score.sentiment(sample(), pos.words, neg.words)
	print("result")
	library(reshape)
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
	table_final=data.frame(Text=table1$Text, Score=table1$value, Positive=table2$value, Negative=table3$value)

	return table_final	
	}   

#CONTINUE!!!!!!!!!!!   


   #table_final = sentimentAnalyzer()
  table_final <- reactive({table_final<-sentimentAnalyzer()})

#entityscores<-reactive({entityscores<-sentimentalanalysis(entity1()$text,entity2()$text,input$entity1,input$entity2)})


   #output$tabledata <- renderTable({
#	head(table_final(),20)
#	})

    }
  )

