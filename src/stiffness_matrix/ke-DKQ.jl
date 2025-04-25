using MMJMesh.Geometries
# Gauss points for numerical integration
const gaussWeights = ones(4)
const gaussPoints = 1 / sqrt(3) * [[-1, -1], [1, -1], [1, 1], [-1, 1]]

# Shape functions and gradients
V = [ -1 1 1 -1; -1 -1 1 1]
const N = MappingFromComponents(lagrangeelement(V)...)

# Element matrix
function DKQKe(p)
    function keFunc(e)
        D = (p.E*p.h^3) / (12*(1-p.ν^2)) * [1 p.ν 0; p.ν 1 0; 0 0 (1-p.ν)/2]
        Ke = zeros(12,12)
        # Jacobimatrix des betrachteten Elements (muss noch transponiert werden s. Zeile 28 und 29 J') 
        jF = jacobian(parametrization(geometry(e)))
        HxFace, HyFace = makeDKQFunctions(e)
        Hx = MappingFromComponents(HxFace...)  
        Hy = MappingFromComponents(HyFace...)  # 12 Element Vektor mit Hy Funktionen 
        # 2 x 12 Matrix, oben Ableitung Hx nach ξ und unten nach η
        ∇ξηHx = MMJMesh.Mathematics.TransposeMapping(jacobian(Hx)) 
        ∇ξηHy = MMJMesh.Mathematics.TransposeMapping(jacobian(Hy))

        for (ξ, w) ∈ zip(gaussPoints, gaussWeights)
            # Jacobi matrix ausgewertet an der Stelle ξ
            J = jF(ξ)
            ∇ˣʸHx = (inv(J') * ∇ξηHx(ξ))
            ∇ˣʸHy = (inv(J') * ∇ξηHy(ξ)) 
            B = [∇ˣʸHx[1,:]', ∇ˣʸHy[2,:]', ∇ˣʸHy[1,:]'+∇ˣʸHx[2,:]']
            Ke += w * B' * D * B * det(J)
        end
        return Ke
    end
    return keFunc
end

 
#------------------------------------------------------------------------------------------
# N = MappingFromComponents((lagrangeelement(V))...)
# ->  ist eine Funktion, die einen Vektor mit den Ergebnissen von den (Lagrange-) Funktionen ausgibt 
#     Bsp.:   N(1,2) gibt einen Vektor mit den Ergebnissen der Funktionen für x1 = 1 und x2 = 2 aus

# jacobian(N) = 
# ->  gibt 4 x 2 Matrix aus mit den Ableitungen der (Lagrange-) Funktionen 
#     1. Spalte = Ableitungen nach x1
#     2. Spalte = Ableitungen nach x2

# MMJMesh.Mathematics.TransposeMapping(jacobian(NPaga))
# ->  gibt transponierte Matrix von jacobian(NPaga) aus
#     1. Spalte = Gradient Funktion 1
#     2. Spalte = Gradient Funktion 2
#     3. Spalte = Gradient Funktion 3
#     4. Spalte = Gradient Funktion 4
#------------------------------------------------------------------------------------------


# Element vector
function DKQRe(q)
    function reFunc(e)
        re = zeros(12)
        V = [ -1 1 1 -1; -1 -1 1 1]
        H4= lagrangeelement(V)

        jac = jacobi(e)
        DetJac = jac[1,1] * jac[2,2] - jac[2,1] * jac[1,2]
        re[1] = integrate(DetJac * H4[1], -1 .. 1, -1 .. 1)
        re[4] = integrate(DetJac * H4[2], -1 .. 1, -1 .. 1)
        re[7] = integrate(DetJac * H4[3], -1 .. 1, -1 .. 1)
        re[10] = integrate(DetJac * H4[4], -1 .. 1, -1 .. 1)
        return q * re
    end
    return reFunc
end