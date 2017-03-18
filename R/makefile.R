#' @export
makefile <- function(job=list(), fileName='Makefile') {
  allTargets <- unlist(lapply(job, function(task) task$target))
  allTask <- task(target='all',
                  depends=paste(allTargets, collapse=' '),
                  build='')
  job <- c(list(allTask), job)

  cleanCmd <- lapply(job, function(task) task[['clean']])
  if (!is.null(cleanCmd) && length(cleanCmd) > 0) {
    cleanTask <- task(target='clean',
                      depends=NULL,
                      build=unlist(cleanCmd))
    job <- c(job, list(cleanTask))
  }

  makefileTask <- rTask(target='Makefile', depends=NULL, source='Makefile.R')
  job <- c(job, list(makefileTask))


  cmdTabs <- lapply(job, function(task) nchar(task$target))
  cmdTabs <- floor((1 + max(unlist(cmdTabs))) / 8) + 1
  cmdTabs <- paste0(rep('\t', cmdTabs), collapse='')

  rows <- lapply(job, function(task) {
    depTabs <- nchar(cmdTabs) - floor(1 + (nchar(task$target) / 8)) + 1
    depTabs <- paste0(rep('\t', depTabs), collapse='')
    paste0(task$target, ':', depTabs, paste(task$depends, collapse=' '), '\n',
           paste0(cmdTabs, task$build, collapse='\n'), '\n')
  })

  conn <- stdout()
  if (!is.null(fileName)) {
    conn <- file(fileName, "w")
  }
  writeLines(unlist(rows), conn)
  if (!is.null(fileName)) {
    close(conn)
  }
}
