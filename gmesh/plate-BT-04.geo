// Gmsh project created on Fri Apr 11 15:07:36 2025
SetFactory("OpenCASCADE");
//+
Point(1) = {0, 0, 0, 1.0};
Point(2) = {8, 0, 0, 1.0};
Point(3) = {8, 8, 0, 1.0};
Point(4) = {0, 8, 0, 1.0};
Point(5) = {0, 4, 0, 1.0};
//+
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 1};
//+
Curve Loop(1) = {3, 4, 5, 1, 2};
Plane Surface(1) = {1};

Transfinite Surface {1} = {1, 2, 3, 4};
Transfinite Curve {3, 2, 1} = 21 Using Progression 1;
Transfinite Curve {4} = 14 Using Progression 1;
Transfinite Curve {5} = 8 Using Progression 1;
//+
Recombine Surface {1};
Mesh 4;
Save "plate-BT-04.msh";
