function postprocessor(params, wHat,model::String)
    # Plate properties
    h = params.h
    E = params.E
    ν = params.ν
    D = E * h^3 / (12 * (1 - ν^2))

    if model == "kirchhoff_conforming"
        return (face, name) -> begin
    
            # Element size and differential operators
            _, a, b = _fsize(face)
            ∂X(we) = (2 / a) * ∂x(we)
            ∂Y(we) = (2 / b) * ∂y(we)
            ∂XX(we) = (2 / a)^2 * ∂xx(we)
            ∂YY(we) = (2 / b)^2 * ∂yy(we)
            ∂XY(we) = (2 / a) * (2 / b) * ∂xy(we)

            # Element displacement function
            V = [ -1 1 1 -1; -1 -1 1 1]
            H4 = hermiteelement(V;conforming=true)
            idxs = idxDOFs(nodeindices(face), 4)
        
            t = repeat([1, a / 2, b / 2, a * b / 4], 4)
            we = sum(wHat[idxs] .* t .* H4) # TODO make dot work
    
            # Derivatives
            wx = ∂X(we)
            wy = ∂Y(we)
            wxx = ∂XX(we)
            wyy = ∂YY(we)
            wxy = ∂XY(we)
            Δw = wxx + wyy

		    # Section forces (Altenbach et al. p176)
		    mx = -D * (wxx + ν * wyy)
		    my = -D * (ν * wxx + wyy)
		    mxy = -D * (1 - ν) * wxy
		    qx = -D * ∂X(Δw)
		    qy = -D * ∂Y(Δw)

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
            
            HxFace, HyFace = makeDKQFunctions(e)
            # first Derivatives of w = -beta 
            we = sum(Ni .* wHat[idxs][1:3:end])
            βx = sum(HxFace .* wHat[idxs]) 
            βy = sum(HyFace .* wHat[idxs]) 
            wx =  -βx # Beta x = -wx
            wy =  -βy # Beta y = -wy

            jF = jacobian(parametrization(geometry(face)))
            Hx = MappingFromComponents(HxFace...)  
            Hy = MappingFromComponents(HyFace...) 
            ∇ξN = MMJMesh.Mathematics.TransposeMapping(jacobian(Hx)) 
            ∇ηN = MMJMesh.Mathematics.TransposeMapping(jacobian(Hy))
            Db = D * [1 ν 0; ν 1 0; 0 0 (1-ν)/2]

            function moment(name)
                    x -> begin
                        J = jF(x)
                        ∇ₓN = (inv(J') * ∇ξN(x))
                        ∇yN = (inv(J') * ∇ηN(x)) 
                        B = [∇ₓN[1,:]', ∇yN[2,:]', ∇yN[1,:]'+∇ₓN[2,:]']
                        if name == :mxfunc
                            return (Db * B)[1] * wHat[idxs]
                        elseif name == :myfunc
                            return (Db * B)[2] * wHat[idxs]
                        elseif name == :mxyfunc
                            return (Db * B)[3] * wHat[idxs]
                        end
                    end
            end
            # Derivatives
            # βxx = j11 * ∂x(βx) + j12 * ∂y(βx)
            # βyy = j21 * ∂x(βy) + j22 * ∂y(βy)
            # βxy = ∂y(βx) + ∂x(βy)
            
            wxx = ∂x(wx)
            wyy = ∂y(wy)
            wxy = ∂y(wx) + ∂x(wy)
            Δw = wxx + wyy

            # Moments Gl. 17 Batoz & Tahar
            mx = moment(:mxfunc)
            my = moment(:mxfunc)
            mxy = moment(:mxfunc)
            # Figure out why these are false
            qx = -D * ∂x(Δw)
            qy = -D * ∂y(Δw)

            # Quick return
            name == :w && return we
            # Return rotations
            name == :βx && return βx
            name == :βy && return βy
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
    end
end

function postprocessorBTP(params, wHat)
    return (face, name) -> begin

        # Plate properties
        h = params.h
        E = params.E
        ν = params.ν
        D = (E*h^3) / (12*(1-ν^2))

        # Element displacement function
            # Indices
        idxs = idxDOFs(nodeindices(face), 3)

        LgFace = bMatrix(face)[1,:]
        HxFace = bMatrix(face)[2,:]
        HyFace = bMatrix(face)[3,:]
        # first Derivatives of w = -beta 
        we = sum(LgFace .* wHat[idxs])
        βx = sum(HxFace .* wHat[idxs]) 
        βy = sum(HyFace .* wHat[idxs]) 
        wx =  -βx # Beta x = -wx
        wy =  -βy # Beta y = -wy

        # Quick return
        name == :w && return we

        jF = jacobian(parametrization(geometry(face)))
        Hx = MappingFromComponents(HxFace...)  
        Hy = MappingFromComponents(HyFace...) 
        ∇ξN = MMJMesh.Mathematics.TransposeMapping(jacobian(Hx)) 
        ∇ηN = MMJMesh.Mathematics.TransposeMapping(jacobian(Hy))
        Db = D * [1 ν 0; ν 1 0; 0 0 (1-ν)/2]

        function moment(name)
                x -> begin
                    J = jF(x)
                    ∇ₓN = (inv(J') * ∇ξN(x))
                    ∇yN = (inv(J') * ∇ηN(x)) 
                    B = [∇ₓN[1,:]', ∇yN[2,:]', ∇yN[1,:]'+∇ₓN[2,:]']
                    if name == :mxfunc
                        return (Db * B)[1] * wHat[idxs]
                    elseif name == :myfunc
                        return (Db * B)[2] * wHat[idxs]
                    elseif name == :mxyfunc
                        return (Db * B)[3] * wHat[idxs]
                    end
                end
        end
        # Derivatives
        # βxx = j11 * ∂x(βx) + j12 * ∂y(βx)
        # βyy = j21 * ∂x(βy) + j22 * ∂y(βy)
        # βxy = ∂y(βx) + ∂x(βy)
        
        wxx = ∂x(wx)
        wyy = ∂y(wy)
        wxy = ∂y(wx) + ∂x(wy)
        Δw = wxx + wyy

        # Return
        name == :βx && return βx
        name == :βy && return βy
        name == :wx && return wx
        name == :wy && return wy
        name == :wxx && return wxx
        name == :wyy && return wyy
        name == :wxy && return wxy
        name == :Δw && return Δw

        # Figure out why these are false
        qx = -D * ∂x(Δw)
        qy = -D * ∂y(Δw)

        # Return
        # Moments Gl. 17 Batoz & Tahar
        name == :mx && return moment(:mxfunc)
        name == :my && return moment(:myfunc)
        name == :mxy && return moment(:mxyfunc)
        name == :qx && return qx
        name == :qy && return qy
        # Unknown label
        error("Unkown function: ", name)
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
    # nfaces(n) = Anzahl der Elemente die an dem Knoten angrenzen 
    # i = Anzahl der Knoten
		sr[i] /= nfaces(n)
	end
	return sr
end