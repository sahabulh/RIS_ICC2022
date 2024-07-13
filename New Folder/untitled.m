load user.mat

S = nchoosek(1:20,12);

tic
xrs_all = zeros(3,1000);
for i = 1:1000
[~,xrs_all(:,i)] = ILS(Ri,Rt,Rr,xr);
end
toc

xr = mean(xrs_all,2);

tic
DOPs = zeros(1,size(S,1));
for i = 1:size(S,1)
[DOPs(i),~] = ILS_NoRnd(Ri,Rt,Rr(:,S(i,:)),xr);
end
toc