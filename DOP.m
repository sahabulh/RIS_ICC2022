clear
close all

n = 20;
m = 12;

mins = [];
maxs = [];

ming = 100;
maxg = 0;

ite = 1000;
% PDOP1 = zeros(factorial(15)/(factorial(7)*factorial(8)),ite);
% PDOP2 = zeros(factorial(20)/(factorial(12)*factorial(8)),ite);
et_his = zeros(1,ite);

S = zeros(1,12);

for j = 1:ite
    x = 100*rand(1,n) - 50;
    y = 100*rand(1,n) - 50;
    z = 50*rand(1,n);
    
    Ru = [0;0;0];
    
    [el,az] = xyz2elaz(x,y,z);
    tic
    [~,idx] = sort(el);
    S(1:5) = [idx(1) idx(end-3:end)];
    P = nchoosek(idx(2:end-4),7);
    for i = 1:size(P,1)
        S(6:end) = P(i,:);
        R = [x(S);y(S);z(S)];
%         PDOP1(i,j) = calc_PDOP(R,Ru);
    end
    et_his(j) = toc;
%     P = nchoosek(1:20,12);
%     for i = 1:size(P,1)
%         R = [x(P(i,:));y(P(i,:));z(P(i,:))];
%         PDOP2(i,j) = calc_PDOP(R,Ru);
%     end
end
% min(PDOP1)
% min(PDOP2)