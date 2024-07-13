function t = graph_ET(name,lg,cl)
font = 24;
m = size(name,2);
mean_et_ult = zeros(m,10);
for i = 1:m
    data = load(name(i));
    mean_et_ult(i,:) = mean(data.et_ult,2)';
end
data = load(name(1));
reward_param = data.reward_param;
% M = [0.01:0.01:0.1;50:50:500;mean_et_ult];
% writematrix(M',"large_top3_ET_N.txt");

figure(1)
t = tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');

nexttile
for i = 1:m
    plot(reward_param,mean_et_ult(i,:),cl(i),'lineWidth',4);
    hold on;
end
hold off;
xlim([0.01 0.1])
xlabel("Reward Learning Parameter");
ylabel("Average Execution Time (sec)");
legend(lg,'Location','northeast');
set(gca,'FontSize',font);
end