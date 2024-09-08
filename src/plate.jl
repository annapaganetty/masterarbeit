include("fem.jl")

function plate(p, model::String, nx, ny = nx)
    m = makemeshonrectangle(p.lx, p.ly, nx, ny)

    nf = 3
    bcs = [true, true, true]
    m.data[:kefunc] = plateKe(p,model)
    m.data[:refunc] = plateRe(p.q)

    K,r = assembleKr(m, nf)
    # display(K)
    applyDirichletBCs!(m.groups[:boundarynodes], K, r, bcs)
    w = K \ r
	m.data[:post] = postprocessor(p, w)
    return m, w
end