function [i,et,P,reward] = batch_NILS_LRP(reward_param,penlty_param)
%% RIS system parameters
data = load('topology.mat');
R = data.R;
B = data.B;
data = load('sets.mat');
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
prev_R = -1;

tic
% Simulation loop
for i = 1:max_ite
    % Choose strategy based on probalility
    n = randsample(M,1,true,P);
    Rr = [B(:,S(n,1)) R(:,S(n,2:4))];
    
    % Run ILS
    DOP = calc_GDOP(Rr,Rt+4*rand(3,1)-2);
    
    % Calculate reward
    reward = 1.58/DOP;
    
    % updating probability using continuous LRI algorithm
    for st = 1:M
        if st == n
            P(st) = P(st) + reward_param*reward*(1 - P(st)) - penlty_param*(1 - reward)*P(st);
        else
            P(st) = P(st) - reward_param*reward*P(st) + penlty_param*(1 - reward)*((1/(M - 1)) - P(st));
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
    
%     fprintf("Iteration done: %d\nProbabilities: %.3f %.3f %.3f %.3f\n\n",i,P(1),P(2),P(3),P(4));
end
et = toc;
i = i - 1;