function t = graph_3Dtop(pat,top1,top2)
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

p1 = scatter3(R(1,:),R(2,:),R(3,:),400,'bp','filled');
hold on;
scatter3(B(1,:),B(2,:),B(3,:),400,'bp','filled');
hold on;
p3 = plot(x,y,'k','lineWidth',3);
hold off;
title("Topology: 4 BS");
xlabel("X (m)");
ylabel("Y (m)");
zlabel("Z (m)");
legend([p1;p3],["BS","User path"],'Location','northeast');
set(gca,'FontSize',font);

nexttile
data = load(top2);
R = data.R;
B = data.B;

p1 = scatter3(R(1,:),R(2,:),R(3,:),400,'rp','filled');
hold on;
p2 = scatter3(B(1,:),B(2,:),B(3,:),400,'bp','filled');
hold on;
p3 = plot(x,y,'k','lineWidth',3);
hold off;
title("Topology: 1 BS 10 RIS");
xlabel("X (m)");
ylabel("Y (m)");
zlabel("Z (m)");
legend([p1;p2;p3],["RIS","BS","User path"],'Location','northeast');
set(gca,'FontSize',font);
end