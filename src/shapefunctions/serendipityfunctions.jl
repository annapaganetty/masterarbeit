function serendipityelement(V)
    W = Array{Int64,2}(undef, 2,4)
    for i = 1:3
            W[1,i] = (V[1,i] + V[1,i+1]) * 0.5
            W[2,i] = (V[2,i] + V[2,i+1]) * 0.5
    end
    W[1,4] = (V[1,4] + V[1,1]) * 0.5
    W[2,4] = (V[2,4] + V[2,1]) * 0.5
    P = mmonomials(2, 2, QHat,(p1, p2) -> p1 + p2 < 4, type = Int)
    N = vcat(
        [
            ValueAtLF(p)
            for p in eachcol(V)
        ],
        [
            [ValueAtLF(q)]
            for q in eachcol(W)
        ]
        ...
    )
    M = [n(p) for p in P, n in N]
    S8 = inv(M)*P
    return S8
end