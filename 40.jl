abstract type AbstractCombinObject end

mutable struct Arrangements{T} <: AbstractCombinObject
    n::Int
    k::Int
    arr::Vector{T}
    Arrangements{T}(n::Int, k::Int) where T = new(n, k, zeros(T, k))
end

struct ArrangementsIterator{T}
    arrangements::Arrangements{T}
    index::Int
end

Base.iterate(iter::ArrangementsIterator{T}) where T = begin
    if iter.index == 1
        iter.arrangements.arr[1] = one(T)
        return (copy(iter.arrangements.arr), iter)
    else
        i = iter.index
        while i > 0 && iter.arrangements.arr[i] == iter.arrangements.n
            i -= 1
        end
        if i == 0
            return nothing
        end
        iter.arrangements.arr[i] += one(T)
        for j in i+1:iter.arrangements.k
            iter.arrangements.arr[j] = iter.arrangements.arr[i]
        end
        iter.index += 1
        return (copy(iter.arrangements.arr), ArrangementsIterator(iter.arrangements, iter.index))
    end
end

Base.iterate(a::Arrangements, state=1) = begin
    if state > length(a)
        return nothing
    else
        iter = ArrangementsIterator(a, state)
        return (iter.arrangements.arr, iter), state + 1
    end
end

Base.IteratorSize(::Type{ArrangementsIterator{T}}) where T = Base.HasLength()
Base.IteratorEltype(::Type{ArrangementsIterator{T}}) where T = Base.HasEltype()
Base.eltype(::Type{ArrangementsIterator{T}}) where T = Vector{T}
Base.length(a::Arrangements) = a.n^a.k
Base.iterate(a::Arrangements) = ArrangementsIterator(a, 1), 1

arrangements = Arrangements{Int}(3, 2)
for arr in arrangements
    println(arr)
end