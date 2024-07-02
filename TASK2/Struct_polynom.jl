
# Структура многочлена


struct Polynomial{T}
    c::Vector{T}
    
    function Polynomial{T}(c::Vector{T}) where T
        while length(c) > 1 && iszero(c[begin])
            popfirst!(c)
        end
        new(c)
    end
    
end













































# Красивый вывод, но некрасивый код

subscript(i::Integer) = i<0 ? error("$i is negative") : join('₀'+d for d in reverse(digits(i)))
superscript(i::Integer) =  begin
    if i < 0 
        c = [Char(0x207B)]
    else
        c = []
    end
    for d in reverse(digits(abs(i)))
        if d == 0 push!(c, Char(0x2070)) end
        if d == 1 push!(c, Char(0x00B9)) end
        if d == 2 push!(c, Char(0x00B2)) end
        if d == 3 push!(c, Char(0x00B3)) end
        if d > 3 push!(c, Char(0x2070+d)) end
    end
    return join(c)
end

function Base. display(p::Polynomial{T}) where T 
    if T == Int || T == Float64
        s = ""
        if length(p.c) > 1
            s = "$(p.c[begin]==one(p.c[begin]) ? "" : p.c[begin])$("x"*(length(p.c)-1 ==1 ? "" : superscript(length(p.c)-1)))"
            for i in 2:length(p.c)-1
                if p.c[i]!=zero(p.c[i])
                    s *="$(p.c[i]>zero(p.c[i]) ? "+" : "-")"
                    s *= "$(abs(p.c[i])==one(p.c[i]) ? "" : abs(p.c[i]))$("x"*(length(p.c)-i ==1 ? "" : superscript(length(p.c)-i)))" 
                end
            end
        
        
            if p.c[end] == zero(p.c[end]) 
                println(s)
            else
                s *="$(p.c[end]>zero(p.c[end]) ? "+" : "-")"
                println("$s"*"$(p.c[end] == zero(p.c[end]) ? "" : (abs(p.c[end])))")
            end
        else
            println(p.c[begin])
        end
    else
        for i in 1:length(p.c)-1
            print("($(p.c[i]))x$((length(p.c)-i ==1 ? "" : superscript(length(p.c)-i))) +")
        end
        println("($(p.c[end]))")
    end
end
