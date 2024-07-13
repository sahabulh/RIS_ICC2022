function t = graph_top(top1)
font = 24;

figure(1)
t = tiledlayout(1,2,'TileSpacing','Compact','Padding','Compact');

nexttile
data = load(top1);
R = data.R;
B = data.B;

p1 = scatter(R(1,:),R(2,:),400,'rp','filled');
hold on;
p2 = scatter(B(1,:),B(2,:),400,'bp','filled');
hold off;
xlim([-250 250]);
ylim([-250 250]);
title("Topology: 4 BS 20 RIS");
xlabel("X (m)");
ylabel("Y (m)");
legend([p1;p2],["RIS","BS"],'Location','northeast');
set(gca,'FontSize',font);

nexttile
data = load(top1);
R = data.R;
B = data.B;

p1 = scatter3(R(1,:),R(2,:),R(3,:),400,'rp','filled');
hold on;
p2 = scatter3(B(1,:),B(2,:),B(3,:),400,'bp','filled');
hold off;
xlim([-250 250]);
ylim([-250 250]);
title("Topology: 4 BS 20 RIS");
xlabel("X (m)");
ylabel("Y (m)");
zlabel("Z (m)");
legend([p1;p2],["RIS","BS"],'Location','northeast');
set(gca,'FontSize',font);
end