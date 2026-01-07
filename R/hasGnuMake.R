#' Check if GNU Make is available via the 'make' command
#'
#' @param version Optional minimum version string to check (the default value,
#'     i.e., "3.82" is the minimum required version for rmake package functionality)
#' @return Logical value indicating if GNU Make is available
#' @author Michal Burda
#' @examples
#' if (hasGnuMake()) {
#'   message("GNU Make is available")
#' }
#' @export
hasGnuMake <- function(version = "3.82") {
  result <- tryCatch({
    version_output <- system2("make",
                              args = "--version",
                              stdout = TRUE,
                              stderr = TRUE)

    if (length(version_output) > 0) {
      isGnu <- grepl("GNU Make", version_output[1], ignore.case = TRUE)
      if (isGnu) {
        if (is.null(version)) {
          return(TRUE)
        } else {
          version_match <- regmatches(version_output[1],
                                      regexpr("[0-9]+\\.[0-9]+(\\.[0-9]+)?",
                                              version_output[1]))
          if (length(version_match) > 0) {
            found_version <- version_match[1]
            if (package_version(found_version) >= package_version(version)) {
              return(TRUE)
            }
          }
        }
      }
    }

    FALSE
  }, error = function(e) {
    FALSE
  }, warning = function(w) {
    FALSE
  })

  result
}
