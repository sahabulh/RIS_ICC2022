function [i,et,P,reward] = batch_ILS_ELRI(reward_param,Rt)
% reward_param = 0.01;
%% RIS system parameters
data = load('topology5.mat');
R = data.R;
B = data.B;
S = data.S;
M = size(S,1);                          % Number of Sets

% Fake = [ILS(Rr(:,S(1,:)),Ri,Rt,t) ILS(Rr(:,S(2,:)),Ri,Rt,t) ILS(Rr(:,S(3,:)),Ri,Rt,t) ILS(Rr(:,S(4,:)),Ri,Rt,t)];
%% LRI parameters
% Max iteration
max_ite = 100000;
% Probability of choosing strategy
P = ones(1,M)/M;
% Convergence variable
max_wait = 10;
conv_check = 0;
prev_R = -1;
R_his = zeros(1,max_ite);
error_his = zeros(3,max_ite);
best_r = 0;

tic
% Simulation loop
for i = 1:max_ite
    % Choose strategy based on probalility
    n = randsample(M,1,true,P);
    Rr = [B R(:,S(n,:))];
    
    % Run ILS
    [DOP,error_his(:,i)] = ILS(Rr(:,1),Rt,Rr(:,2:4),mean(Rr,2));
    
    % Calculate reward
    reward = 1.58/DOP;
    R_his(i) = reward;
    
    % updating probability using continuous LRI algorithm
    for st = 1:M
        if st == n
            P(st) = P(st) + reward_param*reward*(1 - P(st));
        else
            P(st) = (1 - reward_param*reward)*P(st);
        end
    end
    
    % Check convergence
    if abs(reward-prev_R) < 0.01 && conv_check == max_wait
        break;
    elseif abs(reward-prev_R) < 0.01
        conv_check = conv_check + 1;
    else
        conv_check = 0;
    end
    prev_R = reward;
    
%     if (i>5)
%         if abs(reward-mean(R_his(i-4:i))) < 0.01 && conv_check == max_wait
%             break;
%         elseif abs(reward-mean(R_his(i-4:i))) < 0.01
%             conv_check = conv_check + 1;
%         else
%             conv_check = 0;
%         end
%     end
    
    if reward>best_r
        best_r = reward;
    elseif reward<(best_r-0.1)
        M = M - 1;
        S(n,:)=[];
        P(n) = [];
        P = P/sum(P);
    end
    
%     fprintf("Iteration done: %d\n",i);
%     fprintf("reward: %.3f\n",reward);
end
et = toc;
[~,idx] = max(P);
Rr = [B R(:,S(idx,:))];
[~,E] = ILS(Rr(:,1),Rt,Rr(:,2:4),mean(Rr,2));
P = E;
i = i - 1;