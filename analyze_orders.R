source("new_orders.R")

suppliers <- c("S1", "S2", "S3", "S4", "S5")
capacity <- c(460, 500, 470, 390, 100)
price <- c(12, 14, 23, 44, 20)
summary <- data.frame(suppliers, capacity, price)


result <- new_orders(name = "Name", supplier_table = summary)

library(ggplot2)

analyze_orders <- function(order_data) {
  if (!all(c("suppliers", "capacity", "price", "Orders") %in% colnames(order_data))) {
    stop("The data does not contain the required columns: 'suppliers', 'capacity', 'price', 'Orders'.")
  }
  
  cat("\n--- Data Analysis ---\n")
  total_orders <- sum(order_data$Orders)
  cat("Total orders placed:", total_orders, "units\n")
  
  order_stats <- summary(order_data$Orders)
  cat("\nOrder statistics:\n")
  print(order_stats)
  
  order_data$Percentage_Used <- (order_data$Orders / order_data$capacity) * 100
  cat("\nPercentage of capacity used by each supplier:\n")
  print(order_data[, c("suppliers", "Percentage_Used")])
  
  order_data$Total_Cost <- order_data$Orders * order_data$price
  total_cost <- sum(order_data$Total_Cost)
  cat("\nTotal cost of all orders: $", total_cost, "\n")
  print(order_data[, c("suppliers", "Total_Cost")])
  
  cat("\n--- Generating Plots ---\n")
  
  bar_plot <- ggplot(order_data, aes(x = suppliers, y = Orders)) +
    geom_bar(stat = "identity", fill = "skyblue") +
    labs(title = "Orders per Supplier", x = "Suppliers", y = "Orders") +
    theme_minimal()
  
  pie_chart <- ggplot(order_data, aes(x = "", y = Percentage_Used, fill = suppliers)) +
    geom_bar(stat = "identity", width = 1) +
    coord_polar("y") +
    labs(title = "Capacity Usage by Supplier") +
    theme_minimal()
  
  dev.new()
  print(bar_plot)
  
  dev.new()
  print(pie_chart)
  
  return(order_data)
}

analyzed_data <- analyze_orders(result)

