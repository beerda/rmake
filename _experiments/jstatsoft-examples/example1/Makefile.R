library(rmake)

# Variant 1
#job <- list(
  #rRule(target="sums.csv", script="script.R", depends="data.csv"),
  #markdownRule(target="analysis.pdf", script="analysis.Rmd", depends="sums.csv")
#)

# Variant 2
job <- "data.csv" %>>% rRule("script.R") %>>%
  "sums.csv" %>>% markdownRule("analysis.Rmd") %>>%
  "analysis.pdf"

makefile(job, "Makefile")
