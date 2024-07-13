function [r] = reward1(DOP,A)
w = [0.25 0.25 0.25 .25];
r = 1/(w(1)*DOP + w(2)*A(1) + w(3)*A(2) + w(4)*A(3));
end