function ab(e)
    x1 = coordinates(e, 1)
    x2 = coordinates(e, 2)
    x3 = coordinates(e, 3)
    x4 = coordinates(e, 4)
    a = x2[1] - x1[1]       # Länge in xi-Richtung
    b = x3[2] - x1[2]       # Länge in eta-Richtung
    return a,b
end

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
    end

    K,r = assembleKr(m, nf)
    applyDirichletBCs!(m.groups[:boundarynodes], K, r, bcs)
    w = K \ r

	m.data[:post] = postprocessor(p, w)
    return w
end