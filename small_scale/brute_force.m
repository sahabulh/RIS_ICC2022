data = load('topology4.mat');
R = data.R;
B = data.B;
S = data.S;
Rt = [0;0;0];
M = size(S,1);

DOP = zeros(1,M);
tic
for i = 1:M
%     Rt = [0;0;0] + 4*rand(3,1) - 2;
    Rr = [B R(:,S(i,:))];
    DOP(i) = calc_GDOP(Rr,Rt);
end
[best_DOP,idx] = min(DOP);
et = toc;
