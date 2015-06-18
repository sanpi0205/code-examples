library(RMySQL)
con <- dbConnect(RMySQL::MySQL(), host = "127.0.0.1",
                 user = "root", password = "", dbname = "customes")
dbListTables(con)
dbGetQuery(con, "SELECT * FROM commodity limit 30")

res <- dbSendQuery(con, "SELECT * FROM commodity ")
data <- dbFetch(res, n = 2)
dbHasCompleted(res)
