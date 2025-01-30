function plotH(
    f::AbstractArray{<:AbstractMapping};fig=Makie.Figure()
)

# AbstractArray{<:AbstractMapping}
    n = length(f)
    cnt = 1
    ncol = Int(ceil(sqrt(n)))
    nrow = Int(ceil(n / ncol))
    
    for i = 1:ncol, j = 1:nrow
        if cnt <= n
            if typeof(f[cnt]) != Float64
                Makie.hidedecorations!(Makie.Axis3(fig[i, j], protrusions=2))
                fplot3d!(f[cnt])
                cnt += 1
            else
                cnt += 1 
            end
        end
    end
    return fig
end
