.minimumRequiredGNUMakeVersion <- "3.82"

#' Check if GNU Make is available via the 'make' command
#'
#' Function checks if GNU Make is installed and available in the system PATH
#' via the 'make' command. It also verifies that the version of GNU Make is
#' at least the minimum required version needed by the package, which is
#' currently set to 3.82.
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
    version_output <- system2("make",
                              args = "--version",
                              stdout = TRUE,
                              stderr = TRUE)

    if (length(version_output) > 0) {
      isGnu <- grepl("GNU Make", version_output[1], ignore.case = TRUE)
      if (isGnu) {
        version_match <- regmatches(version_output[1],
                                    regexpr("[0-9]+\\.[0-9]+(\\.[0-9]+)?",
                                            version_output[1]))
        if (length(version_match) > 0) {
          found_version <- version_match[1]
          if (package_version(found_version) >= package_version(.minimumRequiredGNUMakeVersion)) {
            return(TRUE)
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
