// Gmsh project created on Sat Apr 12 13:01:48 2025
SetFactory("OpenCASCADE");
//+
Point(1) = {0, 0, 0, 1.0};
Point(2) = {31, 0, 0, 1.0};
Point(3) = {31, -7, 0, 1.0};
Point(4) = {16.5, -7, 0, 1.0};
Point(5) = {0, -9, 0, 1.0};
Point(6) = {11, -9, 0, 1.0};
Point(7) = {27, -17, 0, 1.0};
Point(8) = {23.385, -20.795, 0, 1.0};
Point(9) = {26, -7, 0, 1.0};
Point(10) = {22, -7, 0, 1.0};
Point(11) = {23.37963268, -13.55138567, 0, 1.0};
Point(12) = {20.48294524, -10.79290749, 0, 1.0};
Point(13) = {22, 0, 0, 1.0};
Point(14) = {16.86745325, -14.58842411, 0, 1.0};
Point(15) = {0, -4, 0, 1.0};
Point(16) = {5, -9, 0, 1.0};
Point(17) = {11, -7, 0, 1.0};
Point(18) = {11, 0, 0, 1.0};
//+
Line(2) = {2, 3};
Line(4) = {8, 7};
Line(5) = {11, 12};
Line(6) = {12, 10};
Line(7) = {9, 10};
Line(8) = {11, 7};
Line(9) = {10, 13};
Line(10) = {9, 3};
Line(11) = {8, 14};
Line(12) = {14, 6};
Line(13) = {14, 12};
Line(14) = {13, 2};
Line(15) = {1, 18};
Line(18) = {1, 15};
Line(19) = {15, 5};
Line(20) = {5, 16};
Line(21) = {16, 6};
//+
Circle(16) = {3, 4, 7};
Circle(17) = {9, 4, 11};
//+

Curve Loop(2) = {9, 14, 2, -10, 7};
Plane Surface(2) = {2};
Curve Loop(3) = {17, 8, -16, -10};
Plane Surface(3) = {3};
Curve Loop(4) = {5, -13, -11, 4, -8};
Plane Surface(4) = {4};
//+

Transfinite Surface {2} = {10, 3, 2, 13};
Transfinite Surface {3} = {11, 7, 3, 9};
Transfinite Surface {4} = {14, 8, 7, 12};
//+
Transfinite Curve {16, 17} = 25 Using Progression 1;
Recombine Surface {2, 3, 4};
//+
Physical Curve("fixed", 22) = {18, 15, 14, 2, 16, 17, 4, 11, 12, 21};
Physical Curve("free", 23) = {19, 20, 6, 5, 7};
Coherence;

MeshSize{:} = 0.5;
Mesh 6;

Save "plate-Bsp.msh";

//+

//+
Line(22) = {18, 13};
//+
Line(23) = {6, 17};
//+
Line(24) = {17, 18};
//+
Line(25) = {17, 10};
