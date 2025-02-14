@variables  j11,j12,j21,j22,d, h, ν,E,l₁₂,l₂₃,l₃₄,l₄₁,S₅,S₆,S₇,S₈,C₅,C₆,C₇,C₈ ;

function generateKeBTP()
    Hx = btpHx()
    Hy = btpHy()

    ∂ξ(u) = ∂x(u)
    ∂η(u) = ∂y(u)

    Be1(u) =  j11 * ∂ξ(u) + j12 * ∂η(u)
    Be2(v) =  j21 * ∂ξ(v) + j22 * ∂η(v)
    Be3(u,v) =  j11 * ∂ξ(v) + j12 * ∂η(v) + j21 * ∂ξ(u) + j22 * ∂η(u)
    BeN(u,v) = [Be1(u) Be2(v) Be3(u,v)]
    BeN2(u,v) = [Be1(u) + ν * Be2(v), ν * Be1(u) + Be2(v), (1- ν)/2 * Be3(u,v)]

    ae(u,v) = integrate(BeN(u,v)⋅BeN(u,v), (-1 .. 1) , (-1 .. 1))
    Ke = (simplifyx.([ae(n1, n2) for n1 ∈ Hx, n2 ∈ Hy]))    

    # D = E*h^3 / 12*(1-ν^2)

    # ae(u,v) = integrate(BeN(u,v) ⋅ BeN2(u,v), (-1 .. 1) , (-1 .. 1))
    # Ke = (simplifyx.(D*d*[ae(n1, n2) for n1 ∈ HxFinal, n2 ∈ hy]))
    return HxFinal
end


function weakformKeBTP(hx,hy)
    # Jacobi-Matrix 
    # j11,j12,j21,j22,d = jacobianMatrix(e)
    D = E*h^3 / 12*(1-ν^2)

    ∂ξ(u) = ∂x(u)
    ∂η(u) = ∂y(u)

    Be1(u) =  j11 * ∂ξ(u) + j12 * ∂η(u)
    Be2(v) =  j21 * ∂ξ(v) + j22 * ∂η(v)
    Be3(u,v) =  j11 * ∂ξ(v) + j12 * ∂η(v) + j21 * ∂ξ(u) + j22 * ∂η(u)
    BeN(u,v) = [Be1(u); Be2(v); Be3(u,v)]
    BeN2(u,v) = [Be1(u) + ν * Be2(v); ν * Be1(u) + Be2(v); (1- ν)/2 * Be3(u,v)]

    ae(u,v) = integrate(BeN(u,v) ⋅ BeN2(u,v), (-1 .. 1) , (-1 .. 1))
    Ke = (simplifyx.(D*d*[ae(n1, n2) for n1 ∈ hx, n2 ∈ hy]))
    return Ke
end

function weakformRe(H4)
    behart(w) = simplifyx(integrate(w, 0 .. a, 0 .. b))
    re = (simplifyx.([behart(n1) for n1 ∈ H4 ]))
    return re
end