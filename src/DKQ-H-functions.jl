# Berechnung von Hx und Hy für ein DKQ Element e
function makeDKQFunctions(e)
    l₁₂,l₂₃,l₃₄,l₄₁,S₅,S₆,S₇,S₈,C₅,C₆,C₇,C₈ = geoH(e)

    V = [ -1 1 1 -1; -1 -1 1 1]
    Ns = serendipityelement(V)

    Hx = Array{Any}(undef,1, 12)
    Hy = Array{Any}(undef,1, 12)

    Hx[1] = (-3Ns[5]*S₅*l₄₁ + 3Ns[8]*S₈*l₁₂) / (2l₁₂*l₄₁)
    Hx[2] = -0.75C₅*Ns[5]*S₅ - 0.75C₈*Ns[8]*S₈
    Hx[3] = Ns[1] + (1//16)*(8(C₅^2) - 4(S₅^2))*Ns[5] + (1//16)*(8(C₈^2) - 4(S₈^2))*Ns[8]
    Hx[4] = (3Ns[5]*S₅*l₂₃ - 3Ns[6]*S₆*l₁₂) / (2l₁₂*l₂₃)
    Hx[5] = -0.75C₅*Ns[5]*S₅ - 0.75C₆*Ns[6]*S₆
    Hx[6] = Ns[2] + (1//16)*(8(C₅^2) - 4(S₅^2))*Ns[5] + (1//16)*(8(C₆^2) - 4(S₆^2))*Ns[6]
    Hx[7] = (3Ns[6]*S₆*l₃₄ - 3Ns[7]*S₇*l₂₃) / (2l₂₃*l₃₄)
    Hx[8] = -0.75C₆*Ns[6]*S₆ - 0.75C₇*Ns[7]*S₇
    Hx[9] = Ns[3] + (1//16)*(8(C₆^2) - 4(S₆^2))*Ns[6] + (1//16)*(8(C₇^2) - 4(S₇^2))*Ns[7]
    Hx[10] = (3Ns[7]*S₇*l₄₁ - 3Ns[8]*S₈*l₃₄) / (2l₃₄*l₄₁)
    Hx[11] = -0.75C₇*Ns[7]*S₇ - 0.75C₈*Ns[8]*S₈
    Hx[12] = Ns[4] + (1//16)*(8(C₇^2) - 4(S₇^2))*Ns[7] + (1//16)*(8(C₈^2) - 4(S₈^2))*Ns[8]

    Hy[1] = (3C₅*Ns[5]*l₄₁ - 3C₈*Ns[8]*l₁₂) / (2l₁₂*l₄₁)
    Hy[2] = -Ns[1] + (1//16)*(4(C₅^2) - 8(S₅^2))*Ns[5] + (1//16)*(4(C₈^2) - 8(S₈^2))*Ns[8]
    Hy[3] = 0.75C₅*Ns[5]*S₅ + 0.75C₈*Ns[8]*S₈
    Hy[4] = (-3C₅*Ns[5]*l₂₃ + 3C₆*Ns[6]*l₁₂) / (2l₁₂*l₂₃)
    Hy[5] = -Ns[2] + (1//16)*(4(C₅^2) - 8(S₅^2))*Ns[5] + (1//16)*(4(C₆^2) - 8(S₆^2))*Ns[6]
    Hy[6] = 0.75C₅*Ns[5]*S₅ + 0.75C₆*Ns[6]*S₆
    Hy[7] = (-3C₆*Ns[6]*l₃₄ + 3C₇*Ns[7]*l₂₃) / (2l₂₃*l₃₄)
    Hy[8] = -Ns[3] + (1//16)*(4(C₆^2) - 8(S₆^2))*Ns[6] + (1//16)*(4(C₇^2) - 8(S₇^2))*Ns[7]
    Hy[9] = 0.75C₆*Ns[6]*S₆ + 0.75C₇*Ns[7]*S₇
    Hy[10] = (-3C₇*Ns[7]*l₄₁ + 3C₈*Ns[8]*l₃₄) / (2l₃₄*l₄₁)
    Hy[11] = -Ns[4] + (1//16)*(4(C₇^2) - 8(S₇^2))*Ns[7] + (1//16)*(4(C₈^2) - 8(S₈^2))*Ns[8]
    Hy[12] = 0.75C₇*Ns[7]*S₇ + 0.75C₈*Ns[8]*S₈

    return Hx,Hy
end

# Berechnung der Gradienten von Hx und Hy für ein DKQ Element e
function makeDKQGradients(e)
    HxFace, HyFace = makeDKQFunctions(e)
    Hx = MappingFromComponents(HxFace...)  
    Hy = MappingFromComponents(HyFace...) 
    ∇Hx = MMJMesh.Mathematics.TransposeMapping(jacobian(Hx)) 
    ∇Hy = MMJMesh.Mathematics.TransposeMapping(jacobian(Hy))
    return  ∇Hx, ∇Hy
end


