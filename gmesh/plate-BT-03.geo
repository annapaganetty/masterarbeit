// Gmsh project created on Thu Apr  3 11:02:43 2025
SetFactory("OpenCASCADE");
//+
Rectangle(1) = {0, 0, 0, 8, 8, 0};

MeshSize{:} = 0.5;
Mesh 3;
