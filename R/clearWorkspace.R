clearWorkspace <- function(all.names=TRUE) {
  rm(list=ls(all.names=all.names, pos=".GlobalEnv"), pos=".GlobalEnv")
}
