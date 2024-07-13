function [d] = distance(P1,P2)
P21 = P1 - P2;
d = (P21'*P21).^(0.5);
end