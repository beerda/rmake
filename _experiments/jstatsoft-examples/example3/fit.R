
library(rmake)

# Variant 1
#str(params)

# Variant 2
#dataName <- getParam(".depends")
#resultName <- getParam(".target")
#alpha <- getParam("alpha")

# Variant 3
dataName <- getParam(".depends", "data.csv")
resultName <- getParam(".target", "result.rds")
alpha <- getParam("alpha", 0.2)

# now we can use these variables to do here some real work...

cat("dataName:", dataName, "\n")
cat("resultName:", resultName, "\n")
cat("alpha:", alpha, "\n")
str(dataName)
str(resultName)
str(alpha)

