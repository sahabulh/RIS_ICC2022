% [x,y] = gen_poly(50,5);
% x = [x 0];
% y = [y 0];

n = 12;
x = 100*rand(1,n) - 50;
y = 100*rand(1,n) - 50;
z = 50*rand(1,n);
Ru = [0;0;0];

DOP = zeros(1,128);
tic
for i = 1:128
%     z = [0 i 0 i 0 i 0 i 0 i 0 i];
%     z = [0 i 0 i 0];
%     R = [x;y;z];
%     DOP(i) = calc_PDOP(R,Ru);
    inv(A'*A);
end
toc
