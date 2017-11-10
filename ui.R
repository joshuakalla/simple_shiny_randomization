shinyUI(pageWithSidebar(
  
  # Header:
  headerPanel("Randomization Tool"),
  
  # Input in sidepanel:
  sidebarPanel(
    tags$style(type='text/css', ".well { max-width: 20em; }"),
    # Tags:
    tags$head(
      tags$style(type="text/css", "select[multiple] { width: 100%; height:10em}"),
      tags$style(type="text/css", "select { width: 100%}"),
      tags$style(type="text/css", "input { width: 19em; max-width:100%}")
    ),
    
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
    
    #Percent in each condition
    #Default to two conditions, 50% in each
    helpText("NOTE: All percentages must add to 1"),
    sliderInput("percentCondition1", "Percent in Group One:", min = 0, max = 1, value = 0.5, step = 0.01),
    sliderInput("percentCondition2", "Percent in Group Two:", min = 0, max = 1, value = 0.5, step = 0.01),
    sliderInput("percentCondition3", "Percent in Group Three:", min = 0, max = 1, value = 0, step = 0.01),
    sliderInput("percentCondition4", "Percent in Group Four:", min = 0, max = 1, value = 0, step = 0.01),
    
    # Upload data:
    fileInput("file", "Upload data-file:"),
    
    # Variable selection:
    htmlOutput("varselect"),
    
    br(),
    
    downloadLink('downloadData', 'Randomize and Download!')
    
  ),
  
  # Main:
  mainPanel(
    
    tableOutput("table")
    
  )
))