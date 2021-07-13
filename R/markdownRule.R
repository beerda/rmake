#' Rule for building text documents from Markdown files
#'
#' This rule is for execution of Markdown rendering in order to create text file
#' of various supported formats such as (PDF, DOCX, etc.).
#'
#' This rule executes the following command in a separate R process:
#' `params <- params; rmarkdown::render(script, output_format=format, output_file=target)`
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
#' @importFrom tools file_ext
markdownRule <- function(target,
                         script,
                         depends=NULL,
                         params=list(),
                         task='all') {
  assert_that(is.character(target))
  assert_that(is.string(script))
  assert_that(is.null(depends) || is.character(depends))
  assert_that(is.list(params))
  assert_that(is.character(task))

  allDeps <- c(script, depends)
  formatTable <- list(html='html_document',
                      htm='html_document',
                      pdf='pdf_document',
                      docx='word_document',
                      doc='word_document',
                      odt='odt_document',
                      rtf='rtf_document',
                      md='md_document')
  formats <- list();
  for (tt in target) {
    ext <- file_ext(tt)
    fmt <- formatTable[[ext]]
    if (is.null(fmt)) {
      stop('Cannot determine document format from file extension: ', ext,
           '. Allowed extensions are: ', paste0(names(formatTable), collapse=', '))
    }
    formats[[tt]] <- fmt
  }

  p <- c(list(.target=target,
              .script=script,
              .depends=depends,
              .task=task),
         params)
  rm(params)

  rule(target=target,
       depends=allDeps,
       build=inShell({
         params <- p
         targets <- formats
         for (tg in names(targets)) {
           rmarkdown::render(script,
                             output_format=targets[[tg]],
                             #intermediates_dir=tempdir(),
                             output_file=tg)
         }
       }),
       clean=paste0('$(RM) ', paste0(sanitizePath(target), collapse=' ')),
       task=task,
       type='markdown')
}
