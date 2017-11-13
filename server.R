library("data.table")

#Grab today's data
#Used to set randomization seed and to name file
today <- gsub("-", "", substr(Sys.time(), 1, 14))
today <- gsub(":", "", today)
today <- gsub(" ", "", today)

#Simple randomization function based on percent allocated to 4 possible treatment conditions
simple.randomization <- function(data, percent.1, percent.2, percent.3, percent.4) {
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

#Complete andomization function based on number allocated to 4 possible treatment conditions
complete.randomization <- function(n.1, n.2, n.3, n.4) {
  #Set seed based on today's date
  set.seed(as.numeric(today))
  m_each <- c(n.1, n.2, n.3, n.4)
  #Length of data should equal the sum of m_each
  condition_names <- c("Group 1", "Group 2", "Group 3", "Group 4")
  treat <- sample(rep(condition_names, m_each))
  return(treat)
}

shinyServer(function(input, output) {
  
  output$simple.help <- renderUI({
    if (input$type.rand=="Simple")
      helpText("NOTE: All percentages must add to 1")
  })
  
  output$simple.percentCondition1 <- renderUI({
    if (input$type.rand=="Simple")
    sliderInput("percentCondition1", "Probability of Group 1:", min = 0, max = 1, value = 0.5, step = 0.01)
  })
  
  output$simple.percentCondition2 <- renderUI({
    if (input$type.rand=="Simple")
      sliderInput("percentCondition2", "Probability of Group 2:", min = 0, max = 1, value = 0.5, step = 0.01)
  })
  
  output$simple.percentCondition3 <- renderUI({
    if (input$type.rand=="Simple")
      sliderInput("percentCondition3", "Probability of Group 3:", min = 0, max = 1, value = 0, step = 0.01)
  })
  
  output$simple.percentCondition4 <- renderUI({
    if (input$type.rand=="Simple")
      sliderInput("percentCondition4", "Probability of Group 4:", min = 0, max = 1, value = 0, step = 0.01)
  })
  
  output$complete.help <- renderUI({
    if (input$type.rand=="Complete")
      helpText("NOTE: Number in each condition must equal number of observations in data")
  })
  
  output$complete.nCondition1 <- renderUI({
    if (input$type.rand=="Complete")
    numericInput("nCondition1", "Number in Group 1", value = 0, min = 0, max = NA, step = 1)
  })
  
  output$complete.nCondition2 <- renderUI({
    if (input$type.rand=="Complete")
    numericInput("nCondition2", "Number in Group 2", value = 0, min = 0, max = NA, step = 1)
  })
  
  output$complete.nCondition3 <- renderUI({
    if (input$type.rand=="Complete")
    numericInput("nCondition3", "Number in Group 3", value = 0, min = 0, max = NA, step = 1)
  })
  
  output$complete.nCondition4 <- renderUI({
    if (input$type.rand=="Complete")
    numericInput("nCondition4", "Number in Group 4", value = 0, min = 0, max = NA, step = 1)
  })
  
  
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
    
    if (input$type.rand=="Simple") {
      #Conduct simple randomization
      Dataset$treat <- simple.randomization(Dataset, input$percentCondition1, input$percentCondition2,
                                            input$percentCondition3, input$percentCondition4) 
    } else {
      #Conduct complete randomization
      Dataset$treat <- complete.randomization(input$nCondition1, input$nCondition2, input$nCondition3, input$nCondition4)
    }
    return(Dataset)
  })
  
  # Select variables to download:
  output$varselect <- renderUI({
    
    if (identical(Dataset(), '') || identical(Dataset(),data.frame())) return(NULL)
    
    # Variable selection:    
    selectInput("vars", "Variables to download:",
                names(Dataset()), names(Dataset()), multiple =TRUE)            
  })
  
  # Show testing text:
  output$text <- renderUI({
    
    if (is.null(input$vars) || length(input$vars)==0) {
        HTML("NEED TO UPLOAD DATA. </br>For additional documentation or to file any issues, see <a href=\"https://github.com/joshuakalla/simple_shiny_randomization/blob/master/README.md\" target=\"_blank\">https://github.com/joshuakalla/simple_shiny_randomization/blob/master/README.md.")
    } else if (input$type.rand=="Simple" & input$percentCondition1 + input$percentCondition2 + input$percentCondition3 + input$percentCondition4 != 1) {
        HTML("WARNING: Percentages do not sum to 1. Please reload and try again. </br>For additional documentation or to file any issues, see <a href=\"https://github.com/joshuakalla/simple_shiny_randomization/blob/master/README.md\" target=\"_blank\">https://github.com/joshuakalla/simple_shiny_randomization/blob/master/README.md.")
    } else if (input$type.rand=="Complete") {
        HTML("Make sure the number in each condition equals the number of observations in data. When the 'Error:' disappears and you see 'Variables to download,' you can select 'Randomize and Download!'</br>For additional documentation or to file any issues, see <a href=\"https://github.com/joshuakalla/simple_shiny_randomization/blob/master/README.md\" target=\"_blank\">https://github.com/joshuakalla/simple_shiny_randomization/blob/master/README.md.")
    } else 
      HTML("GOOD TO DOWNLOAD! </br>For additional documentation or to file any issues, see <a href=\"https://github.com/joshuakalla/simple_shiny_randomization/blob/master/README.md\" target=\"_blank\">https://github.com/joshuakalla/simple_shiny_randomization/blob/master/README.md.")
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