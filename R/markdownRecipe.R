#' Recipe for building text documents from Markdown files
#'
#' This recipe is for execution of Markdown rendering in order to create text file
#' of various supported formats such as (PDF, DOCX, etc.).
#'
#' @param target Name of the output file to be created
#' @param script Name of the markdown file to be rendered
#' @param depends A vector of file names that the markdown script depends on.
#' @param format Requested format of the result. Parameter is passed as `format` argument
#' to [markdown::render()]. Allowed values are: 'all', 'html_document', 'pdf_document',
#' 'word_document', 'odt_document', 'rtf_document', or 'md_document'.
#' @param params A list of R values that become available within the `script` in variables of names
#' corresponding to names of elements in the list.
#' @return Instance of S3 class `recipe`
#' @seealso [recipe()], [makefile()], [rRecipe()]
#' @author Michal Burda
#' @export
#' @importFrom rmarkdown render
markdownRecipe <- function(target,
                           script,
                           depends=NULL,
                           format='all',
                           params=NULL,
                           task='all') {
  assert_that(is.character(target))
  assert_that(is.string(script))
  assert_that(is.null(depends) || is.character(depends))
  assert_that(is.character(format))
  assert_that(is.character(task))

  format <- match.arg(format,
                      c('all', 'html_document', 'pdf_document', 'word_document',
                        'odt_document', 'rtf_document', 'md_document'),
                      several.ok=TRUE)
  allDeps <- c(script, depends)
  p <- params
  rm(params)

  recipe(target=target,
         depends=allDeps,
         build=inShell({
           library(rmarkdown)
           params <- p
           render(script, output_format=format, output_file=target)
         }),
         clean=paste0('$(RM) ', paste0(target, collapse=' ')),
         task=task)
}
