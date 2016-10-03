library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("Twitter Sentiment Analysis"),
  
  # Getting User Inputs
  
  sidebarPanel(
    
    selectInput("category","Enter category for analysis", c("Movie","Product","Service","People"),selected="Movie", selectize=TRUE
               ),
    textInput("hastag", "Enter data to be searched with '#'", "#"),
    sliderInput("noOfTweets","Number of recent tweets to use for analysis:",min=5,max=1500,value=1500), 
    sliderInput("noOfDays","Number of recent days upto which tweets are retrieved:",min=1,max=7,value=7),
    submitButton(text="Analyse")
    
  ),
  
  mainPanel(
    tabsetPanel(
      
       tabPanel("WordCloud",HTML("<div>Most used words associated with the hashtag</div>"),verbatimTextOutput("wordcloud"),plotOutput("word"),
               HTML
               ("<div>A word cloud is a visual representation of text data, typically used to depict keyword metadata (tags) on websites, or to visualize free form text.
This format is useful for quickly perceiving the most prominent terms and for locating a term alphabetically to determine its relative prominence.
                </div>")),
      
      tabPanel("Histogram",plotOutput("histPos"),plotOutput("histNeg"),plotOutput("histScore"),verbatimTextOutput("histogram"),
               HTML
               ("<div> Histograms graphically depict the positivity or negativity of peoples' opinions of the hastag</div>")),
      
      tabPanel("Pie Chart",HTML("<div>Depicting sentiment on a scale of 5</div>"), plotOutput("piechart"), verbatimTextOutput("piechart"), 
		HTML   
		("<div> A pie chart is a circular statistical graphic, which is divided into slices to illustrate the sentiment of the hastag. 
In a pie chart, the arc length of each slice (and consequently its central angle and area), is proportional to the quantity it represents.</div>")
               
               ),
      
      tabPanel("Table",HTML
               ("<div> Depicting sentiment in a tabular form on a scale of 5</div>"),
               tableOutput("sentiheadtable"),tableOutput("sentitailtable"),verbatimTextOutput("table"),
		HTML   
		("<div> The table depicts the sentiment (positive, negative or neutral) of the tweets associated withy the search hastag by showing the score 
for each type of sentiment</div>")
            
		),
      
      tabPanel("Top tweeters",HTML
               ("<div> Top 15 tweeters of hastag</div>"),plotOutput("entity1wcplot"),h2(textOutput("tweeters")),plotOutput("tweetersplot")),
      
      tabPanel("Timeline plot",tableOutput("timelineTable"),HTML
               ("<div> This plot shows timeline of tweets of upto 7 recent days for frequency of tweets hour wise</div>"))
    )
  )
  
))
