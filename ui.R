library(shiny)
library(shinydashboard)
load("./data/userList.rda")
load("./data/activityList.rda")
load("./data/recordList.rda")
dashboardPage(
  skin = "blue",
  
  dashboardHeader(
    title = "Financial Management Dashboard"
  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Welcome", tabName="welcomeTab", icon = icon("key")),
      menuItem("Record", tabName="recordTab", icon = icon("plus")),
      menuItem("Activity", tabName = "activityTab", icon=icon("credit-card")),
      menuItem("User", tabName = "userTab", icon=icon("child")),
      menuItem("Overview", tabName="overviewTab", icon=icon("line-chart"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "welcomeTab",
        fluidRow({
          column(
            width = 12,
            h1("Welcome to your Financial Management Dashboard", align = "center"),
            h3("Here, you can easily record your financial activities and visualize them", align = "center")
          )
        }), 
        br(),
        br(),
        fluidRow(
          column(width=3),
          column(
            width=6,
              passwordInput("password", "Password"),
              actionButton("loginBtn", "Login")
          ),
          column(width=3)
        )
      ),
      
      tabItem(
        tabName = "recordTab",
        uiOutput("recordTabUI")
      ),
      
      tabItem(
        tabName = "activityTab",
        uiOutput("activityTabUI")
      ),
      
      tabItem(
        tabName = "userTab",
        uiOutput("userTabUI")
      ),
      
      tabItem(
        tabName = "overviewTab",
        uiOutput("overviewTabUI")
      )
    )
  )
)