function btpHx(e)
        l₁₂,l₂₃,l₃₄,l₄₁,S₅,S₆,S₇,S₈,C₅,C₆,C₇,C₈ = geoH(e)
    
        @variables x₁,x₂;
        
        N = Array{Any}(undef,8)
        N[1] = -0.25 *x₁^2*x₂-0.25*x₁*x₂^2+0.25*x₁^2+0.25*x₁*x₂+0.25*x₂^2-0.25
        N[2] = -0.25*x₁^2*x₂+0.25*x₁*x₂^2+0.25*x₁^2-0.25*x₁*x₂+0.25*x₂^2-0.25
        N[3] = 0.25*x₁^2*x₂+0.25*x₁*x₂^2+0.25*x₁^2+0.25*x₁*x₂+0.25*x₂^2-0.25
        N[4] = 0.25*x₁^2*x₂-0.25*x₁*x₂^2+0.25*x₁^2-0.25*x₁*x₂+0.25*x₂^2-0.25
        N[5] = 0.5*x₁^2*x₂+-0.0*x₁*x₂^2-0.5*x₁^2-0.5*x₂+0.5
        N[6] = -0.0*x₁^2*x₂-0.5*x₁*x₂^2-0.5*x₂^2+0.5*x₁+0.5
        N[7] = -0.5*x₁^2*x₂-0.5x₁^2+0.5*x₂+0.5
        N[8] = 0.5*x₁*x₂^2-0.5*x₂^2-0.5*x₁+0.5

        Hx = Array{Any}(undef,12)
        Hx[1] = (-24.0*N[5]*S₅*l₂₃*l₃₄*l₄₁ + 24.0*N[8]*S₈*l₁₂*l₂₃*l₃₄) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[2] = (-12.0C₅*N[5]*S₅*l₁₂*l₂₃*l₃₄*l₄₁ - 12.0C₈*N[8]*S₈*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[3] = (16.0N[1]*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₅^2)*N[5]*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₈^2)*N[8]*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N[5]*(S₅^2)*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N[8]*(S₈^2)*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[4] = (24.0N[5]*S₅*l₂₃*l₃₄*l₄₁ - 24.0N[6]*S₆*l₁₂*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[5] = (-12.0C₅*N[5]*S₅*l₁₂*l₂₃*l₃₄*l₄₁ - 12.0C₆*N[6]*S₆*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[6] = (16.0N[2]*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₅^2)*N[5]*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₆^2)*N[6]*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N[5]*(S₅^2)*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N[6]*(S₆^2)*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[7] = (24.0N[6]*S₆*l₁₂*l₃₄*l₄₁ - 24.0N[7]*S₇*l₁₂*l₂₃*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[8] = (-12.0C₆*N[6]*S₆*l₁₂*l₂₃*l₃₄*l₄₁ - 12.0C₇*N[7]*S₇*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[9] = (16.0N[3]*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₆^2)*N[6]*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₇^2)*N[7]*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N[6]*(S₆^2)*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N[7]*(S₇^2)*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[10] = (24.0N[7]*S₇*l₁₂*l₂₃*l₄₁ - 24.0N[8]*S₈*l₁₂*l₂₃*l₃₄) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[11] = (-12.0C₇*N[7]*S₇*l₁₂*l₂₃*l₃₄*l₄₁ - 12.0C₈*N[8]*S₈*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)
        Hx[12] = (16.0N[4]*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₇^2)*N[7]*l₁₂*l₂₃*l₃₄*l₄₁ + 8.0(C₈^2)*N[8]*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N[7]*(S₇^2)*l₁₂*l₂₃*l₃₄*l₄₁ - 4.0N[8]*(S₈^2)*l₁₂*l₂₃*l₃₄*l₄₁) / (16l₁₂*l₂₃*l₃₄*l₄₁)

    return expand.(Hx)
end 