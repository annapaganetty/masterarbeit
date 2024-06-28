include("element_stiffness_matrix.jl")

function plateKe(p)
    function keFunc(e)

        x1 = coordinates(e, 1)
        x2 = coordinates(e, 2)
        x3 = coordinates(e, 3)
        x4 = coordinates(e, 4)
        a = x2[1] - x1[1]       # Länge in xi-Richtung
        b = x3[2] - x1[2]       # Länge in eta-Richtung

        KeElement = Kelement(p,a,b)

        return KeElement
    end
    return keFunc
end

function plateRe(q)
    function reFunc(e)
        x1 = coordinates(e, 1)
        x2 = coordinates(e, 2)
        x3 = coordinates(e, 3)
        x4 = coordinates(e, 4)
        a = x2[1] - x1[1]       # Länge in xi-Richtung
        b = x3[2] - x1[2]       # Länge in eta-Richtung

        Fz = 1/4 * a * b * q
        Mx = 1/24 * a^2 * b * q
        My = 1/24 * a * b^2 * q
        re = [Fz, Mx, My, Fz, -Mx, My, Fz, -Mx, -My, Fz, Mx, -My]

        return re
    end
    return reFunc
end