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
function makequadrilateralMesh(p, nx, ny)
    coords = [  0.0 (2/10 * p.lx) (8/10 * p.lx) p.lx 0.0  (3/10 * p.lx) (7/10 * p.lx) p.lx;
                0.0 (4/10 * p.ly) (2/10 * p.ly) 0.0  p.ly (7/10 * p.ly) (8/10 * p.ly) p.ly]
    elts = [[1,2,3,4],[4,3,7,8],[8,7,6,5],[5,6,2,1],[2,3,7,6]]
    m = MMJMesh.Meshes.Mesh(coords, elts, 2)
    return m
end