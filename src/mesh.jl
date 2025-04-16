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

# Patch Test Gitter
function makequadrilateralMesh(p)
    coords = [  0.0 (9/50 * p.lx) (18/25 * p.lx) p.lx 0.0  (9/25 * p.lx) (18/25 * p.lx) p.lx;
                0.0 (2/10 * p.ly) (4/10 * p.ly) 0.0  p.ly (7/10 * p.ly) (7/10 * p.ly) p.ly]
    elts = [[1,4,3,2],[3,4,8,7],[6,7,8,5],[1,2,6,5],[2,3,7,6]]
    m = MMJMesh.Meshes.Mesh(coords, elts, 2)
    return m
end