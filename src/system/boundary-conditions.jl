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