function next_permute!(p::AbstractVector)
    n = length(p)
    k = 0 
    for i in reverse(1:n-1) 
        if p[i] < p[i+1]
            k=i; break
        end
    end
    k == firstindex(p)-1 && return nothing 
    i=k+1
    while i<n && p[i+1]>p[k] 
        i += 1
    end

    p[k], p[i] = p[i], p[k]

    reverse!(@view p[k+1:end])
    return p
end

Base.iterate(obj::AbstractCombinObject) = (get(obj), nothing)
Base.iterate(obj::AbstractCombinObject, state) = 
    if isnothing(next!(obj)) #  false
        nothing
    else
        (get(obj), nothing)
    end
    

struct Permute{N} <: AbstractCombinObject
    value::Vector{Int}
    Permute{N}() where N = new(collect(1:N))
end


Base.get(obj::Permute) = obj.value
next!(permute::Permute) = next_permute!(permute.value)

permute = Permute{3}()
function Base. println(R::Permute{N}) where {N}
    for a in R
        println(a)
    end
end

println(permute)