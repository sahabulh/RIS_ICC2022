% Method from "Ta2011Thesis.pdf"
% Problem from "Solving the GPS Equations.pdf"

syms X Y Z dT;

c = 3e5;
x = [15600,18760,17610,19170];
y = [7540,2750,14630,610];
z = [20140,18610,13480,18390];
r = [0.07074,0.07220,0.07690,0.07242]*c;

for i = 1:4
    R(i) = r(i) - sqrt((X-x(i))^2 + (Y-y(i))^2 + (Z-z(i))^2) - c*dT;
end

R = R';
J = [];

for i = 1:4
    J = [J; diff(R(i),X) diff(R(i),Y) diff(R(i),Z) diff(R(i),dT)];
end

x = [0;0;6370;0];
eps = 1e-3;
ite = 20;
i = 1;
dxs = eps + 1;

while (abs(dxs'*dxs) > eps) && i < ite 
    Js = subs(J,[X,Y,Z,dT],x');
    Rs = subs(R,[X,Y,Z,dT],x');
    dx = (Js'*Js)\Js'*Rs;
    x = x - double(dx);
    i = i + 1;
    dxs = double(dx);
    fprintf("Iteration: %d\nError: %.2e\nOutput: X=%.3e Y=%.3e Z=%.3e dT=%.3e\n\n",i,dxs'*dxs,x(1),x(2),x(3),x(4));
end

Xr = -41.772709;
Yr = -16.789194;
Zr = 6370.059559;
dTr = -0.003201;

fprintf("AE: dX=%.3e dY=%.3e dZ=%.3e\n",x(1)-Xr,x(2)-Yr,x(3)-Zr);
fprintf("APE: dX=%.3e dY=%.3e dZ=%.3e\n\n",100*(x(1)-Xr)/Xr,100*(x(2)-Yr)/Yr,100*(x(3)-Zr)/Zr);