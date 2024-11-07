#   ___________________________________________________________________________

#           generieren der Steifigkeitsmatrix und des Lastvektors

#   ___________________________________________________________________________

function generateH(Hx,Hy)
    lx = size(Hx,1)
    ly = size(Hy,1)

    for i = 1:lx
        println("Hx[", i, "] = ", Hx[i])
    end
    for i = 1:ly
        println("Hy[", i, "] = ", Hy[i])
    end
end
