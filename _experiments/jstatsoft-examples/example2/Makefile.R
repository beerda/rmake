library(rmake)

job <- c(
  "data.csv" %>>% rRule("preprocess.R") %>>% "data.rds",
  "data.rds" %>>% markdownRule("preview.Rmd", task="preview") %>>% "preview.pdf",
  "data.rds" %>>% markdownRule("final.Rmd", task="final") %>>% "final.pdf"
)

makefile(job, "Makefile")
