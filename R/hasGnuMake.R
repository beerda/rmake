#' Check if GNU Make is available via the 'make' command
#'
#' @return Logical value indicating if GNU Make is available
#' @author Michal Burda
#' @examples
#' if (hasGnuMake()) {
#'   message("GNU Make is available")
#' }
#' @export
hasGnuMake <- function() {
  result <- tryCatch({
    version_output <- system2("make", args = "--version",
                              stdout = TRUE, stderr = TRUE)
    grepl("GNU Make", version_output[1], ignore.case = TRUE)
  }, error = function(e) {
    FALSE
  }, warning = function(w) {
    FALSE
  })

  result
}
