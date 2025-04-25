function postprocessor(params, wHat,model::String)
    # Plate properties
    h = params.h
    E = params.E
    ν = params.ν
    D = E * h^3 / (12 * (1 - ν^2))

    if model == "kirchhoff_conforming"
        return (face, name) -> begin
    
            # Element size
            _, a, b = _fsize(face)

            # Element displacement function
            V = [ -1 1 1 -1; -1 -1 1 1]
            H4 = hermiteelement(V;conforming=true)
            idxs = idxDOFs(nodeindices(face), 4)
        
            t = repeat([1, a / 2, b / 2, a * b / 4], 4)
            we = sum(wHat[idxs] .* t .* H4)
    
            # Derivatives
            wx = (2 / a) * ∂x(we)
            wy = (2 / b) * ∂y(we)
            wxx = (2 / a)^2 * ∂xx(we)
            wyy = (2 / b)^2 * ∂yy(we)
            wxy = (2 / a) * (2 / b) * ∂xy(we)
            Δw = wxx + wyy

		    # Section forces (Altenbach et al. p176)
		    mx = -D * (wxx + ν * wyy)
		    my = -D * (ν * wxx + wyy)
		    mxy = -D * (1 - ν) * wxy
		    qx = -D * (2 / a) * ∂x(Δw)
		    qy = -D * (2 / b) * ∂y(Δw)

            # Quick return
            name == :w && return we
            # Return
	        name == :wx && return wx
	        name == :wy && return wy
            name == :wxx && return wxx
            name == :wyy && return wyy
            name == :wxy && return wxy
            name == :Δw && return Δw
    
            name == :mx && return mx
            name == :my && return my
            name == :mxy && return mxy
            name == :qx && return qx
            name == :qy && return qy
            # Unknown label
            error("Unkown function: ", name)
        end
	elseif model == "BTP"
        return (face, name) -> begin
            # Element displacement function
                # Indices
            idxs = idxDOFs(nodeindices(face), 3)
            V = [ -1 1 1 -1; -1 -1 1 1]
            Ni = lagrangeelement(V)

            HxFace, HyFace = makeDKQFunctions(face)

            we = sum(Ni .* wHat[idxs][1:3:end])
            βx = sum(HxFace .* wHat[idxs]) 
            βy = sum(HyFace .* wHat[idxs]) 

            jF = jacobian(parametrization(geometry(face)))
            Hx = MappingFromComponents(HxFace...)  
            Hy = MappingFromComponents(HyFace...) 
            ∇ξηHx = MMJMesh.Mathematics.TransposeMapping(jacobian(Hx)) 
            ∇ξηHy = MMJMesh.Mathematics.TransposeMapping(jacobian(Hy))
            Db = D * [1 ν 0; ν 1 0; 0 0 (1-ν)/2]

            function moment(name)
                    x -> begin
                        J = jF(x) 
                        ∇ˣʸHx = (inv(J') * ∇ξηHx(x))
                        ∇ˣʸHy = (inv(J') * ∇ξηHy(x)) 
                        B = [∇ˣʸHx[1,:]', ∇ˣʸHy[2,:]', ∇ˣʸHy[1,:]'+∇ˣʸHx[2,:]']
                        if name == :mxfunc
                            return (Db * B)[1] * wHat[idxs]
                        elseif name == :myfunc
                            return (Db * B)[2] * wHat[idxs]
                        elseif name == :mxyfunc
                            return (Db * B)[3] * wHat[idxs]
                        end
                    end
            end

            NiMap = MappingFromComponents(Ni...)
            ∇Ni = MMJMesh.Mathematics.TransposeMapping(jacobian(NiMap)) 

            function querkraft(name)
                x -> begin
                    VV = [[-1, -1], [1, -1], [1, 1], [-1, 1]]
                    J = jF(x) 
                    ∇ˣʸNi = (inv(J') * ∇Ni(x))
                    ∇Mx = ∇ˣʸNi * moment(:mxfunc).(VV)
                    ∇My = ∇ˣʸNi * moment(:myfunc).(VV)
                    ∇Mxy = ∇ˣʸNi * moment(:mxyfunc).(VV)
                    qx = ∇Mx[1] + ∇Mxy[2]
                    qy = ∇Mxy[1] + ∇My[2]
                    if name == :qxfunc
                        return qx
                    elseif name == :qyfunc
                        return qy
                    end
                end
            end

            # Moments Gl. 17 Batoz & Tahar
            mx = moment(:mxfunc)
            my = moment(:myfunc)
            mxy = moment(:mxyfunc)
            # Querkräfte 
            qx = querkraft(:qxfunc)
            qy = querkraft(:qyfunc)

            # Quick return
            name == :w && return we
            # Return rotations
            name == :βx && return βx
            name == :βy && return βy
            # Return
	        name == :wx && return -βx # Beta x = -wx
	        name == :wy && return -βy # Beta y = -wy
    
            name == :mx && return mx
            name == :my && return my
            name == :mxy && return mxy
            name == :qx && return qx
            name == :qy && return qy
            # Unknown label
            error("Unkown function: ", name)        
        end 
    end
end

function nodalresult(m, result)
    # Vektor mit 0en: Anzahl 0en = Anzahl Knoten
	sr = zeros(nnodes(m))
    # Vektor mit Koordinaten Referenzelement
	VV = [[-1, -1], [1, -1], [1, 1], [-1, 1]]
	for f ∈ faces(m)
		sr[nodeindices(f)] .+= m.data[:post](f, result).(VV)
	end
	for (i, n) ∈ enumerate(nodes(m))
		sr[i] /= nfaces(n)
	end
	return sr
end

function meshNodes(m)
    xCoord = zeros(nnodes(m))
    yCoord = zeros(nnodes(m))
	for (i, n) ∈ enumerate(nodes(m))
        # i = Anzahl der Knoten
        xCoord[i] = coordinates(n)[1]
        yCoord[i] = coordinates(n)[2] 
	end
	return xCoord,yCoord
end