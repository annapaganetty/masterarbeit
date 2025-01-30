# Gauss points for numerical integration
const gaussWeights = ones(4)
const gaussPoints = 1 / sqrt(3) * [[-1, -1], [1, -1], [1, 1], [-1, 1]]

# Shape functions and gradients
V = [ -1 1 1 -1; -1 -1 1 1]
const Ni = lagrangeelement(V)
const ∇N = [∂x(Ni[1]) ∂x(Ni[2]) ∂x(Ni[3]) ∂x(Ni[4]); ∂y(Ni[1]) ∂y(Ni[2]) ∂y(Ni[3]) ∂y(Ni[4])]

# Element matrix
function heatKe(p)
    function keFunc(e)
        ν = p.ν
        E = p.E
        h = p.h
        D = E*h^3 / 12*(1-ν^2) * [1 ν 0; ν 1 0; 0 0 (1-ν)/2]

        Ke = zeros(12,12)
        xy =coordMatrix(e)
        jF = ∇N * xy

        Hxserendip = btpHxNew(e)
        Hyserendip = btpHyNew(e)


        Hxderivξ = []
        Hxderivη = []
        Hyderivξ = []
        Hyderivη = []
        for i = 1:12
            push!(Hxderivξ, ∂x(Hxserendip[i]))
            push!(Hxderivη, ∂y(Hxserendip[i]))
            push!(Hyderivξ, ∂x(Hyserendip[i]))
            push!(Hyderivη, ∂y(Hyserendip[i]))
        end

        for (ξ, w) ∈ zip(gaussPoints, gaussWeights)
            J = [jF[1,1](ξ) jF[1,2](ξ); jF[2,1](ξ) jF[2,2](ξ)]
            Jinv = inv(J)
            B =     [hcat([[sum([Jinv[1,1] * Hxderivξ[i](ξ) + Jinv[1,2] * Hxderivη[i](ξ)])] for i = 1:12]...);
                    hcat([[sum([Jinv[2,1] * Hyderivξ[i](ξ) + Jinv[2,2] * Hyderivη[i](ξ)])] for i = 1:12]...);
                    hcat([[sum([Jinv[1,1] * Hyderivξ[i](ξ) + Jinv[1,2] * Hyderivη[i](ξ) + Jinv[2,1] * Hxderivξ[i](ξ) + Jinv[2,2] * Hxderivη[i](ξ)])] for i = 1:12]...)]
            Ke += w * B' * D * B * det(J)
        end
        return Ke
    end
    return keFunc
end

# Element vector
function heatRe(q)
    function reFunc(e)
        a,b = ab(e)
        re = zeros(12)
        re[1]=(1//4)*a*b
        re[2]= 0
        re[3]= 0
        re[4]=(1//4)*a*b
        re[5]= 0
        re[6]= 0
        re[7]=(1//4)*a*b
        re[8]= 0
        re[9]= 0
        re[10]=(1//4)*a*b
        re[11]= 0
        re[12]= 0
        return re*q
    end
    return reFunc
end