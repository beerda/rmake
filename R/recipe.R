recipe <- function(target, depends, build=NULL, clean=NULL) {
  structure(list(target=target,
                 depends=unique(depends),
                 build=build,
                 clean=clean),
            class='recipe')
}


rRecipe <- function(target, script, depends=NULL) {
  recipe(target=target,
         depends=c(script, depends),
         #build=paste0('R --no-save --no-restore --quiet -e \'source(\"', script, '\")\''),
         build=rCmd(source(script)),
         clean=paste0('rm ', target))
}


.map <-  c(html="html_document",
           pdf="pdf_document",
           docx="word_document",
           odt="odt_document",
           rtf="rtf_document",
           md="md_document")


markdownFormatByExtension <- function(extension=c('html', 'pdf', 'docx', 'odt', 'rtf', 'md')) {
  extension <- match.arg(extension)
  .map[extension]
}


markdownRecipe <- function(target,
                           script,
                           depends=NULL,
                           format=markdownFormatByExtension(tools::file_ext(target)),
                           ...) {
  params <- c(list(script, output_format=format, output_file=target), list(...))
  recipe(target=target,
         depends=c(script, depends),
         build=rCmd({
           library(rmarkdown)
           do.call('render', params)
         }),
         clean=paste0('rm ', target))

}
