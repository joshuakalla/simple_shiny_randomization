library("data.table")

shinyServer(function(input, output) {
  
  #Grab today's data
  #Used to set randomization seed and to name file
  today <- gsub("-", "", substr(Sys.time(), 1, 10))
  
  #Randomization function based on percent allocated to 4 possible treatment conditions
  randomization <- function(data, percent.1, percent.2, percent.3, percent.4) {
    #Set seed based on today's date
    set.seed(as.numeric(today))
    rand <- runif(nrow(data), min = 0.0001, max = 0.9999)
    group.1 <- percent.1
    group.2 <- percent.1 + percent.2
    group.3 <- percent.1 + percent.2 + percent.3
    group.4 <- percent.1 + percent.2 + percent.3 + percent.4
    #NOTE: group.4 should always equal 1, there is a test for this
    treat <- rep(NA, length(data))
    treat[rand %inrange% list(0, group.1)] <- "Group 1"
    treat[rand %inrange% list(group.1, group.2)] <- "Group 2"
    treat[rand %inrange% list(group.2, group.3)] <- "Group 3"
    treat[rand %inrange% list(group.3, group.4)] <- "Group 4"
    return(treat)
  }
  
  ### Argument names:
  ArgNames <- reactive({
    Names <- names(formals(input$readFunction)[-1])
    Names <- Names[Names!="..."]
    return(Names)
  })
  
  ## Arg text field:
  output$ArgText <- renderUI({
    fun__arg <- paste0(input$readFunction,"__",input$arg)
    
    if (is.null(input$arg)) return(NULL)
    
    Defaults <- formals(input$readFunction)
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
    
    #Conduct randomization
    Dataset$treat <- randomization(Dataset, input$percentCondition1, input$percentCondition2,
                             input$percentCondition3, input$percentCondition4)
    
    return(Dataset)
  })
  
  # Select variables to download:
  output$varselect <- renderUI({
    
    if (identical(Dataset(), '') || identical(Dataset(),data.frame())) return(NULL)
    
    # Variable selection:    
    selectInput("vars", "Variables to download:",
                names(Dataset()), names(Dataset()), multiple =TRUE)            
  })
  
  # Show table:
  output$table <- renderTable({
    
    if (is.null(input$vars) || length(input$vars)==0) {
      return(NULL)
    } else if (input$percentCondition1 + input$percentCondition2 + input$percentCondition3 + input$percentCondition4 != 1) {
      return("WARNING: Percentages do not sum to 1. Please reload and try again")
    } else {return(Dataset()[,input$vars,drop=FALSE])}
  })
  
  ### Download save:
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(gsub(".csv", "", input$file), "_", today, "_randomized.csv", sep = "")
    },
    content = function(file) {
      write.csv(Dataset(), file, row.names = FALSE)
    }
  )
  
})