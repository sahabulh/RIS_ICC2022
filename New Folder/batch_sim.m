function [i,et,P,reward_his] = batch_sim(reward_param)
%% RIS system parameters
Ri = [1;-0.5;8];                            % gNB position
Rr = [10,3,15,-18;35,-30,-2,1;2,8,5,8];     % RISs position, first column first RIS
% t = [0,0,0,0];                          % Array for tj
% c = 299792458;

M = size(Rr,2);                         % Number of RISs

Rt = [1;0;0];                         % True position of UAV, static case

S = nchoosek(1:4,3);                    % All possible 3 from 4 combinations of RISs

% Fake = [ILS(Rr(:,S(1,:)),Ri,Rt,t) ILS(Rr(:,S(2,:)),Ri,Rt,t) ILS(Rr(:,S(3,:)),Ri,Rt,t) ILS(Rr(:,S(4,:)),Ri,Rt,t)];
%% LRI parameters
% Max iteration
max_ite = 2000;
% Probability of choosing strategy
P = ones(1,M)/M;
% Reward parameter or a
% reward_param = 0.5;
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
    xr = mean(Rr,2);
    [DOP,~] = ILS(Ri,Rt,Rr(:,S(n,:)),xr);
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