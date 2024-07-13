function t = graph_GDOP(name,lg,cl)
font = 24;
m = size(name,2);
mean_R_ult = zeros(m,10);
for i = 1:m
    data = load(name(i));
    mean_R_ult(i,:) = mean(data.R_ult,2)';
end
data = load(name(1));
reward_param = data.reward_param;
% M = [0.01:0.01:0.1;50:50:500;mean_R_ult];
% writematrix(M',"large_top3_GDOP_E.txt");

figure(1)
t = tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');

nexttile
for i = 1:m
    plot(reward_param,mean_R_ult(i,:),cl(i),'lineWidth',4);
    hold on;
end
hold off;
xlim([0.01 0.1])
xlabel("Reward Learning Parameter");
ylabel("Average GDOP");
legend(lg,'Location','northwest');
set(gca,'FontSize',font);
end