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
        m.data[:kefunc] = plateKe(p,model)
        m.data[:refunc] = plateRe(p.q)
    elseif model == "kirchhoff_nonconforming"
        nf = 3
        bcs = [true, true, true]
        m.data[:kefunc] = plateKe(p,model)
        m.data[:refunc] = plateRe(p.q)
    elseif model == "hartmann_conforming"
        nf = 4
        bcs = [true, true, true, false]
        m.data[:kefunc] = plateKe(p,model)
        m.data[:refunc] = plateRe(p.q)
    elseif model == "hartmann_nonconforming"
        nf = 3
        bcs = [true, true, true]
        m.data[:kefunc] = plateKe(p,model)
        m.data[:refunc] = plateRe(p.q)
    end

    K,r = assembleKr(m, nf)
    applyDirichletBCs!(m.groups[:boundarynodes], K, r, bcs)
    w = K \ r

	m.data[:post] = postprocessor(p, w)
    return w
end