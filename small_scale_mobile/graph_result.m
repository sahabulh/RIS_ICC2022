function [] = graph_result(name)
ref = 1.7844; %loc1
data = load(name);
R_ult = data.R_ult;
et_ult = data.et_ult;
reward_param = data.reward_param;
figure(1)
subplot(2,2,1)
plot(reward_param,mean(R_ult,2),'b','lineWidth',2);
xlim([0.01 0.1])
title("Average GDOP vs Reward parameter");
xlabel("Reward parameter");
ylabel("Average GDOP");
set(gca,'FontSize',16);
subplot(2,2,2)
plot(reward_param,mean(et_ult,2),'b','lineWidth',2);
xlim([0.01 0.1])
title("Average execution time vs Reward parameter");
xlabel("Reward parameter");
ylabel("Average execution time (sec)");
set(gca,'FontSize',16);
subplot(2,2,3)
plot(reward_param,sum(R_ult<=ref*1.05,2)/100,'b','lineWidth',2);
xlim([0.01 0.1])
title("5{%} error rate vs Reward parameter");
xlabel("Reward parameter");
ylabel("5{%} error rate ({%})");
set(gca,'FontSize',16);
subplot(2,2,4)
plot(reward_param,sum(R_ult<=ref*1.1,2)/100,'b','lineWidth',2);
xlim([0.01 0.1])
title("10{%} error rate vs Reward parameter");
xlabel("Reward parameter");
ylabel("10{%} error rate ({%})");
set(gca,'FontSize',16);