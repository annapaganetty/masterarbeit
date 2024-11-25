using Symbolics

#   geometrische Größen des allgemeines Vierecks nach Batoz und Tahar 
Ck = Symbolics.variables(:C,5:8)
Sk = Symbolics.variables(:S,5:8)
lij = Symbolics.variables(:l,(12,23,34,41))

#   Freiheitsgerade des allgemeinen Vierecks 
#   Verschiebung w, Verdrehungen θx und θy an den Eckpunkten des Elements
we = Symbolics.variables(:we,1:4)
θex = Symbolics.variables(:θex,1:4)
θey = Symbolics.variables(:θey,1:4)
Ue = vcat([[we[i], θex[i], θey[i]] for i = 1:4]...)

#   Vereinbarung von βn nach dem Paper von Batoz und Tahar 
βn = []
push!(βn, expand(-1/2 * (Sk[1] * (θex[1] + θex[2]) + Ck[1] * (-θey[1] - θey[2]))))      # βn5
push!(βn, expand(-1/2 * (Sk[2] * (θex[2] + θex[3]) + Ck[2] * (-θey[2] - θey[3]))))      # βn6
push!(βn, expand(-1/2 * (Sk[3] * (θex[3] + θex[4]) + Ck[3] * (-θey[3] - θey[4]))))      # βn7
push!(βn, expand(-1/2 * (Sk[4] * (θex[4] + θex[1]) + Ck[4] * (-θey[4] - θey[1]))))      # βn8

#   Vereinbarung von ws nach dem Paper von Batoz und Tahar 
ws = []
push!(ws, expand((-3/(2*lij[1])) * (we[1] - we[2]) - 1/4 * (Ck[1] * (θex[1] + θex[2]) + Sk[1] * (θey[1] + θey[2]))))
push!(ws, expand((-3/(2*lij[2])) * (we[2] - we[3]) - 1/4 * (Ck[2] * (θex[2] + θex[3]) + Sk[2] * (θey[2] + θey[3]))))
push!(ws, expand((-3/(2*lij[3])) * (we[3] - we[4]) - 1/4 * (Ck[3] * (θex[3] + θex[4]) + Sk[3] * (θey[3] + θey[4]))))
push!(ws, expand((-3/(2*lij[4])) * (we[4] - we[1]) - 1/4 * (Ck[4] * (θex[4] + θex[1]) + Sk[4] * (θey[4] + θey[1]))))

βs = []
for i = 1:4
    push!(βs, -ws[i])
end

# Berechnung von βxi und βyi
βxi = []
βyi = []
    # Berechnung von βx1 bis βx4 und βy1 bis βy4
for i = 1:4                                 
    push!(βxi, θey[i])
    push!(βyi, -θex[i])
end
    # Berechnung von βx5 bis βx8 und βy5 bis βy8
for i = 1:4
    push!(βxi, expand(Ck[i] * βn[i] - Sk[i] * βs[i]))
    push!(βyi, expand(Sk[i] * βn[i] + Ck[i] * βs[i]))
end

# Variablen, stellvertreten für die Basisfunktioen 
@variables N[1:8]
N = Symbolics.scalarize(N)

# Berechnung von βx und βy
betaX = []
betaY = []
for i = 1:8 
    push!(betaX, expand(N[i] * βxi[i]))
    push!(betaY, expand(N[i] * βyi[i]))
end
βx = simplify((sum(betaX)))
βy = simplify((sum(betaY)))

# Vektor-Matrix Produkt aus βx und βx erstellen durch "ausklammern" des Vektors der Freiheitsgrade Ue
Hx = expand.([Symbolics.coeff(βx, y) for y = Ue])
Hy = expand.([Symbolics.coeff(βy, y) for y = Ue])