// Gmsh project created on Thu Apr  3 10:39:26 2025
SetFactory("OpenCASCADE");

Rectangle(1) = {0, 0, 0, 8, 8, 0};
//+
Transfinite Surface {1} = {4, 3, 2, 1};
//+
MeshSize{:} =0.2;
Recombine Surface {1};
