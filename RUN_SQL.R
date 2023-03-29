
library(DBI)
library(readr)

con2 <- dbConnect(odbc::odbc(), "reproreplica")


query <- dbGetQuery(con2, statement = read_file('SQL/220.sql'))

View(query)
