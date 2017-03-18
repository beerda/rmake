.map <-  c(html="html_document",
           pdf="pdf_document",
           docx="word_document",
           odt="odt_document",
           rtf="rtf_document",
           md="md_document")


#' @export
markdownFormatFromExtension <- function(extension=c('html', 'pdf', 'docx', 'odt', 'rtf', 'md')) {
  extension <- match.arg(extension)
  .map[extension]
}
