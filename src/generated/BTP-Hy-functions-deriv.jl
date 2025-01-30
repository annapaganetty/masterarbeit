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

# Berechnung Ableitungen von Hy für ein Element e
function btpHy(e)
    l₁₂,l₂₃,l₃₄,l₄₁,S₅,S₆,S₇,S₈,C₅,C₆,C₇,C₈ = geoH(e)

    V = [ -1 1 1 -1; -1 -1 1 1]
    N = serendipityelement(V)

    Hy = Array{Any}(undef,12)
    Hy[1] = simplify(sum([0,0,0,0,(3C₅) / (2l₁₂),0,0,(-3C₈) / (2l₄₁)] .* N))
    Hy[2] = simplify(sum([-1,0,0,0,(1//16)*(4(C₅^2) - 8(S₅^2)),0,0,(1//16)*(4(C₈^2) - 8(S₈^2))] .* N))
    Hy[3] = simplify(sum([0,0,0,0,0.75C₅*S₅,0,0,0.75C₈*S₈] .* N))
    Hy[4] = simplify(sum([0,0,0,0,(-3C₅) / (2l₁₂),(3C₆) / (2l₂₃),0,0] .* N))
    Hy[5] = simplify(sum([0,-1,0,0,(1//16)*(4(C₅^2) - 8(S₅^2)),(1//16)*(4(C₆^2) - 8(S₆^2)),0,0] .* N))
    Hy[6] = simplify(sum([0,0,0,0,0.75C₅*S₅,0.75C₆*S₆,0,0] .* N))
    Hy[7] = simplify(sum([0,0,0,0,0,(-3C₆) / (2l₂₃),(3C₇) / (2l₃₄),0] .* N))
    Hy[8] = simplify(sum([0,0,-1,0,0,(1//16)*(4(C₆^2) - 8(S₆^2)),(1//16)*(4(C₇^2) - 8(S₇^2)),0] .* N))
    Hy[9] = simplify(sum([0,0,0,0,0,0.75C₆*S₆,0.75C₇*S₇,0] .* N))
    Hy[10] = simplify(sum([0,0,0,0,0,0,(-3C₇) / (2l₃₄),(3C₈) / (2l₄₁)] .* N))
    Hy[11] = simplify(sum([0,0,0,-1,0,0,(1//16)*(4(C₇^2) - 8(S₇^2)),(1//16)*(4(C₈^2) - 8(S₈^2))] .* N))
    Hy[12] = simplify(sum([0,0,0,0,0,0,0.75C₇*S₇,0.75C₈*S₈] .* N))   

    return ∂x(Hy[1]), ∂x(Hy[2]), ∂x(Hy[3]), ∂x(Hy[4]), ∂x(Hy[5]), ∂x(Hy[6]), ∂x(Hy[7]), ∂x(Hy[8]), ∂x(Hy[9]), ∂x(Hy[10]), ∂x(Hy[11]), ∂x(Hy[12]),∂y(Hy[1]), ∂y(Hy[2]), ∂y(Hy[3]), ∂y(Hy[4]), ∂y(Hy[5]), ∂y(Hy[6]), ∂y(Hy[7]), ∂y(Hy[8]), ∂y(Hy[9]), ∂y(Hy[10]), ∂y(Hy[11]), ∂y(Hy[12])
end 

    # Hy[1,1] = sum([0,0,0,0,(BigInt(3)*C₅) / (2l₁₂),0,0,(-BigInt(3)*C₈) / (2l₄₁)] .* N)
    # Hy[1,2] = sum([-BigInt(1),0,0,0,(BigInt(1)//16)*(BigInt(4)*(C₅^2) - BigInt(8)*(S₅^2)),0,0,(BigInt(1)//16)*(BigInt(4)*(C₈^2) - BigInt(8)*(S₈^2))] .* N)
    # Hy[1,3] = sum([0,0,0,0,0.75C₅*S₅,0,0,0.75C₈*S₈] .* N)
    # Hy[1,4] = sum([0,0,0,0,(-BigInt(3)*C₅) / (2l₁₂),(BigInt(3)*C₆) / (2l₂₃),0,0] .* N)
    # Hy[1,5] = sum([0,-BigInt(1),0,0,(BigInt(1)//16)*(BigInt(4)*(C₅^2) - BigInt(8)*(S₅^2)),(BigInt(1)//16)*(BigInt(4)*(C₆^2) - BigInt(8)*(S₆^2)),0,0] .* N)
    # Hy[1,6] = sum([0,0,0,0,0.75C₅*S₅,0.75C₆*S₆,0,0] .* N)
    # Hy[1,7] = sum([0,0,0,0,0,(-BigInt(3)*C₆) / (2l₂₃),(BigInt(3)*C₇) / (2l₃₄),0] .* N)
    # Hy[1,8] = sum([0,0,-BigInt(1),0,0,(BigInt(1)//16)*(BigInt(4)*(C₆^2) - BigInt(8)*(S₆^2)),(BigInt(1)//16)*(BigInt(4)*(C₇^2) - BigInt(8)*(S₇^2)),0] .* N)
    # Hy[1,9] = sum([0,0,0,0,0,0.75C₆*S₆,0.75C₇*S₇,0] .* N)
    # Hy[1,10] = sum([0,0,0,0,0,0,(-BigInt(3)*C₇) / (2l₃₄),(BigInt(3)*C₈) / (2l₄₁)] .* N)
    # Hy[1,11] = sum([0,0,0,-BigInt(1),0,0,(BigInt(1)//16)*(BigInt(4)*(C₇^2) - BigInt(8)*(S₇^2)),(BigInt(1)//16)*(BigInt(4)*(C₈^2) - BigInt(8)*(S₈^2))] .* N)
    # Hy[1,12] = sum([0,0,0,0,0,0,0.75C₇*S₇,0.75C₈*S₈] .* N)  