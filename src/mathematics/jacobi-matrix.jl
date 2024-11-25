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
