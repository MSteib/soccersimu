function yyy = transOneY(yy)
% This function is used to transform y(i,:) like [1,0,0,0,0,0] or [0,0,0,0,0,1] into 
% a one-column matrix (vector) with y(i) = 1 or 6.
% The use of this function is to calculate the prediction accuracy.

yyy = yy(:,1)+2.*yy(:,2)+3.*yy(:,3)+4.*yy(:,4)+5.*yy(:,5)+6.*yy(:,6);
end
