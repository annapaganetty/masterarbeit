# quadratisches Gitter: Seiten eines Elementes sind gleichlang
function quadMesh(p, nx, ny = nx)
    m = makemeshonrectangle(p.lx, p.ly, nx, ny)
    return m
end

# rechteckiges Gitter: x- und y-Seiten eines Elementes sind unterschiedlich lang
function rectMesh(p, nx, ny)
    m = makemeshonrectangle(p.lx, p.ly, nx, ny)
end