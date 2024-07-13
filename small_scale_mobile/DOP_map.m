data = load('topology3.mat');
R = data.R;
B = data.B;
S = data.S;
M = size(S,1);
map = zeros(100,100);
id = zeros(100,100);
for x = 1:100
    for y = 1:100
        Rt = [5.1*x-250;5.1*y-250;0];
        DOP = zeros(1,M);
        for i = 1:M
            Rr = [B R(:,S(i,:))];
            DOP(i) = calc_GDOP(Rr,Rt);
        end
        [map(x,y),id(x,y)] = min(DOP);
        fprintf("Done: %.3f\n",(100*(x-1)+y)/10000);
    end
end
figure(1)
[C,h] = contourf(5*[1:100]-250,5*[1:100]-250,map',[0 2 3 4 6 8 10]);
clabel(C,h,'FontSize',15,'Color','black')
% colormap('jet')
colorbar
hold on;
k = max(map,[],'all')*ones(1,size(R,2)+1);
scatter3([B(1) R(1,:)],[B(2) R(2,:)],k,200,'rp','filled')
hold off;