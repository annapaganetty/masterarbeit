function plotH(
    f::Vector{Any}, title
)
    n = length(f)
    cnt = 1
    ncol = Int(ceil(sqrt(n)))
    nrow = Int(ceil(n / ncol))
    fig = Figure()
    
    for i = 1:ncol, j = 1:nrow
        if cnt <= n
            Makie.hidedecorations!(Makie.Axis3(fig[i, j], protrusions=0))
            fplot3d!(f[cnt])
            cnt += 1
        end
    end

    return fig
end

# function fplot3d(
#     fs::AbstractArray{<:AbstractMapping}; colormap=MakieCore.theme(:colormap), fig=Makie.Figure()
# )
#     n = length(fs)
#     cnt = 1
#     ncol = Int(ceil(sqrt(n)))
#     nrow = Int(ceil(n / ncol))
#     for i = 1:ncol, j = 1:nrow
#         if cnt <= n
#             Makie.hidedecorations!(Makie.Axis3(fig[i, j], protrusions=0))
#             fplot3d!(fs[cnt], colormap=colormap)
#             cnt += 1
#         end
#     end
#     return fig
# end