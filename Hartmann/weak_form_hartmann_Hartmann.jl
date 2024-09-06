@variables  a,b, h, ν,E ;

# Einheitsmatrix
I12 = Matrix{Int}(I, 12, 12);

# shape functions
V = [ 0 a a 0; 0 0 b b]

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

Minv = simplify.(M \ I12)
H4 = Minv*P

# stiffness matrix
D = (E*h^3) / (12*(1 - ν^2))

κxx(u) = (∂x(∂x(u)))
κyy(u) = (∂y(∂y(u)))
κxy(u) = (∂x(∂y(u)))

Be1(u) = [κxx(u), κyy(u), 2 * κxy(u)]
Be2(u) = [κxx(u), κyy(u), κxy(u)]

ae(u,v) = integrate(Be1(u) ⋅ Be2(v), (0 .. a) , (0 .. b))
Ke =  simplifyx.(D * [ae(n1, n2) for n1 ∈ H4, n2 ∈ H4])
# display(Ke)

# output stiffness matrix

KeNew = zeros(12,12)
for i = 1:12
    for j = 1:12
        if KeNew[i,j] == 1
        else 
            KeNew[i,j] = 1 
            print("Ke[",i,",",j,"]")
            for m = 1:12
                for n = 1:12
                    if m==i && j==n 
                    elseif isequal(expand(Ke[i,j]),expand(Ke[m,n])) == true 
                        KeNew[m,n] = 1.0
                        print(" = ", "Ke[",m,",",n,"]")
                    else
                    end
                end
            end
        println()
        println("             = ", Ke[i,j])
        println()
        end
    end
end