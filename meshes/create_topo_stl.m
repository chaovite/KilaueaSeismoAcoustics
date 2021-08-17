%%
addpath('matlab_helper');

grid_size = 10;
skip         = round(grid_size/10);
z_min      = 1050;
xy_max   =  4000;
z_remote = 1100;
taper_ratio = 0.4;
xy_min    = -xy_max;
Lbox       = 500e3;
filename  =  sprintf('../data/topo_stl_zmin_%d_zremote_%d_space_%d_limit_%d_taper_ratio_%.2f_Lbox_%d.stl', z_min, z_remote, grid_size, xy_max,taper_ratio, Lbox);

% load the data
load('../data/Kilauea_DEM_and_lavalakelocation.mat');
%% lake location
x_lake= 2.604584249773606e+05;
y_lake= 2.147270125870880e+06;
%% downsample
X = DEM.x(1:skip:end) - x_lake;
Y = DEM.y(1:skip:end) - y_lake;
Z = DEM.Z(1:skip:end, 1:skip:end);
Z(Z<z_min & sqrt(X'.^2 + (Y).^2)<1500) = z_min;

% select mesh region
indx = X>=xy_min & X<=xy_max;
indy = Y>=xy_min & Y<=xy_max;

X = X(indx);
Y = Y(indy);
Z = Z(indy, indx);

% contour(X,Y, Z,50);
% daspect([1,1,1]);

% taper the remote Z.
weights      = tukeywin(size(Z,1),0.2)*(tukeywin(size(Z,2),0.2))';
Z       =   (Z - z_remote).*weights + z_remote;
contour(X,Y, Z, 50);
[Xg, Yg]=meshgrid(X,Y);

% append points for remote boundary;
Xg = Xg(:);
Yg = Yg(:);
Z   = Z(:);

Z   = [Z; ones(4, 1)*z_remote];
Xg  = [Xg; [-Lbox/2 -Lbox/2 Lbox/2 Lbox/2]'];
Yg  = [Yg; [Lbox/2 -Lbox/2 -Lbox/2 Lbox/2]'];
    
daspect([1,1,1]);
% write X,Y,Z
stlwrite(filename, Xg, Yg, Z);