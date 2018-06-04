#' Rule for building text documents from Markdown files
#'
#' This rule is for execution of Markdown rendering in order to create text file
#' of various supported formats such as (PDF, DOCX, etc.).
#'
#' This rule executes the following command in a separate R process:
#' `params <- params; rmarkdown::render(script, output_format=format, output_file=target)``
#'
#' That is, parameters given in the `params` argument are stored into the global variable
#' and then the `script` is rendered with rmarkdown. That is, the re-generation of the
#' `Makefile` with any change to `params` will not cause the re-execution of the recipe unless
#' any other script dependencies change.
#'
#' Issuing `make clean` from the shell causes removal of all files specified in `target` parameter.
#'
#' @param target Name of the output file to be created
#' @param script Name of the markdown file to be rendered
#' @param depends A vector of file names that the markdown script depends on, or `NULL`.
#' @param format Requested format of the result. Parameter is passed as `format` argument
#' to [rmarkdown::render()]. Allowed values are: 'all', 'html_document', 'pdf_document',
#' 'word_document', 'odt_document', 'rtf_document', or 'md_document'.
#' @param params A list of R values that become available within the `script` in
#' a `params` variable.
#' @param task A character vector of parent task names. The mechanism of tasks allows to
#' group rules. Anything different from `'all'` will
#' cause creation of a new task depending on the given rule. Executing `make taskname`
#' will then force building of this rule.
#' @return Instance of S3 class `rmake.rule`
#' @seealso [rule()], [makefile()], [rRule()]
#' @author Michal Burda
#' @examples
#' r <- markdownRule(target='report.pdf',
#'                   script='report.Rmd',
#'                   depends=c('data1.csv', 'data2.csv'))
#'
#' # generate the content of a makefile (as character vector)
#' makefile(list(r))
#'
#' # generate to file
#' tmp <- tempdir()
#' makefile(list(r), file.path(tmp, "Makefile"))
#' @export
#' @importFrom rmarkdown render
markdownRule <- function(target,
                         script,
                         depends=NULL,
                         format='all',
                         params=list(),
                         task='all') {
  assert_that(is.character(target))
  assert_that(is.string(script))
  assert_that(is.null(depends) || is.character(depends))
  assert_that(is.character(format))
  assert_that(is.list(params))
  assert_that(is.character(task))

  format <- match.arg(format,
                      c('all', 'html_document', 'pdf_document', 'word_document',
                        'odt_document', 'rtf_document', 'md_document'),
                      several.ok=TRUE)
  allDeps <- c(script, depends)

  p <- c(list(.target=target,
              .script=script,
              .depends=depends,
              .format=format,
              .task=task),
         params)
  rm(params)

  rule(target=target,
       depends=allDeps,
       build=inShell({
         params <- p
         rmarkdown::render(script, output_format=format, output_file=target)
       }),
       clean=paste0('$(RM) ', paste0(target, collapse=' ')),
       task=task)
}
