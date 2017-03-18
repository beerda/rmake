#' @export
inShell <- function(...) {
  f <- as.list(parent.frame())
  exprs <- lapply(pryr::dots(...), function(e) {
    pryr::substitute_q(e, f)
  })
  paste0('$(Rcode) \'', as.character(exprs), '\'')
}
