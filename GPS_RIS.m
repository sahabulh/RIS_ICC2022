% Method from "Ta2011Thesis.pdf"
% Problem is created randomly for testing

clear
close all

syms X Y Z;

Rt = [25;25;0];
Ri = [25;25;10];
Rr = [0,25,50,25;25,0,25,50;8,8,8,8];
t = [0,0,0,0];
c = 299792458;

for i = 1:4
    Rj = Rr(:,i);
    Ru = [X;Y;Z];

    Ui = (Ru - Ri)/norm(Ru - Ri);
    Uj = (Rj - Ri)/norm(Rj - Ri);
    Uu = (Ru - Rj)/norm(Ru - Rj);

    dp(i) = (Uj - Ui)'*(Rj - Ri) + (Uu - Ui)'*(Ru - Rj);
    
    r(i) = norm(Ru-Rj)+norm(Rj-Ri)-norm(Ru-Ri);
    
    R(i) = subs(r(i),[X,Y,Z],Rt') - dp(i) - c*t(i) + normrnd(0,3);
end

R = R';
J = [];

for i = 1:4
    J = [J; diff(R(i),X) diff(R(i),Y) diff(R(i),Z)];
end

xr = [10;10;0];
eps = 1e-20;
ite = 20;
i = 1;
dxs = eps + 1;

while (abs(dxs'*dxs) > eps) && i < ite 
    Js = double(subs(J,[X,Y,Z],xr'));
    Rs = double(subs(R,[X,Y,Z],xr'));
    dx = (Js'*Js)\Js'*Rs;
    xr = xr - double(dx);
    i = i + 1;
    dxs = double(dx);
    fprintf("Iteration: %d\nUpdate: %.2e\nOutput: X=%.3e Y=%.3e Z=%.3e\n\n",i-1,dxs'*dxs,xr(1),xr(2),xr(3));
end

fprintf("Errors: dX=%.3f dY=%.3f dZ=%.3f\n",xr(1)-Rt(1),xr(2)-Rt(2),xr(3)-Rt(3));

D = inv(Js'*Js);
VDOP = sqrt(D(3,3));
HDOP = sqrt(D(1,1)+D(2,2));
PDOP = sqrt(D(1,1)+D(2,2)+D(3,3));