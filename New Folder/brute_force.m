data = load('user.mat');
Rr = data.Rr;
Rt = data.Rt;
S = nchoosek(1:20,4);
M = size(S,1);

DOP = zeros(1,M);
tic
for i = 1:M
    DOP(i) = calc_GDOP(Rr(:,S(i,:)),Rt);
end
[best_DOP,idx] = min(DOP);
et = toc;
