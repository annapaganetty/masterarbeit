# Berechnung von Hx für ein Element e
function btpHx(e)
    l₁₂,l₂₃,l₃₄,l₄₁,S₅,S₆,S₇,S₈,C₅,C₆,C₇,C₈ = geoH(e)

    V = [ -1 1 1 -1; -1 -1 1 1]
    Ns = serendipityelement(V)

    Hx = Array{Any}(undef,12)
    Hx[1] = simplify(sum([0,0,0,0,(-3S₅) / (2l₁₂),0,0,(3S₈) / (2l₄₁)] .* Ns))
    Hx[2] = simplify(sum([0,0,0,0,-0.75C₅*S₅,0,0,-0.75C₈*S₈] .* Ns))
    Hx[3] = simplify(sum([1,0,0,0,(1//16)*(8(C₅^2) - 4(S₅^2)),0,0,(1//16)*(8(C₈^2) - 4(S₈^2))] .* Ns))
    Hx[4] = simplify(sum([0,0,0,0,(3S₅) / (2l₁₂),(-3S₆) / (2l₂₃),0,0] .* Ns))
    Hx[5] = simplify(sum([0,0,0,0,-0.75C₅*S₅,-0.75C₆*S₆,0,0] .* Ns))
    Hx[6] = simplify(sum([0,1,0,0,(1//16)*(8(C₅^2) - 4(S₅^2)),(1//16)*(8(C₆^2) - 4(S₆^2)),0,0] .* Ns))
    Hx[7] = simplify(sum([0,0,0,0,0,(3S₆) / (2l₂₃),(-3S₇) / (2l₃₄),0] .* Ns))
    Hx[8] = simplify(sum([0,0,0,0,0,-0.75C₆*S₆,-0.75C₇*S₇,0] .* Ns))
    Hx[9] = simplify(sum([0,0,1,0,0,(1//16)*(8(C₆^2) - 4(S₆^2)),(1//16)*(8(C₇^2) - 4(S₇^2)),0] .* Ns))
    Hx[10] = simplify(sum([0,0,0,0,0,0,(3S₇) / (2l₃₄),(-3S₈) / (2l₄₁)] .* Ns))
    Hx[11] = simplify(sum([0,0,0,0,0,0,-0.75C₇*S₇,-0.75C₈*S₈] .* Ns))
    Hx[12] = simplify(sum([0,0,0,1,0,0,(1//16)*(8(C₇^2) - 4(S₇^2)),(1//16)*(8(C₈^2) - 4(S₈^2))] .* Ns))
    return Hx
    # return ∂x(Hx[1]), ∂x(Hx[2]), ∂x(Hx[3]), ∂x(Hx[4]), ∂x(Hx[5]), ∂x(Hx[6]), ∂x(Hx[7]), ∂x(Hx[8]), ∂x(Hx[9]), ∂x(Hx[10]), ∂x(Hx[11]), ∂x(Hx[12]),∂y(Hx[1]), ∂y(Hx[2]), ∂y(Hx[3]), ∂y(Hx[4]), ∂y(Hx[5]), ∂y(Hx[6]), ∂y(Hx[7]), ∂y(Hx[8]), ∂y(Hx[9]), ∂y(Hx[10]), ∂y(Hx[11]), ∂y(Hx[12])
end 

function btpHy(e)
    l₁₂,l₂₃,l₃₄,l₄₁,S₅,S₆,S₇,S₈,C₅,C₆,C₇,C₈ = geoH(e)

    V = [ -1 1 1 -1; -1 -1 1 1]
    Ns = serendipityelement(V)

    Hy = Array{Any}(undef,12)
    Hy[1] = simplify(sum([0,0,0,0,(3C₅) / (2l₁₂),0,0,(-3C₈) / (2l₄₁)] .* Ns))
    Hy[2] = simplify(sum([-1,0,0,0,(1//16)*(4(C₅^2) - 8(S₅^2)),0,0,(1//16)*(4(C₈^2) - 8(S₈^2))] .* Ns))
    Hy[3] = simplify(sum([0,0,0,0,0.75C₅*S₅,0,0,0.75C₈*S₈] .* Ns))
    Hy[4] = simplify(sum([0,0,0,0,(-3C₅) / (2l₁₂),(3C₆) / (2l₂₃),0,0] .* Ns))
    Hy[5] = simplify(sum([0,-1,0,0,(1//16)*(4(C₅^2) - 8(S₅^2)),(1//16)*(4(C₆^2) - 8(S₆^2)),0,0] .* Ns))
    Hy[6] = simplify(sum([0,0,0,0,0.75C₅*S₅,0.75C₆*S₆,0,0] .* Ns))
    Hy[7] = simplify(sum([0,0,0,0,0,(-3C₆) / (2l₂₃),(3C₇) / (2l₃₄),0] .* Ns))
    Hy[8] = simplify(sum([0,0,-1,0,0,(1//16)*(4(C₆^2) - 8(S₆^2)),(1//16)*(4(C₇^2) - 8(S₇^2)),0] .* Ns))
    Hy[9] = simplify(sum([0,0,0,0,0,0.75C₆*S₆,0.75C₇*S₇,0] .* Ns))
    Hy[10] = simplify(sum([0,0,0,0,0,0,(-3C₇) / (2l₃₄),(3C₈) / (2l₄₁)] .* Ns))
    Hy[11] = simplify(sum([0,0,0,-1,0,0,(1//16)*(4(C₇^2) - 8(S₇^2)),(1//16)*(4(C₈^2) - 8(S₈^2))] .* Ns))
    Hy[12] = simplify(sum([0,0,0,0,0,0,0.75C₇*S₇,0.75C₈*S₈] .* Ns))   
    return Hy
    # return ∂x(Hy[1]), ∂x(Hy[2]), ∂x(Hy[3]), ∂x(Hy[4]), ∂x(Hy[5]), ∂x(Hy[6]), ∂x(Hy[7]), ∂x(Hy[8]), ∂x(Hy[9]), ∂x(Hy[10]), ∂x(Hy[11]), ∂x(Hy[12]),∂y(Hy[1]), ∂y(Hy[2]), ∂y(Hy[3]), ∂y(Hy[4]), ∂y(Hy[5]), ∂y(Hy[6]), ∂y(Hy[7]), ∂y(Hy[8]), ∂y(Hy[9]), ∂y(Hy[10]), ∂y(Hy[11]), ∂y(Hy[12])
end

# Berechnung von Hx für ein Element e
function bMatrix(e)
    l₁₂,l₂₃,l₃₄,l₄₁,S₅,S₆,S₇,S₈,C₅,C₆,C₇,C₈ = geoH(e)

    V = [ -1 1 1 -1; -1 -1 1 1]
    Ns = serendipityelement(V)
    Ni = lagrangeelement(V)

    H = Array{Any}(undef,3, 12)
    H[1,1] = Ni[1]
    H[1,2] = 0
    H[1,3] = 0
    H[1,4] = Ni[2]
    H[1,5] = 0
    H[1,6] = 0
    H[1,7] = Ni[3]
    H[1,8] = 0
    H[1,9] = 0
    H[1,10] = Ni[4]
    H[1,11] = 0
    H[1,12] = 0

    H[2,1] = simplify(sum([0,0,0,0,(-3S₅) / (2l₁₂),0,0,(3S₈) / (2l₄₁)] .* Ns))
    H[2,2] = simplify(sum([0,0,0,0,-0.75C₅*S₅,0,0,-0.75C₈*S₈] .* Ns))
    H[2,3] = simplify(sum([1,0,0,0,(1//16)*(8(C₅^2) - 4(S₅^2)),0,0,(1//16)*(8(C₈^2) - 4(S₈^2))] .* Ns))
    H[2,4] = simplify(sum([0,0,0,0,(3S₅) / (2l₁₂),(-3S₆) / (2l₂₃),0,0] .* Ns))
    H[2,5] = simplify(sum([0,0,0,0,-0.75C₅*S₅,-0.75C₆*S₆,0,0] .* Ns))
    H[2,6] = simplify(sum([0,1,0,0,(1//16)*(8(C₅^2) - 4(S₅^2)),(1//16)*(8(C₆^2) - 4(S₆^2)),0,0] .* Ns))
    H[2,7] = simplify(sum([0,0,0,0,0,(3S₆) / (2l₂₃),(-3S₇) / (2l₃₄),0] .* Ns))
    H[2,8] = simplify(sum([0,0,0,0,0,-0.75C₆*S₆,-0.75C₇*S₇,0] .* Ns))
    H[2,9] = simplify(sum([0,0,1,0,0,(1//16)*(8(C₆^2) - 4(S₆^2)),(1//16)*(8(C₇^2) - 4(S₇^2)),0] .* Ns))
    H[2,10] = simplify(sum([0,0,0,0,0,0,(3S₇) / (2l₃₄),(-3S₈) / (2l₄₁)] .* Ns))
    H[2,11] = simplify(sum([0,0,0,0,0,0,-0.75C₇*S₇,-0.75C₈*S₈] .* Ns))
    H[2,12] = simplify(sum([0,0,0,1,0,0,(1//16)*(8(C₇^2) - 4(S₇^2)),(1//16)*(8(C₈^2) - 4(S₈^2))] .* Ns))

    H[3,1] = simplify(sum([0,0,0,0,(3C₅) / (2l₁₂),0,0,(-3C₈) / (2l₄₁)] .* Ns))
    H[3,2] = simplify(sum([-1,0,0,0,(1//16)*(4(C₅^2) - 8(S₅^2)),0,0,(1//16)*(4(C₈^2) - 8(S₈^2))] .* Ns))
    H[3,3] = simplify(sum([0,0,0,0,0.75C₅*S₅,0,0,0.75C₈*S₈] .* Ns))
    H[3,4] = simplify(sum([0,0,0,0,(-3C₅) / (2l₁₂),(3C₆) / (2l₂₃),0,0] .* Ns))
    H[3,5] = simplify(sum([0,-1,0,0,(1//16)*(4(C₅^2) - 8(S₅^2)),(1//16)*(4(C₆^2) - 8(S₆^2)),0,0] .* Ns))
    H[3,6] = simplify(sum([0,0,0,0,0.75C₅*S₅,0.75C₆*S₆,0,0] .* Ns))
    H[3,7] = simplify(sum([0,0,0,0,0,(-3C₆) / (2l₂₃),(3C₇) / (2l₃₄),0] .* Ns))
    H[3,8] = simplify(sum([0,0,-1,0,0,(1//16)*(4(C₆^2) - 8(S₆^2)),(1//16)*(4(C₇^2) - 8(S₇^2)),0] .* Ns))
    H[3,9] = simplify(sum([0,0,0,0,0,0.75C₆*S₆,0.75C₇*S₇,0] .* Ns))
    H[3,10] = simplify(sum([0,0,0,0,0,0,(-3C₇) / (2l₃₄),(3C₈) / (2l₄₁)] .* Ns))
    H[3,11] = simplify(sum([0,0,0,-1,0,0,(1//16)*(4(C₇^2) - 8(S₇^2)),(1//16)*(4(C₈^2) - 8(S₈^2))] .* Ns))
    H[3,12] = simplify(sum([0,0,0,0,0,0,0.75C₇*S₇,0.75C₈*S₈] .* Ns))   
    return H
    # return ∂x(Hy[1]), ∂x(Hy[2]), ∂x(Hy[3]), ∂x(Hy[4]), ∂x(Hy[5]), ∂x(Hy[6]), ∂x(Hy[7]), ∂x(Hy[8]), ∂x(Hy[9]), ∂x(Hy[10]), ∂x(Hy[11]), ∂x(Hy[12]),∂y(Hy[1]), ∂y(Hy[2]), ∂y(Hy[3]), ∂y(Hy[4]), ∂y(Hy[5]), ∂y(Hy[6]), ∂y(Hy[7]), ∂y(Hy[8]), ∂y(Hy[9]), ∂y(Hy[10]), ∂y(Hy[11]), ∂y(Hy[12])
end