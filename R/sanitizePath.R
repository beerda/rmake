#' @export
sanitizePath <- function(path) {
  if (.Platform$OS.type != 'unix') {
    return(gsub('/', '\\', path, fixed=TRUE))
  }
  return(path)
}
