library(tidyverse)
library(scales)
library(plotly)
theme_set(theme_light())
library(ggthemes)

library(fuzzyjoin
)

library(shinycssloaders)

tt <- tidytuesdayR::tt_load('2021-04-06')

forest_area <- tt$forest_area
forest <- tt$forest
brazil_loss <- tt$brazil_loss

forest_area_country <- forest_area %>% 
  
  filter(str_length(code)==3, year>= 1992) %>% 
  rename(country=entity) %>% 
  #making the forest area value be in percentateg
  mutate(forest_area = forest_area/100)


# forest_area_country_plot <- forest_area_country %>% 
#   filter(country %in% c(get(input$var1))) %>% 
#   mutate(country = fct_reorder(country, -forest_area)) %>% 
#   ggplot(aes(year, forest_area, color = country))+
#   geom_line()+
#   scale_y_continuous(labels = percent)+
#   expand_limits(y=0)+
#   labs(x = "Year", 
#        y = "% of global forest area")
# 

#choices for the country to display choices 

choice_of_country <-unique(forest_area_country$country, incomparables="country")

forest <- tt$forest %>% 
  filter(str_length(code)==3) %>% 
  rename(country = entity)

choice_of_year <- unique(forest$year, incomparables="country")

brazil_loss <- tt$brazil_loss %>% 
  pivot_longer(commercial_crops:small_scale_clearing, 
               names_to = "cause",
               values_to = "loss") %>%
  # this is sying take all the coluns from comm. to small. the names will be called cause and the value of each colmn will be calles loss
  mutate(cause = str_to_sentence(str_replace_all(cause, "_", " "))) 

#getting the top 5 countries

forest %>% 
  select(country, net_forest_conversion) %>% 
  arrange(desc(net_forest_conversion)) %>% 
  head(5)

forest %>% 
  select(country, net_forest_conversion) %>% 
  arrange(net_forest_conversion) %>% 
  head(5)


country_data <- forest %>% 
  filter(year == 2010) %>% 
  inner_join(maps::iso3166, by = c(code ="a3")) 
