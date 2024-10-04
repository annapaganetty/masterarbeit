function assembleKr(s,nf)
    N = nnodes(s) * nf
    K = zeros(N, N)
    r = zeros(N)
    
    for e ∈ elements(s)
        # Indexvektor
        nI = nodeindices(e)
        I = fill(1,nf*4)      # Vektor (mit 1 gefüllt)
        for i = 1:nf 
            I[i + 0 * nf] = nI[1] * nf - nf + i 
            I[i + 1 * nf] = nI[2] * nf - nf + i
            I[i + 2 * nf] = nI[3] * nf - nf + i
            I[i + 3 * nf] = nI[4] * nf - nf + i
        end
        # Berechnung ke für jedes Element
        kef = e.data[:kefunc]
        Ke = kef(e)
        # Addition von ke auf die globale Steifigkeitsmatrix K
        K[I, I] += Ke

        # Berechnung re für jedes Element
        ref = e.data[:refunc]
        re = ref(e)
        # Addition von re auf den globalen Lastvektor
        r[I] += re
    end
    return   K ,r
end

idxDOFs(nodes::AbstractVector{<:Integer}, nf::Integer) = collect(reshape([(i - 1) * nf + j for i = nodes, j = 1:nf]', :))

function fixedDOFs(fixedNodes, fixed)
    nf = 3
    d = idxDOFs(fixedNodes,nf)
    return d
end

function applyDirichletBCs!(fixedNodes, K, r, fixed = [true])
    dofs = fixedDOFs(fixedNodes,fixed)
    r[dofs] .= 0
    K[dofs, :] .= 0
    K[diagind(K)[dofs]] .= 1
    return nothing 
end