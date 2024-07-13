function t = graph_mob(idx,name,lg,cl)
font = 24;
m = size(name,2);
R_ult = zeros(m,1000);

for i = 1:m
    data = load(name(i));
    R_ult(i,:) = data.R_ult(idx,:);
end

figure(1)
t = tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');

nexttile
p = [];
% M = zeros(1000,7);
% M(:,1) = (1:1000)';
for i = 1:m
    temp = plot(R_ult(i,:),cl(i),'lineWidth',1);
    p=[p;temp];
    hold on;
    plot(mean(R_ult(i,:))*ones(1,1000),cl(i)+'--','lineWidth',4);
%     M(:,2*i) = R_ult(i,:)';
%     M(:,2*i+1) = mean(R_ult(i,:))*ones(1000,1);
    hold on;
end
hold off;
xlabel("Time Index");
ylabel("GDOP");
legend(p,lg,'Location','northeast');
set(gca,'FontSize',font);
% writematrix(M,'small_top3_sqre_mob.txt');
end