task <- function(target, depends, build, clean=NULL) {
  list(target=target,
       depends=unique(depends),
       build=build,
       clean=clean)
}


rTask <- function(target,
                  depends=NULL,
                  source=replaceSuffix(target, '.R')) {
  task(target=target,
       depends=c(source, depends),
       build=paste0('R --no-save --no-restore --quiet -e \'source(\"', source, '\")\''),
       clean=paste0('rm ', target))
}


.map <-  c(html="html_document",
           pdf="pdf_document",
           docx="word_document",
           odt="odt_document",
           rtf="rtf_document",
           md="md_document")

rmdFormatByExtension <- function(extension=c('html', 'pdf', 'docx', 'odt', 'rtf', 'md')) {
  extension <- match.arg(extension)
  .map[extension]
}


rmdTask <- function(target,
                    depends=NULL,
                    source=replaceSuffix(target, '.Rmd'),
                    format=rmdFormatByExtension(tools::file_ext(target))) {
  task(target=target,
       depends=c(source, depends),
       build=paste0('R --no-save --no-restore --quiet -e \'',
                    'library(rmarkdown); ',
                    'render(\"', source, '\", output_format=\"', format, '\")\''),
       clean=paste0('rm ', target))
}


pdftexTask <- function(target,
                       depends,
                       source=replaceSuffix(target, '.tex')) {
  sourceNoSuffix <- replaceSuffix(source, '')
  task(target=target,
       depends=c(source, depends),
       build=paste0('xelatex \"', source, '\"'),
       clean=paste0('rm ', paste(sourceNoSuffix, c('pdf', 'aux', 'log', 'out', 'toc'), sep='.', collapse=' ')))
}


