source('sanitizeCovr.R')

test_that('single target rRecipe', {
  r <- rRecipe(target='target.Rdata', script='script.R', depends=c('dep1', 'dep2'))
  expect_true(is.recipe(r))
  expect_equal(r$target, 'target.Rdata')
  expect_equal(r$depends, c('script.R', 'dep1', 'dep2'))
  expect_equal(r$clean, '$(RM) target.Rdata')
  expect_equal(sanitizeCovr(r$build),
               c('$(ECHO) \'{\\n\'\\',
                 '\'    params <- NULL\\n\'\\',
                 '\'    source("script.R")\\n\'\\',
                 '\'}\\n\' | $(R)'))
})

test_that('multiple target rRecipe', {
  r <- rRecipe(target=c('target.Rdata', 'target2.Rdata'),
               script='script.R',
               depends=c('dep1', 'dep2'))
  expect_true(is.recipe(r))
  expect_equal(r$target, c('target.Rdata', 'target2.Rdata'))
  expect_equal(r$pattern, c('target%Rdata', 'target2%Rdata'))
  expect_equal(r$depends, c('script.R', 'dep1', 'dep2'))
  expect_equal(r$clean, '$(RM) target.Rdata target2.Rdata')
  expect_equal(sanitizeCovr(r$build),
               c('$(ECHO) \'{\\n\'\\',
                 '\'    params <- NULL\\n\'\\',
                 '\'    source("script.R")\\n\'\\',
                 '\'}\\n\' | $(R)'))
})
