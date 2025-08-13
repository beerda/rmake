#'
#' @return
#' @author Michal Burda
#' @export
sanitizeSpaces <- function(x) {
  gsub(" ", "\\ ", x, fixed=TRUE)
}
