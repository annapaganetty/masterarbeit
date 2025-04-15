function plate(m, p, model::String)
    nf = 0
    bcs = []

    if model == "kirchhoff_conforming"
        nf = 4
        bcs = [true, true, true, false]
        m.data[:kefunc] = pkcKe(p)
        m.data[:refunc] = pkcRe(p.q)
    elseif model == "BTP"
        nf = 3
        bcs = [true, true, true]
        m.data[:kefunc] = plateKe(p)
        m.data[:refunc] = plateRe(p.q)
    end

    K,r = assembleKr(m, nf)
    applyDirichletBCs!(m.groups[:boundarynodes], K, r, bcs)
    w = K \ r

    if model == "BTP"
	    m.data[:post] = postprocessorBTP(p, w)
    else
        m.data[:post] = postprocessor(p, w)
    end

    return w
end