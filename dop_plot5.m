clear
close all

n = 12;

mins = [];
maxs = [];

ming = 100;
maxg = 0;

ite = 10000;
PDOP = zeros(1,ite);

for j = 1:ite
    x = 100*rand(1,n) - 50;
    y = 100*rand(1,n) - 50;
    z = 50*rand(1,n);
%     [x,y] = gen_poly(50,12);
%     z = 50*rand(1,12);
    
    Ru = [0;0;0];
    R = [x;y;z];
    
    PDOP(j) = calc_PDOP(R,Ru);
    
    if maxg < PDOP(j)
        maxg = PDOP(j);
        maxs = [x;y;z];
    end
    if ming > PDOP(j)
        ming = PDOP(j);
        mins = [x;y;z];
    end
    
end

figure(1)
scatter3(maxs(1,:),maxs(2,:),maxs(3,:),200,'rp','filled')
hold on
scatter3(0,0,0,200,'bp','filled')
hold off

figure(2)
scatter3(mins(1,:),mins(2,:),mins(3,:),200,'rp','filled')
hold on
scatter3(0,0,0,200,'bp','filled')
hold off