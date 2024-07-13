function [DOP,Ru] = ILS(Ri,Rt,R,Ru)
% Ri = [1;-0.5;8];
% Rr = [10,3,15,-18;35,-30,-2,1;2,8,5,8];
% Rt = [1;0;0];
% Ru = mean(R,2);
% Ru(3) = 60;
% R = Rr;
M = size(R,2);
c = 299792458;
t = zeros(M,1);
Tempxr = Ru;
eps = 1e-10;
ite = 20;
DOP = 1i;

Rs = zeros(M,1);
Js = zeros(M,3);
dp = zeros(M,1);
    
while ~isreal(DOP)
    
    r = zeros(M,1);
    for j = 1:M
        Rj = R(:,j);
%         r(j) = norm(Rt-Rj)+norm(Rj-Ri)-norm(Rt-Ri);
        r(j) = norm(Rt-Rj)+norm(Rj-Ri)-norm(Rt-Ri) + 4*rand - 2;
    end
    
    Ru = Tempxr;
    i = 1;
    dx = eps + 1;

    while (abs(dx'*dx) > eps) && i < ite 
        for j = 1:M
            Rj = R(:,j);

            Ruj = norm(Ru-Rj);
            Rui = norm(Ru-Ri);

            dp(j) = Ruj+norm(Rj-Ri)-Rui;

            x = (Ru(1)-Rj(1))/Ruj - (Ru(1)-Ri(1))/Rui;
            y = (Ru(2)-Rj(2))/Ruj - (Ru(2)-Ri(2))/Rui;
            z = (Ru(3)-Rj(3))/Ruj - (Ru(3)-Ri(3))/Rui;

            Rs(j) = r(j) - dp(j) - c*t(j);
            Js(j,:) = [x y z];
        end
        D = inv(Js'*Js);
        dx = D*Js'*Rs;
        Ru = Ru + dx;
        i = i + 1;
    end
    if (abs(dx'*dx) > 1)
        continue
    end
    if isnan(Ru(1))
        DOP = 1e6;
    else
        DOP = calc_GDOP([Ri R],Ru);
    end
end