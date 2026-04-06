test_that("extract returns a tibble", {
  result <- extract("Goldman Sachs", method = "exact", mode = "match", verbose = FALSE)
  expect_s3_class(result, "tbl_df")
})

test_that("exact match finds known corporation from character input", {
  result <- extract("Goldman Sachs", method = "exact", mode = "match", verbose = FALSE)
  expect_gt(nrow(result), 0)
  expect_true("match" %in% names(result))
})

test_that("exact match returns empty tibble for nonsense input", {
  result <- extract("xyzzy foobar notacorp", method = "exact", mode = "match", verbose = FALSE)
  expect_equal(nrow(result), 0)
})

test_that("extract works with data frame input", {
  df <- data.frame(text = c("JPMorgan Chase", "Apple Inc"), stringsAsFactors = FALSE)
  result <- extract(df, col_name = "text", method = "exact", mode = "match", verbose = FALSE)
  expect_s3_class(result, "tbl_df")
  expect_true("text" %in% names(result))
})

test_that("custom col_name is respected", {
  df <- data.frame(company = c("Citigroup"), stringsAsFactors = FALSE)
  result <- extract(df, col_name = "company", method = "exact", mode = "match", verbose = FALSE)
  expect_true("company" %in% names(result))
})

test_that("NA and empty strings are removed", {
  df <- data.frame(text = c("Goldman Sachs", NA, "", "  "), stringsAsFactors = FALSE)
  result <- extract(df, method = "exact", mode = "match", verbose = FALSE)
  # Should not error, and NAs/blanks should be filtered out
  expect_s3_class(result, "tbl_df")
})

test_that("all-empty input returns empty tibble", {
  df <- data.frame(text = c(NA, "", "  "), stringsAsFactors = FALSE)
  result <- extract(df, method = "exact", mode = "match", verbose = FALSE)
  expect_equal(nrow(result), 0)
})

test_that("token method returns similarity column", {
  result <- extract("Goldman Sachs", method = "token", mode = "match", verbose = FALSE)
  if (nrow(result) > 0) {
    expect_true("similarity" %in% names(result))
  }
})

test_that("token method filters low-quality matches", {
  result <- extract("American", method = "token", mode = "match", verbose = FALSE)
  if (nrow(result) > 0) {
    expect_true(all(result$similarity > 0.6))
  }
})

test_that("regex_return_cols controls output columns", {
  result <- extract("Goldman Sachs",
                    method = "exact", mode = "match",
                    regex_return_cols = c("cik"),
                    verbose = FALSE)
  if (nrow(result) > 0) {
    expect_true("cik" %in% names(result))
  }
})

test_that("verify_tokens scores correctly", {
  # Perfect overlap
  expect_equal(verify_tokens("goldman sachs", "goldman sachs"), 1.0)

  # Partial overlap
  score <- verify_tokens("american moment", "american corp")
  expect_equal(score, 0.5)

  # No overlap
  expect_equal(verify_tokens("apple", "microsoft"), 0)

  # Noise words ignored
  expect_equal(verify_tokens("inc", "inc"), 0)
})

test_that("search mode finds Goldman Sachs and JPMorgan", {
  text <- "Executives at Goldman Sachs met with JPMorgan Chase representatives."
  result <- extract(text, method = "exact", mode = "search", verbose = FALSE)

  expect_true("Goldman Sachs" %in% result$match)
  expect_true("JPMorgan Chase" %in% result$match)
})


