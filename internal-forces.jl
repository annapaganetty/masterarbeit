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
        h = params.d
        E = params.E
        ν = params.ν
        D = E * h^3 / (12 * (1 - ν^2))

        # Section forces (Altenbach et al. p176)
        mx = -1e-3 * D * (wxx + ν * wyy)
        my = -1e-3 * D * (ν * wxx + wyy)
        mxy = -1e-3 * D * (1 - ν) * wxy
        qx = -1e-3 * D * ∂X(Δw)
        qy = -1e-3 * D * ∂Y(Δw)

        # From equilibrium
        qxe = ∂X(mx) + ∂Y(mxy) # TODO figure out why this does not work
        qye = ∂X(mxy) + ∂Y(my)

        # Return
        name == :mx && return mx
        name == :my && return my
        name == :mxy && return mxy
        name == :qx && return qx
        name == :qy && return qy
        name == :qxe && return qxe
        name == :qye && return qye
        name == :mxg && return interpolateg(mx, 2)
        name == :myg && return interpolateg(my, 2)
        name == :mxyg && return interpolateg(mxy, 2)
        name == :qxg && return interpolateg(qx, 2)
        name == :qyg && return interpolateg(qy, 2)
        name == :qxgg && return ∂X(interpolateg(mx, 2)) + ∂Y(interpolateg(mxy, 2))
        name == :qygg && return ∂X(interpolateg(mxy, 2)) + ∂Y(interpolateg(my, 2))

        # Unknown label
        error("Unkown function: ", name)
    end
end