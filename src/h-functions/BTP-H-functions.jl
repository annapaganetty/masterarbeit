#--------------------------------------------------------------------------
# Herleitung der Hx Funktionen aus dem Paper von Batoz und Tahar
#--------------------------------------------------------------------------
using Symbolics

function HxHy()
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
    return Hx,Hy
end

# Ausgabe der H-Funktionen für die späteren Funktionen coeffbtpHx
function printH(Hx,Hy)
    lx = size(Hx,1)
    ly = size(Hy,1)

    for i = 1:lx
        println("Hx[", i, "] = ", simplify(Hx[i]))
    end
    for i = 1:ly
        println("Hy[", i, "] = ", simplify(Hy[i]))
    end
end

#--------------------------------------------------------------------------
# Berechnung der Koeffizienten von N (einmalig) (N = Serendipity-Funktionen)
#--------------------------------------------------------------------------

# für Hx
function coeffbtpHx()
    @variables N1, N2, N3, N4, N5, N6, N7, N8 l₁₂,l₂₃,l₃₄,l₄₁,S₅,S₆,S₇,S₈,C₅,C₆,C₇,C₈;
    
    Hx = Vector{Any}(undef,12)
    Hx[1] = (-24.0*N5*S₅*l₂₃*l₃₄*l₄₁ + 24.0*N8*S₈*l₁₂*l₂₃*l₃₄) / (16l₁₂*l₂₃*l₃₄*l₄₁)
    Hx[2] = (-12.0C₅*N5*S₅*l₁₂*l₂₃*l₃₄*l₄₁ - 12.0C₈*N8*S₈*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
    Hx[3] = (16.0N1*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₅^2)*N5*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₈^2)*N8*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N5*(S₅^2)*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N8*(S₈^2)*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
    Hx[4] = (24.0N5*S₅*l₂₃*l₃₄*l₄₁ - 24.0N6*S₆*l₁₂*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
    Hx[5] = (-12.0C₅*N5*S₅*l₁₂*l₂₃*l₃₄*l₄₁ - 12.0C₆*N6*S₆*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
    Hx[6] = (16.0N2*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₅^2)*N5*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₆^2)*N6*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N5*(S₅^2)*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N6*(S₆^2)*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
    Hx[7] = (24.0N6*S₆*l₁₂*l₃₄*l₄₁ - 24.0N7*S₇*l₁₂*l₂₃*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
    Hx[8] = (-12.0C₆*N6*S₆*l₁₂*l₂₃*l₃₄*l₄₁ - 12.0C₇*N7*S₇*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
    Hx[9] = (16.0N3*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₆^2)*N6*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₇^2)*N7*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N6*(S₆^2)*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N7*(S₇^2)*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
    Hx[10] = (24.0N7*S₇*l₁₂*l₂₃*l₄₁ - 24.0N8*S₈*l₁₂*l₂₃*l₃₄) / (16l₁₂*l₂₃*l₃₄*l₄₁)
    Hx[11] = (-12.0C₇*N7*S₇*l₁₂*l₂₃*l₃₄*l₄₁ - 12.0C₈*N8*S₈*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
    Hx[12] = (16.0N4*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₇^2)*N7*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₈^2)*N8*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N7*(S₇^2)*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N8*(S₈^2)*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)

    coeffizients = Vector{Any}(undef,12)
    for i = 1:12
        a1 = simplify.(Symbolics.coeff(Hx[i], N1))
        a2 = simplify.(Symbolics.coeff(Hx[i], N2))
        a3 = simplify.(Symbolics.coeff(Hx[i], N3))
        a4 = simplify.(Symbolics.coeff(Hx[i], N4))
        a5 = simplify.(Symbolics.coeff(Hx[i], N5))
        a6 = simplify.(Symbolics.coeff(Hx[i], N6))
        a7 = simplify.(Symbolics.coeff(Hx[i], N7))
        a8 = simplify.(Symbolics.coeff(Hx[i], N8))
        coeffizients[i] = [a1, a2, a3, a4, a5, a6, a7, a8]
    end 
    return expand.(coeffizients)
end 

# für Hy
function coeffbtpHy()
@variables N1, N2, N3, N4, N5, N6, N7, N8,l₁₂,l₂₃,l₃₄,l₄₁,S₅,S₆,S₇,S₈,C₅,C₆,C₇,C₈;

Hy = Vector{Any}(undef,12)
Hy[1] = (24.0C₅*N5*l₂₃*l₃₄*l₄₁ - 24.0C₈*N8*l₁₂*l₂₃*l₃₄) / (16l₁₂*l₂₃*l₃₄*l₄₁)
Hy[2] = (-16.0N1*l₁₂*l₂₃*l₃₄*l₄₁ + 4.0(C₅^2)*N5*l₁₂*l₂₃*l₃₄*l₄₁ + 4.0(C₈^2)*N8*l₁₂*l₂₃*l₃₄*l₄₁ - 8.0N5*(S₅^2)*l₁₂*l₂₃*l₃₄*l₄₁ - 8.0N8*(S₈^2)*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
Hy[3] = (12.0C₅*N5*S₅*l₁₂*l₂₃*l₃₄*l₄₁ + 12.0C₈*N8*S₈*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
Hy[4] = (-24.0C₅*N5*l₂₃*l₃₄*l₄₁ + 24.0C₆*N6*l₁₂*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
Hy[5] = (-16.0N2*l₁₂*l₂₃*l₃₄*l₄₁ + 4.0(C₅^2)*N5*l₁₂*l₂₃*l₃₄*l₄₁ + 4.0(C₆^2)*N6*l₁₂*l₂₃*l₃₄*l₄₁ - 8.0N5*(S₅^2)*l₁₂*l₂₃*l₃₄*l₄₁ - 8.0N6*(S₆^2)*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
Hy[6] = (12.0C₅*N5*S₅*l₁₂*l₂₃*l₃₄*l₄₁ + 12.0C₆*N6*S₆*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
Hy[7] = (-24.0C₆*N6*l₁₂*l₃₄*l₄₁ + 24.0C₇*N7*l₁₂*l₂₃*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
Hy[8] = (-16.0N3*l₁₂*l₂₃*l₃₄*l₄₁ + 4.0(C₆^2)*N6*l₁₂*l₂₃*l₃₄*l₄₁ + 4.0(C₇^2)*N7*l₁₂*l₂₃*l₃₄*l₄₁ - 8.0N6*(S₆^2)*l₁₂*l₂₃*l₃₄*l₄₁ - 8.0N7*(S₇^2)*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
Hy[9] = (12.0C₆*N6*S₆*l₁₂*l₂₃*l₃₄*l₄₁ + 12.0C₇*N7*S₇*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
Hy[10] = (-24.0C₇*N7*l₁₂*l₂₃*l₄₁ + 24.0C₈*N8*l₁₂*l₂₃*l₃₄) / (16l₁₂*l₂₃*l₃₄*l₄₁)
Hy[11] = (-16.0N4*l₁₂*l₂₃*l₃₄*l₄₁ + 4.0(C₇^2)*N7*l₁₂*l₂₃*l₃₄*l₄₁ + 4.0(C₈^2)*N8*l₁₂*l₂₃*l₃₄*l₄₁ - 8.0N7*(S₇^2)*l₁₂*l₂₃*l₃₄*l₄₁ - 8.0N8*(S₈^2)*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
Hy[12] = (12.0C₇*N7*S₇*l₁₂*l₂₃*l₃₄*l₄₁ + 12.0C₈*N8*S₈*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)        

coeffizients = Vector{Any}(undef,12)
for i = 1:12
    a1 = simplify.(Symbolics.coeff(Hy[i], N1))
    a2 = simplify.(Symbolics.coeff(Hy[i], N2))
    a3 = simplify.(Symbolics.coeff(Hy[i], N3))
    a4 = simplify.(Symbolics.coeff(Hy[i], N4))
    a5 = simplify.(Symbolics.coeff(Hy[i], N5))
    a6 = simplify.(Symbolics.coeff(Hy[i], N6))
    a7 = simplify.(Symbolics.coeff(Hy[i], N7))
    a8 = simplify.(Symbolics.coeff(Hy[i], N8))
    coeffizients[i] = [a1, a2, a3, a4, a5, a6, a7, a8]
end 
return expand.(coeffizients)
end 

#--------------------------------------------------------------------------
# Ausgabe der Koeffizienten von N (einmalig)
#--------------------------------------------------------------------------

# für Hx
function printBTPhx(coeffizients)
    for i = 1:12
        println("Hx[",i,"] = sum.([",coeffizients[i][1],",",coeffizients[i][2],",",coeffizients[i][3],",",coeffizients[i][4],",",coeffizients[i][5],",",coeffizients[i][6],",",coeffizients[i][7],",",coeffizients[i][8],"] .* N)")    
    end
end

# für Hy
function printBTPhy(coeffizients)
for i = 1:12
    println("Hy[",i,"] = sum.([",coeffizients[i][1],",",coeffizients[i][2],",",coeffizients[i][3],",",coeffizients[i][4],",",coeffizients[i][5],",",coeffizients[i][6],",",coeffizients[i][7],",",coeffizients[i][8],"] .* N)")    
end
end