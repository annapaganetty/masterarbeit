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

        V = [ -1 1 1 -1; -1 -1 1 1]
        Ni = serendipityelement(V)

        @variables N₁, N₂, N₃, N₄, N₅, N₆, N₇, N₈;

        Hx = Array{Any}(undef,12)
        
        Hx1 = expand((-24.0N₅*S₅*l₄₁ + 24.0N₈*S₈*l₁₂) / (16l₁₂*l₄₁))
        Hx2 = expand((1//16)*(-12.0C₅*N₅*S₅ - 12.0C₈*N₈*S₈))
        Hx3 = expand((1//16)*(16.0N₁ + 8.0(C₅^2)*N₅ + 8.0(C₈^2)*N₈ - 4.0N₅*(S₅^2) - 4.0N₈*(S₈^2)))
        Hx4 = (24.0N₅*S₅*l₂₃ - 24.0N₆*S₆*l₁₂) / (16l₁₂*l₂₃)
        Hx5 = (1//16)*(-12.0C₅*N₅*S₅ - 12.0C₆*N₆*S₆)
        Hx6 = (1//16)*(16.0N₂ + 8.0(C₅^2)*N₅ + 8.0(C₆^2)*N₆ - 4.0N₅*(S₅^2) - 4.0N₆*(S₆^2))
        Hx7 = (24.0N₆*S₆*l₃₄ - 24.0N₇*S₇*l₂₃) / (16l₂₃*l₃₄)
        Hx8 = (1//16)*(-12.0C₆*N₆*S₆ - 12.0C₇*N₇*S₇)
        Hx9 = (1//16)*(16.0N₃ + 8.0(C₆^2)*N₆ + 8.0(C₇^2)*N₇ - 4.0N₆*(S₆^2) - 4.0N₇*(S₇^2))
        Hx10 = (24.0N₇*S₇*l₄₁ - 24.0N₈*S₈*l₃₄) / (16l₃₄*l₄₁)
        Hx11 = (1//16)*(-12.0C₇*N₇*S₇ - 12.0C₈*N₈*S₈)
        Hx12 = (1//16)*(16.0N₄ + 8.0(C₇^2)*N₇ + 8.0(C₈^2)*N₈ - 4.0N₇*(S₇^2) - 4.0N₈*(S₈^2))

        # Hx[1] = ([Symbolics.coeff(Hx1, y) for y = [N₅ N₈]]) * [Ni[5],Ni[8]]
        # Hx[2] = ([Symbolics.coeff(Hx2, y) for y = [N₅ N₈]]) * [Ni[5],Ni[8]]
        # Hx[3] = ([Symbolics.coeff(Hx3, y) for y = [N₁ N₅ N₈]]) * [Ni[1],Ni[5],Ni[8]]
        # Hx[4] = ([Symbolics.coeff(Hx4, y) for y = [N₅ N₆]]) * [Ni[5],Ni[6]]
        # Hx[5] = ([Symbolics.coeff(Hx5, y) for y = [N₅ N₆]]) * [Ni[5],Ni[6]]
        # Hx[6] = ([Symbolics.coeff(Hx6, y) for y = [N₂ N₅ N₆]]) * [Ni[2],Ni[5],Ni[6]]
        # Hx[7] = ([Symbolics.coeff(Hx7, y) for y = [N₆ N₇]]) * [Ni[6],Ni[7]]
        # Hx[8] = ([Symbolics.coeff(Hx8, y) for y = [N₆ N₇]]) * [Ni[6],Ni[7]]
        # Hx[9] = ([Symbolics.coeff(Hx9, y) for y = [N₃ N₆ N₇]]) * [Ni[3],Ni[6],Ni[7]]
        # Hx[10] = ([Symbolics.coeff(Hx10, y) for y = [N₇ N₈]]) * [Ni[7],Ni[8]]
        # Hx[11] = ([Symbolics.coeff(Hx11, y) for y = [N₇ N₈]]) * [Ni[7],Ni[8]]
        # Hx[12] = ([Symbolics.coeff(Hx12, y) for y = [N₄ N₇ N₈]]) * [Ni[4],Ni[7],Ni[8]]

        return Hx3
    end
    return hxFunc
end 