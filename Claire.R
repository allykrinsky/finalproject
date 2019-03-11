library("dplyr")
library("tidyr")
library("httr")
library("stringr")
library("ggplot2")
library("shiny")
library("plotly")

gdp <- read.csv("data/gdp.csv",stringsAsFactors = FALSE)

gdp <- select(gdp, -1, -3)


compared_gdp <- function(state, industry){
    state_gdp <- filter(gdp, GeoName == state | GeoName == "United States*")
  
  # remove the blank space in the begining
  remove_space <- trimws(state_gdp$Description, "left")
  state_gdp$Description = remove_space
  industry_gdp <- filter(state_gdp,Description == industry)
  #View(industry_gdp)
  
  gathered_industry <- gather(industry_gdp, time, GDP, 3:57) %>% 
    # add a column for the year
    mutate(year = substr(time, 2,5)) 
  gathered_industry$GDP = as.numeric(gathered_industry$GDP)

  
  p <- ggplot(data = gathered_industry) +
    
    geom_line(mapping = aes(x= year, y = GDP, group = GeoName))+
    geom_point(mapping = aes(x= year, y = GDP, group = GeoName))+
    theme(
      panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
      panel.background = element_blank(), axis.line = element_line(colour = "black")
    )+
    labs(
      title = paste("The GDP in United States and",state, "from 2016 to 2018 in", industry),
      x = "year",
      y = "GDP"
    )
  
  ggplotly(p)
  
  
}

compared_gdp("Washington",industry <- "Construction")