### -----------------------------
### simon munzert
### intro to web scraping with R
### solutions to exercises
### -----------------------------



## scraping with rvest ---------------------------------------

# 1. repeat playing CSS diner until plate 10!
# 2. go to the following website
browseURL("https://www.jstatsoft.org/about/editorialTeam")
# a) which CSS identifiers can be used to describe all names of the editorial team?
# b) write a corresponding CSS selector that targets them!

".member a"
"#group a"



# 1. revisit the jstatsoft.org website from above and use rvest to extract the names!
# 2. bonus: try and extract the full lines including the affiliation and count how many of the editors are at a statistics or mathematics department or institution!

url <- "https://www.jstatsoft.org/about/editorialTeam"
url_parsed <- read_html(url)
names <- html_nodes(url_parsed, css = ".member a") %>% html_text()
names <- html_nodes(url_parsed, css = ".member") %>% html_text()
names <- html_nodes(url_parsed, "#group a") %>% html_text()

xpath <- '//div[@id="content"]//li/a'
html_nodes(url_parsed, xpath = xpath) %>% html_text()

affiliations <- html_nodes(url_parsed, ".member li") %>% html_text()
str_detect(affiliations, "tatisti|athemati") %>% table



# 1. Scrape the table tall buildings (300m+) currently under construction from https://en.wikipedia.org/wiki/List_of_tallest_buildings_in_the_world"
# 2. How many of those buildings are currently built in China? And in which city are most of the tallest buildings currently built?

url <- "https://en.wikipedia.org/wiki/List_of_tallest_buildings_in_the_world"
url_parsed <- read_html(url)
tables <- html_table(url_parsed, fill = TRUE)
buildings <- tables[[6]]
table(buildings$`Country/region`) %>% sort
table(buildings$City) %>% sort



# 1. Use SelectorGadget to identify a CSS selector that helps extract all article author names from Buzzfeed's main page!
# 2. Use rvest to scrape these names!

url <- "https://www.buzzfeed.com/?country=us"
url_parsed <- read_html(url)
authors <- html_nodes(url_parsed, css = ".small-meta__item:nth-child(1) a") %>% html_text()
table(authors) %>% sort



## tapping APIs ---------------------------------------

# 1. familiarize yourself with the pageviews package! what functions does it provide and what do they do?
# 2. use the package to fetch page view statistics for the articles about Donald Trump and Hillary Clinton on the English Wikipedia, and plot them against each other in a time series graph!

library(pageviews)
ls("package:pageviews")

trump_views <- article_pageviews(project = "en.wikipedia", article = "Donald Trump", user_type = "user", start = "2016010100", end = "20161110")
head(trump_views)
clinton_views <- article_pageviews(project = "en.wikipedia", article = "Hillary Clinton", user_type = "user", start = "2016010100", end = "20161110")

plot(ymd_h(trump_views$timestamp), trump_views$views, col = "red", type = "l")
lines(ymd_h(clinton_views$timestamp), clinton_views$views, col = "blue")



# 1. familiarize yourself with the OpenWeatherMap API!
browseURL("http://openweathermap.org/current")
# 2. sign up for the API at the address below and obtain an API key!
browseURL("http://openweathermap.org/api")
# 3. make a call to the API to find out the current weather conditions in Chicago!

apikey <- "&appid=42c7829f663f87eb05d2f12ab11f2b5d"
endpoint <- "http://api.openweathermap.org/data/2.5/find?"
city <- "Mannheim,Germany"
metric <- "&units=metric"
url <- paste0(endpoint, "q=", city, metric, apikey)
weather_res <- GET(url)
res_list <- content(weather_res, as =  "parsed")
res_list <- content(weather_res, as =  "text")  %>% jsonlite::fromJSON(flatten = TRUE)
res_list$list


