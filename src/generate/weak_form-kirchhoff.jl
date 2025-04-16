@variables  a,b, h, ν,E ;

function weakform(H4,model::String)
    if model == "standard"
        ∂1(u) =  (∂x(∂x(u)))
        ∂2(u) =  (∂y(∂y(u)))
        ∂3(u) =  2*(∂x(∂y(u)))
        Be1std(u) = [∂1(u), ∂2(u), ∂3(u)]
        Be2std(u) = [∂1(u) + ν * ∂2(u), ν * ∂1(u) + ∂2(u),(1- ν)/2 * ∂3(u)]
        aestd(u,v) = integrate(Be1std(u) ⋅ Be2std(v), (0 .. a) , (0 .. b))
        Ke = (simplifyx.([aestd(n1, n2) for n1 ∈ H4, n2 ∈ H4]))
        return Ke
    elseif model == "hartmann"
        κxx(u) = (∂x(∂x(u)))
        κyy(u) = (∂y(∂y(u)))
        κxy(u) = (∂x(∂y(u)))
        Be1hart(u) = [κxx(u), κyy(u), 2 * κxy(u)]
        Be2hart(u) = [κxx(u), κyy(u), κxy(u)]
        aehart(u,v) = integrate(Be1hart(u) ⋅ Be2hart(v), (0 .. a) , (0 .. b))
        Ke = (simplifyx.([aehart(n1, n2) for n1 ∈ H4, n2 ∈ H4]))
        return Ke
    else
        println("Dieses Modell existiert nicht oder wurde noch nicht programmiert.")
    end
end

function weakformRe(H4)
    behart(w) = simplifyx(integrate(w, 0 .. a, 0 .. b))
    re = (simplifyx.([behart(n1) for n1 ∈ H4 ]))
    return re
end