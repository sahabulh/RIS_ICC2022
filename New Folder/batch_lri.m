function [i,et,P,reward_his] = batch_lri(r)
fake = linspace(1,20,6435);
M = size(fake,2);
%% LRI parameters
% Max iteration
max_ite = 5000;
% Probability of choosing strategy
P = ones(1,M)/M;
% Reward parameter or a
reward_param = r;
% Convergence variable
max_wait = 10;
conv_check = 0;
prev_R = -1;

% Histories
reward_his = zeros(1,max_ite);
s_his = zeros(1,max_ite);
P_his = zeros(M,max_ite);

tic
% Simulation loop
for i = 1:max_ite
    % Choose strategy based on probalility
    n = randsample(M,1,true,P);
    s_his(i) = n;
    
    % Run ILS
    DOP = fake(n);
%     A = abs(Rt-xr);
    
    % Calculate reward
    reward = 1/DOP;
%     reward = reward1(DOP,A)/4;
%     reward = reward2(DOP,A);
%     reward = reward1(Fake(n),[0,0,0])/4;
    reward_his(i) = reward;
    
    % updating probability using continuous LRI algorithm
    for st = 1:M
        if st == n
            P(st) = P(st) + reward_param*reward*(1 - P(st));
        else
            P(st) = (1 - reward_param*reward)*P(st);
        end
    end
    P_his(:,i) = P';
    
    % Check convergence
    if sum(abs(P-prev_R)) < 0.01 && conv_check == max_wait
        reward_his(i+1:end) = reward;
        break;
    elseif sum(abs(P-prev_R)) < 0.01
        conv_check = conv_check + 1;
    else
        conv_check = 0;
    end
    prev_R = P;
    
%     fprintf("Iteration done: %d\nProbabilities: %.3f %.3f %.3f %.3f\n\n",i,P(1),P(2),P(3),P(4));
    
end
et = toc;
i = i - 1;
end