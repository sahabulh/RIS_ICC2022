function [el,az] = xyz2elaz(x,y,z)
el = atan2(z,sqrt(x.^2+y.^2));
az = atan2(y,x);