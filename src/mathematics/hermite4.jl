
V = [-1 1 1 -1; -1 -1 1 1]

# Einheitsmatrix
I12 = Matrix{Int}(I, 12, 12);

P = mmonomials(2, 3, QHat , (p1, p2) -> p1 + p2 <= 4 && p1 * p2 <4,type = Int)
N = vcat(
    [
        [
            ValueAtLF(p),
            PDerivativeAtLF(p, [1, 0]),
            PDerivativeAtLF(p, [0, 1])
        ]
        for p in eachcol(V)
    ]...
)
M = [n(p) for p in P, n in N]
Minv = round.(simplify.(M \ I12);digits = 3)
H4 = Minv*P