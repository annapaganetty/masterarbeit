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

function printFunc(L)
    # lx = length(L)

    for i = 1:4
        name = L"\mathbf{N}^"
        s1 = name.s[2:end-1]
        s2 = latexify(simplify.(L[i], expand=true), env=:raw)
        return L"%$s1 = %$s2"
    end
    # for i = 1:lx
    #     println("L[", i, "] = ", L[i])
    # end
end
