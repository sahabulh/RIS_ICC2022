function t = graph_2Dtop(pat,top1,top2)
font = 24;
if pat == "s"
    d = 125;
    x = [d*ones(1,250) linspace(d,-d,250) -d*ones(1,250) linspace(-d,d,250)];
    y = [linspace(-d,d,250) d*ones(1,250) linspace(d,-d,250) -d*ones(1,250)];
elseif pat == "c"
    d = 150;
    x = d*cos(linspace(0,2*pi,1000));
    y = d*sin(linspace(0,2*pi,1000));
end

figure(1)
t = tiledlayout(1,2,'TileSpacing','Compact','Padding','Compact');

nexttile
data = load(top1);
R = data.R;
B = data.B;

p1 = scatter(R(1,:),R(2,:),200,'bp','filled');
hold on;
scatter(B(1,:),B(2,:),200,'bp','filled');
hold on;
p3 = plot(x,y,'k','lineWidth',3);
hold off;
xlim([-250 250]);
ylim([-250 250]);
title("Topology: 4 BS");
xlabel("X (m)");
ylabel("Y (m)");
legend([p1;p3],["BS","User path"],'Location','northeast');
set(gca,'FontSize',font);

nexttile
data = load(top2);
R = data.R;
B = data.B;

p1 = scatter(R(1,:),R(2,:),200,'rp','filled');
hold on;
p2 = scatter(B(1,:),B(2,:),200,'bp','filled');
hold on;
p3 = plot(x,y,'k','lineWidth',3);
hold off;
xlim([-250 250]);
ylim([-250 250]);
title("Topology: 1 BS 10 RIS");
xlabel("X (m)");
ylabel("Y (m)");
legend([p1;p2;p3],["RIS","BS","User path"],'Location','northeast');
set(gca,'FontSize',font);
end