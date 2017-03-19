#' @export
recipe <- function(target, depends=NULL, build=NULL, clean=NULL) {
  assert_that(is.character(target))
  assert_that(is.null(depends) || is.character(depends))
  assert_that(is.null(build) || is.character(build))
  assert_that(is.null(clean) || is.character(clean))

  pattern <- target
  if (length(target) > 1) {
    if (!all(grepl('.', target, fixed=TRUE))) {
      stop('"." not found in all targets')
    }
    pattern <- sub('.', '%', target, fixed=TRUE)
  }

  structure(list(target=target,
                 pattern=pattern,
                 depends=unique(depends),
                 build=build,
                 clean=clean),
            class='recipe')
}
