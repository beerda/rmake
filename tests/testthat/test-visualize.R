test_that('visualize', {
  job <- 'data.csv' %>>% rRule('data.R') %>>% 'data.rds' %>>%
    markdownRule('analysis.Rmd') %>>% c('analysis.pdf', 'analysis.docx')
  res <- visualizeRules(job)

  n <- res$x$nodes
  expect_equal(nrow(n), 8)
  expect_equal(as.character(n$id),
               c('1:R',
                 'data.R',
                 'data.csv',
                 'data.rds',
                 '2:markdown',
                 'analysis.Rmd',
                 'analysis.pdf',
                 'analysis.docx'))

  e <- res$x$edges
  expect_equal(nrow(e), 7)
  expect_equal(paste(e$from, '->', e$to),
               c('data.R -> 1:R',
                 'data.csv -> 1:R',
                 '1:R -> data.rds',
                 'analysis.Rmd -> 2:markdown',
                 'data.rds -> 2:markdown',
                 '2:markdown -> analysis.pdf',
                 '2:markdown -> analysis.docx'))
})
