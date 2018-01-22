#' @export
#' @importFrom tools file_path_sans_ext
replaceSuffix <-  function(fileName, newSuffix) {
  assert_that(is.character(fileName))
  assert_that(is.character(newSuffix))

  res <- file_path_sans_ext(fileName)
  paste0(res, newSuffix)
}
