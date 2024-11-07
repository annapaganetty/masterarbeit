function geoHx(e)
    x = []
    y = []
    for i = 1:4
        push!(x, coordinates(e, i)[1])
        push!(y, coordinates(e, i)[2])
    end

    xij = []
    push!(xij, x[1] - x[2])
    push!(xij, x[2] - x[3])
    push!(xij, x[3] - x[4])
    push!(xij, x[4] - x[1])

    yij = []
    push!(yij, y[1] - y[2])
    push!(yij, y[2] - y[3])
    push!(yij, y[3] - y[4])
    push!(yij, y[4] - y[1])

    l₁₂ = (xij[1]^2 + yij[1]^2)^(1/2)
    l₂₃ = (xij[2]^2 + yij[2]^2)^(1/2)
    l₃₄ = (xij[3]^2 + yij[3]^2)^(1/2)
    l₄₁ = (xij[4]^2 + yij[4]^2)^(1/2)

    S₅ = xij[1]/l₁₂
    S₆ = xij[2]/l₂₃
    S₇ = xij[3]/l₃₄
    S₈ = xij[4]/l₄₁

    C₅ = -yij[1]/l₁₂
    C₆ = -yij[2]/l₂₃
    C₇ = -yij[3]/l₃₄
    C₈ = -yij[4]/l₄₁

    return l₁₂,l₂₃,l₃₄,l₄₁,S₅,S₆,S₇,S₈,C₅,C₆,C₇,C₈
end

function btpHx()
    function hxFunc(e)
        l₁₂,l₂₃,l₃₄,l₄₁,S₅,S₆,S₇,S₈,C₅,C₆,C₇,C₈ = geoHx(e)

        @variables N[1:8]
        N = Symbolics.scalarize(N)
    
        Hx = Array{Any}(undef,12)
        
# Warum klappt das nicht mit der Multiplikation der ShapeFunktionen ??
       
        # V = [ -1 1 1 -1; -1 -1 1 1]
        # N = serendipityelement(V)
    
        Hx[1] = (-24.0*N[5]*S₅*l₂₃*l₃₄*l₄₁ + 24.0*N[8]*S₈*l₁₂*l₂₃*l₃₄) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[2] = (-12.0C₅*N[5]*S₅*l₁₂*l₂₃*l₃₄*l₄₁ - 12.0C₈*N[8]*S₈*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[3] = (16.0N[1]*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₅^2)*N[5]*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₈^2)*N[8]*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N[5]*(S₅^2)*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N[8]*(S₈^2)*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[4] = (24.0N[5]*S₅*l₂₃*l₃₄*l₄₁ - 24.0N[6]*S₆*l₁₂*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[5] = (-12.0C₅*N[5]*S₅*l₁₂*l₂₃*l₃₄*l₄₁ - 12.0C₆*N[6]*S₆*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[6] = (16.0N[2]*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₅^2)*N[5]*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₆^2)*N[6]*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N[5]*(S₅^2)*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N[6]*(S₆^2)*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[7] = (24.0N[6]*S₆*l₁₂*l₃₄*l₄₁ - 24.0N[7]*S₇*l₁₂*l₂₃*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[8] = (-12.0C₆*N[6]*S₆*l₁₂*l₂₃*l₃₄*l₄₁ - 12.0C₇*N[7]*S₇*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[9] = (16.0N[3]*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₆^2)*N[6]*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₇^2)*N[7]*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N[6]*(S₆^2)*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N[7]*(S₇^2)*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[10] = (24.0N[7]*S₇*l₁₂*l₂₃*l₄₁ - 24.0N[8]*S₈*l₁₂*l₂₃*l₃₄) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[11] = (-12.0C₇*N[7]*S₇*l₁₂*l₂₃*l₃₄*l₄₁ - 12.0C₈*N[8]*S₈*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[12] = (16.0N[4]*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₇^2)*N[7]*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₈^2)*N[8]*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N[7]*(S₇^2)*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N[8]*(S₈^2)*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        return expand.(Hx)
    end
    return hxFunc
end 