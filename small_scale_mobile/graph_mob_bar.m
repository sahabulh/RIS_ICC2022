function t = graph_mob_bar(name,lg,cl)
font = 24;
tipfont = 24;
pres = 3;

m = size(name,2);
data = load(name(1));
n = size(data.R_ult,1);
mean_R_ult = zeros(m,n);
mean_R_ult(1,:) = mean(data.R_ult,2)';
reward_param = data.reward_param;
for i = 2:m
    data = load(name(i));
    mean_R_ult(i,:) = mean(data.R_ult,2)';
end

figure(1)
t = tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');

nexttile
b = bar(mean_R_ult');
writematrix([[0.01;0.05;0.1] mean_R_ult'],'small_top3_circ_bar.txt');
for i = 1:m
    xtips = b(i).XEndPoints;
    ytips = b(i).YEndPoints;
    labels = string(round(b(i).YData,pres));
    text(xtips,ytips,labels,'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',tipfont)
end
ylim([0 0.2+max(mean_R_ult,[],'all')]);
if ~isempty(cl)
    for i = 1:m
        b(i).FaceColor = cl(i);
    end
end
xticklabels(reward_param);
xlabel("Reward Learning Parameter");
ylabel("Average GDOP");
legend(lg,'Location','southeast');
set(gca,'FontSize',font);
end