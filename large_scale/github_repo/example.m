% Luke Plausin 2015
%
% This is an example to show you how to use the axisxx and axisyy classes

% Example: Multiple axis
% Create the figure, and some test functions...
close all;

figure(1); clf;
x = 0:.1:4*pi;
plot(x, sin(x));
xlabel('X1 Angle');
ylabel('Y1 Sin(x)');

radii = mod(1:11,2) + 1;
angles = linspace(0,2*pi,11) + pi/2;
star_xpts = real(radii.*exp(i*angles));
star_ypts = imag(radii.*exp(i*angles));

angles = linspace(0,2*pi,150);
circ_xpts = real(exp(i*angles));
circ_ypts = imag(exp(i*angles));

h_ax = gca;
% To plot something on a second Y axis, use the function axisyy. It takes 
% any arguments that plot(...) does, and will return a handle to the 
% additional axis object which is created.

Y2 = axisyy(x, 3*cos(x), 'r-');

% To change properties of the additional axis, you can set properties of
% the axis object. The lineseries and axis object can be manipulated
% through the h_axis and h_axis_line properties. Whenever you change YData,
% limits or anything else the axis will be reset for you.

% Example - change ydata of new line object
set(Y2.h_axis, 'YLim', [-4 4]);
set(Y2.h_axis_line, 'YData', 3*cos(x) + 1);

% A shortcut to YLabel are provided directly through the addaxis object
Y2.YLabel = 'Y2 (Multiple Lines)';

% You can draw multiple lines on the same second axis by calling the
% plot method on the returned object.
Y2.plot(x, -(3*cos(x)+1), 'r-');

% You can also add plots which share the Y axis with the main plot. XLim
% and XLabel can be input as arguments to the addaxis function
X2 = axisxx(circ_xpts, circ_ypts, 'm-', 'XLim', [-1 1], 'XLabel', 'X2 (Circle)');

% You can have as many axes as you want in your plot. You can also use any
% function you want to plot. Here we will create a third Y axis containing
% a patch object
X3 = axisxx('PlotFcn', @patch, star_xpts/2, star_ypts/2, 'k-', 'FaceColor', 'y', 'LineWidth', 3, ...
    'FaceAlpha', 0.3, 'XLim', [-1 1], 'XLabel', 'X3 (Patch Star)');
set(X3.h_axis, 'xcolor', [0 0 1]);

% The resize configuration also supports colorbars. You may need to force a
% resize for it to display nicely
h_cb = colorbar;
ylabel(h_cb, 'Colorbar compatible!');
addaxis.resizeParentAxis(h_ax);

% If you want to remove one of your axis, just delete the object.
%          delete(Y2);

% This package is compatiable with the Zoom, Pan and datatip utilities.
% Have a go!

%% Example 2: Using different scales
figure(2); clf;

x = linspace(0, 10, 100);
plot(x, sin(x));
xlabel('X');
ylabel('Y1 Sin(x)');

x = 0:10;
Y_Log = axisyy(x, 10.^x, 'go-', 'PlotFcn', @semilogy);
Y_Reverse = axisyy(x, x, '--m');
set(Y_Reverse.h_axis, 'YDir', 'reverse');
x = 1:9;
Y_EB = axisyy('PlotFcn', @errorbar, x, zeros(size(x)), 0.05 * x, 'c-');
xlim([0, 10]);

legend({'Linear Scale', 'Log Scale', 'Reverse Dir. Scale', 'Error Bars'}, 'Location', 'best');
title('Unusual scales example');

%% Example 3: Subplots with or without the GUI layout toolbox.
% You may like to look at this package
% http://uk.mathworks.com/matlabcentral/fileexchange/47982-gui-layout-toolbox

figure(3); clf;
BT = {}; % Use BT = {'BorderType', 'none'}; if you don't like the panel borders!

GLT = exist('uiextras.Grid');
if GLT % If you have the GUI layout toolbox installed...
    UIGrid = uiextras.Grid('Parent', gcf);
    % We must use the MATLAB uipanel to contain an addaxis plot, otherwise axis
    % placement code is broken by the GLT.
    Panel1 = uipanel('Parent', UIGrid, 'Title', 'Axis 1', BT{:});
    Panel2 = uipanel('Parent', UIGrid, 'Title', 'Axis 2', BT{:});
    UIGrid.ColumnSizes = [-1 -1];
else % Otherwise you can use normalised units (rubbish)
    Panel1 = uipanel('Parent', gcf, 'Title', 'Axis 1', BT{:});
    Panel2 = uipanel('Parent', gcf, 'Title', 'Axis 2', BT{:});
    set(Panel1, 'Position', [0 0 0.5 1], 'Units', 'normalized');
    set(Panel2, 'Position', [0.5 0 0.5 1], 'Units', 'normalized');
end

ax1 = axes('Parent', Panel1);
ax2 = axes('Parent', Panel2);

axes(ax1);
x = linspace(0, 2*pi, 100);
plot(x, sin(x));
xlabel('x (radians)');
ylabel('Y1 Sin(x)');
yy = axisyy(x, 180 * x / pi, 'r-');
yy.YLabel = 'x (deg)';
legend('Sin(x)', 'x (deg)');
title('X = radians');

axes(ax2);
x = linspace(0, 360, 100);
plot(x, sin(x*pi/180));
xlabel('X');
ylabel('Y1 Sin(x)');
yy = axisyy(x, pi * x / 180, 'r-');
yy.YLabel = 'x (rad)';
legend('Sin(x)', 'x (rad)');
title('X = degrees');

%% To come in the next update.
% XY axis (lineseries with both axis different)
% 3D plots???

% Put title at the top of multiple x axis?
% Add title, labels to autoresize listeners?

% Change zoom / pan / datatip callbacks to accomodate other packages


