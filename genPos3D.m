function [pos] = genPos3D(distance,n)
x = randsrc(n,1).*distance.*rand(n,1);
y = randsrc(n,1).*((distance^2 - x.^2).^(1/2)).*rand(n,1);
z = randsrc(n,1).*(distance^2 - x.^2 - y.^2).^(1/2);
pos = [x y z];
end