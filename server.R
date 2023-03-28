function(input, output, session){
  #rendering the data
  
  output$forest_area_table <- renderDataTable(
    forest_area
  )
  
  output$forest_table <- renderDataTable(
    forest
  )
  
  output$brazil_lost_table <- renderDataTable(
    brazil_lost
  )
  
   output$countries <- renderPlotly({
     forest_area_country_plot <- forest_area_country %>% 
       filter(country %in% c(input$var1)) %>% 
       mutate(country = fct_reorder(country, -forest_area)) %>% 
       ggplot(aes(year, forest_area, color = country))+
       geom_line()+
       scale_y_continuous(labels = percent)+
       expand_limits(y=0)+
       labs(x = "Year", 
            y = "% of global forest area")
     ggplotly(forest_area_country_plot)
     
   })
   
   output$gains_countries <- renderPlotly({
      by_year <- forest %>% 
       filter(year == input$var2) %>% 
       arrange((net_forest_conversion)) %>% 
       slice_max(abs(net_forest_conversion), n = 20) %>%  
       mutate(country = fct_reorder(country, net_forest_conversion)) %>% 
       ggplot(aes(net_forest_conversion, country,
                  fill = net_forest_conversion > 0  ))+
       geom_col()+
       labs(x = "Net change in forest (hectares)", 
            y = "")+
       scale_x_continuous(labels = comma)+
       theme(legend.position = "none")
     
     ggplotly(by_year)
     
   })
   
   output$forest_by_year <- renderPlotly({
     
     forest_by_year <- forest %>% 
       mutate(country = fct_lump(country, 8, w = abs(net_forest_conversion))) %>% 
       group_by(country, year) %>% 
       summarise(net_forest_conversion = sum(net_forest_conversion), 
                 .groups = "drop") %>% 
       mutate(country = fct_reorder(country, -net_forest_conversion)) %>% 
       ggplot(aes(year, net_forest_conversion, color = country))+
       geom_line()+
       scale_y_continuous(label = comma)+
       labs(y = "Net change on forest (hectares)")
     
        ggplotly(forest_by_year)
     })
  
 output$brazil_loss_by_cause <- renderPlotly({
   brazil_loss_by_cause <-  brazil_loss %>% 
     mutate(cause = fct_lump(cause, 6, w = loss)) %>% 
     group_by(cause, year) %>% 
     summarise(loss = sum(loss), .groups = "drop") %>% 
     mutate(cause = fct_reorder(cause, loss)) %>% 
     ggplot(aes(year, loss, fill= cause))+
     geom_area()+
     scale_y_continuous(labels = comma)+
     labs(y= "Loss of forest in 2013 (in hectares)")
   
   ggplotly(brazil_loss_by_cause)
 })
   
 output$top5 <- renderText(
   paste("Top 5 countries rate of forest")
 )
 
 output$top5T <- renderTable({
   forest %>% 
     filter(year == input$var2) %>% 
     select(country, net_forest_conversion) %>% 
     arrange(desc(net_forest_conversion)) %>% 
     head(5)
   
 })
 
 output$bottom5 <- renderText(
   paste("Last 5 countries rate  of forest")
 )
 
 output$low5T <- renderTable({
   forest %>% 
     filter(year == input$var2) %>% 
     select(country, net_forest_conversion) %>% 
     arrange(net_forest_conversion) %>% 
     head(5)
   
 })
 
 output$map_plot <- renderPlot({
   
   map_data("world") %>% 
     as_tibble() %>% 
     filter(region != "Antarctica") %>% 
     regex_left_join(country_data, by = c(region = "mapname")) %>% 
     ggplot(aes(long, lat, group = group, fill = net_forest_conversion ))+
     geom_polygon( color = "gray", size = .05)+
     scale_fill_gradient2(low = "red", high = "green", labels = comma)+
     theme_map()+
     labs(fill  = "Net forest change(2010)")+
     theme(legend.position = c(.004, .05))
   
   
   
   
 })
  
}