function yy = transformY(yyy)
% This is a function file for Octave (>=3.6.x) or Matlab
% because yyy is an m * 4 matrix with each row like [1,1,0,0] or [0,1,1,0]
% need to transform it into six column matrix, 
% with only one of each column being 1 and the other five equal to 0, 
% e.g. [1,0,0,0,0,0] or [0,0,1,0,0,0]

yy = zeros(size(yyy,1),6);
y1 = yyy(:,1).+ 2.*yyy(:,2) .+ 3.*yyy(:,3) .+ 5.*yyy(:,4) .-2;
yy = ((1: size(yy,2))==y1); 
yy = double(yy);

end
