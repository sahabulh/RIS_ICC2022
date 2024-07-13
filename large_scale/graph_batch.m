function t = graph_batch(name,lg,cl)
font = 24;
m = size(name,2);
mean_R_ult = zeros(m,10);
mean_et_ult = zeros(m,10);
for i = 1:m
    data = load(name(i));
    mean_R_ult(i,:) = mean(data.R_ult,2)';
    mean_et_ult(i,:) = mean(data.et_ult,2)';
end
data = load(name(1));
reward_param = data.reward_param;
% M = [0.01:0.01:0.1;50:50:500;mean_R_ult];
% writematrix(M',"result_GDOP_All_Elimination.txt");
% M = [0.01:0.01:0.1;50:50:500;mean_et_ult];
% writematrix(M',"result_ET_All_Elimination.txt");

figure(1)
t = tiledlayout(1,2,'TileSpacing','Compact','Padding','Compact');

nexttile
for i = 1:m
    plot(reward_param,mean_R_ult(i,:),cl(i),'lineWidth',4);
    hold on;
end
hold off;
xlim([0.01 0.1])
title("Average GDOP vs Reward parameter");
xlabel("Reward parameter");
ylabel("Average GDOP");
legend(lg,'Location','northwest');
set(gca,'FontSize',font);

nexttile
for i = 1:m
    plot(reward_param,mean_et_ult(i,:),cl(i),'lineWidth',4);
    hold on;
end
hold off;
xlim([0.01 0.1])
title("Average Executon Time (sec) vs Reward parameter");
xlabel("Reward parameter");
ylabel("Average Executon Time (sec)");
legend(lg,'Location','northeast');
set(gca,'FontSize',font);
end