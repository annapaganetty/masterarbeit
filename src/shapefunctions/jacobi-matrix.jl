# Jacobi-Matrix für 2D Elemente

function generateJacobi()

    @variables x1,x2,x3,x4,y1,y2,y3,y4;
    xe = [x1,x2,x3,x4]
    ye = [y1,y2,y3,y4]

    Njacobi = nodalbasis(makeelement(:lagrange, QHat, k=1))
    
    ∂xNjacobi = ∂x.(Njacobi)
    ∂yNjacobi = ∂y.(Njacobi)

    Jac11 = []
    Jac12 = []
    Jac21 = []
    Jac22 = []
    for i = 1:4 
        push!(Jac11,∂xNjacobi[i] * xe[i])
        push!(Jac12,∂xNjacobi[i] * ye[i])
        push!(Jac21,∂yNjacobi[i] * xe[i])
        push!(Jac22,∂yNjacobi[i] * ye[i])
    end 
    J11 = sum(Jac11)
    J12 = sum(Jac12)
    J21 = sum(Jac21)
    J22 = sum(Jac22)

    return J11,J12,J21,J22
end

#----------------------------------------------------------------
#       Ergebnis der oberen Funktion
#   0.25(x1 + x3) - 0.25(x2 + x4)x₂+-0.25(x1 + x4) + 0.25(x2 + x3), 
#   0.25(y1 + y3) - 0.25(y2 + y4)x₂+-0.25(y1 + y4) + 0.25(y2 + y3), 
#   0.25(x1 + x3) - 0.25(x2 + x4)x₁+-0.25(x1 + x2) + 0.25(x3 + x4), 
#   0.25(y1 + y3) - 0.25(y2 + y4)x₁+-0.25(y1 + y2) + 0.25(y3 + y4)
#----------------------------------------------------------------


# Einträge der inversen Jacobi Matrix eines Elements
function jacobianMatrix(e)
    @variables x₁, x₂;

    xy = coordElement(e)

    J11 = (0.25(xy[1,1] + xy[3,1]) - 0.25(xy[2,1] + xy[4,1]))x₂ -0.25(xy[1,1] + xy[4,1]) + 0.25(xy[2,1] + xy[3,1])
    J12 = (0.25(xy[1,2] + xy[3,2]) - 0.25(xy[2,2] + xy[4,2]))x₂ -0.25(xy[1,2] + xy[4,2]) + 0.25(xy[2,2] + xy[3,2])
    J21 = (0.25(xy[1,1] + xy[3,1]) - 0.25(xy[2,1] + xy[4,1]))x₁ -0.25(xy[1,1] + xy[2,1]) + 0.25(xy[3,1] + xy[4,1])
    J22 = (0.25(xy[1,2] + xy[3,2]) - 0.25(xy[2,2] + xy[4,2]))x₁ -0.25(xy[1,2] + xy[2,2]) + 0.25(xy[3,2] + xy[4,2])
    
#--------------------------------------------------------------------------
#               Determinante und Komponenten der inversen Jacobi-Matrix
#--------------------------------------------------------------------------

    d = J11 * J22 - J21 * J12
    j11 = J22/d
    j12 = -J12/d
    j21 = -J21/d
    j22 = J11/d
    return j11, j12, j21, j22, d 
end
