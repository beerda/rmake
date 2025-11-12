library(rmake)

job <- c('data' %>>% markdownRule('pokus.Rmd') %>>% c('pokus1.pdf', 'pokus12.docx'))

makefile(job, "Makefile")


