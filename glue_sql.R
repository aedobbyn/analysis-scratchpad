
ids <- c(127251, 127252, 127253)
descrips <- c("foo", "bar", "baz")

sample_sql <- glue_sql("UPDATE `products`
                         SET description = {descrips} WHERE id = {ids}", .con = local_db_con_2) 

for (i in seq_along(sample_sql_2)) {
  dbGetQuery(local_db_con_2, sample_sql_2[i])
}

map(sample_sql, dbGetQuery, local_db_con_2)