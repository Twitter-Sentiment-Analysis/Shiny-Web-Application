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
      
	 tabPanel("Top Trending Tweets Today",HTML("<div>Top Trending Tweets according to location</div>"),verbatimTextOutput("trending")),
	
	 selectInput("trendingTable","Choose location to extract trending tweets",c("Worldwide" ,  "Abu Dhabi" ,"Acapulco" , "Accra" , 
										    "Adana" , "Adela", "Aguascalientes" , "Ahmedabad" ,         
   "Ahsa" , "Albuquerque" , "Alexandria" , "Algeria" , "Algiers" , "Amman" , "Amritsar" , "Amsterdam",  "Ankara" , "Ansan" ,
	"Antalya" , "Antipolo" , "Argentina" ,  "Athens" ,  
  "Atlanta" ,             "Auckland" ,            "Austin" ,              "Australia" ,           "Austria"  ,            "Bahrain"     ,         "Baltimore"  ,         
  "Bandung"   ,           "Bangalore" ,           "Bangkok",              "Barcelona" ,           "Barcelona",            "Barquisimeto",         "Barranquilla"  ,      
  "Baton Rouge" ,         "Bekasi"    ,           "Belarus",              "Belém"     ,           "Belfast"  ,            "Belgium"     ,         "Belo Horizonte",      
  "Benin City"  ,         "Bergen"    ,           "Berlin" ,              "Bhopal"    ,           "Bilbao"   ,            "Birmingham"  ,         "Birmingham"    ,      
  "Blackpool"   ,         "Bogotá"    ,           "Bologna",              "Bordeaux"  ,           "Boston"   ,            "Bournemouth" ,         "Brasília"      ,      
  "Brazil"      ,         "Bremen"    ,           "Brest"  ,              "Brighton"  ,           "Brisbane" ,            "Bristol"     ,         "Bucheon"       ,      
  "Buenos Aires",         "Bursa"     ,           "Busan"  ,              "Cagayan de Oro" ,      "Cairo"    ,            "Calgary"     ,         "Cali"      ,          
  "Calocan"     ,         "Campinas"  ,           "Can Tho",              "Canada"    ,           "Canberra"  ,           "Cape Town"   ,         "Caracas"   ,          
  "Cardiff"     ,         "Cebu City" ,           "Changwon" ,            "Charlotte" ,           "Chelyabinsk" ,         "Chennai"     ,         "Chiba"     ,          
  "Chicago"     ,         "Chihuahua" ,           "Chile"    ,            "Cincinnati",           "Ciudad Guayana" ,      "Ciudad Juarez",        "Cleveland" ,          
  "Cologne"     ,         "Colombia"  ,           "Colorado Springs",     "Columbus"  ,           "Concepcion" ,          "Córdoba"      ,        "Cork"      ,          
  "Coventry"    ,         "Culiacán"  ,           "Curitiba"    ,         "Da Nang"   ,           "Daegu"      ,          "Daejeon"      ,        "Dallas-Ft. Worth" ,   
 "Dammam"  , "Darwin" ,"Davao City", "Delhi", "Den Haag" , "Denmark" ,"Denver" ,  "Depok" , "Derby" , "Detroit" , "Diyarbakır" , "Dnipropetrovsk" ,"Dominican Republic","Donetsk",
 "Dortmund"  ,           "Dresden" ,             "Dubai"         ,       "Dublin"      ,         "Durban"       ,        "Dusseldorf"    ,       "Ecatepec de Morelos", 
 "Ecuador"       ,       "Edinburgh" ,           "Edmonton"      ,       "Egypt"       ,         "El Paso"      ,        "Eskişehir"     ,       "Essen"    ,           
 "Faisalabad"    ,       "Fortaleza"  ,          "France"        ,       "Frankfurt"   ,         "Fresno"       ,        "Fukuoka"       ,       "Galway"   ,           
 "Gaziantep"    ,        "Gdańsk"      ,         "Geneva"       ,        "Genoa"       ,         "Germany"      ,        "Ghana"         ,       "Giza"     ,           
 "Glasgow"      ,        "Goiânia"     ,         "Gomel"        ,        "Gothenburg"  ,         "Goyang"       ,        "Greece"        ,       "Greensboro" ,         
 "Grodno"       ,        "Guadalajara" ,         "Guarulhos"    ,        "Guatemala"   ,         "Guatemala City"  ,     "Guayaquil"     ,       "Gwangju"  ,           
 "Hai Phong"    ,        "Haifa"       ,         "Hamamatsu"    ,        "Hamburg"     ,         "Hanoi"      ,          "Harrisburg"    ,       "Hermosillo"     ,     
 "Hiroshima"    ,        "Ho Chi Minh City" ,    "Honolulu"     ,        "Houston"     ,         "Hull"       ,          "Hulu Langat"   ,       "Hyderabad"      ,     
 "Ibadan"       ,        "Incheon"      ,        "India"        ,        "Indianapolis",         "Indonesia" ,           "Indore"        ,       "Ipoh"           ,     
 "Ireland"      ,        "Irkutsk"       ,       "Israel"       ,        "Istanbul"    ,         "Italy"     ,           "Izmir"         ,       "Jackson"        ,     
 "Jacksonville" ,        "Jaipur"        ,       "Jakarta"      ,        "Japan"       ,         "Jeddah"    ,           "Jerusalem"     ,       "Johannesburg"   ,     
 "Johor Bahru"  ,        "Jordan"        ,       "Kaduna"       ,        "Kajang"      ,         "Kano"      ,           "Kanpur"        ,       "Kansas City"    ,     
 "Karachi"      ,        "Kawasaki"      ,       "Kayseri"      ,        "Kazan"       ,         "Kenya"     ,           "Khabarovsk"    ,       "Kharkiv"        ,     
 "Kitakyushu"   ,        "Klang"         ,       "Kobe"         ,        "Kolkata"      ,        "Konya"     ,           "Korea"         ,       "Kraków"         ,     
 "Krasnodar"    ,        "Krasnoyarsk"   ,       "Kuala Lumpur" ,        "Kumamoto"    ,         "Kumasi"    ,           "Kuwait"        ,       "Kyiv"           ,     
"Kyoto" ,               "Lagos"    ,            "Lahore"       ,        "Las Palmas",           "Las Vegas"   ,         "Latvia" ,              "Lausanne"       ,     
[232] "Lebanon"              "Leeds"                "Leicester"            "Leipzig"              "León"                 "Lille"                "Lima"                
[239] "Liverpool"            "Lodz"                 "London"               "Long Beach"           "Los Angeles"          "Louisville"           "Lucknow"             
[246] "Lviv"                 "Lyon"                 "Madrid"               "Makassar"             "Makati"               "Malaga"               "Malaysia"            
[253] "Manaus"               "Manchester"           "Manila"               "Maracaibo"            "Maracay"              "Marseille"            "Maturín"             
[260] "Mecca"                "Medan"                "Medellín"             "Medina"               "Melbourne"            "Memphis"              "Mendoza"             
[267] "Mérida"               "Mersin"               "Mesa"                 "Mexicali"             "Mexico"               "Mexico City"          "Miami"               
[274] "Middlesbrough"        "Milan"                "Milwaukee"            "Minneapolis"          "Minsk"                "Mombasa"              "Monterrey"           
[281] "Montpellier"          "Montreal"             "Morelia"              "Moscow"               "Multan"               "Mumbai"               "Munich"              
[288] "Murcia"               "Muscat"               "Nagoya"               "Nagpur"               "Nairobi"              "Nantes"               "Naples"              
[295] "Nashville"            "Naucalpan de Juárez"  "Netherlands"          "New Haven"            "New Orleans"          "New York"             "New Zealand"         
[302] "Newcastle"            "Nezahualcóyotl"       "Nigeria"              "Niigata"              "Nizhny Novgorod"      "Norfolk"              "Norway"              
[309] "Nottingham"           "Novosibirsk"          "Odesa"                "Okayama"              "Okinawa"              "Oklahoma City"        "Omaha"               
[316] "Oman"                 "Omsk"                 "Orlando"              "Osaka"                "Oslo"                 "Ottawa"               "Pakistan"            
[323] "Palembang"            "Palermo"              "Palma"                "Panama"               "Paris"                "Pasig"                "Patna"               
[330] "Pekanbaru"            "Perm"                 "Perth"                "Peru"                 "Petaling"             "Philadelphia"         "Philippines"         
[337] "Phoenix"              "Pittsburgh"           "Plymouth"             "Poland"               "Port Elizabeth"       "Port Harcourt"        "Portland"            
[344] "Porto Alegre"         "Portsmouth"           "Portugal"             "Poznań"               "Preston"              "Pretoria"             "Providence"          
[351] "Puebla"               "Puerto Rico"          "Pune"                 "Qatar"                "Quebec"               "Querétaro"            "Quezon City"         
[358] "Quito"                "Rajkot"               "Raleigh"              "Ranchi"               "Rawalpindi"           "Recife"               "Rennes"              
[365] "Richmond"             "Riga"                 "Rio de Janeiro"       "Riyadh"               "Rome"                 "Rosario"              "Rostov-on-Don"       
[372] "Rotterdam"            "Russia"               "Sacramento"           "Sagamihara"           "Saint Petersburg"     "Saitama"              "Salt Lake City"      
[379] "Saltillo"             "Salvador"             "Samara"               "San Antonio"          "San Diego"            "San Francisco"        "San Jose"            
[386] "San Luis Potosí"      "Santiago"             "Santo Domingo"        "São Luís"             "São Paulo"            "Sapporo"              "Saudi Arabia"        
[393] "Seattle"              "Semarang"             "Sendai"               "Seongnam"             "Seoul"                "Seville"              "Sharjah"             
[400] "Sheffield"            "Singapore"            "Singapore"            "South Africa"         "Soweto"               "Spain"                "Srinagar"            
[407] "St. Louis"            "Stockholm"            "Stoke-on-Trent"       "Strasbourg"           "Stuttgart"            "Surabaya"             "Surat"               
[414] "Suwon"                "Swansea"              "Sweden"               "Switzerland"          "Sydney"               "Taguig"               "Takamatsu"           
[421] "Tallahassee"          "Tampa"                "Tangerang"            "Tel Aviv"             "Thailand"             "Thane"                "Thessaloniki"        
[428] "Tijuana"              "Tokyo"                "Toluca"               "Toronto"              "Toulouse"             "Tucson"               "Turin"               
[435] "Turkey"               "Turmero"              "Ufa"                  "Ukraine"              "Ulsan"                "United Arab Emirates" "United Kingdom"      
[442] "United States"        "Utrecht"              "Valencia"             "Valencia"             "Valparaiso"           "Vancouver"            "Venezuela"           
[449] "Vienna"               "Vietnam"              "Virginia Beach"       "Vladivostok"          "Volgograd"            "Voronezh"             "Warsaw"              
[456] "Washington"           "Winnipeg"             "Worldwide"            "Wroclaw"              "Yekaterinburg"        "Yokohama"             "Yongin"              
[463] "Zamboanga City"       "Zapopan"              "Zaporozhye"           "Zaragoza"             "Zurich"  ), selected = "Worldwide", selectize = TRUE)

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
