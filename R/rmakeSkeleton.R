#' Prepare existing project for building with *rmake*.
#'
#' This function creates a `Makefile.R` with an empty *rmake* project
#' and generates a basic `Makefile` from it.
#'
#' @seealso [makefile()], [rule()]
#' @author Michal Burda
#' @export
rmakeSkeleton <- function() {
  cat('library(rmake)\n\njob <- list()\n\nmakefile(job, "Makefile")\n', file='Makefile.R')
  makefile(list(), 'Makefile')
}
