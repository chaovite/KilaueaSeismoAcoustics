//SetFactory("OpenCASCADE");

// size = 500e3;
size = 500e3;
lc = 10e3;

length = size;
height = size;
zmax = 10e3; //1500;
zmin = -size/2;

Point(newp) = {length/2,height/2,zmax,lc};
Point(newp) = {length/2,height/2,zmin,lc};
Point(newp) = {-length/2,height/2,zmax,lc};
Point(newp) = {-length/2,-height/2,zmax,lc};
Point(newp) = {length/2,-height/2,zmax,lc};
Point(newp) = {length/2,-height/2,zmin,lc};
Point(newp) = {-length/2,height/2,zmin,lc};
Point(newp) = {-length/2,-height/2,zmin,lc};
Line(1) = {3,1};
Line(2) = {3,7};
Line(3) = {7,2};
Line(4) = {2,1};
Line(5) = {1,5};
Line(6) = {5,4};
Line(7) = {4,8};
Line(8) = {8,6};
Line(9) = {6,5};
Line(10) = {6,2};
Line(11) = {3,4};
Line(12) = {8,7};
Line Loop(13) = {-6,-5,-1,11};
Plane Surface(14) = {13};
Line Loop(15) = {4,5,-9,10};
Plane Surface(16) = {15};
Line Loop(17) = {-3,-12,8,10};
Plane Surface(18) = {17};
Line Loop(19) = {7,12,-2,11};
Plane Surface(20) = {19};
Line Loop(21) = {-4,-3,-2,1};
Plane Surface(22) = {21};
Line Loop(23) = {8,9,6,7};
Plane Surface(24) = {23};

Surface Loop(25) = {14,24,-18,22,16,-20};
Volume(26) = {25};
