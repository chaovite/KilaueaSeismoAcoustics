% plot_topo_crater
clear all;
close all;

% load the summit DEM
load('../data/Kilauea_DEM_and_lavalakelocation.mat');

% load the point clouds for the crater.
craterfile = '../data/CraterGeometry_9May2018.txt';
d = csvread(craterfile,1,0);

% load station locations
load('../data/stations_loc_all.mat');
%% plots
x_lake= 2.604584249773606e+05;
y_lake= 2.147270125870880e+06;

skip_topo = 1;
x = DEM.x(1:skip_topo:end) - x_lake;
y = DEM.y(1:skip_topo:end) - y_lake;
Z =  DEM.Z(1:skip_topo:end,1:skip_topo:end);

indx = find(x>-5000 & x < 5000);
indy = find(y>-5000 & y < 5000);

[X,Y] = meshgrid(x(indx), y(indy));

C=contour(X, Y, Z(indy, indx),30);
% clabel(C)
alpha 0.1

colormap(gray);

hold on;
skip_c = 500;
xc  = d(1:skip_c:end, 1) - x_lake;
yc  = d(1:skip_c:end, 2) - y_lake;
zc = d(1:skip_c:end, 3);

ind = zc<1030;
xc  = xc(ind);
yc  = yc(ind);
zc  = zc(ind);

plot3(xc, yc, zc,'.','color','c');
colormap(gray);

plot3(locations(:, 1), locations(:, 2), locations(:, 3),'.','color','b','markersize',30);
hold off;

xlim([-1, 1]*5000);
ylim([-1, 1]*5000);

xlabel('East (m)');
ylabel('North (m)');
zlabel('Elevation (m)');
set(gca,'fontsize',14);

daspect([1,1,0.5]);
legend({'topography','crater point cloud','stations'},'location','west');
shg