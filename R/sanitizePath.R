#' Sanitize a file path for the current operating system
#'
#' This function replaces forward slashes with backslashes on Windows systems,
#' and leaves the path unchanged on Unix-like systems.
#'
#' @param path A character string representing the file path to be sanitized.
#' @return A sanitized file path suitable for the current operating system.
#' @author Michal Burda
#' @export
sanitizePath <- function(path) {
  if (.Platform$OS.type != 'unix') {
    return(gsub('/', '\\', path, fixed=TRUE))
  }
  return(path)
}
