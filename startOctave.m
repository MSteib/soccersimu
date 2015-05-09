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
% My practice has given a 92% accuracy with logistic regression and 94% with neural network (with a single hidden layer).
% See how you may improve this. Good luck!
