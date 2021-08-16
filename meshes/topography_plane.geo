lc = 10;

// xmin = -9983.482789544796;
// xmax = 15443.977492558566;
// ymin = -12155.990126644727;
// ymax = 10576.767193291802;

xmin = -1500;
ymin = xmin;
xmax = 1500;
ymax = xmax;



Point(1) = { xmin, ymin, 0.0, lc};
Point(2) = { xmin, ymax, 0.0, lc};
Point(3) = { xmax, ymax, 0.0, lc};
Point(4) = { xmax, ymin, 0.0, lc};

Line(1) = {1,2}; Line(2) = {2,3}; Line(3) = {3,4}; Line(4) = {4,1}; 

Line Loop(1) = {1, 2, 3, 4};
Plane Surface(1) = {1};
