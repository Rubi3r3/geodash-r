# Load required libraries
library(shiny)
library(leaflet)
library(shinyjs)


source("config.R")
# Define the UI
ui <- fluidPage(
  # Initialize shinyjs
  useShinyjs(),
  
  # Center the login page
  tags$style(type="text/css", ".login-container { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }"),
  
  # Login page
  div(id = "login",
      textInput("username", "Username"),
      class = "login-container",  # Added class for centering
      passwordInput("password", "Password"),
      actionButton("loginBtn", "Login"),
      verbatimTextOutput("loginMessage")
  ),
  
  # Map page
  div(id = "map",
      leafletOutput("belizeMap", height = "100vh")
  )
)

# Define the server logic
server <- function(input, output, session) {
  # Initial login status
  loginStatus <- reactiveValues(loggedIn = FALSE)
  
  # Login button click event
  observeEvent(input$loginBtn, {
    # Check credentials
    if (input$username == auth_user$username && input$password == auth_user$password) {
      loginStatus$loggedIn <- TRUE
    } else {
      loginStatus$loggedIn <- FALSE
    }
  })
  
  # Update UI based on login status
  observe({
    if (loginStatus$loggedIn) {
      # Hide login page, show map page
      shinyjs::hide("login")
      shinyjs::show("map")
    } else {
      # Show login page, hide map page
      shinyjs::show("login")
      shinyjs::hide("map")
    }
  })
  
  # Display login message
  output$loginMessage <- renderText({
    if (loginStatus$loggedIn) {
      "Login successful! Redirecting..."
    } else {
      "Incorrect username or password. Please try again."
    }
  })
  
  # Define Belize map
  output$belizeMap <- renderLeaflet({
    leaflet() %>%
      setView(lng = -88.896530, lat = 17.189877, zoom = 7) %>%
      addTiles() %>%
      addMarkers(lng = -88.896530, lat = 17.189877, popup = "Welcome to Belize!")
  })
}



# Run the application
shinyApp(ui, server, options=list(port=8100))
