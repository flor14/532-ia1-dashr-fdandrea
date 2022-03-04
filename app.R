library(dash)
library(dashHtmlComponents)
#library(dashCoreComponents)
library(ggplot2)
library(dplyr)
library(plotly)

app = Dash$new()

app$layout(htmlDiv(
 list(
  htmlH1(children = "RadioItems / Checklist comparison"),
  dccGraph(id = "plot-area" ),
  htmlH3(children = "Checklist"),
  htmlP(children = "The user can visualize multiple options at the same time"),
  dccChecklist(
    id = "checkwidget",
    options = list(list("label" = "Grupo A", 'value' ="A"),
                   list("label" = "Grupo B", 'value' = "B"),
                   list("label" = "Grupo C", 'value' = "C")),
    value = list("A", "B", "C")),
  htmlH3(children = 'RadioItems'),
  htmlP(children = 'The user can select only one option (the options are mutually exclusive )'),
  dccRadioItems(id = "radio",
                options = list(
                  list('label' = 'Accent', 'value' = 'Accent'),
                  list('label' = 'Dark2', 'value' = 'Dark2'),
                  list('label' = 'Accent', 'value' = 'Accent'),
                  list('label' = 'Set1', 'value' = 'Set1'),
                  list('label' = 'Set2', 'value' = 'Set2')),
                value =  'Set1'))))



app$callback(
  output(id = "plot-area", property = "figure"),
  list(input(id = "checkwidget", property ="value"),
       input(id = "radio", property ="value")),
  function(checkgroup, radiocolor){
    set.seed(1)
    source_data <- data.frame( y = rnorm(300),
                          group =  c(rep("A", 100) , rep("B", 100), rep("C", 100)),
    x = rep(1:100, times = 3))
    source_data <- source_data |>
      dplyr::filter(source_data$group %in% checkgroup) |>
      dplyr::mutate(y = round(y, digits = 2))
  plot <- ggplot(source_data, aes(color = group)) +
  geom_line(aes(x = x, y = y)) +
  scale_color_brewer(type = 'qual', palette = radiocolor)+
  ggplot2::theme_classic()
  ggplotly(plot)
  }
)

app$run_server(debug = T)