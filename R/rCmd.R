rCmd <- function(...) {
  f <- parent.frame()
  exprs <- lapply(pryr::dots(...), function(e) {
    substitute_q(e, as.list(f))
  })

  paste0('R --no-save --no-restore --quiet -e \'',
         as.character(exprs),
         '\'')
}
