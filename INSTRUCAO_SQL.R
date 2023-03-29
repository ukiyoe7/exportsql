library(DBI)
library(dplyr)

con2 <- dbConnect(odbc::odbc(), "reproreplica")



dbGetQuery(con2,"SELECT * FROM INSTRUCAOSQL") %>% View()