% clear
% close all

x = [0,10,-5,0];
y = [10,0,-5,0];
z = [0,0,0,10];

% x = [0,8,-8,0];
% y = [9.5,-4.7,-5,0];
% z = [-3.5,-3.5,-3.5,10];
el = deg2rad(0.1:0.1:90);
az = deg2rad(-180:0.1:180);

Ru = [0;0;0];

GDOP = zeros(size(E));

for i = 1:size(E,1)
    for j = 1:size(E,2)
        [x(4),y(4),z(4)] = sph2cart(az(i),el(j),10);
        GDOP(i,j) = calc_GDOP([x;y;z],Ru);
    end
end

az = rad2deg(az);
el = rad2deg(el);
GDOP(GDOP>20)=20;
figure(1)
[C,h] = contourf(az,el,GDOP');
clabel(C,h,'FontSize',15,'Color','black')
colorbar