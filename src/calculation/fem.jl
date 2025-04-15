function assembleKr(s, nf)
    N = nnodes(s) * nf
    K = zeros(N, N)
    r = zeros(N)

    for e ∈ elements(s)
        # Indexvektor
        I = idxDOFs(nodeindices(e),nf)

        # Berechnung ke für Element + Addition ke globale Steifigkeitsmatrix K
        kef = data(e, :kefunc)
        K[I, I] += kef(e)

        # Berechnung re für Elemente + Addition re globalen Lastvektor
        ref = data(e, :refunc)
        r[I] += ref(e)
    end
    return K, r
end

idxDOFs(nodes::AbstractVector{<:Integer}, nf::Integer) = collect(reshape([(i - 1) * nf + j for i = nodes, j = 1:nf]', :))

function fixedDOFs(fixedNodes, fixed)
    cnt = 1
    nff = sum(fixed)        # summe (true = 1; false = 0)
    nf = length(fixed)      # länge vektor 
    idxs = zeros(Int, nff * length(fixedNodes))

    for i = fixedNodes, j = 1:nf
        if fixed[j]
            idxs[cnt] = (i - 1) * nf + j
            cnt = cnt + 1
        end
    end
    return idxs
end

function applyDirichletBCs!(fixedNodes, K, r, fixed = [true])
    dofs = fixedDOFs(fixedNodes,fixed)
    r[dofs] .= 0
    K[dofs, :] .= 0
    K[diagind(K)[dofs]] .= 1
    return nothing 
end