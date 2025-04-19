// Gmsh project created on Sat Mar  1 13:10:46 2025
SetFactory("OpenCASCADE");
//+
Point(1) = {0, 0, 0, 1.0};
Point(2) = {0.5, 0, 0, 1.0};
Point(3) = {0, 1, 0, 1.0};
Point(4) = {0.5, 1, 0, 1.0};
Point(5) = {0.5, 0.3, 0, 1.0};
Point(6) = {0.75, 0.3, 0, 1.0};
Point(7) = {0.5, 0.9, 0, 1.0};
Point(8) = {0.75, 0.9, 0, 1.0};
Point(9) = {0.75, 0, 0, 1.0};
Point(10) = {1.25, 0, 0, 1.0};
Point(11) = {0.75, 1, 0, 1.0};
Point(12) = {1.25, 1, 0, 1.0};
//+
Line(1) = {1, 2};
Line(2) = {2, 5};
Line(3) = {5, 6};
Line(4) = {6, 9};
Line(5) = {9, 10};
Line(6) = {10, 12};
Line(7) = {12, 11};
Line(8) = {11, 8};
Line(9) = {8, 7};
Line(10) = {7, 4};
Line(11) = {4, 3};
Line(12) = {3, 1};
Line(13) = {7, 5};
Line(14) = {8, 6};
//+
Curve Loop(2) = {12, 1, 2, -13, 10, 11};
Plane Surface(1) = {2};
Curve Loop(3) = {13, 3, -14, 9};
Plane Surface(2) = {3};
Curve Loop(4) = {14, 4, 5, 6, 7, 8};
Plane Surface(3) = {4};
//+
Transfinite Surface {1} = {1, 2, 4, 3};
Transfinite Surface {2} = {5, 6, 8, 7};
Transfinite Surface {3} = {9, 10, 12, 11};
//+
Transfinite Curve {12, 6} = 21 Using Progression 1;
Transfinite Curve {1, 5, 7, 11} = 11 Using Progression 1;
Transfinite Curve {9, 3} = 6 Using Progression 1;
Transfinite Curve {2, 4} = 7 Using Progression 1;
Transfinite Curve {10, 8} = 3 Using Progression 1;
Transfinite Curve {13, 14} = 13 Using Progression 1;
//+
Recombine Surface {1};
Recombine Surface {2};
Recombine Surface {3};
Coherence;
Mesh 2;
//+
Save "complex-plate-02.msh";
