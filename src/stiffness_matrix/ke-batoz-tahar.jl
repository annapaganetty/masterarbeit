using MMJMesh.Geometries
# Gauss points for numerical integration
const gaussWeights = ones(4)
const gaussPoints = 1 / sqrt(3) * [[-1, -1], [1, -1], [1, 1], [-1, 1]]

# Shape functions and gradients
V = [ -1 1 1 -1; -1 -1 1 1]
const N = MappingFromComponents(lagrangeelement(V)...)

# Element matrix
function plateKe(p)
    function keFunc(e)
        D = p.E*p.h^3 / 12*(1-p.ν^2) * [1 p.ν 0; p.ν 1 0; 0 0 (1-p.ν)/2]
        Ke = zeros(12,12)
        # Jacobimatrix des betrachteten Elements (muss noch transponiert werden s. Zeile 28 und 29 J') 
        jF = jacobian(parametrization(geometry(e)))

        Hx = MappingFromComponents(bMatrix(e)[2,:]...) # 12 Element Vektor mit Hx Funktionen 
        Hy = MappingFromComponents(bMatrix(e)[3,:]...)  # 12 Element Vektor mit Hy Funktionen 
        # 2 x 12 Matrix, oben Ableitung Hx nach ξ und unten nach η
        ∇ξN = MMJMesh.Mathematics.TransposeMapping(jacobian(Hx)) 
        # 2 x 12 Matrix, oben Ableitung Hy nach ξ und unten nach η
        ∇ηN = MMJMesh.Mathematics.TransposeMapping(jacobian(Hy))

        for (ξ, w) ∈ zip(gaussPoints, gaussWeights)
            # Jacobi matrix ausgewertet an der Stelle ξ
            J = jF(ξ)
            ∇ₓN = (inv(J') * ∇ξN(ξ))
            ∇yN = (inv(J') * ∇ηN(ξ)) 
            B = [∇ₓN[1,:]', ∇yN[2,:]', ∇yN[1,:]'+∇ₓN[2,:]']
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
function plateRe(q)
    function reFunc(e)
        p,a,b= _fsize(e)
        re = zeros(12)
        re[1]=(1/4)*a*b
        re[2]= 0
        re[3]= 0
        re[4]=(1/4)*a*b
        re[5]= 0
        re[6]= 0
        re[7]=(1/4)*a*b
        re[8]= 0
        re[9]= 0
        re[10]=(1/4)*a*b
        re[11]= 0
        re[12]= 0
        return re*q
    end
    return reFunc
end