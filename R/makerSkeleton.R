#' @export
makerSkeleton <- function() {
  cat('library(maker)\n\njob <- list()\n\nmakefile(job)\n', file='Makefile.R')
  makefile()
}
