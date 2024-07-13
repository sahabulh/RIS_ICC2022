function [x,y] = gen_poly(r,n)
a = 360/n;

theta = pi*(0:a:360)/180;
x = r*cos(theta);
y = r*sin(theta);
x(end) = [];
y(end) = [];