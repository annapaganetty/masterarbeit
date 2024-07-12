function mkfig(
    ; a3d=true, w=600, h=400, title="",
    limits=(nothing, nothing, nothing)
)
    fig = Figure(size=(w, h),fontsize = 2, linewidth = 0.2)
    if a3d
        GLMakie.activate!()
        ax = Axis3(
            fig[1, 1],
            aspect=:data,
            title=title,
            viewmode=:stretch,
            perspectiveness=0.2,
            limits=limits,
            protrusions=0
        )
    else
        CairoMakie.activate!()
        ax = Axis(fig[1, 1], aspect=DataAspect(), title=title)
    end
    hidedecorations!(ax)
    hidespines!(ax)
    return fig
end

function makewe(wHat)
    return face -> begin
        idxs = idxDOFs(nodeindices(face), 3)
        _, a, b = _fsize(face)
        t = repeat([ a / 2, b / 2, a * b / 4], 4)
        return sum(wHat[idxs] .* t .* H4) # TODO make dot work
    end
end

function plotw(
    m, wHat;
    zs=2,
    a3d=true, w=600, h=400, title="",
    edgesvisible=false, nodesvisible=false, edgelinewidth=2.5,
    mesh=5,
    colorrange=Makie.automatic,
    colormap=Makie.theme(:colormap),
    limits=(nothing, nothing, nothing)
)
    fig = mkfig(a3d=a3d, w=w, h=h, title=title, limits=limits)
    mplot!(
        m, makewe(wHat),
        faceplotzscale=zs / maximum(wHat),
        faceplotmesh=mesh,
        edgesvisible=edgesvisible, edgelinewidth=edgelinewidth,
        nodesvisible=nodesvisible,
        color=3,
        colorrange=colorrange,
        colormap=colormap
    )
    fig
end

function plotsol(params,n)
    m, wHat = plate(params, n);
    plotw(
        m, wHat, 
        w=1200, h=650,
        zs=2400*maximum(wHat), # plotw scales by 1 / maximum(wHat)
        edgesvisible=true, edgelinewidth=4,
        limits=(nothing,nothing,(0,1.15))
    )
end

function plotr(m, result, title, cr, npoints = 15; nodal = false, a3d)
	if false
		fig = Figure(size = (1200, 800))
		if a3d
			ax = Axis3(fig[1, 1])
			zscale = 1
		else
			ax = Axis(fig[1, 1], aspect = DataAspect())
			zscale = 0
		end

		warpnodes = nothing

		if nodal
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
	else
		return L"Zeitweise außer Betrieb"
	end
end