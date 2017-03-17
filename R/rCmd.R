rCmd <- function(...) {
  f <- as.list(parent.frame())
  exprs <- lapply(pryr::dots(...), function(e) {
    substitute_q(e, f)
  })
  paste0('R --no-save --no-restore --quiet -e \'', as.character(exprs), '\'')
}
