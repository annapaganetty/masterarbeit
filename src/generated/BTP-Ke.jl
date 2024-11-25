function btpKe(p)
    function keFunc(e)
        E = p.E
        h = p.h
        ν = p.ν

        Hx = btpHx(e)
        Hy = btpHy(e)
      
        # Umrechnungsfaktoren Jacobi Matrix
        j11,j12,j21,j22,d = jacobianMatrix(e)

        
        @variables  h, ν,E ;
        D = E*h^3 / 12*(1-ν^2)

        var = Symbolics.variables(:x,1:2)
        ∂ξ(u) = Symbolics.derivative.(u,x₁)
        ∂η(u) = Symbolics.derivative.(u,x₂)

        B1 =  j11 * ∂ξ(Hx) + j12 * ∂η(Hx)
        B2 =  j21 * ∂ξ(Hy) + j22 * ∂η(Hy)
        B3 =  j11 * ∂ξ(Hy) + j12 * ∂η(Hy) + j21 * ∂ξ(Hx) + j22 * ∂η(Hx)
        Be = [B1 B2 B3]'
        Be2 = [B1 + ν * B2 ν * B1 + B2 (1- ν)/2 * B3]'

        # Funktioniert noch nicht ab hier!!!
        # D * integrate(Be' * Be2 * d, QHat)
        # aestd(u,v) = integrate(Be1std(u) ⋅ Be2std(v), QHat)
        # Ke = (simplifyx.([aestd(n1, n2) for n1 ∈ H4, n2 ∈ H4]))

        
        return Be
    end
    return keFunc
end 