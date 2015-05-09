# soccersimu
Some R and Octave codes to see if machine learning can 'predict' the outcome of each group match by only looking into the goal numbers.

This simulation is about how the outcome of group-stage matches of soccer can be "predicted" by a logistic regression or neural network, given only the numbers of goals in each game by each team.
 
Imagine a group of aliens have watched all the group stage matches, learned the goal numbers for all teams in all matches,
and have been informed the outcome (i.e. which teams have entered the elimination stage),
but they don't know anything about the soccer rules on our planet.
 
They might try to guess the rules, making more and more talent/complex hypotheses and test them with the informed outcomes, or simply, they just use a logistic regression or neural network to 'blindly' establish a predictive model, and make 'predictions' like we are doing in this 'big data' era.

In this study, I generate a set of group match data and calculate the 'true' outcomes based on a set of rules which are similar to European Championship rules, then I will create a logistic regression programme and neural networks, to let them try to predict the outcomes, and see how well they can predict.

### The ranking rules I used are as follows:(modified from the UEFA European Championship rules)
### firstly, use the accumulated points (win -> 3, draw -> 1, lose -> 0)
### If two or more teams are equal on points on completion of the group matches: 
### a) winning relationship, if two teams finish equal on points, 
###    or when only two teams get a equal mark at any following calculation stage;
### b) superior goal difference in the matches among the teams in question, if more
###    than two teams finish equal on points;
### c) higher number of goals scored in the matches among the teams in question, if
###    more than two teams finish equal on points;
### d) superior goal difference in all the group matches;
### e) higher number of goals scored in all the group matches;
### f) random choice (throwing dices)

Below is how I structure the data and do the programming

Each record of data represents a group of four teams (A, B, C, D), containing all the 12 goal numbers in the six games among them.
These are considered as known, independent variables (x1, x2, ... x12), in this simulation they are given the names "AB" (goal number of team A in the game between A and B), "BA", "AC", ...

An R function, getWinmatrix(), was written to calculate the outcome variables y=c(y1, y2, y3, y4), indicating if
each of teams A, B, C, and D finally makes it to the final games (elimination stage).
For example, if y[i]=c(1,1,0,0) for a record, that means in this group, teams A and B have entered elimination stage while C and D didn't. The principles used in getWinmatrix() for determination of who would enter the elimination stage are based on the ranking rules above.

In getWinmatrix() another pre-written function, teamscore(), is called in, which calculate the accumulated scores/points of each team when the group stage is finished. Make sure the two .r files for the two functions are included in the working directory.

To do one-vs-all classification, note there are only six possible outcomes. Each possible y[i], like c(1,1,0,0) or c(1,0,1,0) has to be transformed into something like y[i]=1 or y[i]=2, and then into y[i]=c(1,0,0,0,0,0) or y[i]=c(0,2,0,0,0,0). An octave function, transformY(), was written to do this transformation.

To play with this analysis, just generate your own x and y matrices, set up training, validation and test sets, and code your own regression or neural network to see how well they can 'predict' the y from the x.
