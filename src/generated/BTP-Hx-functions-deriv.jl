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

# Berechnung Ableitungen von Hx für ein Element e
function btpHx(e)
    l₁₂,l₂₃,l₃₄,l₄₁,S₅,S₆,S₇,S₈,C₅,C₆,C₇,C₈ = geoH(e)

    V = [ -1 1 1 -1; -1 -1 1 1]
    N = serendipityelement(V)

    Hx = Array{Any}(undef,12)
    Hx[1] = simplify(sum([0,0,0,0,(-3S₅) / (2l₁₂),0,0,(3S₈) / (2l₄₁)] .* N))
    Hx[2] = simplify(sum([0,0,0,0,-0.75C₅*S₅,0,0,-0.75C₈*S₈] .* N))
    Hx[3] = simplify(sum([1,0,0,0,(1//16)*(8(C₅^2) - 4(S₅^2)),0,0,(1//16)*(8(C₈^2) - 4(S₈^2))] .* N))
    Hx[4] = simplify(sum([0,0,0,0,(3S₅) / (2l₁₂),(-3S₆) / (2l₂₃),0,0] .* N))
    Hx[5] = simplify(sum([0,0,0,0,-0.75C₅*S₅,-0.75C₆*S₆,0,0] .* N))
    Hx[6] = simplify(sum([0,1,0,0,(1//16)*(8(C₅^2) - 4(S₅^2)),(1//16)*(8(C₆^2) - 4(S₆^2)),0,0] .* N))
    Hx[7] = simplify(sum([0,0,0,0,0,(3S₆) / (2l₂₃),(-3S₇) / (2l₃₄),0] .* N))
    Hx[8] = simplify(sum([0,0,0,0,0,-0.75C₆*S₆,-0.75C₇*S₇,0] .* N))
    Hx[9] = simplify(sum([0,0,1,0,0,(1//16)*(8(C₆^2) - 4(S₆^2)),(1//16)*(8(C₇^2) - 4(S₇^2)),0] .* N))
    Hx[10] = simplify(sum([0,0,0,0,0,0,(3S₇) / (2l₃₄),(-3S₈) / (2l₄₁)] .* N))
    Hx[11] = simplify(sum([0,0,0,0,0,0,-0.75C₇*S₇,-0.75C₈*S₈] .* N))
    Hx[12] = simplify(sum([0,0,0,1,0,0,(1//16)*(8(C₇^2) - 4(S₇^2)),(1//16)*(8(C₈^2) - 4(S₈^2))] .* N))
   
    return ∂x(Hx[1]), ∂x(Hx[2]), ∂x(Hx[3]), ∂x(Hx[4]), ∂x(Hx[5]), ∂x(Hx[6]), ∂x(Hx[7]), ∂x(Hx[8]), ∂x(Hx[9]), ∂x(Hx[10]), ∂x(Hx[11]), ∂x(Hx[12]),∂y(Hx[1]), ∂y(Hx[2]), ∂y(Hx[3]), ∂y(Hx[4]), ∂y(Hx[5]), ∂y(Hx[6]), ∂y(Hx[7]), ∂y(Hx[8]), ∂y(Hx[9]), ∂y(Hx[10]), ∂y(Hx[11]), ∂y(Hx[12])
end 

    # Hx[1,1] = sum([0,0,0,0,(-BigInt(3)*S₅) / (2l₁₂),0,0,(BigInt(3)*S₈) / (2l₄₁)] .* N)
    # Hx[1,2] = sum([0,0,0,0,-0.75C₅*S₅,0,0,-0.75C₈*S₈] .* N)
    # Hx[1,3] = sum([BigInt(1),0,0,0,(BigInt(1)//16)*(BigInt(8)*(C₅^2) - BigInt(4)*(S₅^2)),0,0,(BigInt(1)//16)*(BigInt(8)*(C₈^2) - BigInt(4)*(S₈^2))] .* N)
    # Hx[1,4] = sum([0,0,0,0,(BigInt(3)*S₅) / (2l₁₂),(-BigInt(3)*S₆) / (2l₂₃),0,0] .* N)
    # Hx[1,5] = sum([0,0,0,0,-0.75C₅*S₅,-0.75C₆*S₆,0,0] .* N)
    # Hx[1,6] = sum([0,BigInt(1),0,0,(BigInt(1)//16)*(BigInt(8)*(C₅^2) - BigInt(4)*(S₅^2)),(BigInt(1)//16)*(BigInt(8)*(C₆^2) - BigInt(4)*(S₆^2)),0,0] .* N)
    # Hx[1,7] = sum([0,0,0,0,0,(BigInt(3)*S₆) / (2l₂₃),(-BigInt(3)*S₇) / (2l₃₄),0] .* N)
    # Hx[1,8] = sum([0,0,0,0,0,-0.75C₆*S₆,-0.75C₇*S₇,0] .* N)
    # Hx[1,9] = sum([0,0,BigInt(1),0,0,(BigInt(1)//16)*(BigInt(8)*(C₆^2) - BigInt(4)*(S₆^2)),(BigInt(1)//16)*(BigInt(8)*(C₇^2) - BigInt(4)*(S₇^2)),0] .* N)
    # Hx[1,10] = sum([0,0,0,0,0,0,(BigInt(3)*S₇) / (2l₃₄),(-BigInt(3)*S₈) / (2l₄₁)] .* N)
    # Hx[1,11] = sum([0,0,0,0,0,0,-0.75C₇*S₇,-0.75C₈*S₈] .* N)
    # Hx[1,12] = sum([0,0,0,BigInt(1),0,0,(BigInt(1)//16)*(BigInt(8)*(C₇^2) - BigInt(4)*(S₇^2)),(BigInt(1)//16)*(BigInt(8)*(C₈^2) - BigInt(4)*(S₈^2))] .* N)
 