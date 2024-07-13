function [i,et,P,reward] = batch_ILS_BL(beta,Rt)
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
best_n = [1 1];
best_r = [0 0];

tic
for i=1:max_ite
    % Choose strategy based on probalility
    n = randsample(M,1,true,P);
    best_n(2) = n;
    Rr = [B(:,S(n,1)) R(:,S(n,2:4))];
    
    % Run ILS
    [DOP,~] = ILS(Rr(:,1),Rt,Rr(:,2:4),mean(Rr,2));
    
    % Calculate reward
    best_r(2) = 1.58/DOP;
    
    U1 = exp(beta*best_r(1));
    U2 = exp(beta*best_r(2));
    C = [U1/(U1+U2) U2/(U1+U2)];
    
    c = randsample(1:2,1,true,C);
    best_r(1) = best_r(c);
    best_n(1) = best_n(c);
    reward_his(i) = best_r(1);
    
    if abs(mean(reward_his(1:i))-best_r(1))<= ep && con_check == T
        break;
    elseif abs(mean(reward_his(1:i))-best_r(1))<= ep
        con_check = con_check + 1;
    else
        con_check = 0;
    end
end
et = toc;
i = i - 1;
P = best_n(1);
reward = best_r(1);