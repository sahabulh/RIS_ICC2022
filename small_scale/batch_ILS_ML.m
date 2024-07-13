function [i,et,P,reward] = batch_ILS_ML(beta)
%% RIS system parameters
data = load('topology4.mat');
R = data.R;
B = data.B;
S = data.S;
Rt = [30;30;0];
M = size(S,1);                          % Number of Sets
%% Max Logit
ep = 0.005;
T = 10;
con_check = 0;
P = ones(1,M)/M;
max_ite = 1000;
reward_his = zeros(1,max_ite);
best_n = 1;
best_r = 0;

tic
for i=1:max_ite
    % Choose strategy based on probalility
    n = randsample(M,1,true,P);
    Rr = [B R(:,S(n,:))];
    
    % Run ILS
    [DOP,~] = ILS(Rr(:,1),Rt,Rr(:,2:4),mean(Rr,2));
    
    % Calculate reward
    reward = 1.58/DOP;
    
    U1 = exp(beta*reward);
    U2 = exp(beta*best_r);
    P1 = U1/max(U1,U2);
    P2 = U2/max(U1,U2);
    
    if P1>P2
        best_n = n;
        best_r = reward;
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
P = best_n;
reward = best_r;