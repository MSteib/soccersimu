# In R or Rstudio, To start with an example data, generate 3000 records of groups' goal numbers, or more if you like.
# Poisson distribution with lambda=2 is used for the goal number in each game for each team, which is most realistic to me.
AB=rpois(3000, 2)
BA=rpois(3000, 2)
AC=rpois(3000, 2)
CA=rpois(3000, 2)
AD=rpois(3000, 2)
DA=rpois(3000, 2)
BC=rpois(3000, 2)
CB=rpois(3000, 2)
BD=rpois(3000, 2)
DB=rpois(3000, 2)
CD=rpois(3000, 2)
DC=rpois(3000, 2)
scores1 = data.frame(AB,BA,AC,CA,AD,DA,BC,CB,BD,DB,CD,DC)

# so you have got an original score data file to start with.

# Each time yo generate a score data, just call the getWinmatrix() function.
source("getWinmatrix.r")
# And generate the outcome data matrix
matrix1 = getWinmatrix(scores1)

# Write the X and y data into separate csv files, so they can be read by other software.
write.csv(scores1, file="scoresx.csv", row.names = F)
write.csv(matrix1, file="outcomey.csv", row.names = F)

# Similarly, generate your xvalidation, yvalidation, xtest and ytest data sets.
# Occasionally R may give you all identical datasets, 
# so pls double check and ensure you get different data sets for training, validation and test.

# After doing all the analysis, you may like to try if your model works well when the x distribution changes.
# e.g. if x is generated from normal distribution or uniform distribution, can your model perform as well?
# In such a scenario, the f(x) rules remain the same but the x's boundary changes. 
# It might be a challenge to some kind of models.
