d <- read.csv("data.csv")
sums <- data.frame(ID="sum",
                   V1=sum(d$V1),
                   V2=sum(d$V2))
write.csv(sums, "sums.csv", row.names=FALSE)
