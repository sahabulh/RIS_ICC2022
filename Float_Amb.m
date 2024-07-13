% Method from "Ta2011Thesis.pdf"
% Problem is created randomly for testing

clear
close all

syms X Y Z N N1 N2 N3 N4 N5;
N = [N1 N2 N3 N4 N5];

Rt = [25;25;-5];
Ru = [X;Y;Z];

Rr = [26;26;-5];

Ri = [0,25,50,25,25;25,0,25,50,25;8,8,8,8,-20];

c = 299792458;
L1 = 1575.42e6;
lambda = c/L1;

n1 = floor((norm(Rt-Ri(:,1)))/lambda);
n2 = floor((norm(Rt-Ri(:,2)) + 6*rand - 3)/lambda);
n3 = floor((norm(Rt-Ri(:,3)) + 6*rand - 3)/lambda);
n4 = floor((norm(Rt-Ri(:,4)) + 6*rand - 3)/lambda);
n5 = floor((norm(Rt-Ri(:,5)) + 6*rand - 3)/lambda);

n = [n1 n2 n3 n4 n5];

r = [];

m = 0;
for i = 2:5
        
    m = m + 1;  
      
    p1u = norm(Rt-Ri(:,1));
    p2u = norm(Rt-Ri(:,i));
    p1r = norm(Rr-Ri(:,1));
    p2r = norm(Rr-Ri(:,i));
    
    c1u = frac_phase(p1u,lambda);
    c2u = frac_phase(p2u,lambda);
    c1r = frac_phase(p1r,lambda);
    c2r = frac_phase(p2r,lambda);
    
    r(m) = - lambda*(c1u - c1r) + lambda*(c2u - c2r);
    R(m) = (norm(Ru-Ri(:,1))-norm(Rr-Ri(:,1))) - (norm(Ru-Ri(:,i))-norm(Rr-Ri(:,i))) + r(m) - lambda*(N1 - floor(p1r/lambda)) + lambda*(n(i) - floor(p2r/lambda));
end

R = R';
J = [];

for i = 1:m
    J = [J; diff(R(i),X) diff(R(i),Y) diff(R(i),Z) diff(R(i),N1)];
end

xr = [10;10;0;140];
eps = 1e-20;
ite = 20;
i = 1;
dxs = eps + 1;

while (abs(dxs'*dxs) > eps) && i < ite 
    Js = double(subs(J,[X,Y,Z,N1],xr'));
    Rs = double(subs(R,[X,Y,Z,N1],xr'));
    dx = (Js'*Js)\Js'*Rs;
    xr = xr - double(dx);
    i = i + 1;
    dxs = double(dx);
    fprintf("Iteration: %d\nError: %.2e\nOutput: X=%.3e Y=%.3e Z=%.3e\n\n",i-1,dxs'*dxs,xr(1),xr(2),xr(3));
end

fprintf("AE: dX=%.3f dY=%.3f dZ=%.3f\n",xr(1)-Rt(1),xr(2)-Rt(2),xr(3)-Rt(3));
fprintf("APE: dX=%.3f dY=%.3f dZ=%.3f\n\n",100*(xr(1)-Rt(1))/Rt(1),100*(xr(2)-Rt(2))/Rt(2),100*(xr(3)-Rt(3))/Rt(3));