function permutations(n::Int)
    function generate(nums::Vector{Int}, current::Vector{Int})
        if isempty(nums)
            return [copy(current)]
        end
        
        perms = Vector{Vector{Int}}()
        for i in 1:length(nums)
            num = nums[i]
            push!(current, num)
            deleteat!(nums, i)
            perms = [perms; generate(nums, current)]
            insert!(nums, i, num)
            pop!(current)
        end
        
        return perms
    end
    
    return generate(collect(1:n), Int[])
end

println(permutations(3))