# Copyright (c) 2018 Michal Burda
# Copyright (c) 2014 Stefan Milton Bache and Hadley Wickham
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
#   The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.


.isPipe <- function(pipe) {
  identical(pipe, quote(`%>>%`))
}


.isParenthesized <- function(expr) {
  is.call(expr) && identical(expr[[1L]], quote(`(`))
}


.isAnonymousFunction <- function(expr) {
  is.call(expr) && identical(expr[[1L]], quote(`function`))
}


.splitChain <- function(expr, envir) {
  chain  <- list()
  i <- 1L
  while(is.call(expr) && .isPipe(expr[[1L]])) {
    # expr[[1L]] is a pipe operator, expr[[2L]] is lhs, expr[[3L]] is rhs
    rhs <- expr[[3L]]
    if (.isParenthesized(rhs)) {
      rhs <- eval(rhs, envir=envir)
    }
    if (.isAnonymousFunction(rhs)) {
      stop("Anonymous functions must be parenthesized", call.=FALSE)
    }
    chain[[i]] <- rhs
    expr <- expr[[2L]]
    i <- i + 1L
  }

  chain[[i]] <- expr
  rev(chain)
}


#' A pipe operator for rmake rules
#'
#' This pipe operator simplifies the definition of multiple rmake rules that constitute a chain,
#' that is, if a first rule depends on the results of a second rule, which depends on the results
#' of a third rule and so on.
#'
#' The format of proper usage is as follows:
#' `'inFile' %>>% rule() %>>% 'outFile'`,
#' which is equivalent to the call `rule(depends='inFile', target='outFile')`. `rule` must be
#' a function that accepts the named parameters `depends` and `target` and creates the
#' `rmake.rule` object (see [rule()], [rRule()], [markdownRule()] etc.).
#' `inFile` and `outFile` are file names.
#'
#' Multiple rules may be pipe-lined as follows:
#' `'inFile' %>>% rRule('script1.R') %>>% 'medFile' %>>% rRule('script2.R') %>>% 'outFile'`,
#' which is equivalent to a job of two rules created with:
#' `rRule(script='script1.R', depends='inFile', target='medFile')` and
#' `rRule(script='script2.R', depends='medFile', target='outFile')`.
#'
#' @param lhs A dependency file name or a call to a function that creates a `rmake.rule`.
#' @param rhs A target file or a call to a function that creates a `rmake.rule`.
#' @return A list of instances of the `rmake.rule` class.
#' @seealso [rule()], [makefile()]
#' @author Michal Burda (`%>>%` operator is derived from the code of the `magrittr` package by
#' Stefan Milton Bache and Hadley Wickham)
#' @examples
#'
#' job1 <- 'data.csv' %>>%
#'   rRule('preprocess.R') %>>%
#'   'data.rds' %>>%
#'   markdownRule('report.rnw') %>>%
#'   'report.pdf'
#'
#' # is equivalent to
#'
#' job2 <- list(rRule(target='data.rds', script='preprocess.R', depends='data.csv'),
#'              markdownRule(target='report.pdf', script='report.rnw', depends='data.rds'))
#' @export
`%>>%` <- function(lhs, rhs) {
  envir <- parent.frame()
  chain <- .splitChain(match.call(), envir=envir)

  job <- list()
  i <- 2L
  while (i < length(chain)) {
    f <- chain[[i]]
    if (!is.call(f)) {
      stop(paste0(deparse(chain[[i]]), ' is not a call'),
           call.=FALSE)
    }
    f$depends <- chain[[i-1]]
    f$target <- chain[[i+1]]
    rule <- eval(f, envir=envir)
    if (!is.rule(rule)) {
      stop(paste0(deparse(chain[[i]]), ' must create an instance of the rmake.rule class'),
           call.=FALSE)
    }
    job <- c(job, list(rule))
    i <- i + 2L
  }
  if (i - 1L != length(chain)) {
    stop('Malformed pipeline: "file" %>>% rule() %>>% "file" %>>% ... %>>% rule() %>>% "file" sequence is expected',
         call.=FALSE)
  }

  job
}
