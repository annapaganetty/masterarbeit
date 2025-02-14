# Jacobi-Matrix für 2D Elemente

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
    
# _______________________________________________________________________________
#               Determinante und Komponenten der inversen Jacobi-Matrix
# _______________________________________________________________________________

    d = J11 * J22 - J21 * J12
    j11 = J22/d
    j12 = -J12/d
    j21 = -J21/d
    j22 = J11/d
    return j11, j12, j21, j22, d 
end
