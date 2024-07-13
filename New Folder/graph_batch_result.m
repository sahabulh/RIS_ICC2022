function [] = graph_batch_result(name)
m = size(name,2);
mean_R_ult = zeros(m,10);
mean_et_ult = zeros(m,10);
mean_5_ult = zeros(m,10);
mean_10_ult = zeros(m,10);
for i = 1:m
    data = load(name(i));
    mean_R_ult(i,:) = mean(data.R_ult,2)';
    mean_et_ult(i,:) = mean(data.et_ult,2)';
    mean_5_ult(i,:) = sum(data.R_ult<=1.6443*1.05,2)'/10;
    mean_10_ult(i,:) = sum(data.R_ult<=1.6443*1.10,2)'/10;
end
reward_param = data.reward_param;
figure(1)
subplot(2,2,1)
for i = 1:m
    plot(reward_param,mean_R_ult(i,:),'lineWidth',2);
    hold on;
end
hold off;
xlim([0.01 0.1])
title("Average reward vs Reward parameter");
xlabel("Reward parameter");
ylabel("Average reward");
set(gca,'FontSize',16);
subplot(2,2,2)
for i = 1:m
    plot(reward_param,mean_et_ult(i,:),'lineWidth',2);
    hold on;
end
hold off;
xlim([0.01 0.1])
title("Average execution time vs Reward parameter");
xlabel("Reward parameter");
ylabel("Average execution time (sec)");
set(gca,'FontSize',16);
subplot(2,2,3)
for i = 1:m
    plot(reward_param,mean_5_ult(i,:),'lineWidth',2);
    hold on;
end
hold off;
xlim([0.01 0.1])
title("5{%} error rate vs Reward parameter");
xlabel("Reward parameter");
ylabel("5{%} error rate ({%})");
set(gca,'FontSize',16);
subplot(2,2,4)
for i = 1:m
    plot(reward_param,mean_10_ult(i,:),'lineWidth',2);
    hold on;
end
hold off;
xlim([0.01 0.1])
title("10{%} error rate vs Reward parameter");
xlabel("Reward parameter");
ylabel("10{%} error rate ({%})");
set(gca,'FontSize',16);
end