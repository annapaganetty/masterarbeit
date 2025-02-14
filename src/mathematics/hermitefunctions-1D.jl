# Hermite Funktionen für Balken, für MA nicht relevant
function hermiteelement1D(V)
    P = monomials([0,1,2,3], IHat)
    N = vcat([[ValueAtLF(p), DerivativeAtLF(p)] for p = [-1,1]]...)
    M = [n(p) for p in P, n in N]
    H4 = inv(M) * P
    return H4
end