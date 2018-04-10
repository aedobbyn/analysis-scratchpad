dbGetQuery(local_db_con,    
           paste("SELECT * FROM products_test
                 WHERE products_test.created_at > STR_TO_DATE(", x_date, ", '%Y-%m-%d')", sep = "")) %>% as_tibble()