# Gauss points for numerical integration
const gaussWeights = ones(4)
const gaussPoints = 1 / sqrt(3) * [[-1, -1], [1, -1], [1, 1], [-1, 1]]

# Shape functions and gradients
V = [ -1 1 1 -1; -1 -1 1 1]
const Ni = lagrangeelement(V)
const ∇N = [∂x(Ni[1]) ∂x(Ni[2]) ∂x(Ni[3]) ∂x(Ni[4]); ∂y(Ni[1]) ∂y(Ni[2]) ∂y(Ni[3]) ∂y(Ni[4])]

# Element matrix
function plateKe(p)
    function keFunc(e)
        D = p.E*p.h^3 / 12*(1-p.ν^2) * [1 p.ν 0; p.ν 1 0; 0 0 (1-p.ν)/2]

        Ke = zeros(12,12)
        xy = coordMatrix(e)
        jF = ∇N * xy

        for (ξ, w) ∈ zip(gaussPoints, gaussWeights)
            J = [jF[1,1](ξ) jF[1,2](ξ); jF[2,1](ξ) jF[2,2](ξ)]
            Jinv = inv(J)
            # B-Matrix gemäß Gl. 13 aus Batoz und Tahar Paper
            B =    [hcat([[sum([Jinv[1,1] * ∂x(btpHx(e)[i])(ξ) + Jinv[1,2] * ∂y(btpHx(e)[i])(ξ)])] for i = 1:12]...);
                    hcat([[sum([Jinv[2,1] * ∂x(btpHy(e)[i])(ξ) + Jinv[2,2] * ∂y(btpHy(e)[i])(ξ)])] for i = 1:12]...);
                    hcat([[sum([Jinv[1,1] * ∂x(btpHy(e)[i])(ξ) + Jinv[1,2] * ∂y(btpHy(e)[i])(ξ) + Jinv[2,1] * ∂x(btpHx(e)[i])(ξ) + Jinv[2,2] * ∂y(btpHx(e)[i])(ξ)])] for i = 1:12]...)]
            Ke += w * B' * D * B * det(J)
        end
        return Ke
    end
    return keFunc
end

# Element vector
function plateRe(q)
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