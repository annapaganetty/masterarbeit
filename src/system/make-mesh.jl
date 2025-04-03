# quadratisches Gitter: Seiten eines Elementes sind gleichlang
function makequadratcicMesh(p, nx, ny = nx)
    m = makemeshonrectangle(p.lx, p.ly, nx, ny)
    return m
end

# rechteckiges Gitter: x- und y-Seiten eines Elementes sind unterschiedlich lang
function makerectMesh(p, nx, ny)
    m = makemeshonrectangle(p.lx, p.ly, nx, ny)
    return m
end

# allgemeines viereckiges Gitter: x- und y-Seiten eines Elementes sind unterschiedlich lang, Winkel < und > als 90° möglich

# evtl noch verallgemeinern
function makequadrilateralMesh(p)
    coords = [  0.0 (9/50 * p.lx) (18/25 * p.lx) p.lx 0.0  (9/25 * p.lx) (18/25 * p.lx) p.lx;
                0.0 (2/10 * p.ly) (4/10 * p.ly) 0.0  p.ly (7/10 * p.ly) (7/10 * p.ly) p.ly]
    elts = [[1,2,3,4],[4,3,7,8],[8,7,6,5],[5,6,2,1],[2,3,7,6]]
    m = MMJMesh.Meshes.Mesh(coords, elts, 2)
    return m
end

# Patch-Test-1: 2 x 2 Elemente
function makePTMesh01(p)
    coords = [  0.0 (1/2 * p.lx) p.lx 0.0  (1/2 * p.lx) p.lx 0.0  (1/2 * p.lx) p.lx;
                0.0 0.0 0.0 (1/2 * p.ly) (1/2 * p.ly) (1/2 * p.ly) p.ly p.ly p.ly]
    elts = [[1,2,5,4],[2,3,6,5],[4,5,8,7],[5,6,9,8]]
    m = MMJMesh.Meshes.Mesh(coords, elts, 2)
    return m
end

# Patch-Test-2.1
        # funktioniert für den beide einseitigen Patch-Tests X und Y
function makePTMesh02(p)
    coords = [0.0 (1/2*p.lx) p.lx 0.0 (0.8*1/2*p.lx) p.lx 0.0 (1/2*p.lx) p.lx;
        0.0 0.0 0.0 (1/2*p.ly) (1.3*1/2*p.ly) (1/2*p.ly) p.ly p.ly p.ly]
    elts = [[1, 2, 5, 4], [2, 3, 6, 5], [4, 5, 8, 7], [5, 6, 9, 8]]
    m = MMJMesh.Meshes.Mesh(coords, elts, 2)
    return m
 end
 
 
 
#  Scheint nicht zu funktionieren (w[2:3:end] ist ungleich null)
 
 function makePTMesh03(p)
    coords = [0.0 (1.3*1/2*p.lx) p.lx 0.0 (0.8*1/2*p.lx) p.lx 0.0 (1.1*1/2*p.lx) p.lx;
        0.0 0.0 0.0 (1/2*p.ly) (1.3*1/2*p.ly) (1.3*1/2*p.ly) p.ly p.ly p.ly]
    elts = [[1, 2, 5, 4], [2, 3, 6, 5], [4, 5, 8, 7], [5, 6, 9, 8]]
    m = MMJMesh.Meshes.Mesh(coords, elts, 2)
    return m
 end


# alter Patch Test 02 (s)
# function makePTMesh02(p)
#     coords = [  0.0 (1/2 * p.lx) p.lx 0.0  (1/3 * p.lx) p.lx 0.0  (1/2 * p.lx) p.lx;
#                 0.0 0.0 0.0 (1/2 * p.ly) (2/3 * p.ly) (1/2 * p.ly) p.ly p.ly p.ly]
#     elts = [[1,2,5,4],[2,3,6,5],[4,5,8,7],[5,6,9,8]]
#     m = MMJMesh.Meshes.Mesh(coords, elts, 2)
#     return m
# end