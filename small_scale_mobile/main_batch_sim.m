warning off
max_ite = 1000;
% reward_param = 50:50:500;
% reward_param = [0.01 0.05 0.1];
reward_param = 0.05;
R_ult = zeros(size(reward_param,2),max_ite);
et_ult = zeros(size(reward_param,2),max_ite);
P_ult = zeros(3,size(reward_param,2));

d = 150;

% Circle: d is radius
x = d*cos(linspace(0,2*pi,1000));
y = d*sin(linspace(0,2*pi,1000));

% Square: d is half of sides
% x = [d*ones(1,250) linspace(d,-d,250) -d*ones(1,250) linspace(-d,d,250)];
% y = [linspace(-d,d,250) d*ones(1,250) linspace(d,-d,250) -d*ones(1,250)];

% Triangle with point up: d is center to peak distance
% x = [linspace(d*cos(deg2rad(330)),0,334) linspace(0,d*cos(deg2rad(210)),333) linspace(d*cos(deg2rad(210)),d*cos(deg2rad(330)),333)];
% y = [linspace(d*sin(deg2rad(330)),d,334) linspace(d,d*sin(deg2rad(210)),333) linspace(d*sin(deg2rad(210)),d*sin(deg2rad(330)),333)];
for r = 1:size(reward_param,2)
ite_his = zeros(1,max_ite);
et_his = zeros(1,max_ite);
P_his = zeros(3,max_ite);
R_his = zeros(1,max_ite);
    for i=1:max_ite
        [ite,et,P,R] = batch_ILS_LRI(reward_param(r),[x(i);y(i);0]);
%         [ite,et,P,R] = batch_ILS_ELRP(reward_param(r),reward_param(r)/10);
%         [ite,et,P,R] = batch_ILS_EML();
%         [ite,et,P,R] = batch_ILS_EBL(reward_param(r));
        ite_his(i) = ite;
        et_his(i) = et;
        R_his(:,i) = R';
        P_his(:,i) = P;
        fprintf("Iteration (%d) progress: %.2f\n",r,100*i/max_ite);
    end
R_his = 1.58./R_his;
R_ult(r,:) = R_his;
et_ult(r,:) = et_his;
P_ult(:,r) = mean(abs((P_his-[x;y;zeros(1,1000)])'));
% save('result_elri_top5_sqre2.mat','R_ult','et_ult','P_ult','reward_param');
end
D = load('train');
sound(D.y,D.Fs);