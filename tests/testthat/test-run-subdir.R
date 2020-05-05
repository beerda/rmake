source('realRunTools.R')

test_that("subdir make", {
  initTesting('subdir_make')
  dir1 <- 'dir1'
  dep1 <- 'dep1.in'
  out1 <- 'result1.out'
  r1 <- 'script1.R'
  dep1full <- paste0(dir1, '/', dep1)
  out1full <- paste0(dir1, '/', out1)
  r1full <- paste0(dir1, '/', r1)

  createMakefile('library(rmake)',
                 paste0('job <- list(subdirRule(target="', dir1, '"))'),
                 'makefile(job, "Makefile")')

  createSubdir(dir1)
  writeToDepFile(dep1full)
  createScriptFile(r1full, out1)
  createMakefile(dir=dir1,
                 'library(rmake)',
                 paste0('job <- list(rRule(target="', out1, '", script="', r1, '", depends="', dep1, '"))'),
                 'makefile(job, "Makefile")')

  expect_true(file.exists(dep1full))
  expect_true(file.exists(r1full))
  expect_false(file.exists(out1full))

  make()
  make()

  expect_true(file.exists(out1full))
  expect_true(contentGreater(out1full, dep1full))

  Sys.sleep(1)
  writeToDepFile(dep1full)
  expect_false(contentGreater(out1full, dep1full))

  make()
  expect_true(contentGreater(out1full, dep1full))

  make('clean')
  expect_true(file.exists(dep1full))
  expect_true(file.exists(r1full))
  expect_false(file.exists(out1full))
})
