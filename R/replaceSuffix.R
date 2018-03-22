#' Replace suffix of the given file name with a new extension (suffix)
#'
#' This helper function takes a file name `fileName`, removes an extension (a suffix)
#' from it and adds a new extension `newSuffix`.
#'
#' @param fileName A character vector with original filenames
#' @param newSuffix A new extension to replace old extensions in file names `fileName`
#' @return A character vector with new file names with old extensions replaced with `newSuffix`
#' @author Michal Burda
#' @examples
#' replaceSuffix('filename.Rmd', '.pdf')          # 'filename.pdf'
#' replaceSuffix(c('a.x', 'b.y', 'c.z'), '.csv')  # 'a.csv', 'b.csv', 'c.csv'
#' @export
#' @importFrom tools file_path_sans_ext
replaceSuffix <-  function(fileName, newSuffix) {
  assert_that(is.character(fileName))
  assert_that(is.character(newSuffix))

  res <- file_path_sans_ext(fileName)
  paste0(res, newSuffix)
}
