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

# gibt Länge und Breite eines Elementes zurück 
function _fsize(face)
	x = coordinates(face)
	p = x[:, 1]
	l1 = x[1, 2] - x[1, 1]
	l2 = x[2, 3] - x[2, 2]
	return p, l1, l2
end