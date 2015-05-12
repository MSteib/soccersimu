## soccersimu

Given the number of goals in each game by each team, when all the group matches complete, it's easy for us to tell which two of the four teams in each group will enter the next stage, because we know excatly what the rules are.

Now imagine some aliens have watched all the group stage matches, learned every information about the goal numbers and outcomes as we have, but they don't know anything about the soccer rules on our planet! They are very curious how we decide the outcome from the original goal numbers.

They might try to guess out the rules (like "maybe kicking more goals would be good"), making more and more talent/complex hypotheses (like "maybe kicking too many goals in a single match is not very good, but sometimes it is") and test them with the informed outcomes. Or alternatively, they may just use a logistic regression or neural network to let computers 'blindly' establish predictive models, making predictions and inference like we are doing in this 'big data' era.

Here I made this experiment, to simulate how these aliens may perform on their computers.

The best prediction accuracy I got now is 91.5%. Will go on developing more advanced models to achieve better performance. However one message is here to take home: These aliens have to watch mathces in >=3000 groups to get an idea of what they are guessing. That's equivalent to watching near 400 years of FIFA or UEFA cups, if they are held every year!
#------------------------
It is said a well built neural network algorithm can 'resemble' lots of complex, non-linear functions, successfully predicting y for a given x, without need to tackle what f(x) really is. Lots of examples are seen, like image recognition, automatic steering, etc. In this simulation, I am aimed to see and show off this super power. 

First, I generate a set of group match data and calculate the 'true' outcomes based on a set of rules, which are similar to European Championship rules. (Using historical data from UEFA may be another choice, but I personally think this data is not enough -- and it turns out not enough.) Then I will create a logistic regression programme and neural networks, to let them try to predict the outcomes, and see how well they can predict.

The ranking rules I used are as follows:(modified from the UEFA European Championship rules)
 Firstly, use the accumulated points (win -> 3, draw -> 1, lose -> 0)
 
 If two or more teams are equal on points on completion of the group matches:
 
 a) winning relationship, if two teams finish equal on points, or when only two teams get a equal mark at any following calculation stage;
 
 b) superior goal difference in the matches among the teams in question, if more than two teams finish equal on points;
 
 c) higher number of goals scored in the matches among the teams in question, if more than two teams finish equal on points;
 
 d) superior goal difference in all the group matches;
 
 e) higher number of goals scored in all the group matches;
 
 f) random choice (throwing dices)

Below is how I structure the data and do the programming:

Each record of data represents a group of four teams (A, B, C, D). The x variables include all the 12 goal numbers in the six games among them. These are considered as known, independent variables (x1, x2, ... x12), in the codes they are given the names "AB" (goal number of team A in the game between A and B), "BA", "AC", ..., "CD", "DC".

An R function, getWinmatrix(), was written to calculate the outcome variables y=c(y1, y2, y3, y4), indicating if
each of teams A, B, C, and D finally makes it to the final games (elimination stage). For example, if y[i]=c(1,1,0,0) for a record, that means in this group, teams A and B have entered elimination stage while C and D haven't. In getWinmatrix() the ranking rules above are implemented.

In getWinmatrix() another pre-written function, teamscore(), is called in, which calculates the accumulated point of each team when the group stage is finished. Make sure the two .r files for the two functions are included in the working directory.

To do one-vs-all classification, note there are only six possible outcomes. Each possible y[i], like c(1,1,0,0) or c(1,0,1,0) has to be transformed into something like y[i]=1 or y[i]=2, and then into y[i]=c(1,0,0,0,0,0) or y[i]=c(0,1,0,0,0,0). An octave function, transformY(), was written to do this transformation.

My own Octave codes for machine learning are adapted from the resource in the online course "Machine learning" on Coursera by Dr. Andrew Ng from Stanford University. The modelling codes are not published here due to the course requirement.

At this stage, I have found that the training sample size has to be >=3000 to get a steady, reasonable prediction accuracy. Using a neural network with single hidden layer of 40 units, I got a prediction accuracy of 88.5-89%, and using a neural network with double hidden layers, each with 32 units, I got it 91.5-92%.

Because my training, validation and test sets are essentially from the same population, in theory overfitting shouldn't be a problem, especially when you use the recommended sample size >=3000. Using regularization with lambda>=0.5 can only decrease the predictivity.

To play with this experiment, just use my R codes here to generate your own x and y matrices, building your training, validation and test sets, and code your own regression, svm or neural networks to see how well they can 'predict' the y from the x. It would be great if you manage up to >95% accuracy. If you get it >98%, please let me know the breaking news and I will appreciate it very much.

Please start from 'startanalysis.r' and then 'startOctave.m'. R and Octave/Matlab will be used.
