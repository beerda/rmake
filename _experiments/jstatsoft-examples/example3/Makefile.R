library(rmake)

grid <- data.frame(
  ALPHA = c(0.1, 0.2, 0.3, 0.4)
)

tmpl <- c("data.csv" %>>% rRule("fit.R", params=list(alpha="$[ALPHA]")) %>>% "out-$[ALPHA].rds")

job <- c(
  expandTemplate(tmpl, grid)
  #"data.csv" %>>% rRule("fit.R", params=list(alpha=0.1)) %>>% "out-0.1.rds",
  #"data.csv" %>>% rRule("fit.R", params=list(alpha=0.2)) %>>% "out-0.2.rds",
  #"data.csv" %>>% rRule("fit.R", params=list(alpha=0.3)) %>>% "out-0.3.rds",
  #"data.csv" %>>% rRule("fit.R", params=list(alpha=0.4)) %>>% "out-0.4.rds"
)

makefile(job, "Makefile")
