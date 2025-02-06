# Berechnung von Hx für ein Element e
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
    return Hx
    # return ∂x(Hx[1]), ∂x(Hx[2]), ∂x(Hx[3]), ∂x(Hx[4]), ∂x(Hx[5]), ∂x(Hx[6]), ∂x(Hx[7]), ∂x(Hx[8]), ∂x(Hx[9]), ∂x(Hx[10]), ∂x(Hx[11]), ∂x(Hx[12]),∂y(Hx[1]), ∂y(Hx[2]), ∂y(Hx[3]), ∂y(Hx[4]), ∂y(Hx[5]), ∂y(Hx[6]), ∂y(Hx[7]), ∂y(Hx[8]), ∂y(Hx[9]), ∂y(Hx[10]), ∂y(Hx[11]), ∂y(Hx[12])
end 

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
    return Hy
    # return ∂x(Hy[1]), ∂x(Hy[2]), ∂x(Hy[3]), ∂x(Hy[4]), ∂x(Hy[5]), ∂x(Hy[6]), ∂x(Hy[7]), ∂x(Hy[8]), ∂x(Hy[9]), ∂x(Hy[10]), ∂x(Hy[11]), ∂x(Hy[12]),∂y(Hy[1]), ∂y(Hy[2]), ∂y(Hy[3]), ∂y(Hy[4]), ∂y(Hy[5]), ∂y(Hy[6]), ∂y(Hy[7]), ∂y(Hy[8]), ∂y(Hy[9]), ∂y(Hy[10]), ∂y(Hy[11]), ∂y(Hy[12])
end