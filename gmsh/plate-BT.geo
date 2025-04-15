// Gmsh project created on Thu Apr  3 09:57:46 2025
SetFactory("OpenCASCADE");
//+
Point(1) = {0, 0, 0, 1.0};
Point(2) = {8, 0, 0, 1.0};
Point(3) = {0, 4, 0, 1.0};
Point(4) = {0, 8, 0, 1.0};
Point(5) = {8, 8, 0, 1.0};
//+
Line(1) = {1, 3};
Line(2) = {3, 4};
Line(3) = {4, 5};
Line(4) = {5, 2};
Line(5) = {2, 1};
//+
Curve Loop(1) = {2, 3, 4, 5, 1};
//+
Plane Surface(1) = {1};
//+
Transfinite Surface {1} = {1, 4, 5, 2};
Transfinite Curve {1} = 8 Using Progression 1;
Transfinite Curve {2} = 14 Using Progression 1;
Transfinite Curve {3, 4, 5} = 21 Using Progression 1;
//+
Recombine Surface {1};

Save "plate-BT.msh";

