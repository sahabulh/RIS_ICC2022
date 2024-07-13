m = 500;
x = m*rand(1,10) - m/2;
y = m*rand(1,10) - m/2;
z = (m/10)*(randsample(1:2,10,true,[0.5 0.5]) - 1);
scatter3(x,y,z,200,'rp','filled')
hold on;
R = [x;y;z];
nr = size(R,2);
S = nchoosek(1:nr,3);
hold off;