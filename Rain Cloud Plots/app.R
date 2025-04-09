#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

options(repos = c(CRAN = "https://cloud.r-project.org/"))

library(shiny)
library(cowplot)
library(ggplot2)
library(dplyr)
library(readr)

options(repos = c(CRAN = "https://cloud.r-project.org/"))

source("R_rainclouds.R")
source("getDataDiabetes.R")

ui <- fluidPage(
  titlePanel("Raincloud Plot de Niveles de Glucosa"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("grupo", "Selecciona el grupo:", 
                  choices = c("Diabéticos", "No Diabéticos", "Ambos"), 
                  selected = "Ambos"),
      
      sliderInput("rango_glucosa", "Selecciona el rango de glucosa:",
                  min = min(pima_clean$Glucose), max = max(pima_clean$Glucose), 
                  value = c(min(pima_clean$Glucose), max(pima_clean$Glucose)))
    ),
    
    mainPanel(
      plotOutput("raincloudPlot")
    )
  )
)

server <- function(input, output) {
  
  # Filtrar el dataset basado en la selección del grupo
  dataset_filtrado <- reactive({
    if(input$grupo == "Diabéticos") {
      subset(pima_clean, Outcome == "Diabético")
    } else if(input$grupo == "No Diabéticos") {
      subset(pima_clean, Outcome == "No Diabético")
    } else {
      pima_clean  # Para la opción "Ambos", no filtramos nada
    }
  })
  
  # Crear el Raincloud Plot según la selección del grupo
  output$raincloudPlot <- renderPlot({
    data <- dataset_filtrado()
    
    # Filtrar por rango de glucosa
    data <- subset(data, Glucose >= input$rango_glucosa[1] & Glucose <= input$rango_glucosa[2])
    
    ggplot(data, aes(x = Outcome, y = Glucose, fill = Outcome)) +
      # Añadir la nube de puntos
      geom_flat_violin(position = position_nudge(x = .35, y = 0), adjust = 2, trim = FALSE) +
      geom_point(position = position_jitter(width = .15), size = .25) +
      # Boxplot alineado con los violines
      geom_boxplot(aes(x = as.numeric(Outcome) + 0.25, y = Glucose), outlier.shape = NA, alpha = 0.3, width = .1, colour = "BLACK") +
      ylab('Nivel de Glucosa') + xlab('Grupo') + coord_flip() + theme_cowplot() + 
      guides(fill = FALSE, colour = FALSE) +
      ggtitle("Raincloud Plot con Boxplots")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
