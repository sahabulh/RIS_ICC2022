function t = graph_comp(name,lg,cl)
ref = 2.1309; %loc2
% ref = 2.3677; %loc1
font = 24;
tipfont = 16;
pres = 3;
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
data = load(name(1));
reward_param = data.reward_param;

figure(1)
t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');

nexttile
idx = [1 5 10];
b = bar(mean_R_ult(:,idx)');
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
xticklabels(reward_param(idx));
title("Average GDOP vs Reward parameter");
xlabel("Reward parameter");
ylabel("Average GDOP");
legend(lg,'Location','southeast');
set(gca,'FontSize',font);

nexttile
b = bar(mean_et_ult(:,idx)');
for i = 1:m
    xtips = b(i).XEndPoints;
    ytips = b(i).YEndPoints;
    labels = string(round(b(i).YData,pres));
    text(xtips,ytips,labels,'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',tipfont)
end
if ~isempty(cl)
    for i = 1:m
        b(i).FaceColor = cl(i);
    end
end
xticklabels(reward_param(idx));
title("Average execution time vs Reward parameter");
xlabel("Reward parameter");
ylabel("Average execution time (sec)");
legend(lg,'Location','northeast');
set(gca,'FontSize',font);

nexttile
b = bar(mean_5_ult(:,idx)');
for i = 1:m
    xtips = b(i).XEndPoints;
    ytips = b(i).YEndPoints;
    labels = string(round(b(i).YData,pres));
    text(xtips,ytips,labels,'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',tipfont)
end
ylim([0 110]);
if ~isempty(cl)
if ~isempty(cl)
    for i = 1:m
        b(i).FaceColor = cl(i);
    end
end
xticklabels(reward_param(idx));
title("5{%} error rate vs Reward parameter");
xlabel("Reward parameter");
ylabel("5{%} error rate ({%})");
legend(lg,'Location','northwest');
set(gca,'FontSize',font);

nexttile
b = bar(mean_10_ult(:,idx)');
for i = 1:m
    xtips = b(i).XEndPoints;
    ytips = b(i).YEndPoints;
    labels = string(round(b(i).YData,pres));
    text(xtips,ytips,labels,'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',tipfont)
end
ylim([0 110]);
if ~isempty(cl)
    for i = 1:m
        b(i).FaceColor = cl(i);
    end
end
xticklabels(reward_param(idx));
title("10{%} error rate vs Reward parameter");
xlabel("Reward parameter");
ylabel("10{%} error rate ({%})");
legend(lg,'Location','southeast');
set(gca,'FontSize',font);
% exportgraphics(t,'myplot.png','BackgroundColor','none','Resolution',300)
end