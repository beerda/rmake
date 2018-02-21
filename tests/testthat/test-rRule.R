source('sanitizeCovr.R')

test_that('single target rRule', {
  r <- rRule(target='target.Rdata', script='script.R', depends=c('dep1', 'dep2'))
  expect_true(is.rule(r))
  expect_equal(r$target, 'target.Rdata')
  expect_equal(r$depends, c('script.R', 'dep1', 'dep2'))
  expect_equal(r$clean, '$(RM) target.Rdata')
  expect_equal(sanitizeCovr(r$build),
               c('$(R) -e \'{\' \\',
                 '-e \'    params <- NULL\' \\',
                 '-e \'    source("script.R")\' \\',
                 '-e \'}\''))
})

test_that('multiple target rRule', {
  r <- rRule(target=c('target.Rdata', 'target2.Rdata'),
               script='script.R',
               depends=c('dep1', 'dep2'))
  expect_true(is.rule(r))
  expect_equal(r$target, c('target.Rdata', 'target2.Rdata'))
  expect_equal(r$pattern, c('target%Rdata', 'target2%Rdata'))
  expect_equal(r$depends, c('script.R', 'dep1', 'dep2'))
  expect_equal(r$clean, '$(RM) target.Rdata target2.Rdata')
  expect_equal(sanitizeCovr(r$build),
               c('$(R) -e \'{\' \\',
                 '-e \'    params <- NULL\' \\',
                 '-e \'    source("script.R")\' \\',
                 '-e \'}\''))
})
