saveWorkspace <- function(file, all=TRUE) {
  save(list=ls(all.names=all), file=file, envir=.GlobalEnv)
}
