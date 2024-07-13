x = 500*rand(1,10) - 250;
y = 500*rand(1,10) - 250;
z = 50*rand(1,10);
scatter3(x,y,z,200,'rp','filled')
hold on
R = [x;y;z];
nr = size(R,2);
S = nchoosek(1:nr,3);