library(shiny)
library(shinydashboard)
load("./data/userList.rda")
dashboardPage(
  skin = "blue",
  
  dashboardHeader(
    title = "Financial Management Dashboard"
  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        "User", tabName = "userTab", icon=icon("child")
      ),
      menuItem(
        "Activity", tabName = "activityTab", icon=icon("credit-card")
      ),
      menuItem(
        "History", tabName="historyTab", icon = icon("plus")
      ),
      menuItem(
        "Overview", tabName="overviewTab", icon=icon("line-chart")
      )
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "userTab",
        fluidRow({
          column(
            width = 12,
            h1("Welcome to your Financial Management Dashboard", align = "center"),
            h3("Here, you can easily record your financial activities and visualize them", align = "center")
          )
        }), 
        br(),
        br(),
        br(),
        br(),
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
            textInput("userDeleteName", "Delete by name:"),
            actionButton("userDeleteBtn", "Delete this user")
          )
        )
      ),
      
      tabItem(
        tabName = "activityTab",
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
            actionButton("activityAddBtn", "Add this activity")
          ),
          box(
            title = "Delete an activity", 
            status = "primary",
            solidHeader = TRUE,
            collapsible = TRUE,
            width=3,
            textInput("activityDeleteName", "Delete by name:"),
            actionButton("activityDeleteBtn", "Delete this activity")
          )
        )
      ),
      
      tabItem(
        tabName = "overviewTab"
      )
    )
  )
)