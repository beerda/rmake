test_that('single target markdownRecipe', {
  r <- markdownRecipe(target='target.pdf', script='script.Rmd', depends=c('dep1', 'dep2'))
  expect_true(is.recipe(r))
  expect_equal(r$target, 'target.pdf')
  expect_equal(r$pattern, 'target.pdf')
  expect_equal(r$depends, c('script.Rmd', 'dep1', 'dep2'))
  expect_equal(r$build, c('echo \'{\\n\'\\',
                          '\'    library(rmarkdown)\\n\'\\',
                          '\'    render("script.Rmd", output_format = "all", output_file = "target.pdf")\\n\'\\',
                          '\'}\\n\' | $(R)'))
  expect_equal(r$clean, '$(RM) target.pdf')
})

test_that('multiple target markdownRecipe', {
  r <- markdownRecipe(target=c('target.pdf', 'target.docx'),
                      script='script.Rmd',
                      depends=c('dep1', 'dep2'))
  expect_true(is.recipe(r))
  expect_equal(r$target, c('target.pdf', 'target.docx'))
  expect_equal(r$pattern, c('target%pdf', 'target%docx'))
  expect_equal(r$depends, c('script.Rmd', 'dep1', 'dep2'))
  expect_equal(r$build, c('echo \'{\\n\'\\',
                          '\'    library(rmarkdown)\\n\'\\',
                          '\'    render("script.Rmd", output_format = "all", output_file = c("target.pdf", "target.docx"))\\n\'\\',
                          '\'}\\n\' | $(R)'))
  expect_equal(r$clean, '$(RM) target.pdf target.docx')
})
