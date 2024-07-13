function [c] = frac_phase(p,lambda)
c = p/lambda;
c = c - floor(c);
end