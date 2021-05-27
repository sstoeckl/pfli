server <- function(input, output, session) {
  out_reactive <- reactive({
    X_predict <- structure(list(c_age = input$c_age, gender = input$gender, li = input$li, lg = input$lg, 
                                c1 = input$c1, s11 = input$s11, s12 = input$s12, s2 = input$s2, s3 = input$s3, 
                                w0 = input$w0, rho2 = input$rho2, rho3 = input$rho3, psi = input$psi, beta = input$beta, 
                                ra = input$ra, delta = input$delta, ret_age = input$ret_age, c2 = input$c2, nu2 = input$nu2, 
                                nu3 = input$nu3), row.names = c(NA, -1L), class = c("tbl_df", 
                                                                               "tbl", "data.frame"))
    
    url <- paste0("http://inno.uni.li:8000/predict?",paste0(paste(names(X_predict),X_predict,sep="="),collapse="&"))
    predictions <- jsonlite::fromJSON(url)
    out <- rbind(predictions$predLM,predictions$predKNN,predictions$predRF)
    colnames(out) <- c("cons","alpha","w_stocks","w_bonds","w_realest")
    rownames(out) <- c("Linear Model","K-Nearest Neighbors","Random Forest")
    return(out)
  })
  output$opti <- renderTable({
    out_reactive()
  },rownames = TRUE)
  pct_reactive <- reactive({
    url <- paste0("http://inno.uni.li:8000/percent")
    percent <- jsonlite::fromJSON(url)
    out <- paste0("Currently we have optimised ",round(as.numeric(percent$n_out)/3110400*100,1)," percent (",as.numeric(percent$n_out)," of ",3110400,")of our initial optimisation grid. Machine Learning results presented below are therefore not very reliable, especially for values outside the initial optimisation grid.")
    return(out)
  })
  output$pct <- renderText({
    pct_reactive()
  })
}