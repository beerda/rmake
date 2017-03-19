#' @export
inShell <- function(...) {
  f <- as.list(parent.frame())
  exprs <- lapply(pryr::dots(...), function(e) {
    pryr::substitute_q(e, f)
  })
  #exprs <- as.character(exprs)
  exprs <- lapply(exprs, function(e) {
    deparse(e,
            width.cutoff=500L,
            control=c('keepInteger', 'showAttributes', 'useSource', 'warnIncomplete', 'keepNA'))
  })
  exprs <- unlist(exprs)
  if (length(exprs) > 0) {
    last <- length(exprs)
    notLast <- seq_len(last-1)
    exprs <- encodeString(paste0(exprs, '\n'))
    exprs <- paste0('\'', exprs, '\'')
    exprs[1] <- paste0('echo ', exprs[1])
    exprs[notLast] <- paste0(exprs[notLast], '\\')
    exprs[last] <- paste0(exprs[last], ' | $(R)')
  }
  exprs
}
