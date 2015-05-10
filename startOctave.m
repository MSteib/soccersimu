% Suppose you have generated three sets of soccer scores and group match outcomes data files:
% scoresx, outcomey, scoresxval, outcomeyval, scoresxtest, outcomeytest
% In Octave or Matlab,
% First read in the data like:
X = csvread("scoresx.csv",1,0);
y = csvread("outcomey.csv",1,0);
Xval = csvread("scoresxval.csv",1,0);
yval = csvread("outcomeyval.csv",1,0);
Xtest = csvread("scoresxtest.csv",1,0);
ytest = csvread("outcomeytest.csv",1,0);

% and then transform the y data:
y = transformY(y);
yval = transformY(yval);
ytest = transformY(ytest);

% Now you can build your own machine learning algorithms, train them with X and y,
% validate and optimise them with Xval and yval, and 
% test them with Xtest and ytest.

% I also wrote another transformation function, transOneY(), to transform the six column y like [0,0,1,0,0,0]
% back into a single column y like [3], to facilitate the calculation of prediction accuracy.
% so if 'predictedy' is the predicted y matrix, you can calculate the accuracy like:
accuracy = mean(double(transOneY(predictedy) == transOneY(y)))*100;
% My practice has given a 74% accuracy with logistic regression and 82% with neural network (with a single hidden layer).
% See how you may improve this. Good luck!

% If instead using transOneY(), you just calculate like:
accuracy = mean(mean(double(predictedy == y)))*100;
% your accuracy score will be much higher, but that's only the mean accuracy for each column, 
% or say, the mean accuracy for each class in a one-vs-all classification problem.
