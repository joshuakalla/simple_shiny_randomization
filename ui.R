shinyUI(pageWithSidebar(
  
  # Header:
  headerPanel("R data reader"),
  
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
      "read.table",
      "read.csv",
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
    
    # Argument selecter:
    htmlOutput("ArgSelect"),
    
    # Argument field:
    htmlOutput("ArgText"),
    
    # Upload data:
    fileInput("file", "Upload data-file:"),
    
    # Number of conditions
    selectInput("numCondition", "Number of Experimental Groups:", c(2, 3, 4)),
    
    #Percent in each condition
    #2 conditions
    sliderInput("percentCondition2.a", "Percent in Group One:", min = 0, max = 1, value = 0, step = 0.01),
    sliderInput("percentCondition2.b", "Percent in Group Two:", min = 0, max = 1, value = 0, step = 0.01),
    #3 conditions
    sliderInput("percentCondition2.c", "Percent in Group Three:", min = 0, max = 1, value = 0, step = 0.01),
    #4 conditions
    sliderInput("percentCondition2.d", "Percent in Group Four:", min = 0, max = 1, value = 0, step = 0.01),
    
    br(),
    
    textInput("name","Dataset name:","Data"),
    
    downloadLink('downloadDump', 'Download source'),
    downloadLink('downloadSave', 'Download binary')
    
  ),
  
  # Main:
  mainPanel(
    
    tableOutput("table")
    
  )
))