#' @export
inShell <- function(...) {
  f <- as.list(parent.frame())
  exprs <- lapply(pryr::dots(...), function(e) {
    pryr::substitute_q(e, f)
  })
  exprs <- trimws(unlist(strsplit(as.character(exprs), '\n', fixed=TRUE)))
  paste0('$(Rcode) \'', paste0(exprs, collapse='; '), '\'')
}
