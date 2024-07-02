using StaticArrays

struct Vector2D{T<:Real} <: FieldVector{2, T} 
    x::T
    y::T
end

# алгоритм Джарвиса построения выпуклой оболочки заданного набора (множества) точек плоскости
function jarvis!(points::AbstractArray{Vector2D{T}})::AbstractArray{Vector2D{T}} where T
    points = copy(points)
    function next!(convex_shell2::AbstractVector{Int64}, points2::AbstractVector{Vector2D{T}}, ort_base::Vector2D{T})::Int64 where T
        cos_max = typemin(T)
        i_base = convex_shell2[end]
        resize!(convex_shell2, length(convex_shell2) + 1)
        for i in eachindex(points2)
            if points2[i] == points2[i_base]
                continue
            end
            ort_i = points2[i] - points2[i_base]
            cos_i = dot(ort_base, ort_i) / (norm(ort_base) * norm(ort_i))
            if cos_i > cos_max
                cos_max = cos_i
                convex_shell2[end] = i
            elseif cos_i == cos_max && dot(ort_i, ort_i) > dot(ort_base, ort_base)
                convex_shell2[end] = i
            end
        end
        return convex_shell2[end]
    end

    @assert length(points) > 1
    ydata = [points[i].y for i in firstindex(points):lastindex(points)]
    i_start = findmin(ydata)
    convex_shell = [i_start[2]]
    ort_base = Vector2D(oneunit(T), zero(T))

    while next!(convex_shell, points, ort_base) != i_start[2]
        ort_base = points[convex_shell[end]] - points[convex_shell[end-1]]
    end

    pop!(convex_shell)

    return points[convex_shell]
end

points = [Vector2D(rand(-10:10), rand(-10:10)) for _ in 1:20]
Jarvis_polygon = jarvis!(points)