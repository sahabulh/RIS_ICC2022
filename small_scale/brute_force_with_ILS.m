R_his = zeros(1,1000);
et_his = zeros(1,1000);
for j = 1:1000
data = load('topology4.mat');
R = data.R;
B = data.B;
S = data.S;
Rt = [0;135;0];
M = size(S,1);

DOP = zeros(1,M);
tic
for i = 1:M
    Rr = [B R(:,S(i,:))];
    Ru = mean(Rr,2);
    [DOP(i),~] = ILS(Rr(:,1),Rt,Rr(:,2:4),Ru);
end
[R_his(j),idx] = min(DOP);
et_his(j) = toc;
fprintf("Iteration (%d) progress.\n",j);
end
R_ult = repmat(R_his,[10,1]);
et_ult = repmat(et_his,[10,1]);
reward_param = 0.01:0.01:0.1;
% save('result_bf_top4_loc4.mat','R_ult','et_ult','reward_param');