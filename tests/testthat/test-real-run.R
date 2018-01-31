initTesting <- function(name) {
  theCounter <<- 1
  theWorkingDir <<- tempfile(pattern=name)
  dir.create(theWorkingDir)
  setwd(theWorkingDir)
}

createDepFile <- function(f) {
  cat(paste0(as.character(as.numeric(Sys.time())), '\n'), file=f)
}

createScriptFile <- function(f, out) {
  cat(paste0('cat(paste0(as.character(as.numeric(Sys.time())), "\\n"), file="', out, '")\n', collapse=''),
      file=f)
}

createMakefile <- function(...) {
  makerSkeleton()
  Sys.sleep(1)
  print(c(...))
  cat(paste(..., sep='\n'), file='Makefile.R')
}

contentGreater <- function(f1, f2) {
  v1 <- read.table(f1)
  v2 <- read.table(f2)
  return(v1[1,1] > v2[1,1])
}

runSystem <- function(cmd) {
  try(system2(cmd, wait=TRUE), silent=FALSE)
}

test_that('simple R script', {
  initTesting('simple')
  dep1 <- 'dep1.in'
  dep2 <- 'dep2.in'
  out <- 'result.out'
  r <- 'script.R'
  createDepFile(dep1)
  createDepFile(dep2)
  createScriptFile(r, out)
  createMakefile('library(maker)',
                 paste0('job <- list(rRecipe("', out, '", "', r, '", c("', dep1, '", "', dep2, '")))'),
                 'makefile(job)')

  expect_true(file.exists(dep1))
  expect_true(file.exists(dep2))
  expect_false(file.exists(out))
  expect_true(file.exists(r))

  res <- runSystem('make')
  expect_false(inherits(res, 'try-error'))

  expect_true(file.exists(out))
  expect_true(contentGreater(out, dep1))
  expect_true(contentGreater(out, dep2))
})
