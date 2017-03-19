#' @export
inShell <- function(...) {
  f <- as.list(parent.frame())
  exprs <- lapply(pryr::dots(...), function(e) {
    pryr::substitute_q(e, f)
  })
  #exprs <- as.character(exprs)
  exprs <- lapply(exprs, function(e) {
    deparse(e, control=c('keepInteger', 'showAttributes', 'useSource', 'warnIncomplete', 'keepNA'))
  })
  exprs <- unlist(exprs)
  exprs <- encodeString(paste0(exprs, '\n'))
  exprs <- paste0('\'', exprs, '\' \\')
  c('echo \\', exprs, ' | $(Rcode)')
}
