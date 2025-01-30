# Berechnung von Hx für ein Element e
function btpHxNew(e)
    l₁₂,l₂₃,l₃₄,l₄₁,S₅,S₆,S₇,S₈,C₅,C₆,C₇,C₈ = geoH(e)

    V = [ -1 1 1 -1; -1 -1 1 1]
    N = serendipityelement(V)

    Hx = Array{Any}(undef,1,12)
    Hx[1,1] = simplify(sum([0,0,0,0,(-3S₅) / (2l₁₂),0,0,(3S₈) / (2l₄₁)] .* N))
    Hx[1,2] = simplify(sum([0,0,0,0,-0.75C₅*S₅,0,0,-0.75C₈*S₈] .* N))
    Hx[1,3] = simplify(sum([1,0,0,0,(1//16)*(8(C₅^2) - 4(S₅^2)),0,0,(1//16)*(8(C₈^2) - 4(S₈^2))] .* N))
    Hx[1,4] = simplify(sum([0,0,0,0,(3S₅) / (2l₁₂),(-3S₆) / (2l₂₃),0,0] .* N))
    Hx[1,5] = simplify(sum([0,0,0,0,-0.75C₅*S₅,-0.75C₆*S₆,0,0] .* N))
    Hx[1,6] = simplify(sum([0,1,0,0,(1//16)*(8(C₅^2) - 4(S₅^2)),(1//16)*(8(C₆^2) - 4(S₆^2)),0,0] .* N))
    Hx[1,7] = simplify(sum([0,0,0,0,0,(3S₆) / (2l₂₃),(-3S₇) / (2l₃₄),0] .* N))
    Hx[1,8] = simplify(sum([0,0,0,0,0,-0.75C₆*S₆,-0.75C₇*S₇,0] .* N))
    Hx[1,9] = simplify(sum([0,0,1,0,0,(1//16)*(8(C₆^2) - 4(S₆^2)),(1//16)*(8(C₇^2) - 4(S₇^2)),0] .* N))
    Hx[1,10] = simplify(sum([0,0,0,0,0,0,(3S₇) / (2l₃₄),(-3S₈) / (2l₄₁)] .* N))
    Hx[1,11] = simplify(sum([0,0,0,0,0,0,-0.75C₇*S₇,-0.75C₈*S₈] .* N))
    Hx[1,12] = simplify(sum([0,0,0,1,0,0,(1//16)*(8(C₇^2) - 4(S₇^2)),(1//16)*(8(C₈^2) - 4(S₈^2))] .* N))
   
    return Hx
end 