#' @export
replaceSuffix <-  function(fileName, newSuffix) {
  assert_that(is.character(fileName))
  assert_that(is.character(newSuffix))

  res <- tools::file_path_sans_ext(fileName)
  paste0(res, newSuffix)
}
