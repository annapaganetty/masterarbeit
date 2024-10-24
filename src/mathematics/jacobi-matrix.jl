# Jacobi-Matrix für 2D Elemente

Njacobi = nodalbasis(makeelement(:lagrange, QHat, k=1))
xe = Symbolics.variables(:xe,1:4)
ye = Symbolics.variables(:ye,1:4)
∂xNjacobi = ∂x.(Njacobi)
∂yNjacobi = ∂y.(Njacobi)

Jac11 = []
Jac12 = []
Jac21 = []
Jac22 = []
for i = 1:4 
    push!(Jac11,∂xNjacobi[i]* xe[i])
    push!(Jac12,∂xNjacobi[i]* ye[i])
    push!(Jac21,∂yNjacobi[i]* xe[i])
    push!(Jac22,∂yNjacobi[i]* ye[i])
end 
J11 = sum(Jac11)
J12 = sum(Jac12)
J21 = sum(Jac21)
J22 = sum(Jac22)

# _______________________________________________________________________________
#
#               Determinante und Komponenten der inversen Jacobi-Matrix
# _______________________________________________________________________________

d = J11 * J22 - J21 * J12;
j11 = J22/d;
j12 = -J12/d;
j21 = -J21/d;
j22 = J11/d;