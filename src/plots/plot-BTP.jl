# Verformung
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
        return sum(wHat[idxs] .* Hy)
    end
end

# Plot Verformung
function plotwBTP(
    m, wHat;
    zs=1000,
    w=250, h=200, title="",
    edgesvisible=false, nodesvisible=false, edgelinewidth=0.2,
    featureedgelinewidth = 0.5,
    mesh=5,
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
    mesh=5,
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
    mesh=5,
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

function maketitle(p, title)
	min, max = string.(round.(valuerange(p), digits = 2))
	return title * " | min: " * min * " | max: " * max
end

function plotrBTP(m, result, title, cr, npoints = 15; nodal = false, a3d)
		fig = Figure(size = (600, 600))
		if a3d == true
			ax = Axis3(fig[1, 1])
			zscale = 1
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