% clear
% close all

xa = -30:0.1:30;
xb = -30:0.1:30;

GDOP = zeros(size(xa,2),size(xa,2));
HDOP = zeros(size(xa,2),size(xa,2));
VDOP = zeros(size(xa,2),size(xa,2));
PDOP = zeros(size(xa,2),size(xa,2));

% x = R(1,:);
% y = R(2,:);
% z = R(3,:);

% x = [50.1,0.1,49.9,0.1];
% y = [-0.1,49.9,-0.1,50.1];
% z = [0,25,0,255];

% n = 8;
% [x,y] = gen_poly(50,n);
% x = [x 0];
% y = [y 0];
% % z = [10 5 10 5 10 5 10 5 10];
% z = [10 0 10 0 10 0 10 0 10];

x = [0,8,-8,0];
y = [10,-6,-6,0];
z = [0,0,0,10];

% x = [0,25,50,25,25];
% y = [25,0,25,50,25];
% z = [8,8,8,8,-10];

% x = normrnd(0,10,[1,50]);
% y = normrnd(0,1,[1,50]);
% z = 10*ones(1,50);

% x = [10,3,15,-18,1];
% y = [35,-30,-2,1,-0.5];
% z = [2,8,5,8,8];

% x = [0,50,50,0,25];
% y = [50,0,50,0,25];
% z = [8,8,8,8,10];

for ia = 1:size(xa,2)
    for ib = 1:size(xb,2)
        Ru = [xa(ia)+0.001;xb(ib)+0.001;0];

        A = [];

        for i = 1:size(x,2)
            Ri = [x(i);y(i);z(i)];
            Ui = norm(Ru - Ri);

            A = [A;(Ri(1)-Ru(1))/Ui (Ri(2)-Ru(2))/Ui (Ri(3)-Ru(3))/Ui 1];
        end
        D = inv(A'*A);
        VDOP(ia,ib) = sqrt(D(3,3));
        HDOP(ia,ib) = sqrt(D(1,1)+D(2,2));
        PDOP(ia,ib) = sqrt(D(1,1)+D(2,2)+D(3,3));
        GDOP(ia,ib) = sqrt(D(1,1)+D(2,2)+D(3,3)+D(4,4));
    end
end
PDOP(PDOP>20)=20;
figure(1)
[C,h] = contourf(xa,xb,PDOP');
clabel(C,h,'FontSize',15,'Color','black')
colorbar
% surf(xa,xb,PDOP)
% shading interp
hold on;
k = max(PDOP,[],'all')*ones(size(x));
scatter3(x,y,k,200,'rp','filled')