# load stable libraries here
library(shiny)
library(shinydashboard)
library(DT)
load("./data/userList.rda")
load("./data/activityList.rda")
load("./data/recordList.rda")
load("./data/tempVar.rda")
log = reactiveValues()

server <- function(input, output, session) {
  log[["userList"]] = userList
  log[["activityList"]] = activityList
  log[["recordList"]] = recordList
  
  core <- eventReactive(input$loginBtn, {
    return(input$password)
  })
  
  output$recordCurrent <- renderDataTable({
    DT::datatable(log$recordList, 
                  rownames = FALSE,
                  filter = 'top', 
                  options = list(pageLength = 10, autoWidth = TRUE))
  })
  
  output$recordAddCategoryUI <- renderUI({
    selectInput("recordAddCategory", "Category:",
                choices = unique(log[["activityList"]]["activity"]))
  })
 
  output$recordAddPersonUI <- renderUI({
    selectInput("recordAddPerson", "Person:",
                choices = unique(log[["userList"]]["userName"]))
  })
  
  output$recordDeleteUI <- renderUI({
    selectizeInput("recordDeleteId", "Delete by ID:",
                   choices = unique(log[["recordList"]]["id"]))
  })
  
  observeEvent(input$recordAddBtn, {
    load("./data/recordList.rda")
    newRow = c(max(recordList$id)+1,
               as.character(input$recordAddDate),
               input$recordAddCategory,
               input$recordAddAmount,
               input$recordAddPerson,
               input$recordAddNote)
    recordList = data.frame(rbind(newRow, as.matrix(recordList)), 
                            stringsAsFactors = FALSE)
    recordList$id = as.numeric(recordList$id)
    recordList$amount = as.numeric(recordList$amount)
    recordList$date = as.Date(recordList$date)
    
    recordList = recordList[order(recordList$date, decreasing = TRUE), ]
    recordList$id = nrow(recordList):1
    log$recordList = recordList
    save(recordList, file="./data/recordList.rda")
  })
  
  observeEvent(input$recordDeleteBtn, {
    load("./data/recordList.rda")
    index = which(recordList$id == input$recordDeleteId)
    recordList = recordList[-index, ]
    recordList$id = nrow(recordList):1
    log$recordList = recordList
    save(recordList, file="./data/recordList.rda")
  })
  
  output$userCurrent <- renderDataTable({
    log$userList
  })
  
  output$userDeleteNameUI <- renderUI({
    selectInput("userDeleteName", "Delete by name:",
                choices = unique(log[["userList"]]["userName"]))
  })
  
  observeEvent(input$userAddBtn, {
    load("./data/userList.rda")
    a = as.character(as.Date(Sys.time()))
    userList = data.frame(rbind(userList, c(a, input$userAddName)))
    log$userList = userList
    save(userList, file="./data/userList.rda")
  })
  
  observeEvent(input$userDeleteBtn, {
    load("./data/userList.rda")
    index = which(userList$userName == input$userDeleteName)
    userList = userList[-index, ]
    log$userList = userList
    save(userList, file="./data/userList.rda")
  })
  
  output$activityCurrent <- renderDataTable({
    log$activityList
  })
  
  output$activityDelete <- renderUI({
    selectizeInput("activityDeleteName", "Delete by name:",
                   choices = unique(log[["activityList"]]["activity"]), 
                   selected = NULL)
  })
  
  observeEvent(input$activityAddBtn, {
    load("./data/activityList.rda")
    newRow = c(input$activityAddName, input$activityAddType)
    activityList = data.frame(rbind(activityList, newRow))
    log$activityList = activityList
    save(activityList, file="./data/activityList.rda")
  })
  
  observeEvent(input$activityDeleteBtn, {
    load("./data/activityList.rda")
    index = which(activityList$activity == input$activityDeleteName)
    activityList = activityList[-index, ]
    log$activityList = activityList
    save(activityList, file="./data/activityList.rda")
  })
  
  output$overviewTabUI <- renderUI({
    cr = core()
    if(FALSE){
      fluidPage(
        fluidRow(
          box(
            title = "Input", 
            status = "primary",
            solidHeader = TRUE,
            collapsible = TRUE,
            width=6,
            dateRangeInput("overviewDateRange", "Selete date range:")
          ),
          box(
            title = "This perid", 
            status = "primary",
            solidHeader = TRUE,
            collapsible = TRUE,
            width=6
          )
        ),
        fluidRow(
          box(
            title = "Overall", 
            status = "primary",
            solidHeader = TRUE,
            collapsible = TRUE,
            width=12
          )
        )
      )
    }
  })
  output$activityTabUI <- renderUI({
    cr = core()
    if(cr==tempVar){
      fluidRow(
        box(
          title = "Current activities", 
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          width=6,
          dataTableOutput("activityCurrent")
        ),
        box(
          title = "Add an activity", 
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          width=3,
          textInput("activityAddName", "New activity:"),
          selectizeInput("activityAddType", "New activity type:",
                         choices=c("Spending","Earning")),
          actionButton("activityAddBtn", "Add this activity")
        ),
        box(
          title = "Delete an activity", 
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          width=3,
          uiOutput("activityDelete"),
          actionButton("activityDeleteBtn", "Delete this activity")
        )
      )
    }
  })
  output$recordTabUI <- renderUI({
    cr = core()
    if(cr==tempVar){
      fluidRow(
        box(
          title = "Current records", 
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          width=8,
          dataTableOutput("recordCurrent")
        ),
        box(
          title = "Add a record", 
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          width=2,
          
          dateInput("recordAddDate", "Date:"),
          uiOutput("recordAddCategoryUI"),
          numericInput("recordAddAmount", "Amount:", value = 0),
          uiOutput("recordAddPersonUI"),
          textInput("recordAddNote", "Note:"),
          actionButton("recordAddBtn", "Add this record")
        ),
        box(
          title = "Delete a record", 
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          width=2,
          uiOutput("recordDeleteUI"),
          actionButton("recordDeleteBtn", "Delete this record")
        )
      )
    }
  })
  output$userTabUI <- renderUI({
    cr = core()
    if(cr==tempVar){
      fluidRow(
        box(
          title = "Current users", 
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          width=6,
          dataTableOutput("userCurrent")
        ),
        box(
          title = "Add an user", 
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          width=3,
          textInput("userAddName", "New user name:"),
          actionButton("userAddBtn", "Add this user")
        ),
        box(
          title = "Delete an user", 
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          width=3,
          uiOutput("userDeleteNameUI"),
          actionButton("userDeleteBtn", "Delete this user")
        )
      )
    }
  })
}