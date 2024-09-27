function prettyprint(name, factor, value)
    s1 = name.s[2:end-1]
    s2 = latexify(simplify(factor), env=:raw)
    s3 = latexify(simplify.(1 / factor * value, expand=true), env=:raw)
    return L"%$s1 = %$s2 %$s3"
end;


function prettyprintKe(name,factor,value)
    s1 = name.s[2:end-1]
    s2 = latexify(simplify(factor), env=:raw)
    s3 = latexify(simplify.(1 / factor * value, expand=false), env=:raw)
    return L"%$s1 = %$s2 %$s3"
end

function printKe(Ke,factor)
    l = size(Ke,1)
    KeNew = zeros(l,l)

    A = Array{String,2}(undef, l,l)
    for i = 1:l
        for j = 1:l
            s3 = "$i$j"
            A[i,j] = "k_$s3"
        end
    end
    name = L"\mathbf{K}^e"
    s1 = name.s[2:end-1]
    s2 = latexify(A, env=:raw)
    s4 = latexify(simplify(factor), env=:raw)
    print( L"%$s1 = %$s4 %$s2")
    
    for i = 1:l
        for j = 1:l
            if KeNew[i,j] == 1
            else
                KeNew[i,j] = 1
                s6 = "k_$i$j"
                print(L"%$",latexify(s6,env=:raw))
                for m = 1:l
                    for n = 1:l
                        if m==i && j==n 
                        elseif isequal((Ke[i,j]),(Ke[m,n])) == true 
                            KeNew[m,n] = 1
                            s7 = " k_$m$n"
                            print("=",latexify(s7,env=:raw))
                        elseif isequal(expand(Ke[i,j]),expand(-1*(Ke[m,n]))) == true 
                            KeNew[m,n] = 1
                            s8 = "-k_$m$n"
                            print("=",latexify(s8,env=:raw))
                        else
                        end
                    end
                end
                print(" = ", latexify(Ke[i,j], env=:raw))
                println()
            end
        end
    end
end

function pKe(Ke)
    l = size(Ke,1)
    KeNew = zeros(l,l)
    for i = 1:l
        for j = 1:l
            if KeNew[i,j] == 1
            else 
                KeNew[i,j] = 1 
                print("Ke[",i,",",j,"]")
                for m = 1:l
                    for n = 1:l
                        if m==i && j==n 
                        elseif isequal(expand(Ke[i,j]),expand(Ke[m,n])) == true 
                        KeNew[m,n] = 1.0
                        print(" = ", "Ke[",m,",",n,"]")
                        else
                        end
                    end
                end
            println(" = ", Ke[i,j])
            end
        end
    end
end

function pre(re)
    l = size(re,1)
    for i = 1:l
        println("re[",i,"]=",re[i] )
    end
end