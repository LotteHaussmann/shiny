#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#


###### Adrian comments, June 26, 2024
# Your app is great! It functions, it takes user input and appends it to text and plots!
# Very well done. I think you have a good structure to create your apps further. 
# I like the fact that you source your code from r script files and that you used
# css customization. 

r <- getOption("repos")
r["CRAN"] <-"https://cloud.r-project.org/"
options(repos=r)

if (!require(shiny)) {
  install.packages("shiny")
  require(shiny)
}

if (!require(tidyverse)) {
  install.packages("tidyverse")
  require(tidyverse)
}

if (!require(sjlabelled)) {
  install.packages("sjlabelled")
  require(sjlabelled)
}

# load data
source("prep_data.R")



#load function
source("function_plotting.R")

######################
# Define UI for application that draws a histogram
ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),

    # Page title 
    titlePanel(tags$strong(HTML(paste("Data description")))),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
      position = "left", fluid = T,
      #color, place,
        sidebarPanel( 
          class = "sidebar", 
            selectInput(inputId = "gender",
                        "Select gender: ",
                        choices = c("Female" = 1, "Male" = 2), 
                        multiple = F),
            selectInput(inputId = "ageg",
                        "Select agegroup: ",
                        choices = c("19-28" = "19-28",
                                    "29-38" = "29-38",
                                    "39-48" = "39-48",
                                    "49 or older" = "49-58")),
            hr(),
        #   actionButton("submit", "Don`t Panic!")
        ),

        # Show a plot of the generated distribution
        mainPanel( 
          class = "main-panel", 
          #contains output, plain, live text or figures
          h3("Results"),
          tabsetPanel(
             tabPanel("Gender", 
                      br(),
                      paste("Here you can see two boxplots of stereotypical evaluation of men."), 
                      br(),
                      plotOutput("plotGender"),
                      br(),
                      plotOutput("plotGender_2"),
                      hr()
                      ),
             tabPanel("Agegroup", 
                      br(),
                      #will not work this way!
                      #HTML(paste("Let's look at some descriptive statistics regarding the age distribution. The age group `r ageg` has a sample size of `r nrow(df)`.")), 
                      htmlOutput("dynamicText"),
                      plotOutput("plotAge"),
                      hr()
                      ),
           )
        )
    )
)
# Define server logic required to draw a histogram
server <- function(input, output) {
  
  tempgen <-reactive({
    
    sjlabelled::remove_all_labels(df) %>%
      filter(gen %in% input$gender)
    
  })

  tempdf <-reactive({
    
      sjlabelled::remove_all_labels(df) %>%
      filter(Agegroup %in% input$ageg)
    
     })
  
  
  plott_gen <- reactive({
    # Plotting selected gender and men_warm
    ggplot(tempgen(), aes_string(x = input$gender, y = "men_warm")) +
      geom_boxplot(fill = "skyblue", color = "black") +
      labs(title = paste(""),
           x = "Gender", 
           y = "Warmth") +
      theme_minimal()
    

    
  }) 
  
  plott_gen_2 <- reactive({
  ggplot(tempgen(), aes_string(x = input$gender, y = "men_comp")) +
    geom_boxplot(fill = "skyblue", color = "black") +
    labs(title = paste(""),
         x = "Gender",
         y = "Competence") +
    theme_minimal()
  })
  
  
  
  
  plott_re <- reactive({
        #plotting 
      func_plot(tempdf(), "age")
      
       
    })
 
### Adrian comments, 26 June, 2024
# Nice! You found the way to write enhanced text for the app
    output$dynamicText <- renderUI({
      HTML(paste("Let's look at some descriptive statistics regarding the age distribution. The age group <b>",
                 input$ageg, "</b> has a sample size of <b>",nrow(tempdf()),"</b>."
      ))
      
    })      
    
    
    output$plotGender <- renderPlot({
      plott_gen()
      
    })  
    
    output$plotGender_2 <- renderPlot({
      plott_gen_2()
      
    })  
    
    
    
    
    output$plotAge <- renderPlot({
      plott_re()
      
    })  
    
     
}

# Run the application 
shinyApp(ui = ui, server = server)
