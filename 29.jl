struct Vector3D{T<:Real} <: FieldVector{3, T}
    x::T
    y::T
    z::T
end

function isconvex(polygon::AbstractArray{Vector3D{T}})::Bool where T<:Real
    @assert length(polygon) > 2
    n = length(polygon)

    for i in 1:n
        v1 = polygon[i] - polygon[(i % n) + 1]
        v2 = polygon[(i % n) + 1] - polygon[((i + 1) % n) + 1]
        if cross(v1, v2).z < 0
            return false
        end
    end

    return true
end

# Пример использования
polygon1 = [Vector3D(3.0, 5.0, 0.0), Vector3D(-2.0, 6.0, 0.0), Vector3D(-3.0, 3.0, 0.0), Vector3D(-6.0, 8.0, 0.0), Vector3D(-2.0, -2.0, 0.0), Vector3D(6.0, 0.0, 0.0)]
polygon2 = [Vector3D(2.0, 4.0, 0.0), Vector3D(-2.0, 6.0, 0.0), Vector3D(-3.0, 5.0, 0.0), Vector3D(3.0, -2.0, 0.0)]

println("Является ли треугольник выпуклым? ", isconvex(polygon1))
println("Является ли треугольник выпуклым? ", isconvex(polygon2))