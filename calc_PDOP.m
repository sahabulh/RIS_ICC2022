function [PDOP] = calc_PDOP(R,Ru)
A = zeros(size(R,2),4);

for i = 1:size(R,2)
    Ri = R(:,i);
    Ui = norm(Ru - Ri);

    A(i,:) = [(Ri(1)-Ru(1))/Ui (Ri(2)-Ru(2))/Ui (Ri(3)-Ru(3))/Ui 1];
end
D = inv(A'*A);
PDOP = sqrt(D(1,1)+D(2,2)+D(3,3));