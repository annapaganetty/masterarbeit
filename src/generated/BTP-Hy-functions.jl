# Berechnung Ableitungen von Hy für ein Element e
function btpHyNew(e)
    l₁₂,l₂₃,l₃₄,l₄₁,S₅,S₆,S₇,S₈,C₅,C₆,C₇,C₈ = geoH(e)

    V = [ -1 1 1 -1; -1 -1 1 1]
    N = serendipityelement(V)

    Hy = Array{Any}(undef,1,12)
    Hy[1,1] = simplify(sum([0,0,0,0,(3C₅) / (2l₁₂),0,0,(-3C₈) / (2l₄₁)] .* N))
    Hy[1,2] = simplify(sum([-1,0,0,0,(1//16)*(4(C₅^2) - 8(S₅^2)),0,0,(1//16)*(4(C₈^2) - 8(S₈^2))] .* N))
    Hy[1,3] = simplify(sum([0,0,0,0,0.75C₅*S₅,0,0,0.75C₈*S₈] .* N))
    Hy[1,4] = simplify(sum([0,0,0,0,(-3C₅) / (2l₁₂),(3C₆) / (2l₂₃),0,0] .* N))
    Hy[1,5] = simplify(sum([0,-1,0,0,(1//16)*(4(C₅^2) - 8(S₅^2)),(1//16)*(4(C₆^2) - 8(S₆^2)),0,0] .* N))
    Hy[1,6] = simplify(sum([0,0,0,0,0.75C₅*S₅,0.75C₆*S₆,0,0] .* N))
    Hy[1,7] = simplify(sum([0,0,0,0,0,(-3C₆) / (2l₂₃),(3C₇) / (2l₃₄),0] .* N))
    Hy[1,8] = simplify(sum([0,0,-1,0,0,(1//16)*(4(C₆^2) - 8(S₆^2)),(1//16)*(4(C₇^2) - 8(S₇^2)),0] .* N))
    Hy[1,9] = simplify(sum([0,0,0,0,0,0.75C₆*S₆,0.75C₇*S₇,0] .* N))
    Hy[1,10] = simplify(sum([0,0,0,0,0,0,(-3C₇) / (2l₃₄),(3C₈) / (2l₄₁)] .* N))
    Hy[1,11] = simplify(sum([0,0,0,-1,0,0,(1//16)*(4(C₇^2) - 8(S₇^2)),(1//16)*(4(C₈^2) - 8(S₈^2))] .* N))
    Hy[1,12] = simplify(sum([0,0,0,0,0,0,0.75C₇*S₇,0.75C₈*S₈] .* N))   

    return Hy
end 