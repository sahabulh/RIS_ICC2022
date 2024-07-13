function [i,et,P,reward] = batch_ILS_ELRP(reward_param,penlty_param)
% reward_param = 0.1;
%% RIS system parameters
data = load('topology2.mat');
R = data.R;
B = data.B;
S = data.S;
Rt = [0;0;0];
M = size(S,1);                          % Number of Sets

% Fake = [ILS(Rr(:,S(1,:)),Ri,Rt,t) ILS(Rr(:,S(2,:)),Ri,Rt,t) ILS(Rr(:,S(3,:)),Ri,Rt,t) ILS(Rr(:,S(4,:)),Ri,Rt,t)];
%% LRI parameters
% Max iteration
max_ite = 10000;
% Probability of choosing strategy
P = ones(1,M)/M;
% Convergence variable
max_wait = 10;
conv_check = 0;
R_his = zeros(1,max_ite+1);
best_r = 0;

tic
% Simulation loop
for i = 1:max_ite
    % Choose strategy based on probalility
    n = randsample(M,1,true,P);
    Rr = [B R(:,S(n,:))];
    
    % Run ILS
    [DOP,~] = ILS(Rr(:,1),Rt,Rr(:,2:4),mean(Rr,2));
    
    % Calculate reward
    reward = 1.58/DOP;
    R_his(i+1) = reward;
    
    % updating probability using continuous LRI algorithm
    for st = 1:M
        if st == n
            P(st) = P(st) + reward_param*reward*(1 - P(st)) - penlty_param*(1 - reward)*P(st);
        else
            P(st) = P(st) - reward_param*reward*P(st) + penlty_param*(1 - reward)*((1/(M - 1)) - P(st));
        end
    end
    
    % Check convergence
    if abs(reward-R_his(i)) < 0.01 && conv_check == max_wait
        break;
    elseif abs(reward-R_his(i)) < 0.01
        conv_check = conv_check + 1;
    else
        conv_check = 0;
    end
    
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
    elseif reward<(best_r-0.01)
        M = M - 1;
        S(n,:)=[];
        P(n) = [];
        P = P/sum(P);
    end
    
%     fprintf("Iteration done: %d\n",i);
%     fprintf("reward: %.3f\n",reward);
end
et = toc;
% reward = mean(R_his(i-19:i));
i = i - 1;