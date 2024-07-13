function t = graph_batch_result(name,lg,cl)
% ref = 2.1309; %loc2
ref = 2.3677; %loc1
font = 24;
m = size(name,2);
mean_R_ult = zeros(m,10);
mean_et_ult = zeros(m,10);
mean_5_ult = zeros(m,10);
mean_10_ult = zeros(m,10);
for i = 1:m
    data = load(name(i));
    mean_R_ult(i,:) = mean(data.R_ult,2)';
    mean_et_ult(i,:) = mean(data.et_ult,2)';
    mean_5_ult(i,:) = sum(data.R_ult<=(ref*1.05),2)'/10;
    mean_10_ult(i,:) = sum(data.R_ult<=(ref*1.1),2)'/10;
end
reward_param = data.reward_param;

figure(1)
t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');

nexttile
p1 = plot(0.01:0.01:0.1,mean_R_ult(1,:),cl(1),'lineWidth',4);
hold on;
p2 = plot(0.01:0.01:0.1,mean_R_ult(2,:),cl(2),'lineWidth',4);
hold on;
p5 = plot(0.01:0.01:0.1,mean_R_ult(5,:),cl(5),'lineWidth',4);
hold off;
xlim([0.01 0.1])
ylim([2.3 3.3])
xlabel("Reward parameter ({\lambda})");
set(gca,'FontSize',font);
ax = axes(t);
p3 = plot(100:100:1000,mean_R_ult(3,:),cl(3),'lineWidth',4);
hold on;
p4 = plot(100:100:1000,mean_R_ult(4,:),cl(4),'lineWidth',4);
hold off;
ax.XAxisLocation = 'top';
ax.Color = 'none';
xlim([100 1000])
ylim([2.3 3.3])
xlabel(ax,"Smoothing parameter ({\beta})");
set(gca,'FontSize',font);
% ax2.Color = 'none';
% ax1.Box = 'off';
% ax2.Box = 'off';
ylabel("Average GDOP");
legend([p1 p2 p3 p4 p5],lg,'Location','northwest');

g = nexttile;
p1 = plot(0.01:0.01:0.1,mean_et_ult(1,:),cl(1),'lineWidth',4);
hold on;
p2 = plot(0.01:0.01:0.1,mean_et_ult(2,:),cl(2),'lineWidth',4);
hold on;
p5 = plot(0.01:0.01:0.1,mean_et_ult(5,:),cl(5),'lineWidth',4);
hold off;
xlim([0.01 0.1])
ylim([0 1])
xlabel("Reward parameter ({\lambda})");
set(gca,'FontSize',font);
% ax = axes();
p3 = plot(100:100:1000,mean_et_ult(3,:),cl(3),'lineWidth',4);
hold on;
p4 = plot(100:100:1000,mean_et_ult(4,:),cl(4),'lineWidth',4);
hold off;
ax.XAxisLocation = 'top';
ax.Color = 'none';
xlim([100 1000])
ylim([0 1])
xlabel(ax,"Smoothing parameter ({\beta})");
set(gca,'FontSize',font);
% ax2.Color = 'none';
% ax1.Box = 'off';
% ax2.Box = 'off';
ylabel("Average Execution Time (sec)");
% legend([p1 p2 p3 p4 p5],lg,'Location','northwest');


nexttile
for i = 1:m
    plot(reward_param,mean_5_ult(i,:),cl(i),'lineWidth',4);
    hold on;
end
hold off;
xlim([0.01 0.1])
title("5{%} error rate vs Reward parameter");
xlabel("Reward parameter");
ylabel("5{%} error rate ({%})");
legend(lg,'Location','northeast');
set(gca,'FontSize',font);

nexttile
for i = 1:m
    plot(reward_param,mean_10_ult(i,:),cl(i),'lineWidth',4);
    hold on;
end
hold off;
xlim([0.01 0.1])
title("10{%} error rate vs Reward parameter");
xlabel("Reward parameter");
ylabel("10{%} error rate ({%})");
legend(lg,'Location','northeast');
set(gca,'FontSize',font);
% exportgraphics(t,'myplot.png','BackgroundColor','none','Resolution',300)
end