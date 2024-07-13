function t = graph_err_bar(name,lg,cl)
font = 24;
tipfont = 24;
pres = 3;

m = size(name,2);
data = load(name(1));
n = size(data.R_ult,1);
P_ult = zeros(m,n);
P_ult(1,:) = data.P_ult(1,:);
reward_param = data.reward_param;
for i = 2:m
    data = load(name(i));
    P_ult(i,:) = data.P_ult(1,:);
end

figure(1)
t = tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');

nexttile
b = bar(P_ult');
for i = 1:m
    xtips = b(i).XEndPoints;
    ytips = b(i).YEndPoints;
    labels = string(round(b(i).YData,pres));
    text(xtips,ytips,labels,'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',tipfont)
end
ylim([0 0.2+max(P_ult,[],'all')]);
if ~isempty(cl)
    for i = 1:m
        b(i).FaceColor = cl(i);
    end
end
xticklabels(reward_param);
title("Average GDOP vs Reward parameter");
xlabel("Reward parameter");
ylabel("Average GDOP");
legend(lg,'Location','southeast');
set(gca,'FontSize',font);
end