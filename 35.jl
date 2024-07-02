function arrangements_with_repetition(n::Int, k::Int)
    function generate(n::Int, k::Int, current::Vector{Int})
        if length(current) == k
            return [copy(current)]
        end
        
        arrangements = Vector{Vector{Int}}()
        for i in 1:n
            push!(current, i)
            arrangements = [arrangements; generate(n, k, current)]
            pop!(current)
        end
        
        return arrangements
    end
    
    return generate(n, k, Int[])
end

println(arrangements_with_repetition(3, 2))