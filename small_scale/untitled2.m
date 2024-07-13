x1 = 0:0.1:40;
y1 = 4.*cos(x1)./(x1+2);
x2 = 1:0.2:20;
y2 = x2.^2./x2.^3;

figure(1)
p1 = plot(x1,y1,'-r');
ylim([min(min(y1),min(y2)) max(max(y1),max(y2))])
hAx(1)=gca;
hAx(1).Box = 'off';
hAx(2)=axes('Position',hAx(1).Position,'XAxisLocation','top','YAxisLocation','left','Color','none','Box','off');
hold(hAx(2),'on')
p2 = plot(x2,y2,'-k');
ylim([min(min(y1),min(y2)) max(max(y1),max(y2))]);
legend([p1;p2],["f";"g"])