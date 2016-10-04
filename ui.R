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
	
	 selectInput("trendingTable","Choose location to extract trending tweets",c("Worldwide" , "Winnipeg"  , "Ottawa" ,             "Quebec"               "Montreal"            
  "Toronto"       ,      "Edmonton"      ,       "Calgary"    ,          "Vancouver"  ,          "Birmingham" ,         
  "Blackpool"  ,          "Bournemouth"  ,        "Brighton"        ,     "Bristol"     ,         "Cardiff"         ,    
  "Coventry"    ,         "Derby"        ,        "Edinburgh"      ,      "Glasgow"      ,        "Hull"             ,   
  "Leeds"        ,        "Leicester"     ,       "Liverpool"     ,       "Manchester"    ,       "Middlesbrough"     ,  
  "Newcastle"     ,       "Nottingham"     ,      "Plymouth"     ,        "Portsmouth"     ,      "Preston"            , 
  "Sheffield"       ,     "Stoke-on-Trent",       "Swansea"         ,     "London"          ,     "Belfast"        ,     
  "Santo Domingo"  ,      "Guatemala City" ,      "Acapulco"       ,      "Aguascalientes"   ,    "Chihuahua"       ,    
  "Mexico City"   ,       "Ciudad Juarez" ,       "Nezahualcóyotl",       "Culiacán"   ,          "Ecatepec de Morelos",  
 "Guadalajara"   ,       "Hermosillo"      ,     "León"          ,       "Mérida"       ,        "Mexicali"    ,        
  "Monterrey"   ,         "Morelia"         ,     "Naucalpan de Juárez",  "Puebla"       ,        "Querétaro"   ,        
  "Saltillo"        ,     "San Luis Potosí"  ,    "Tijuana"          ,    "Toluca"        ,       "Zapopan"      ,       
  "Mendoza"        ,      "Santiago"  ,           "Concepcion"      ,     "Valparaiso"     ,      "Bogotá"        ,      
  "Cali"          ,       "Medellín"   ,          "Barranquilla"   ,      "Quito"           ,     "Guayaquil"      ,     
  "Caracas"      ,        "Maracaibo"   ,         "Maracay"       ,       "Valencia"     ,        "Barcelona"       ,    
  "Ciudad Guayana" ,      "Turmero"      ,        "Lima"         ,        "Brasília"      ,       "Belém"            ,   
  "Belo Horizonte",       "Curitiba"      ,       "Porto Alegre"     ,    "Recife"         ,      "Rio de Janeiro"    ,  
  "Salvador"    ,         "São Paulo"      ,      "Campinas"        ,     "Fortaleza"       ,     "Goiânia"            , 
  "Manaus"     ,          "São Luís"        ,     "Guarulhos"      ,      "Córdoba"     ,         "Rosario"  ,           
 "Barquisimeto"   ,      "Maturín"           ,   "Buenos Aires"   ,      "Gdansk"        ,       "Kraków"    ,          
 "Lodz"            ,     "Poznan"     ,          "Warsaw"        ,       "Wroclaw"        ,      "Vienna"     ,         
 "Cork"          ,       "Dublin"      ,         "Galway"           ,    "Bordeaux"   ,          "Lille"       ,        
 "Lyon"         ,        "Marseille"    ,        "Montpellier"     ,     "Nantes"      ,         "Paris"      ,         
 "Rennes"      ,         "Strasbourg"    ,       "Toulouse"       ,      "Berlin"       ,        "Bremen"      ,        
[121] "Dortmund"             "Dresden"              "Dusseldorf"           "Essen"    ,            "Frankfurt",           
[126] "Hamburg"              "Cologne"              "Leipzig"              "Munich"    ,           "Stuttgart"           
[131] "Bologna"              "Genoa"                "Milan"                "Naples"     ,          "Palermo"             
[136] "Rome"                 "Turin"                "Den Haag"             "Amsterdam"   ,         "Rotterdam"           
[141] "Utrecht"              "Barcelona"            "Bilbao"               "Las Palmas"   ,        "Madrid"              
[146] "Malaga"               "Murcia"               "Palma"                "Seville"       ,       "Valencia"            
[151] "Zaragoza"             "Geneva"               "Lausanne"             "Zurich"         ,      "Brest"              156] "Grodno"               "Gomel"                "Minsk"                "Riga"                 "Bergen"              
[161] "Oslo"                 "Gothenburg"           "Stockholm"            "Dnipropetrovsk"       "Donetsk"             
[166] "Kharkiv"              "Kyiv"                 "Lviv"                 "Odesa"                "Zaporozhye"          
[171] "Athens"               "Thessaloniki"         "Bekasi"               "Depok"                "Pekanbaru"           
[176] "Surabaya"             "Makassar"             "Bandung"              "Jakarta"              "Medan"               
[181] "Palembang"            "Semarang"             "Tangerang"            "Singapore"            "Perth"               
[186] "Adelaide"             "Brisbane"             "Canberra"             "Darwin"               "Melbourne"           
[191] "Sydney"               "Kitakyushu"           "Saitama"              "Chiba"                "Fukuoka"             
[196] "Hamamatsu"            "Hiroshima"            "Kawasaki"             "Kobe"                 "Kumamoto"            
[201] "Nagoya"               "Niigata"              "Sagamihara"           "Sapporo"              "Sendai"              
[206] "Takamatsu"            "Tokyo"                "Yokohama"             "Goyang"               "Yongin"              
[211] "Ansan"                "Bucheon"              "Busan"                "Changwon"             "Daegu"               
[216] "Gwangju"              "Incheon"              "Seongnam"             "Suwon"                "Ulsan"               
[221] "Seoul"                "Kajang"               "Ipoh"                 "Johor Bahru"          "Klang"               
[226] "Kuala Lumpur"         "Calocan"              "Makati"               "Pasig"                "Taguig"              
[231] "Antipolo"             "Cagayan de Oro"       "Cebu City"            "Davao City"           "Manila"              
[236] "Quezon City"          "Zamboanga City"       "Bangkok"              "Hanoi"                "Hai Phong"           
[241] "Can Tho"              "Da Nang"              "Ho Chi Minh City"     "Algiers"              "Accra"               
[246] "Kumasi"               "Benin City"           "Ibadan"               "Kaduna"               "Kano"                
[251] "Lagos"                "Port Harcourt"        "Giza"                 "Cairo"                "Alexandria"          
[256] "Mombasa"              "Nairobi"              "Durban"               "Johannesburg"         "Port Elizabeth"      
[261] "Pretoria"             "Soweto"               "Cape Town"            "Medina"               "Dammam"              
[266] "Riyadh"               "Jeddah"               "Mecca"                "Sharjah"              "Abu Dhabi"           
[271] "Dubai"                "Haifa"                "Tel Aviv"             "Jerusalem"            "Amman"               
[276] "Chelyabinsk"          "Khabarovsk"           "Krasnodar"            "Krasnoyarsk"          "Samara"              
[281] "Voronezh"             "Yekaterinburg"        "Irkutsk"              "Kazan"                "Moscow"              
[286] "Nizhny Novgorod"      "Novosibirsk"          "Omsk"                 "Perm"                 "Rostov-on-Don"       
[291] "Saint Petersburg"     "Ufa"                  "Vladivostok"          "Volgograd"            "Karachi"             
[296] "Lahore"               "Multan"               "Rawalpindi"           "Faisalabad"           "Muscat"              
[301] "Nagpur"               "Lucknow"              "Kanpur"               "Patna"                "Ranchi"              
[306] "Kolkata"              "Srinagar"             "Amritsar"             "Jaipur"               "Ahmedabad"           
[311] "Rajkot"               "Surat"                "Bhopal"               "Indore"               "Thane"               
[316] "Mumbai"               "Pune"                 "Hyderabad"            "Bangalore"            "Chennai"             
[321] "Mersin"               "Adana"                "Ankara"               "Antalya"              "Bursa"               
[326] "Diyarbakır"           "Eskişehir"            "Gaziantep"            "Istanbul"             "Izmir"               
[331] "Kayseri"              "Konya"                "Okinawa"              "Daejeon"              "Auckland"            
[336] "Albuquerque"          "Atlanta"              "Austin"               "Baltimore"            "Baton Rouge"         
[341] "Birmingham"           "Boston"               "Charlotte"            "Chicago"              "Cincinnati"          
 "Cleveland"            "Colorado Springs"     "Columbus"             "Dallas-Ft. Worth"     "Denver"              
 "Detroit"              "El Paso"              "Fresno"               "Greensboro"           "Harrisburg"         , 
 "Honolulu"             "Houston"              "Indianapolis"    ,     "Jackson"       ,       "Jacksonville"    ,    
 "Kansas City"          "Las Vegas"            "Long Beach"      ,     "Los Angeles"    ,      "Louisville"      ,    
 "Memphis"            ,  "Mesa"      ,           "Miami"          ,      "Milwaukee"    ,        "Minneapolis"   ,      
 "Nashville"         ,   "New Haven"  ,          "New Orleans"    ,      "New York"     ,        "Norfolk"       ,      
 "Oklahoma City"    ,    "Omaha"       ,         "Orlando"        ,      "Philadelphia"  ,       "Phoenix"       ,      
 "Pittsburgh"      ,     "Portland"    ,         "Providence"     ,      "Raleigh"       ,       "Richmond"      ,      
 "Sacramento"     ,      "St. Louis"   ,         "Salt Lake City" ,      "San Antonio"   ,       "San Diego"     ,      
 "San Francisco" ,       "San Jose"    ,         "Seattle"       ,       "Tallahassee"   ,       "Tampa"        ,       
 "Tucson"       ,        "Virginia Beach" ,      "Washington"    ,       "Osaka"         ,       "Kyoto"        ,       
 "Delhi"       ,         "United Arab Emirates", "Algeria"       ,       "Argentina"     ,       "Australia"   ,        
 "Austria"    ,          "Bahrain"    ,          "Belgium"       ,       "Belarus"       ,       "Brazil"      ,        
 "Canada"    ,           "Chile"      ,          "Colombia"      ,       "Denmark"       ,       "Dominican Republic",  
 "Ecuador"  ,            "Egypt"      ,          "Ireland"       ,       "France"        ,       "Ghana"       ,        
 "Germany" ,             "Greece"     ,          "Guatemala"     ,       "Indonesia"     ,       "India"       ,        
 "Israel"             ,  "Italy"      ,          "Japan"         ,       "Jordan"        ,       "Kenya"       ,        
 "Korea"             ,   "Kuwait"     ,          "Lebanon"       ,       "Latvia"        ,       "Oman"        ,        
 "Mexico"           ,    "Malaysia"   ,          "Nigeria"       ,       "Netherlands"   ,       "Norway"      ,        
 "New Zealand"     ,     "Peru"       ,          "Pakistan"      ,       "Poland"        ,       "Panama"      ,        
 "Portugal"       ,      "Qatar"      ,          "Philippines"   ,       "Puerto Rico"   ,       "Russia"      ,        
 "Saudi Arabia"      ,   "South Africa"  ,       "Singapore"     ,       "Spain"          ,      "Sweden"      ,        
 "Switzerland"      ,    "Thailand"      ,       "Turkey"        ,       "United Kingdom"  ,     "Ukraine"     ,        
 "United States"   ,     "Venezuela"     ,       "Vietnam"       ,       "Petaling"         ,    "Hulu Langat" ,        
 "Ahsa"           ,      "Okayama"  ), selected = "Worldwide", selectize = TRUE)

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
