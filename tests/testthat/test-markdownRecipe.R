source('sanitizeCovr.R')

test_that('single target markdownRecipe', {
  r <- markdownRecipe(target='target.pdf', script='script.Rmd', depends=c('dep1', 'dep2'))
  expect_true(is.recipe(r))
  expect_equal(r$target, 'target.pdf')
  expect_equal(r$pattern, 'target.pdf')
  expect_equal(r$depends, c('script.Rmd', 'dep1', 'dep2'))
  expect_equal(r$clean, '$(RM) target.pdf')

  if (.Platform$OS.type == 'unix') {
    expect_equal(sanitizeCovr(r$build),
                 c('echo \'{\\n\'\\',
                   '\'    params <- NULL\\n\'\\',
                   '\'    rmarkdown::render("script.Rmd", output_format = "all", output_file = "target.pdf")\\n\'\\',
                   '\'}\\n\' | $(R)'))
  } else {
    expect_equal(r$build,
                 c('(echo {&echo     params ^<- NULL&echo     rmarkdown::render^("script.Rmd"^, output_format ^= "all"^, output_file ^= "target.pdf"^)&echo }) | $(R)'))
  }
})

test_that('multiple target markdownRecipe', {
  r <- markdownRecipe(target=c('target.pdf', 'target.docx'),
                      script='script.Rmd',
                      depends=c('dep1', 'dep2'))
  expect_true(is.recipe(r))
  expect_equal(r$target, c('target.pdf', 'target.docx'))
  expect_equal(r$pattern, c('target%pdf', 'target%docx'))
  expect_equal(r$depends, c('script.Rmd', 'dep1', 'dep2'))
  expect_equal(r$clean, '$(RM) target.pdf target.docx')

  if (.Platform$OS.type == 'unix') {
    expect_equal(sanitizeCovr(r$build),
                 c('echo \'{\\n\'\\',
                   '\'    params <- NULL\\n\'\\',
                   '\'    rmarkdown::render("script.Rmd", output_format = "all", output_file = c("target.pdf", "target.docx"))\\n\'\\',
                   '\'}\\n\' | $(R)'))
  } else {
    expect_equal(r$build,
                 c('(echo {&echo     params ^<- NULL&echo     rmarkdown::render^("script.Rmd"^, output_format ^= "all"^, output_file ^= "target.pdf"^, "target.docx"^)&echo }) | $(R)'))
  }
})
