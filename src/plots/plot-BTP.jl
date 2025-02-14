# Plot der H-Funktionen für ein Element

function plotH(f::Vector{Any};fig=Makie.Figure())
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


# Verformung Bogner-Fox-Schmitt
function makeweBFS(wHat)
    V = [-1 1 1 -1; -1 -1 1 1]
    H4 = hermiteelement(V;conforming=true)
    return face -> begin
        idxs = idxDOFs(nodeindices(face), 4) 
        _, a, b = _fsize(face)
		t = repeat([1, a / 2, b / 2, a * b / 4], 4)
        return sum(wHat[idxs] .* t .* H4)
    end
end

# Verformung bilinear
function makeweBTP(wHat)
    V = [-1 1 1 -1; -1 -1 1 1]
    H4 = lagrangeelement(V)
    return face -> begin
        idxs = idxDOFs(nodeindices(face), 3)[1:3:end]  
        return sum(wHat[idxs] .* H4)
    end
end

# Verdrehung theta x
function makeThetaxBTP(wHat)
    return face -> begin
        idxs = idxDOFs(nodeindices(face), 3)
        Hx = btpHx(face)
        return sum(wHat[idxs] .* Hx)
    end
end
# Verdrehung theta y
function makeThetayBTP(wHat)
    return face -> begin
        idxs = idxDOFs(nodeindices(face), 3)
        Hy = btpHy(face)
        println("ThetaY = ",(sum(wHat[idxs] .* Hy)))
        return sum(wHat[idxs] .* Hy)
    end
end

# Plot Verformung
function plotwBTP(
    m, wHat;
    zs=100,
    w=600, h=500, title="",
    edgesvisible=false, nodesvisible=false, edgelinewidth=0.2,
    featureedgelinewidth = 0.5,
    mesh=0,
    colorrange=Makie.automatic,
    colormap=Makie.theme(:colormap),
    limits=(nothing, nothing, nothing)
)
    fig = mkfig3d(title=title)
    mplot!(
        m, makeweBTP(wHat),
        faceplotzscale=zs,
        faceplotmesh=mesh,
        edgesvisible=edgesvisible, 
        edgelinewidth=edgelinewidth,
        nodesvisible=nodesvisible,
        featureedgelinewidth=featureedgelinewidth,
        color=5,
        colorrange=colorrange,
        colormap=colormap,
        limits = limits
    )
    fig
end
# Plot Verdrehung ThetaX
function plotThetaxBTP(
    m, wHat;
    zs=1000,
    w=250, h=200, title="",
    edgesvisible=false, nodesvisible=false, edgelinewidth=0.2,
    featureedgelinewidth = 0.5,
    mesh=0,
    colorrange=Makie.automatic,
    colormap=Makie.theme(:colormap),
    limits=(nothing, nothing, nothing)
)
    fig = mkfig3d(title=title)
    mplot!(
        m, makeThetaxBTP(wHat),
        faceplotzscale=zs,
        faceplotmesh=mesh,
        edgesvisible=edgesvisible, 
        edgelinewidth=edgelinewidth,
        nodesvisible=nodesvisible,
        featureedgelinewidth=featureedgelinewidth,
        color=5,
        colorrange=colorrange,
        colormap=colormap,
        limits = limits
    )
    fig
end

# Plot Verdrehung ThetaY
function plotThetayBTP(
    m, wHat;
    zs=1000,
    w=250, h=200, title="",
    edgesvisible=false, nodesvisible=false, edgelinewidth=0.2,
    featureedgelinewidth = 0.5,
    mesh=0,
    colorrange=Makie.automatic,
    colormap=Makie.theme(:colormap),
    limits=(nothing, nothing, nothing)
)
    fig = mkfig3d(title=title)
    mplot!(
        m, makeThetayBTP(wHat),
        faceplotzscale=zs,
        faceplotmesh=mesh,
        edgesvisible=edgesvisible, 
        edgelinewidth=edgelinewidth,
        nodesvisible=nodesvisible,
        featureedgelinewidth=featureedgelinewidth,
        color=5,
        colorrange=colorrange,
        colormap=colormap,
        limits = limits
    )
    fig
end

# Plot Basisfunktionen
function plotBasisfunc(
    m, result;
    zs=2,
    w=600, h=500, title="",
    edgesvisible=false, nodesvisible=false, edgelinewidth=0.2,
    featureedgelinewidth = 0.5,
    mesh=5,
    colorrange=Makie.automatic,
    colormap=Makie.theme(:colormap),
    limits=(nothing, nothing, nothing)
)
    fig = Figure(;size = (600,500),linewidth = 0.5,fontsize = 12,font="calibri")
    ax = Axis3(
        fig[1, 1],
        aspect=:data,
        title=title,
        viewmode=:stretch,
        perspectiveness=0.5,
        limits=(nothing, nothing, nothing),
        protrusions=0)
    hidedecorations!(ax)
    hidespines!(ax)
    mplot!(
        m, result,
        faceplotzscale=zs,
        faceplotmesh=mesh,
        edgesvisible=edgesvisible, 
        edgelinewidth=edgelinewidth,
        nodesvisible=nodesvisible,
        featureedgelinewidth=featureedgelinewidth,
        color=5,
        colorrange=colorrange,
        colormap=colormap,
        limits = limits
    )
    fig
end

function maketitle(p, title)
	min, max = string.(round.(valuerange(p), digits = 2))
	return title * " | min: " * min * " | max: " * max
end

function plotrBTP(m, result, title, cr, npoints = 15; nodal, a3d)
		fig = Figure(size = (600, 600))
		if a3d == true
			ax = Axis3(fig[1, 1])
			zscale = 1000
		else
			ax = Axis(fig[1, 1], aspect = DataAspect())
			zscale = 0
		end

		warpnodes = nothing

		if nodal == true
			r = nodalresult(m, result)
			if a3d
				warpnodes = r
			end
		else
			r = result
		end

		p = mplot!(
			m, r, edgesvisible = a3d,
			nodewarp = warpnodes,
			faceplotzscale = zscale, faceplotnpoints = npoints,
			colorrange = cr,
		)

		if !a3d
			mplot!(m, edgesvisible = false, facesvisible = false)
		end

		Colorbar(fig[1, 2], p)
		hidespines!(ax)
		hidedecorations!(ax)
		ax.title = maketitle(p, title)

		return fig
end