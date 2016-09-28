# load stable libraries here
library(shiny)
library(shinydashboard)
load("./data/userList.rda")
log = reactiveValues()

server <- function(input, output, session) {
  log[["userList"]] = userList
  log[["activityList"]] = activityList
  
  output$userCurrent <- renderDataTable({
    log$userList
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
}