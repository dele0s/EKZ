function combinations(n::Int, k::Int)
    function generate(n::Int, k::Int, start::Int, current::Vector{Int})
        if length(current) == k
            return [copy(current)]
        end
        
        combinations = Vector{Vector{Int}}()
        for i in start:n
            push!(current, i)
            combinations = [combinations; generate(n, k, i+1, current)]
            pop!(current)
        end
        
        return combinations
    end
    
    return generate(n, k, 1, Int[])
end

println(combinations(5, 3))
