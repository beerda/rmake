#' Prepare existing project for building with *maker*.
#'
#' This function creates a `Makefile.R` with an empty *maker* project
#' and generates a basic `Makefile` from it.
#'
#' @seealso [makefile()], [recipe()]
#' @author Michal Burda
#' @export
makerSkeleton <- function() {
  cat('library(maker)\n\njob <- list()\n\nmakefile(job)\n', file='Makefile.R')
  makefile()
}
