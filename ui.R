library(shiny)
library(shinydashboard)
library(shinycssloaders)

dashboardPage(
  dashboardHeader(title = "DEFORESTATION ACROSS THE GLOBE",
                  titleWidth = 650,
                  #adding the social media icons 
                  tags$li(class = "dropdown", tags$a(href = "www.linkedin.com/in/NSING_VICTORY", icon("youtube"), "Youtube", target = "_blank"  )),
                  tags$li(class = "dropdown", tags$a(href = "www.linkedin.com/in/NSING_VICTORY", icon("youtube"), "Linkdin", target = "_blank"  )),
                  tags$li(class = "dropdown", tags$a(href = "www.linkedin.com/in/NSING_VICTORY", icon("youtube"), "Source Code", target = "_blank"  ))
  ),
  dashboardSidebar(
    # working on the side bar menu we define the side bar items within the side bar menu function
    sidebarMenu(
      id = "sidebar",
      
      #first menu item
      menuItem("Dataset", tabName = "data", icon = icon("database")),
      menuItem(text = "Visualization", tabName = "viz", icon = icon("chart-line")),
      conditionalPanel("input.sidebar == 'viz' && input.t2== 'trends' ",selectInput(inputId = "var1" , label = "Add the country to plot", choices  = choice_of_country, selected = "Argentina", multiple = TRUE)),
      conditionalPanel("input.sidebar == 'viz' && input.t2== 'distro' ",selectInput(inputId = "var2" , label = "Select the year", choices  = choice_of_year, selected = "2015")),
      menuItem(text = "choropleth Map", tabName = "map", icon = icon("map"))
      
    )
  ),
  
  
  
  
  
  dashboardBody(
        tabItems(
          tabItem(tabName = "data", 
                  #tab box
                  tabBox(
                    id = "t1", width = 12,
                    tabPanel("About", icon = icon("address-card"), fluidRow(
                      column(width = 7, tags$img(src = "deforestation.jpg", width = 600, height = 500),
                             tags$br(),
                             tags$a("Photo by Ven Victor "), align = "center"),
                      column(width = 5, tags$br(),
                             tags$b('The net change in forest cover measures any gains in forest cover – either through natural forest expansion or afforestation through tree-planting – minus deforestation.

How much of the world’s land surface today is covered by forest?

In the visualization we see the breakdown of global land area.

10% of the world is covered by glaciers, and a further 19% is barren land – deserts, dry salt flats, beaches, sand dunes, and exposed rocks. This leaves what we call ‘habitable land’.

Forests account for a little over one-third (38%) of habitable land area. This is around one-quarter (26%) of total (both habitable and uninhabitable) land area.

This marks a significant change from the past: global forest area has reduced significantly due to the expansion of agriculture. Today half of global habitable land is used for farming. The area used for livestock farming in particular is equal in area to the world’s forests.

Every year the world loses around 5 million hectares of forest. 95% of this occurs in the tropics. At least three-quarters of this is driven by agriculture – clearing forests to grow crops, raise livestock and produce products such as paper.1

If we want to tackle deforestation we need to understand two key questions: where we’re losing forests, and what activities are driving it. This allows us to target our efforts towards specific industries, products, or countries where they will have the greatest impact.

More than three-quarters (77%) of global soy is fed to livestock for meat and dairy production. Most of the rest is used for biofuels, industry or vegetable oils. Just 7% of soy is used directly for human food products such as tofu, soy milk, edamame beans, and tempeh. The idea that foods often promoted as substitutes for meat and dairy – such as tofu and soy milk – are driving deforestation is a common misconception.

In this article I address some key questions about palm oil production: how has it changed; where is it grown; and how this has affected deforestation and biodiversity. The story of palm oil is not as simple as it is often portrayed. Global demand for vegetable oils has increased rapidly over the last 50 years. Being the most productive oilcrop, palm has taken up a lot of this production. This has had a negative impact on the environment, particularly in Indonesia and Malaysia. But it’s not clear that the alternatives would have fared any better. In fact, because we can produce up to 20 times as much oil per hectare from palm versus the alternatives, it has probably spared a lot of environmental impacts from elsewhere.  "))
                
'))
                    )),
                    tabPanel(title = " FOREST", icon = icon("address-card"), dataTableOutput("forest_table")),
                    tabPanel(title = " FOREST AREA", icon = icon("address-card"), dataTableOutput("forest_area_table")),
                    tabPanel(title = " BRAZIL", icon = icon("address-card"), dataTableOutput("brazil_lost_table"))
                  )
          ),
          #second item 
          tabItem(tabName = "viz",
                  tabBox(
                    id = "t2", width = 12,
                    tabPanel(title = "GLANCE AT FOREST DISTRIBUTIONS", value = "trends", 
                             withSpinner(plotlyOutput("countries"))),
                    tabPanel(title = "COUNTRY DISTRIBUTION", value = "distro",withSpinner(plotlyOutput("gains_countries"))),
                    tabPanel(title = "FOREST BY YEAR", value = "year", 
                             fluidRow(tags$div(align = "center", box(tableOutput("top5T"), title = textOutput("top5"), collapsible = TRUE, status = "primary", collapsed = TRUE)),
                                      tags$div(align = "center", box(tableOutput("low5T"), title = textOutput("bottom5"),  collapsible = TRUE, status = "primary", collapsed = TRUE))
                                      
                             ),
                             withSpinner(plotlyOutput("forest_by_year")) ),
                    tabPanel(title = "BRAZIL LOSS BY CAUSE", value = "relation",withSpinner(plotlyOutput("brazil_loss_by_cause")))
                  )
          ),
          
          
          #third item
          
          tabItem(tabName = "map",
                 withSpinner( plotOutput("map_plot")), width = 12)
          )
    
    
    )




)