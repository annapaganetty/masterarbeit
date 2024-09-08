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
∂1(u) =  (∂x(∂x(u)))
∂2(u) =  (∂y(∂y(u)))
∂3(u) =  2*(∂x(∂y(u)))
Be1(u) = [∂1(u), ∂2(u), ∂3(u)]
Be2(u) = [∂1(u) + ν * ∂2(u), ν * ∂1(u) + ∂2(u),(1- ν)/2 * ∂3(u)]

ae(u,v) = integrate(Be1(u) ⋅ Be2(v), (0 .. a) , (0 .. b))
Ke = (((E*h^3) / (12*(1-ν^2)))* simplifyx.([ae(n1, n2) for n1 ∈ H4, n2 ∈ H4]))
display(Ke[1])
# output stiffness matrix

KeNew = zeros(12,12)
for i = 1:12
    for j = 1:12
        if KeNew[i,j] == 1
        else 
            KeNew[i,j] = 1 
            print("Ke",i,",",j)
            for m = 1:12
                for n = 1:12
                    if m==i && j==n 
                    elseif isequal((Ke[i,j]),(Ke[m,n])) == true 
                        KeNew[m,n] = 1.0
                        print(" = ", "Ke",m,",",n)
                    elseif isequal(expand(Ke[i,j]),expand(-1*(Ke[m,n]))) == true 
                        KeNew[m,n] = 1.0
                        print(" = ", "-Ke",m,",",n)
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