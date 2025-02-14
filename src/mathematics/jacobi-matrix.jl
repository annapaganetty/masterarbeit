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

# Einträge der inversen Jacobi Matrix eines Elements
function jacobianMatrix(e)
    @variables x₁, x₂;
    x1 = coordinates(e, 1)[1]
    x2 = coordinates(e, 2)[1]
    x3 = coordinates(e, 3)[1]
    x4 = coordinates(e, 4)[1]
    y1 = coordinates(e, 1)[2]
    y2 = coordinates(e, 2)[2]
    y3 = coordinates(e, 3)[2]
    y4 = coordinates(e, 4)[2]

    J11 = (0.25(x1 + x3) - 0.25(x2 + x4))x₂ -0.25(x1 + x4) + 0.25(x2 + x3)
    J12 = (0.25(y1 + y3) - 0.25(y2 + y4))x₂ -0.25(y1 + y4) + 0.25(y2 + y3)
    J21 = (0.25(x1 + x3) - 0.25(x2 + x4))x₁ -0.25(x1 + x2) + 0.25(x3 + x4)
    J22 = (0.25(y1 + y3) - 0.25(y2 + y4))x₁ -0.25(y1 + y2) + 0.25(y3 + y4)
    
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
