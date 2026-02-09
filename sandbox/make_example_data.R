library(rvest)

html <- read_html("https://www.ft.com/companies") # The UN homepage
links <- html_nodes(html, "a") # "a" nodes are linked text
html_text(links)

ft <- html_text(links)[20:320]
save(ft, file = here::here("data", "ft.rd"))
