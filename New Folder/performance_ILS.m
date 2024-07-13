syms X Y Z;
load test.mat;

ite = 1000;

Ri = [1;-0.5;8];
Rr = [10,3,15,-18;35,-30,-2,1;2,8,5,8];

t = [0,0,0,0];
c = 299792458;
Rt = [1;0;0];

R = zeros(4,1);
J = zeros(4,3);
dp = zeros(4,1);
r = zeros(4,1);

tic
for i = 1:ite
    for j = 1:4
        Rj = Rr(:,j);
        Ru = xr;
        
        Ruj = norm(Ru-Rj);
        Rui = norm(Ru-Ri);
        
        dp(j) = Ruj+norm(Rj-Ri)-Rui;

        r(j) = norm(Rt-Rj)+norm(Rj-Ri)-norm(Rt-Ri);
        
        x = (Ru(1)-Rj(1))/Ruj - (Ru(1)-Ri(1))/Rui;
        y = (Ru(2)-Rj(2))/Ruj - (Ru(2)-Ri(2))/Rui;
        z = (Ru(3)-Rj(3))/Ruj - (Ru(3)-Ri(3))/Rui;
        
        R(j) = r(j) - dp(j) - c*t(j);
        J(j,:) = [x y z];
    end
end
toc

% tic
% for i = 1:ite
%     Js = double(subs(J,[X,Y,Z],xr'));
%     Rs = double(subs(R,[X,Y,Z],xr'));
%     dx = (Js'*Js)\Js'*Rs;
% end
% toc