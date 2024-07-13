max_ite = 1000;
R_ult = zeros(10,max_ite);
et_ult = zeros(10,max_ite);
reward_param = 0.01:0.01:0.1;
for r = 1:10
M = 4845;
ite_his = zeros(1,max_ite);
et_his = zeros(1,max_ite);
% P_his = zeros(M,max_ite);
R_his = zeros(1,max_ite);
    for i=1:max_ite
        [ite,et,P,R] = batch_sim_3(reward_param(r));
        ite_his(i) = ite;
        et_his(i) = et;
    %     P_his(:,i) = P';
        R_his(:,i) = R';
        fprintf("Iteration (%d) progress: %.2f\n",r,i/10);
    end
R_his = 1.58./R_his;
R_ult(r,:) = R_his;
et_ult(r,:) = et_his;
end
% save('result_r_f_0.001.mat','R_ult','et_ult','reward_param');