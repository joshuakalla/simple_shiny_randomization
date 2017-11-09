library("data.table")

shinyServer(function(input, output) {
  
  randomization <- function(data, percent.1, percent.2, percent.3, percent.4) {
    #Set seed based on today's date
    set.seed(as.numeric(gsub("-", "", substr(Sys.time(), 1, 10))))
    rand <- runif(nrow(data), min = 0.0001, max = 0.9999)
    group.1 <- percent.1
    group.2 <- percent.1 + percent.2
    group.3 <- percent.1 + percent.2 + percent.3
    group.4 <- percent.1 + percent.2 + percent.3 + percent.4
    
    #NOTE: group.4 should always equal 1
    
    treat <- rep(NA, length(data))
    treat[rand %inrange% list(0, group.1)] <- 1
    treat[rand %inrange% list(group.1, group.2)] <- 2
    treat[rand %inrange% list(group.2, group.3)] <- 3
    treat[rand %inrange% list(group.3, group.4)] <- 4
    
    treat
    return(treat)
  }
  
  data <- data.frame(runif(100))
  data$treat <- randomization(data, 0.25, 0.25, 0.5, 0)
  table(data$treat)
  
  
  ### Argument names:
  ArgNames <- reactive({
    Names <- names(formals(input$readFunction)[-1])
    Names <- Names[Names!="..."]
    return(Names)
  })
  
  # Argument selector:
  output$ArgSelect <- renderUI({
    if (length(ArgNames())==0) return(NULL)
    
    selectInput("arg","Argument:",ArgNames())
  })
  
  ## Arg text field:
  output$ArgText <- renderUI({
    fun__arg <- paste0(input$readFunction,"__",input$arg)
    
    if (is.null(input$arg)) return(NULL)
    
    Defaults <- formals(input$readFunction)
    
    if (is.null(input[[fun__arg]]))
    {
      textInput(fun__arg, label = "Enter value:", value = deparse(Defaults[[input$arg]])) 
    } else {
      textInput(fun__arg, label = "Enter value:", value = input[[fun__arg]]) 
    }
  })
  
  
  ### Data import:
  Dataset <- reactive({
    if (is.null(input$file)) {
      # User has not uploaded a file yet
      return(data.frame())
    }
    
    args <- grep(paste0("^",input$readFunction,"__"), names(input), value = TRUE)
    
    argList <- list()
    for (i in seq_along(args))
    {
      argList[[i]] <- eval(parse(text=input[[args[i]]]))
    }
    names(argList) <- gsub(paste0("^",input$readFunction,"__"),"",args)
    
    argList <- argList[names(argList) %in% ArgNames()]
    
    Dataset <- as.data.frame(do.call(input$readFunction,c(list(input$file$datapath),argList)))
    return(Dataset)
  })
  
  # Select variables:
  output$varselect <- renderUI({
    
    if (identical(Dataset(), '') || identical(Dataset(),data.frame())) return(NULL)
    
    # Variable selection:    
    selectInput("vars", "Variables to use:",
                names(Dataset()), names(Dataset()), multiple =TRUE)            
  })
  
  # Show table:
  output$table <- renderTable({
    
    if (is.null(input$vars) || length(input$vars)==0) return(NULL)
    
    return(Dataset()[,input$vars,drop=FALSE])
  })
  
  
  ### Download save:
  
  output$downloadSave <- downloadHandler(
    filename = "Rdata.RData",
    content = function(con) {
      
      assign(input$name, Dataset()[,input$vars,drop=FALSE])
      
      save(list=input$name, file=con)
    }
  )
  
})