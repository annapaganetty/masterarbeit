# Erstellt geometrische Größen für ein Element, die für die BTP Formulierung wichtig sind
function geoH(e)
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

# # ∇N = [∂x(N[1]) ∂x(N[2]) ∂x(N[3]) ∂x(N[4]); ∂y(N[1]) ∂y(N[2]) ∂y(N[3]) ∂y(N[4])]
# # Jacobi-Matrix für 2D Elemente
# function jacobianMatrix(e)
#     xy = coordElement(e)
#     J = ∇N * xy
#     return J
# end

# Einträge der inversen Jacobi Matrix eines Elements
function jacobianMatrixInv(e)
    @variables x₁, x₂;

    xy = coordElement(e)

    J11 = (0.25(xy[1,1] + xy[3,1]) - 0.25(xy[2,1] + xy[4,1]))x₂ -0.25(xy[1,1] + xy[4,1]) + 0.25(xy[2,1] + xy[3,1])
    J12 = (0.25(xy[1,2] + xy[3,2]) - 0.25(xy[2,2] + xy[4,2]))x₂ -0.25(xy[1,2] + xy[4,2]) + 0.25(xy[2,2] + xy[3,2])
    J21 = (0.25(xy[1,1] + xy[3,1]) - 0.25(xy[2,1] + xy[4,1]))x₁ -0.25(xy[1,1] + xy[2,1]) + 0.25(xy[3,1] + xy[4,1])
    J22 = (0.25(xy[1,2] + xy[3,2]) - 0.25(xy[2,2] + xy[4,2]))x₁ -0.25(xy[1,2] + xy[2,2]) + 0.25(xy[3,2] + xy[4,2])
    
#--------------------------------------------------------------------------
#               Determinante und Komponenten der inversen Jacobi-Matrix
#--------------------------------------------------------------------------

    d = J11 * J22 - J21 * J12
    j11 = J22/d
    j12 = -J12/d
    j21 = -J21/d
    j22 = J11/d
    return j11, j12, j21, j22, d 
end


# gibt Koordinaten eines Elementes zurück
function coordElement(e)
    x = []
    y = []
    for i = 1:4
        push!(x, coordinates(e, i)[1])
        push!(y, coordinates(e, i)[2])
    end
    xy = [x[1] y[1]; x[2] y[2]; x[3] y[3]; x[4] y[4]]
    return xy
end

# gibt Länge und Breite eines Elementes zurück 
function _fsize(face)
	x = coordinates(face)
	p = x[:, 1]
	l1 = x[1, 2] - x[1, 1]
	l2 = x[2, 3] - x[2, 2]
	return p, l1, l2
end

# TODO delete function
# macht das gleiche wir _fsize(face)
function ab(e)
    x1 = coordinates(e, 1)
    x2 = coordinates(e, 2)
    x3 = coordinates(e, 3)
    x4 = coordinates(e, 4)
    a = x2[1] - x1[1]       # Länge in xi-Richtung
    b = x3[2] - x1[2]       # Länge in eta-Richtung
    return a,b
end