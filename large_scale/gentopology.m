X = zeros(1,4);
Y = zeros(1,4);

theta = [0 0 120 240];
r = [0 150 150 150];
for i = 1:4
    X(i) = r(i)*cos(deg2rad(theta(i)));
    Y(i) = r(i)*sin(deg2rad(theta(i)));
end
B = [X;Y;100*ones(1,4)];

X = [100*ones(1,3) 0 -100*ones(1,3) 0 200*ones(1,4) 200/3 -200/3 -200*ones(1,4) -200/3 200/3];
Y = [-100 0 100*ones(1,3) 0 -100*ones(1,2) -200 -200/3 200/3 200*ones(1,4) 200/3 -200/3 -200*ones(1,3)];
R = [X;Y;zeros(1,20)];

nb = size(B,2);
nr = size(R,2);
b = nchoosek(1:nb,1);
r = nchoosek(1:nr,3);
nb = size(b,1);
nr = size(r,1);
[X,Y] = meshgrid(1:nb,1:nr);
S = [b(X,:) r(Y,:)];