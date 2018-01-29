source('sanitizeCovr.R')

test_that('single target rRecipe', {
  r <- rRecipe(target='target.Rdata', script='script.R', depends=c('dep1', 'dep2'))
  expect_true(is.recipe(r))
  expect_equal(r$target, 'target.Rdata')
  expect_equal(r$depends, c('script.R', 'dep1', 'dep2'))
  expect_equal(r$clean, '$(RM) target.Rdata')

  if (.Platform$OS.type == 'unix') {
    expect_equal(sanitizeCovr(r$build),
                 c('echo \'{\\n\'\\',
                   '\'    params <- NULL\\n\'\\',
                   '\'    source("script.R")\\n\'\\',
                   '\'}\\n\' | $(R)'))
  } else {
    expect_equal(r$build,
                 c('(echo {&echo     params ^<- NULL&echo     source("script.R")&echo }) | $(R)'))

  }
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

  if (.Platform$OS.type == 'unix') {
    expect_equal(sanitizeCovr(r$build),
                 c('echo \'{\\n\'\\',
                   '\'    params <- NULL\\n\'\\',
                   '\'    source("script.R")\\n\'\\',
                   '\'}\\n\' | $(R)'))
  } else {
    expect_equal(r$build,
                 c('(echo {&echo     params ^<- NULL&echo     source("script.R")&echo }) | $(R)'))
  }
})
