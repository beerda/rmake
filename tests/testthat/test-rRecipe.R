test_that('rRecipe', {
  r <- rRecipe(target='target.Rdata', script='script.R', depends=c('dep1', 'dep2'))
  expect_true(is.recipe(r))
  expect_equal(r$target, 'target.Rdata')
  expect_equal(r$depends, c('script.R', 'dep1', 'dep2'))
  expect_equal(r$build, 'echo \'source("script.R")\\n\' | $(R)')
  expect_equal(r$clean, '$(RM) target.Rdata')
})
