# In R or Rstudio, To start with an example data, generate 300 records of groups' goal numbers, or 1000 or more if you like.
# Poisson distribution with lambla=2 is used for the goal number in each game for each team, which is most realistic
AB=rpois(300, 2)
BA=rpois(300, 2)
AC=rpois(300, 2)
CA=rpois(300, 2)
AD=rpois(300, 2)
DA=rpois(300, 2)
BC=rpois(300, 2)
CB=rpois(300, 2)
BD=rpois(300, 2)
DB=rpois(300, 2)
CD=rpois(300, 2)
DC=rpois(300, 2)
scores1 = data.frame(AB,BA,AC,CA,AD,DA,BC,CB,BD,DB,CD,DC)

# so you have got an original score data file to start with.
