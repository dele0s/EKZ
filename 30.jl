struct Vector2D{T<:Real} <: FieldVector{2, T} 
    x::T
    y::T
end

xdot(a::Vector2D,b::Vector2D{T}) where T =  a.x*b.y - a.y*b.x

Base. cos(a::Vector2D{T}, b::Vector2D{T}) where T = dot(a,b)/norm(a)/norm(b)
Base. sin(a::Vector2D{T}, b::Vector2D{T}) where T = xdot(a,b)/norm(a)/norm(b)
Base. angle(a::Vector2D{T}, b::Vector2D{T}) where T = atan(sin(a,b),cos(a,b))

# Лежит ли точка внутри многоугольника
function isinside(point::Vector2D{T},polygon::AbstractArray{Vector2D{T}})::Bool where T
    @assert length(polygon) > 2
 
    sum = zero(Float64)
 
    for i in firstindex(polygon):lastindex(polygon)
        sum += angle(polygon[i] - point , polygon[i % lastindex(polygon) + 1] - point)
    end
    
    return abs(sum) > π
end

p1 = Vector2D(0,1) 
p2 = Vector2D(0,7) 

polygon1 = [Vector2D(3,5),Vector2D(-2,6),Vector2D(-3,3),Vector2D(-6,8),Vector2D(-2,-2),Vector2D(6,0)]

if isinside(p1, polygon1)
    println("Точка лежит внутри многоугольника")
else
    println("Точка не лежит внутри многоугольника")
end

if isinside(p2, polygon1)
    println("Точка лежит внутри многоугольника")
else
    println("Точка не лежит внутри многоугольника")
end