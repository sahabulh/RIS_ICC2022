data = load('topology.mat');
R = data.R;
B = data.B;
S = data.S;
scatter3(R(1,:),R(2,:),R(3,:),200,'rp','filled')
hold on
scatter3(B(1),B(2),B(3),200,'bp','filled')
hold off