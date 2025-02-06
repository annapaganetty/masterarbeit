# Berechnung der Koeffizienten von N (musste nur einmalig berechnet werden)
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

# Ausgabe der Koeffizienten (musste nur einmalig berechnet werden, dann kopieren und in nachfolgende Funktion kopiert)
function printBTPhx(coeffizients)
    for i = 1:12
        println("Hx[",i,"] = sum.([",coeffizients[i][1],",",coeffizients[i][2],",",coeffizients[i][3],",",coeffizients[i][4],",",coeffizients[i][5],",",coeffizients[i][6],",",coeffizients[i][7],",",coeffizients[i][8],"] .* N)")    
    end
end

# Berechnung der Koeffizienten von N (musste nur einmalig berechnet werden)

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

# Ausgabe der Koeffizienten (musste nur einmalig berechnet werden, dann kopieren und in nachfolgende Funktion kopiert)
function printBTPhy(coeffizients)
for i = 1:12
    println("Hy[",i,"] = sum.([",coeffizients[i][1],",",coeffizients[i][2],",",coeffizients[i][3],",",coeffizients[i][4],",",coeffizients[i][5],",",coeffizients[i][6],",",coeffizients[i][7],",",coeffizients[i][8],"] .* N)")    
end
end