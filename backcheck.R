library(devtools)
install_github("vikjam/bcstatsR",force = TRUE)

# Load bcstatsR
library(bcstatsR)

# Load a toy example bundled with bcstatsR
data(survey, bc)

# Compare the differences with bcstats
result <- bcstats(surveydata  = survey,
                  bcdata      = bc,
                  id          = "id",
                  t1vars      = "gender",
                  t2vars      = "gameresult",
                  t3vars      = "itemssold",
                  enumerator  = "enum",
                  enumteam    = "enumteam",
                  backchecker = "bcer")

compute.bc$backcheck

