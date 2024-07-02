function partitions(n::Int)
    function generate(n::Int, m::Int)
        if n == 0
            return [[]]
        end
        
        partitions = Vector{Vector{Int}}()
        for i in m:n
            for p in generate(n-i, i)
                push!(p, i)
                push!(partitions, p)
            end
        end
        
        return partitions
    end
    
    return generate(n, 1)
end

println(partitions(5))