library(shiny)

shinyServer(function(input, output) {
  trip <- reactive({
    req(input$car, input$distance, input$price)
    validate(need(is.finite(input$price) && input$price > 0,
                  "Enter a fuel price greater than zero."))
    km_per_litre <- setNames(mtcars[, "mpg"], rownames(mtcars)) * 0.425143707
    litres <- input$distance / km_per_litre
    costs <- litres * input$price
    list(litres = litres, costs = costs)
  })

  output$estimate <- renderText({
    result <- trip()
    sprintf("%s: %.1f litres of fuel, approximately ₹%.0f for %.0f km.",
            input$car, result$litres[input$car], result$costs[input$car],
            input$distance)
  })

  output$comparison <- renderPlot({
    result <- trip()
    cheapest <- sort(result$costs)[1:10]
    old_par <- par(mar = c(5, 11, 4, 1))
    on.exit(par(old_par))
    barplot(rev(cheapest), horiz = TRUE, las = 1,
            col = ifelse(names(rev(cheapest)) == input$car, "#bb603d", "#447b68"),
            border = NA, xlab = "Estimated cost (₹)",
            main = "Ten most fuel-efficient cars in mtcars",
            cex.names = 0.8)
  })
})
