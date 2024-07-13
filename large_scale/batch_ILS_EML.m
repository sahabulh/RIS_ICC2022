function [i,et,P,reward] = batch_ILS_EML(Rt)
%% RIS system parameters
data = load('topology3.mat');
R = data.R;
B = data.B;
S = data.S;
M = size(S,1);                          % Number of Sets
%% Max Logit
ep = 0.005;
T = 10;
con_check = 0;
P = ones(1,M)/M;
max_ite = 10000;
reward_his = zeros(1,max_ite);
best_r = 0;

tic
for i=1:max_ite
    % Choose strategy based on probalility
    n = randsample(M,1,true,P);
    Rr = [B(:,S(n,1)) R(:,S(n,2:4))];
    
    % Run ILS
    [DOP,~] = ILS(Rr(:,1),Rt,Rr(:,2:4),mean(Rr,2));
    
    % Calculate reward
    reward = 1.58/DOP;
    
    if reward>best_r
        best_r = reward;
    elseif reward<(best_r-0.01)
        M = M - 1;
        S(n,:)=[];
        P(n) = [];
        P = P/sum(P);
    end
    reward_his(i) = best_r;
    
    if abs(mean(reward_his(1:i))-best_r)<= ep && con_check == T
        break;
    elseif abs(mean(reward_his(1:i))-best_r)<= ep
        con_check = con_check + 1;
    else
        con_check = 0;
    end
end
et = toc;
i = i - 1;
P = 0;
reward = best_r;