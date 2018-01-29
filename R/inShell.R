.unixInShell <- function(exprs) {
  last <- length(exprs)
  notLast <- seq_len(last-1)
  exprs <- encodeString(paste0(exprs, '\n'))
  exprs <- paste0('\'', exprs, '\'')
  exprs[1] <- paste0('echo ', exprs[1])
  exprs[notLast] <- paste0(exprs[notLast], '\\')
  exprs[last] <- paste0(exprs[last], ' | $(R)')
  exprs
}


.windowsInShell <- function(exprs) {
  exprs <- gsub('([&()^<>|\'`,;=])', '^\\1', exprs)
  exprs <- paste0('echo ', exprs, collapse = '&')
  exprs <- paste0('(', exprs, ') | $(R)')
  exprs
}


#' Convert R code to the character vector of shell commands evaluating the given R code.
#'
#' The function takes R commands, deparses them, substitutes existing variables, and converts
#' everything to character strings, from which a shell command is created that sends the given
#' R code to the R interpreter. Function is used internally to print the commands of R recipes
#' into `Makefile`.
#'
#' @param ... R commands to be converted
#' @return  A character vector of shell commands, which send the given R code by pipe to the R
#' interpreter
#' @author Michal Burda
#' @seealso [rRecipe()], [markdownRecipe()]
#' @export
#' @importFrom pryr dots
#' @importFrom pryr substitute_q
inShell <- function(...) {
  f <- as.list(parent.frame())
  exprs <- lapply(dots(...), function(e) {
    substitute_q(e, f)
  })
  #exprs <- as.character(exprs)
  exprs <- lapply(exprs, function(e) {
    deparse(e,
            width.cutoff=500L,
            control=c('keepInteger', 'showAttributes', 'useSource', 'warnIncomplete', 'keepNA'))
  })
  exprs <- unlist(exprs)
  if (length(exprs) > 0) {
    if (.Platform$OS.type == 'windows') {
      exprs <- .windowsInShell(exprs)
    } else {
      exprs <- .unixInShell(exprs)
    }
  }
  exprs
}
