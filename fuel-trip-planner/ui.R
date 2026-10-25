library(shiny)

fluidPage(
  tags$head(tags$style(HTML("
    body { background: #f6f3ec; color: #17342e; }
    .container-fluid { max-width: 1100px; margin: auto; }
    .well { background: #fff; border-color: #e4ded0; border-radius: 12px; }
    .help-box { background: #e8f2ed; padding: 16px 20px; border-radius: 12px; margin: 18px 0; }
    .result { font-size: 1.25rem; line-height: 1.8; }
  "))),
  titlePanel("Trip Fuel Planner"),
  p("Estimate fuel use and cost for a journey using the cars in R's mtcars dataset."),
  div(class = "help-box",
      h3("How to use this app"),
      tags$ol(
        tags$li("Choose a car from the list."),
        tags$li("Set the journey distance in kilometres and fuel price per litre."),
        tags$li("Read the estimate and compare it with the other cars in the chart.")
      ),
      p("The estimate uses each car's dataset fuel economy as a constant. Actual fuel use varies with traffic, driving, load, and vehicle condition. The dataset contains older cars, so use this as an illustration rather than a current vehicle quote.")
  ),
  sidebarLayout(
    sidebarPanel(
      selectInput("car", "Car", choices = rownames(mtcars), selected = "Toyota Corolla"),
      sliderInput("distance", "Journey distance (km)", min = 10, max = 1000,
                  value = 250, step = 10),
      numericInput("price", "Fuel price (₹ per litre)", value = 100,
                   min = 1, max = 1000, step = 1)
    ),
    mainPanel(
      h3("Your estimate"),
      div(class = "result", textOutput("estimate")),
      h3("Lowest estimated fuel costs for this journey"),
      plotOutput("comparison", height = "400px"),
      p("Formula: litres = distance ÷ (miles per gallon × 0.425143707); cost = litres × fuel price.")
    )
  )
)
