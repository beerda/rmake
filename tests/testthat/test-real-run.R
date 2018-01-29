initTesting <- function(name) {
  theTestingName <<- name
  theTestingFiles <<- NULL
  setwd(tempdir())
}

doneTesting <- function() {
  file.remove(theTestingFiles, showWarnings=FALSE)
  theTestingName <<- NULL
  theTestingFiles <<- NULL
}

createDepFile <- function() {
  f <- tempfile(pattern=theTestingName, fileext='.in')
  cat(paste0(as.character(as.numeric(Sys.time())), '\n'), file=f)
  theTestingFiles <<- c(theTestingFiles, f)
  return(f)
}

createScriptFile <- function(out) {
  f <- tempfile(pattern=theTestingName, fileext='.R')
  cat(paste0('cat(paste0(as.character(as.numeric(Sys.time())), "\\n"), file="', out, '")\n', collapse=''),
      file=f)
  theTestingFiles <<- c(theTestingFiles, f)
  return(f)
}

createMakefile <- function(...) {
  makerSkeleton()
  Sys.sleep(1)
  cat(paste(..., sep='\n'), file=paste0(tempdir(), '/Makefile.R'))
  theTestingFiles <<- c(theTestingFiles, paste0(tempdir(), '/', c('Makefile.R', 'Makefile')))
}

getOutFileName <- function() {
  o <- tempfile(pattern=theTestingName, fileext='.out')
  theTestingFiles <<- c(theTestingFiles, o)
  return(o)
}

contentGreater <- function(f1, f2) {
  v1 <- read.table(f1)
  v2 <- read.table(f2)
  return(v1[1,1] > v2[1,1])
}

test_that('simple R script', {
  initTesting('simple')
  dep1 <- createDepFile()
  dep2 <- createDepFile()
  out <- getOutFileName()
  r <- createScriptFile(out)
  createMakefile('library(maker)',
                 paste0('job <- list(rRecipe("', out, '", "', r, '", c("', dep1, '", "', dep2, '")))'),
                 'makefile(job)')

  expect_false(file.exists(out))
  system('make')
  expect_true(file.exists(out))
  expect_true(contentGreater(out, dep1))
  expect_true(contentGreater(out, dep2))
  doneTesting()
})
