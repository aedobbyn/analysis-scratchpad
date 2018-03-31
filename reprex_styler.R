

styler::style_text({
  foo <- "bar"
  baz <- "bing"
})


styler::style_text(
  testthat::test_that("foo", {
    text_w_accent <- "J'aimerais aller à la plage"
    another_text <- "J'aimerais aller à la plage"
    
    testthat::expect_equal(text_w_accent, another_text)
  })
)


styler::style_text({
  text1 <- "Hauràs de dirigir-te al punt de trobada del grup al que et vulguis unir."
  text2 <- "i want to buy an iphone"
  text3 <- "Je déteste ne plus avoir de dentifrice."
  text_4 <- "I hate not having any toothpaste."
})

testthat::test_that("We can use different texts_per_req in classify_df and get the same output and unnesting works", {
  text1 <- "Hauràs de dirigir-te al punt de trobada del grup al que et vulguis unir."
  text2 <- "i want to buy an iphone"
  text3 <- "Je déteste ne plus avoir de dentifrice."
  text_4 <- "I hate not having any toothpaste."
  request_df <- tibble::tibble(txt = c(text1, text2, text3, text_4),
                               other_col = 1:4)
  
  # General test of dataframe
  request_df %>% test_texts(col = txt)
  
  # foo is not a column; expect informative error
  testthat::expect_equal(
    testthat::capture_error(monkey_classify(request_df, foo))$message,
    "Column supplied does not appear in dataframe."
  )
  
  # No column supplied
  testthat::expect_equal(
    testthat::capture_error(monkey_classify(request_df))$message,
    "If input is a dataframe, col must be non-null."
  )
  
  # Test texts_per_req is a number and <= number of texts
  testthat::expect_equal(
    testthat::capture_error(monkey_classify(request_df, txt, texts_per_req = "bar"))$message,
    "texts_per_req must be a whole positive number less than or equal to the number of texts."
  )
  
  testthat::expect_equal(
    testthat::capture_error(monkey_extract(request_df, txt, texts_per_req = 10))$message,
    "texts_per_req must be a whole positive number less than or equal to the number of texts."
  )
  
  # Set up texts to test
  output_unnested <- monkey_classify(request_df, txt, texts_per_req = 2, unnest = TRUE)
  output_nested <- monkey_classify(request_df, txt, texts_per_req = 2, unnest = FALSE)
  output_2_texts <- tidyr::unnest(monkey_classify(request_df, txt, texts_per_req = 2, unnest = FALSE))
  output_3_texts <- tidyr::unnest(monkey_classify(request_df, txt, texts_per_req = 3, unnest = FALSE))
  
  # Different numbers of texts_per_req give same output
  testthat::expect_equal(output_2_texts, output_3_texts)
  
  # Unnesting parameter unnests
  testthat::expect_equal(
    tidyr::unnest(output_nested),
    output_unnested
  )
  test_headers(output_nested)
  test_headers(output_unnested)
  
  # Dataframe or vector as input produce same result
  vec_output <- monkey_classify(request_df$txt, texts_per_req = 2, unnest = TRUE) %>%
    dplyr::rename(txt = req)
  df_output <- monkey_classify(request_df, txt, texts_per_req = 1, unnest = TRUE, .keep_all = FALSE)
  
  testthat::expect_equal(vec_output, df_output)
  test_headers(vec_output)
  test_headers(df_output)
})
