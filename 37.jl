function subsets(n::Int)
    function generate(n::Int, start::Int, current::Vector{Int})
        push!(subsets, copy(current))
        
        for i in start:n
            push!(current, i)
            generate(n, i+1, current)
            pop!(current)
        end
    end
    
    subsets = Vector{Vector{Int}}()
    generate(n, 1, Int[])
    return subsets
end

println(subsets(3))