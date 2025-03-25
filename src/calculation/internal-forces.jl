function postprocessor(params, wHat)
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

        # Quick return
        name == :w && return we
    
        # Derivatives
        wxx = ∂XX(we)
        wyy = ∂YY(we)
        wxy = ∂XY(we)
        Δw = wxx + wyy
        
        # Return
		name == :wx && return ∂X(we)
		name == :wy && return ∂Y(we)
		name == :wxx && return wxx
		name == :wyy && return wyy
		name == :wxy && return wxy
		name == :Δw && return Δw

		# Plate properties
		h = params.h
		E = params.E
		nu = params.ν
		D = E * h^3 / (12 * (1 - nu^2))

		# Section forces (Altenbach et al. p176)
		mx = -1e-3 * D * (wxx + nu * wyy)
		my = -1e-3 * D * (nu * wxx + wyy)
		mxy = -1e-3 * D * (1 - nu) * wxy
		qx = -1e-3 * D * ∂X(Δw)
		qy = -1e-3 * D * ∂Y(Δw)

		# From equilibrium
		qxe = ∂X(mx) + ∂Y(mxy)
		qye = ∂X(mxy) + ∂Y(my)

        # Return
		name == :mx && return mx
		name == :my && return my
		name == :mxy && return mxy
		name == :qx && return qx
		name == :qy && return qy
		name == :qxe && return qxe
		name == :qye && return qye
		# name == :mxg && return interpolateg(mx, 2)
		# name == :myg && return interpolateg(my, 2)
		# name == :mxyg && return interpolateg(mxy, 2)
		# name == :qxg && return interpolateg(qx, 2)
		# name == :qyg && return interpolateg(qy, 2)
		# name == :qxgg && return ∂X(interpolateg(mx, 2)) + ∂Y(interpolateg(mxy, 2))
		# name == :qygg && return ∂X(interpolateg(mxy, 2)) + ∂Y(interpolateg(my, 2))

		# Unknown label
		error("Unkown function: ", name)
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
        idxsWe = idxs[1:3:end]  

    #------------------------------------------------------------------------
    # TODO figure out why this does not work
        # displ = bMatrix(face) * wHat[idxs]

        # we =   sum(bMatrix(face)[1,:] .* wHat[idxs]) # Ni = functions of Lagrange Element
        # βx = - sum(bMatrix(face)[2,:] .* wHat[idxs]) # Beta x = -wx
        # βy = - sum(bMatrix(face)[3,:] .* wHat[idxs]) # Beta y = -wy
    #------------------------------------------------------------------------
        
        # this works 
        V = [ -1 1 1 -1; -1 -1 1 1]
        we = sum(wHat[idxsWe] .* lagrangeelement(V)) # N = functions of Lagrange Element

        # first Derivatives of w = beta 
        βx = sum(btpHx(face) .* wHat[idxs]) # Beta x = -wx
        βy = sum(btpHy(face) .* wHat[idxs]) # Beta y = -wy
        wx =  -βx # Beta x = -wx
        wy =  -βy # Beta y = -wy
        println("βx  = ",(βx))
        println("βy  = ",(βy))

        # Quick return
        name == :w && return we

        # Derivatives
        βxx = ∂x(βx)
        βyy = ∂y(βy)
        βxy = ∂y(βx) + ∂x(βy)
        
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

        # Section forces (Altenbach et al. p176)
        # βxx =   Hx,x            * U
        # βyy =   Hy,y            * U
        # βxy =   (Hx,y + Hy,x)   * U
        #         B               * U

        # mx =    D * (Hx,x * U + ν * Hy,y * U) 
        # my =    D * (ν * Hx,x * U + Hy,y * U)
        # mxy =   D * ((Hx,y + Hy,x) * U)
 
        mx = D * (βxx + ν * βyy)
        my = D * (ν * βxx + βyy)
        mxy = D * (1 - ν) * βxy
        qx = -1e-3 * D * ∂x(Δw)
        qy = -1e-3 * D * ∂y(Δw)

        println("wxx  = ", wxx)
        println("wyy  = ", wyy)
        println("mx = ", mx)
        println("my = ", my)

        # # From equilibrium
        # qxe = ∂X(mx) + ∂Y(mxy) # TODO figure out why this does not work
        # qye = ∂X(mxy) + ∂Y(my)

        # Return
        name == :mx && return mx
        name == :my && return my
        name == :mxy && return mxy
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