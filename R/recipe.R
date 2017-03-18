#' @export
recipe <- function(target, depends, build=NULL, clean=NULL) {
  assert_that(is.string(target))
  assert_that(is.null(depends) || is.character(depends))
  assert_that(is.null(build) || is.character(build))
  assert_that(is.null(clean) || is.character(clean))

  structure(list(target=target,
                 depends=unique(depends),
                 build=build,
                 clean=clean),
            class='recipe')
}
