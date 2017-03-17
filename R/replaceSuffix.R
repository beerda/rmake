replaceSuffix <-  function(fileName, newSuffix) {
  res <- tools::file_path_sans_ext(fileName)
  paste0(res, newSuffix)
}
