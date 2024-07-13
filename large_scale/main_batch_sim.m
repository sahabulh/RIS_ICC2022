warning off
max_ite = 1000;
Rt = [0;0;0];
% reward_param = 50:50:500;
reward_param = 0.01:0.01:0.1;
R_ult = zeros(size(reward_param,2),max_ite);
et_ult = zeros(size(reward_param,2),max_ite);
for r = 1:size(reward_param,2)
ite_his = zeros(1,max_ite);
et_his = zeros(1,max_ite);
% P_his = zeros(M,max_ite);
R_his = zeros(1,max_ite);
    for i=1:max_ite
%         [ite,et,P,R] = batch_ILS_ELRI(reward_param(r),Rt);
%         [ite,et,P,R] = batch_ILS_ELRP(reward_param(r),reward_param(r)/10,Rt);
        [ite,et,P,R] = batch_ILS_EML(Rt);
%         [ite,et,P,R] = batch_ILS_BL(reward_param(r),Rt);
        ite_his(i) = ite;
        et_his(i) = et;
        R_his(:,i) = R';
        fprintf("Iteration (%d) progress: %.2f\n",r,100*i/max_ite);
    end
R_his = 1.58./R_his;
R_ult(r,:) = R_his;
et_ult(r,:) = et_his;
save('result_eml_top3_loc1.mat','R_ult','et_ult','reward_param');
end
D = load('gong');
sound(D.y,D.Fs);