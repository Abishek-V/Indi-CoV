source("global.R")

ui <- bs4Dash::dashboardPage(
  #enable_preloader = TRUE,
  #loading_background =  "#000000",
  title = "CoronaVirus Dashboard",
  old_school = TRUE,
  navbar = bs4Dash::bs4DashNavbar(
    bs4Badge(
      position = "right",
      status = "danger",
      h4(" COVID-19 PANDEMIC ANALYSIS IN INDIA ")
    ),
    skin="dark",
    status = "warning",
    border = TRUE,
    sidebarIcon = NULL,
    compact = FALSE,
    controlbarIcon = "th",
    leftUi = NULL,
    rightUi = bs4DropdownMenu(
      show = FALSE,
      labelText= "!",
      status = "danger",
      menuIcon = "bell",
      src = "https://www.google.com/search?q=corona+virus+updates+india"
      
      
    ), 
    fixed = FALSE
  ),
  sidebar_mini = FALSE,
  sidebar = bs4Dash::bs4DashSidebar(inputId = NULL,
                                    disable = T,
                                    
                                    skin = "dark",
                                    status = "primary",
                                    brandColor = NULL,
                                    url = NULL,
                                    src = NULL,
                                    elevation = 4,
                                    opacity = 0.8,
                                    expand_on_hover = F),
  
  
  
  body = bs4DashBody(
    br(),
    
    bs4Jumbotron(
      title = "Indi-Cov",
      lead = "Hey There...! What does a dataphile do when he gets access to  to COVID-19 data, he has 
      a happy headache pre-processing it, playing with data and finding Insights ",
      "",
      href = "https://github.com/Abishek-V/Indi-CoV/",
      btn_name = "More",
      status = "warning"
    ),
    
    h2("NATION-WIDE STATISTICS "),
    fluidRow(
      bs4ValueBox(
        elevation = 8,
        value = h1(totalconfirmed),
        subtitle = h4("CONFIRMED"),
        status = "info",
        icon = "hospital",
        href = "#"
      ),
      bs4ValueBox(
        elevation = 5,
        subtitle = h4("ACTIVE"),
        value = h1(totalactive),
        status = "warning",
        icon = "procedures"
      ),
      bs4ValueBox(
        elevation = 5,
        subtitle = h4("RECOVERED"),
        value = h1(totalrecovered),
        status = "success",
        icon = "user-shield"
      ),
      bs4ValueBox(
        elevation = 5,
        subtitle = h4("DEATHS"),
        value = h1(totaldeceased),
        status = "danger",
        icon = "heartbeat"
      )
    ),
    h4("Today Stats"),
    fluidRow(
      bs4InfoBox(
        title = h5("Confirmed"),
        value = h4(todayconfirmed),
        icon = "ambulance"
      ),
      bs4InfoBox(
        title = h5("Recovered"),
        status = "success",
        value = h4(todayrecovered),
        icon = "home"
      ),
      bs4InfoBox(
        title = h5("Deaths"),
        gradientColor = "danger",
        value = h4(todaydeaths),
        icon = "heartbeat"
      )
    ),
    br(),
    
    #bs4Box(
    # height = "800px",
    #title = h3("CORONA VIRUS SPREAD IN INDIA (Confirmed Cases)"),
    #width=5,
    #plotlyOutput("plot2")
    #),
    
    
    fluidRow(
      
      bs4Box(
        height = "800px",
        title = h3("CORONA VIRUS SPREAD IN INDIA (Confirmed Cases)"),
        width=5,
       plotlyOutput("plot3"),
        #,plotlyOutput("plot2")
      ),
      bs4Box(
        height = "800px",
        width=4,
        title = h3("STATE-WISE COUNT"),
        dataTableOutput(outputId = "dfftable") 
      ),
      bs4Box(
        height = "800px",
        width=3,
        title = h3("DISTRICT-WISE COUNT"),
        column(
          width = 10,
          align = "center",
          dropdownIcon = "wrench",
          selectInput("State", h4("Select State"), choices = as.list(data.frame(State_data$State),sorted=TRUE), selected = "Tamil Nadu")
          
        ),
        dataTableOutput(outputId = "sfftable") 
      )
      
    ),
    
    
    
    
    fluidRow(
      bs4Card(
        title = h3("Timeline of Updates - Past 3 days"),
        bs4Timeline(
          width = 12,
          reversed = TRUE,
          bs4TimelineEnd(status = "danger"),
          bs4TimelineLabel(paste(timeline[4,"date"]), status = "success"),
          bs4TimelineItem(
            elevation = 4,
            title = paste("Confirmed : ",timeline[4,"dailyconfirmed"]),
            icon = "angle-double-right",
            status = "warning",
            footer = paste("Deaths : ",timeline[4,"dailydeceased"]),
            paste("Recovered : ",timeline[4,"dailyrecovered"])
          ),
          
          bs4TimelineLabel(paste(timeline[3,"date"]), status = "success"),
          bs4TimelineItem(
            elevation = 3,
            title = paste("Confirmed : ",timeline[3,"dailyconfirmed"]),
            icon = "angle-double-right",
            status = "warning",
            footer = paste("Deaths : ",timeline[3,"dailydeceased"]),
            paste("Recovered : ",timeline[3,"dailyrecovered"])
          ),
          
          bs4TimelineLabel(paste(timeline[2,"date"]), status = "success"),
          bs4TimelineItem(
            elevation = 2,
            title = paste("Confirmed : ",timeline[2,"dailyconfirmed"]),
            icon = "angle-double-right",
            status = "warning",
            footer = paste("Deaths : ",timeline[2,"dailydeceased"]),
            paste("Recovered : ",timeline[2,"dailyrecovered"])
          ),
          
          bs4TimelineStart(status = "danger")
        )
      ),
      bs4Card(
        title = h3("COVID-19 Preventive Measures by WHO"),
        bs4Carousel(
          id = "mycarousel",
          width = 12,
          bs4CarouselItem(
            active = TRUE,
            src = "https://i.imgur.com/y9sXk7V.jpg"
          ),
          bs4CarouselItem(
            active = FALSE,
            src = "https://www.who.int/images/default-source/health-topics/coronavirus/risk-communications/general-public/protect-yourself/blue-1.png"
          ),
          bs4CarouselItem(
            active = FALSE,
            src = "https://www.who.int/images/default-source/health-topics/coronavirus/risk-communications/general-public/protect-yourself/blue-2.png"
          ),
          bs4CarouselItem(
            active = FALSE,
            src = "https://www.who.int/images/default-source/health-topics/coronavirus/risk-communications/general-public/protect-yourself/blue-3.png"
          ),
          bs4CarouselItem(
            active = FALSE,
            src = "https://www.who.int/images/default-source/health-topics/coronavirus/risk-communications/general-public/protect-yourself/blue-4.png"
          )
        )
      )
    ),
    
    br(),
    
    fluidRow(
      
      bs4Card(
        title = h1("COVID-19 Spread in India"),
        closable = TRUE,
        width = 6,
        status = "warning",
        solidHeader=TRUE,
        labelStatus = "danger",
        gradientColor = "success",
        collapsible = TRUE,
        maximizable = TRUE,
        echarts4rOutput("riverPlot")
        
      ),
      bs4Card(
        title = h1("COVID-19 Spread in India"),
        closable = TRUE,
        width = 6,
        status = "success",
        solidHeader=TRUE,
        labelStatus = "danger",
        gradientColor = "warning",
        collapsible = TRUE,
        maximizable = TRUE,
        
        echarts4rOutput("rivPlot")
        
      )
      
    )
    
    
    #fluidRow(
    # bs4Card(
    #  title = h1("Timeline of confirmed Cases"),
    # closable = TRUE,
    #width = 12,
    #height = 1000,
    #status = "success",
    #solidHeader=TRUE,
    ##labelStatus = "danger",
    #gradientColor = "danger",
    #collapsible = TRUE,
    #maximizable = TRUE,
    
    
    
    #tags$video(id="video2", type = "video/mp4",src = "animation_4.mp4", controls = "controls")
    #)
    # )   
    
    
  ),
  
  
  footer = bs4DashFooter(
    copyrights = a(
      href = "https://www.instagram.com/i_dataphile/",
      target = "_blank", h4("@i_dataphile")
    ),
    
    right_text = "2020"
  )
  
)
#output$plot2 <- renderPlotly({
#    
#           fig
#})     

server = function(input, output, session) {
  output$plot3 <- renderPlotly({
    library(ggplot2)
    library(gganimate)
    library(babynames)
    library(hrbrthemes)
    library(dplyr)
    library(viridis)
 
    # Plot
    don %>%
      ggplot( aes(x=year, y=n, group=name, color=name)) +
      geom_line() +
      geom_point() +
      scale_color_viridis(discrete = TRUE) +
      ggtitle("Popularity of American names in the previous 30 years") +
      theme_ipsum() +
      ylab("Number of babies born") +
      transition_reveal(year)
  })
  
  
  output$sfftable<- renderDataTable({
    
    
    sf<-district_wise[district_wise$State==input$State,2:4]
    sf<-sf[order(sf[,2],decreasing = T),]
    datatable(data = sf, options(paging=FALSE,buttons="excel",fixedHeader=TRUE,searchPanes=FALSE),
              rownames = FALSE,style = "bootstrap")
  })
  
  output$dfftable<- renderDataTable({
    
    datatable(data = bf, options(paging=FALSE,buttons="excel",fixedHeader=TRUE),
              rownames = FALSE,style = "bootstrap")
  })
  
  
  output$rivPlot <- renderEcharts4r({
    
  })
  
  output$riverPlot <- renderEcharts4r({
    cum_river %>%
      e_charts(date_format) %>%
      e_river(totalconfirmed) %>%
      e_river(totalrecovered) %>%
      e_river(totaldeceased) %>%
      e_tooltip(trigger = "axis") %>%
      e_title("Flow of cases", "(Day-wise)") %>%
      #(Data from [03 March 2020- Present] Hover over the map
      e_theme("shine")
  })
  
  
  
  
}

shinyApp(ui=ui, server=server)

