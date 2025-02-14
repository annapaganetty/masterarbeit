function plate(m, p, model::String)
    nf = 0
    bcs = []

    if model == "kirchhoff_conforming"
        nf = 4
        bcs = [true, true, true, false]
        m.data[:kefunc] = pkcKe(p)
        m.data[:refunc] = pkcRe(p.q)
    elseif model == "kirchhoff_nonconforming"
        nf = 3
        bcs = [true, true, true]
        m.data[:kefunc] = pknKe(p)
        m.data[:refunc] = pknRe(p.q)
    elseif model == "hartmann5.2_conforming"
        nf = 4
        bcs = [true, true, true, false]
        m.data[:kefunc] = phcKe(p)
        m.data[:refunc] = phcRe(p.q)
    elseif model == "hartmann5.2_nonconforming"
        nf = 3
        bcs = [true, true, true]
        m.data[:kefunc] = phnKe(p)
        m.data[:refunc] = phnRe(p.q)
    elseif model == "BTP"
        nf = 3
        bcs = [true, true, true]
        m.data[:kefunc] = plateKe(p)
        m.data[:refunc] = plateRe(p.q)
    end

    K,r = assembleKr(m, nf)
    applyDirichletBCs!(m.groups[:boundarynodes], K, r, bcs)
    w = K \ r

	m.data[:post] = postprocessor(p, w)
    return w
end