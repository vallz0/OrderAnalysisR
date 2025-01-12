new_orders <- function(name, supplier_table) {
  
  my_orders <- rep(0, nrow(supplier_table))  # Inicializa os pedidos como zero
  continue_ordering <- TRUE
  
  while (continue_ordering) {  # Loop principal para continuar os pedidos
    cat("\n----------- NEW ORDER ------------\n")
    cat("We have", nrow(supplier_table), "registered suppliers.\n")
    
    for (i in seq_len(nrow(supplier_table))) {  # Loop por cada fornecedor
      repeat {
        cat("\nHow many units would you like to order from supplier", supplier_table$suppliers[i], "?\n")
        input <- readline(prompt = "Enter the quantity: ")
        
        # Validação da entrada
        if (!grepl("^[0-9]+(\\.[0-9]*)?$", input)) {
          cat("Invalid input. Please enter a valid number.\n")
          next
        }
        
        order <- as.numeric(input)  # Converte para número após validação
        
        # Verificações de limite do pedido
        if (order <= 0) {
          cat("Please enter a valid value.\n")
        } else if (order < 0.1 * supplier_table$capacity[i]) {
          cat("Order too low. It must be greater than", 0.1 * supplier_table$capacity[i], "units.\n")
        } else if (order > supplier_table$capacity[i]) {
          cat("Order exceeds maximum stock. The order must not exceed", supplier_table$capacity[i], "units.\n")
        } else {
          my_orders[i] <- order
          cat("Order successfully placed!\n")
          break  # Sai do `repeat` quando o pedido é válido
        }
      }
    }
    
    # Atualiza os pedidos na tabela
    supplier_table$Orders <- my_orders
    
    # Exibe resumo dos pedidos
    cat("\n ----- Order Summary ------ \n")
    print(supplier_table)
    
    # Pergunta ao usuário se deseja continuar pedindo
    continue_ordering <- tolower(readline(prompt = "Do you want to continue ordering? (y/n): ")) == "y"
  }
  
  # Finaliza e retorna a tabela
  cat("\nOrder finalized for the customer:", name, "\n")
  return(supplier_table)
}

