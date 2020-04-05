% create uniform grid for FDTD simulation
datadir = '../data/';
addpath(datadir);
tic
% grid spacing.
h = 1; 
xmin  = -2000;
xmax = 3000;
ymin  = -2000;
ymax = 3000;

% load in topography.
load('Kilauea_DEM_and_lavalakelocation.mat');

% plot summit topography
x_lake= 2.604584249773606e+05;
y_lake= 2.147270125870880e+06;

skip_topo = 1;
x = DEM.x(1:skip_topo:end) - x_lake;
y = DEM.y(1:skip_topo:end) - y_lake;
Z =  DEM.Z(1:skip_topo:end,1:skip_topo:end);

indx = find(x>(xmin-1000) & x <(xmax+1000));
indy = find(y>(ymin-1000) & y <(ymax+1000));
%% resample the topography using ndgrid
Ztopo = Z(indy, indx);
[X,Y] = ndgrid(x(indx), y(indy));
F = griddedInterpolant(X, Y, Ztopo');

xq = xmin:h:xmax;
yq = ymin:h:ymax;

% resampled topography without crater
[Xq,Yq] = meshgrid(xq, yq);
Zq = F(Xq', Yq'); 

% Zq in meshgrid
Zq = Zq';
%% load the convex hull of the crater.
vd = load('VentGeometryData.mat');

figure(1)
for i = 1: length(vd.zs)
    pts = vd.points{i};
    np  = size(pts,1);
    plot3(pts(:, 1)-x_lake,pts(:, 2)-y_lake,pts(:, 3),'.-','markersize',10);
    hold on;
end
hold off

%% crater structured grid for the crater

% xmin = -500;
% ymin = -500;
% 
% xmax = 500;
% ymax = 500;
% 
% xq = xmin:h:xmax;
% yq = ymin:h:ymax;
% [Xq,Yq] = meshgrid(xq, yq);

Vmax = 99999;
ztop  = 1030;
expand_ratio = 1.02;
inhulls = cell(length(vd.zs), 1);
pts_tp = vd.points{end};
inhull_tp = inpolygon(Xq, Yq, pts_tp(:,1) - x_lake, pts_tp(:, 2)-y_lake);

for i = 1: length(vd.zs)
    pts = vd.points{i};
    inhull_i = inpolygon(Xq,Yq, pts(:,1) - x_lake, pts(:, 2)-y_lake);
    region_out  = (1 - inhull_i) * Vmax;
    region_in    = (inhull_i & inhull_tp) * vd.zs(i);
    region_md  =( inhull_i & (~inhull_tp)) * ztop;
    inhulls{i} = region_out + region_in +  region_md;
end

Zq_c1 = inhulls{1};
for i = 2:length(vd.zs)
    Zq_c1 = min(Zq_c1, inhulls{i});
end

Zq_c1 = Zq_c1.*inhull_tp;

% add another layer
inhull_tpp = inpolygon(Xq, Yq, (pts_tp(:,1) - x_lake)*expand_ratio, ...
                                   (pts_tp(:, 2)-y_lake)*expand_ratio);

Zq_crater  = (inhull_tpp & inhull_tp).*Zq_c1 +  (inhull_tpp & ~inhull_tp) * ztop + (~inhull_tpp)*Vmax;

% take min between topography and crater elevation 
% to obtain the final value into FDTD simulator

Zq = min(Zq_crater, Zq);

figure(2)
contour(Xq, Yq, Zq, 30);
xlabel('East (m)');
ylabel('North (m)');
save('FDTDGrid.mat','xq','yq','Zq','h');

toc
