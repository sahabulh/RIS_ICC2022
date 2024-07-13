function [r] = reward2(DOP,A)
r = 1/(DOP*A(1)*A(2)*A(3));
end