function lagrangeelement(V)
    m = 4
    P = mmonomials(2, 1, QHat  ,type = Int)
    N = vcat(
        [
            [ValueAtLF(p)]
            for p in eachcol(V)
        ]...
    )
    Imatrix = Matrix{Int}(I, m, m)
    M = [n(p) for p in P, n in N]
    Minv = simplifyx.(M \ Imatrix)
    L4 = Minv*P
return L4
end

function hermiteelement(V;conforming=true)
    if conforming
        m = 16
        P = mmonomials(2, 3, QHat  ,type = Int)
        N = vcat(
            [
                [ValueAtLF(p), PDerivativeAtLF(p, [1, 0]), PDerivativeAtLF(p, [0, 1]), PDerivativeAtLF(p, [1, 1])]
                for p in eachcol(V)
            ]...
        )
    else 
        m = 12
        P = mmonomials(2, 3, QHat , (p1, p2) -> p1 + p2 <= 4 && p1 * p2 <4,type = Int)
        N = vcat(
            [
                [ValueAtLF(p), PDerivativeAtLF(p, [1, 0]), PDerivativeAtLF(p, [0, 1])]
                for p in eachcol(V)
            ]...
        )
    end
    Imatrix = Matrix{Int}(I, m, m)
    M = [n(p) for p in P, n in N]
    Minv = (M \ Imatrix) #round.(...., digits=10) 
    H4 = (Minv*P)
return H4
end

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