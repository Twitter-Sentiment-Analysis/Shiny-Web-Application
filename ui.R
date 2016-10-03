library(shiny)

shinyUI(fluidPage(
  
  headerPanel("Twitter Sentiment Analysis"),
  
  # Getting User Inputs
  
  sidebarPanel(
    
      
    selectInput("category", "Enter category for analysis", c("Movie", "Product", "Service", "People"), selected="Select", selectize=TRUE
              ),
    textInput ("hashtag","Enter hashtag to be searched with '#'"),
    sliderInput("noOfTweets","Number of recent tweets to use for analysis",min=5,max=1500,value=1500), # The max can, of course, be increased
    sliderInput("noOfDays","No of recent days upto which tweets are retrieved",min=1,max=7,value=7,step=1), 
    submitButton(text="Analyse")
    
  ),
  
  mainPanel(
    tabsetPanel(
      
      tabPanel("WordCloud",HTML("<div>Most used words associated with the hashthag</div>"),verbatimTextOutput("wordcloud"),plotOutput("word"),
               HTML
               ("<div> A word cloud is a visual representation of text data, typically used to depict keyword metadata (tags) on websites, or to visualize free form text.
                This format is useful for quickly perceiving the most prominent terms and for locating a term alphabetically to determine its relative prominence.
			</div>")),
      
      
      tabPanel("Histogram",plotOutput("histPos"), verbatimTextOutput("histo"),plotOutput("histNeg"), plotOutput("histScore"),
               HTML
               ("<div> Histograms graphically depict the positivity or negativity of peoples' opinion about of the hahtag
			</div>")),
      
      
      tabPanel("Pie Chart",HTML("<div>Depicting sentiment on a scale of 5</div>"),verbatimTextOutput("poisstest"), plotOutput("piechart"),HTML
               ("<div> A pie chart is a circular statistical graphic, which is divided into slices to illustrate the sentiment of the hashtag. In a pie chart, the arc length 
			of each slice (and consequently its central angle and area), is proportional to the quantity it represents.</div>")
                
              ),
      
      tabPanel("Table",HTML("<div> Depicting sentiment in a tablular form on a scale of 5 </div>"), verbatimTextOutput("table"),
               tableOutput("sentiheadtable"),tableOutput("sentitailtable"),HTML
			("<div> The table depicts the sentiment (positive, negative or neutral) of the tweets 
				associated with the search hashtag by showing the score for each type of sentiment. </div>")),
      
      #Output from tab 5 - Word clouds - with some html tags
      
      tabPanel("Top Tweeters",HTML("<div> Top 15 Tweeters of hashtag </div>"),plotOutput("tweetersplot")),
      
      #Output from tabs 6 and 7, the raw tweets
      tabPanel("Timeline plot",tableOutput("tableentity1"), HTML("<div> Shows timeline of tweets of upto 7 recents days for frequency of tweets hourwise
			</div>")  )    
    )
  )
  
))