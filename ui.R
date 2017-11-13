shinyUI(pageWithSidebar(
  
  # Header:
  headerPanel("Randomization Tool"),
                    # Input in sidepanel:
                    sidebarPanel(
                      tags$style(type='text/css', ".well { max-width: 30em; }"),
                      # Tags:
                      tags$head(
                        tags$style(type="text/css", "select[multiple] { width: 100%; height:10em}"),
                        tags$style(type="text/css", "select { width: 100%}"),
                        tags$style(type="text/css", "input { width: 29em; max-width:100%}")
                      ),
                      
                      selectInput("type.rand", "Type of Randomization:", c("Simple", "Complete")),
                      
                      # Select filetype:
                      selectInput("readFunction", "Function to read data:", c(
                        # Base R:
                        "read.csv",
                        "read.table",
                        "read.csv2",
                        "read.delim",
                        "read.delim2",
                        
                        # foreign functions:
                        "read.spss",
                        "read.arff",
                        "read.dbf",
                        "read.dta",
                        "read.epiiinfo",
                        "read.mtp",
                        "read.octave",
                        "read.ssd",
                        "read.systat",
                        "read.xport",
                        
                        # Advanced functions:
                        "scan",
                        "readLines"
                      )),
                      
                      #SIMPLE RANDOM ASSIGNMENT Percent in each condition
                      #Default to two conditions, 50% in each
                      uiOutput("simple.help"),
                      uiOutput("simple.percentCondition1"),
                      uiOutput("simple.percentCondition2"),
                      uiOutput("simple.percentCondition3"),
                      uiOutput("simple.percentCondition4"),

                      #COMPLETE RANDOM ASSIGNMENT Specify N in each condition
                      uiOutput("complete.help"),
                      uiOutput("complete.nCondition1"),
                      uiOutput("complete.nCondition2"),
                      uiOutput("complete.nCondition3"),
                      uiOutput("complete.nCondition4"),
                      
                      # Upload data:
                      fileInput("file", "Upload data file:"),
                      
                      # Variable selection:
                      htmlOutput("varselect"),
                      
                      br(),
                      
                      downloadLink('downloadData', 'Randomize and Download!')
                    ),

  # Main:
  mainPanel(
    
    uiOutput("text")
    
  )
))