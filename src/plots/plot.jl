function mkfig2d(
    ;title=""
)
    fig = Figure(;size = (360, 288),linewidth = 0.5,fontsize = 12,font="arial")
    ax = Axis(fig[1, 1],aspect=DataAspect(),  title=title, titlefont="arial",xlabelfont = "arial",ylabelfont ="arial")
    hidedecorations!(ax)
    hidespines!(ax)
    return fig
end


function mkfig3d(
    ;title ="")
    fig = Figure(;size = (500,400),linewidth = 0.5,fontsize = 12,font="arial")
    ax = Axis3(
        fig[1, 1],
        aspect=:data,
        title=title,
        viewmode=:stretch,
        perspectiveness=0.5,
        limits=(nothing, nothing, nothing),
        protrusions=0,
        titlefont = "arial",
        xlabelfont = "arial",
        ylabelfont = "arial",
        zlabelfont = "arial")
    hidedecorations!(ax)
    hidespines!(ax)
    return fig
end

function plotmesh(m;title)
    fig = mkfig2d(;title = title)
    mplot!(
    m,
    faceplotzscale= 0.05,
    faceplotmesh=5,
    edgesvisible=false, 
    edgelinewidth=2.5,
    nodesvisible=true,
    featureedgelinewidth=0.2,
    color=5,
    colorrange=Makie.automatic,
    colormap=Makie.theme(:colormap)
    )
    return fig
end

function makewe(wHat;conforming=false)
    V = [-1 1 1 -1; -1 -1 1 1]
    if conforming ==true
        H4 = hermiteelement(V;conforming=true)
        return face -> begin                        # face = element
            idxs = idxDOFs(nodeindices(face), 4)    # Freiheitsgrade der Knoten des Elements
            _, a, b = _fsize(face)                  # legt a und b fest = Länge der Seiten eines Elements
            t = repeat([1, a / 2, b / 2, a * b / 4], 4)
            return sum(wHat[idxs] .* t .* H4) # TODO make dot work
        end
    else
        H4 = hermiteelement(V;conforming=false)
        # H4 = serendipityelement(V)
        return face -> begin                        # face = element
            idxs = idxDOFs(nodeindices(face), 3)    # Freiheitsgrade der Knoten des Elements
            _, a, b = _fsize(face)                  # legt a und b fest = Länge der Seiten eines Elements
            t = repeat([1,a / 2, b / 2], 4)
            s = sum(wHat[idxs] .* t .* H4)
            return s
        end
    end
end



# Plot der Verformung
function plotw(
    m, wHat;conforming = true,
    zs=150,
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
        m, makewe(wHat,conforming = conforming),
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

#____________________________________________________________
# function plotsol(params,model,n)
#     wHat = plate(m, p, model::String)
#     m, wHat = plate(params, model,n);
#     plotw(
#         m, wHat, 
#         w=500, h=500,
#         zs=1000*maximum(wHat), # plotw scales by 1 / maximum(wHat)
#         edgesvisible=true, edgelinewidth=0.1,
#         limits=(nothing,nothing,(0,1.15))
#     )
# end
#____________________________________________________________

function plotr(m, result, title, cr, npoints = 15; nodal = false, a3d)
	# if false
		fig = Figure(size = (1200, 800))
		if a3d == true
			ax = Axis3(fig[1, 1])
			zscale = 1
            
		else
			ax = Axis(fig[1, 1], aspect = DataAspect())
			zscale = 0
            println("klappt")
		end

		warpnodes = nothing

		if nodal == true
			r = nodalresult(m, result)
			if a3d
				warpnodes = r
			end
		else
			r = result
            println("klappt")
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
	# else
	# 	return L"Zeitweise außer Betrieb"
	# end
end

function maketitle(p, title)
	min, max = string.(round.(valuerange(p), digits = 2))
	return title * " | min: " * min * " | max: " * max
end

function valuerange(p)
	values = p.plots[1].kw[:color]
	min, max = extrema(values)
	return min, max
end