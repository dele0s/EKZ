using LinearAlgebra
using StaticArrays
using Plots

struct Vector2D{T<:Real} <: FieldVector{2, T} 
    x::T
    y::T
end


struct Segment2D{T<:Real}
    A::Vector2D{T}
    B::Vector2D{T}
end

Base.size(::Type{Vector2D}) = (2,)
Base.getindex(v::Vector2D, i::Int) = i == 1 ? v.x : v.y
Base.setindex!(v::Vector2D, val, i::Int) = i == 1 ? (v.x = val) : (v.y = val)

# Косое произведение 
xdot(a::Vector2D,b::Vector2D{T}) where T =  a.x*b.y - a.y*b.x

Base. cos(a::Vector2D{T}, b::Vector2D{T}) where T = dot(a,b)/norm(a)/norm(b)

Base. sin(a::Vector2D{T}, b::Vector2D{T}) where T = xdot(a,b)/norm(a)/norm(b)

Base. angle(a::Vector2D{T}, b::Vector2D{T}) where T = atan(sin(a,b),cos(a,b))

Base. sign(a::Vector2D{T}, b::Vector2D{T}) where T = sign(sin(a,b))






v1 = Vector2D(1,1)
v2 = Vector2D(-1,1)
v3 = Vector2D(0,0)
v4 = Vector2D(0,2)

s1 = Segment2D(v1,v2)
s2 = Segment2D(v3,v4)

# Задача поиска точки пересеччения двух отрезков на плоскости 
function intersection(s1::Segment2D{T},s2::Segment2D{T})::Union{Vector2D{T},Nothing} where T
    A = [s1.B[2]-s1.A[2] s1.A[1]-s1.B[1]
        s2.B[2]-s2.A[2] s2.A[1]-s2.B[1]]
 
    b = [s1.A[2]*(s1.A[1]-s1.B[1]) + s1.A[1]*(s1.B[2]-s1.A[2])
        s2.A[2]*(s2.A[1]-s2.B[1]) + s2.A[1]*(s2.B[2]-s2.A[2])]
 
    x,y = A\b
 
    if isinner(Vector2D(x, y), s1)==false || isinner(Vector2D(x, y), s2)==false
        return nothing
    end
 
    return Vector2D{T}((x,y))
end







# Проверка, принадлежит ли точка отрезку
isinner(P::Vector2D, s::Segment2D)::Bool =
    (s.A.x <= P.x <= s.B.x || s.A.x >= P.x >= s.B.x) &&
    (s.A.y <= P.y <= s.B.y || s.A.y >= P.y >= s.B.y)

v5 = Vector2D(15,3)
v6 = Vector2D(-22,-25)

# Задача, определить лежат ли 2 точки по одну сторону от прямой( от какой то области )

function is_one(P::Vector2D{T}, Q::Vector2D{T}, s::Segment2D{T}) where T 
    l = s.B-s.A
    return sin(l, P-s.A)*sin(l,Q-s.A)>0    
end

is_one_area(F::Function, P::Vector2D{T}, Q::Vector2D{T}) where T = ( F(P...) * F(Q...) > 0 )
f(x,y) = y > x + 5








# Лежит ли точка внутри многоугольника
function isinside(point::Vector2D{T},polygon::AbstractArray{Vector2D{T}})::Bool where T
    @assert length(polygon) > 2
 
    sum = zero(Float64)
 
    for i in firstindex(polygon):lastindex(polygon)
        sum += angle( polygon[i] - point , polygon[i % lastindex(polygon) + 1] - point )
    end
    
    return abs(sum) > π
end

polygon1 = [Vector2D(3,5),Vector2D(-2,6),Vector2D(-3,3),Vector2D(-6,8),Vector2D(-2,-2),Vector2D(6,0)]

p1 = Vector2D(0,1) 
p2 = Vector2D(0,7) 







polygon2 = [Vector2D(2,4),Vector2D(-2,6),Vector2D(-3,5),Vector2D(3,-2)] # Выпуклый 

# Является ли заданный многоугольник выпуклым.
function isconvex(polygon::AbstractArray{Vector2D{T}})::Bool where T
    @assert length(polygon) > 2
 
    for i in firstindex(polygon):lastindex(polygon)
        if angle( polygon[i > firstindex(polygon) ? i - 1 : lastindex(polygon)] - polygon[i] , polygon[i % lastindex(polygon) + 1] - polygon[i] ) <=0
            return false
        end
    end
    
    return true
end

function isconvex(polygon::AbstractArray{Vector2D{T}})::Bool where T
    @assert length(polygon) > 2
    n = length(polygon)

    for i in 1:n
        v1 = polygon[i] - polygon[(i % n) + 1]
        v2 = polygon[(i % n) + 1] - polygon[((i + 1) % n) + 1]
        if angle(v1, v2) < 0
            return false
        end
    end

    return true
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


# Грехом
# Найдем начальную точку, т.е. точку с наименьшим y, а в случае равенства y - с наименьшим x
# Функция для определения направления поворота (левый или правый)
function orientation(p, q, r)
    val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y)
    return val
end

# Найдем начальную точку, т.е. точку с наименьшим y, а в случае равенства y - с наименьшим x
function find_start_point(points::Vector{Vector2D{T}}) where T
    min_index = argmin([(p.y, p.x) for p in points])
    return points[min_index]
end

# Сортировка точек по полярному углу относительно начальной точки
function polar_angle_sort(points::Vector{Vector2D{T}}, start_point::Vector2D{T}) where T
    
    function compare(p, q)
        o = orientation(start_point, p, q)
        if o == 0
            return norm(p - start_point) < norm(q - start_point)
        else
            return o > 0
        end
    end
    
    return sort(points, lt=compare)
end

# Функция для построения выпуклой оболочки с использованием алгоритма Грехома
function graham(points::Vector{Vector2D{T}}) where T
    points = copy(points)
    start_point = find_start_point(points)

    sorted_points = polar_angle_sort(filter!(p -> p != start_point, points), start_point)
    
    hull = [start_point, sorted_points[1]]
    
    for i in 2:length(sorted_points)
        while length(hull) >= 2 && orientation(hull[end-1], hull[end], sorted_points[i]) < 0
            pop!(hull)
        end
        push!(hull, sorted_points[i])
    end
    
    return hull
end



points = [Vector2D(rand(-10:10), rand(-10:10)) for _ in 1:20]
Jarvis_polygon = jarvis!(points)
Graham_polygon = graham(points)
#for i in 1:20 view(points[i]) end

# Площадь многоугольника

function area_trapezoid(points::AbstractVector{Vector2D{T}}) where T
    n = length(points)
    area = sum((points[i].y + points[i % n + 1].y) * (points[i % n + 1].x - points[i].x) for i in 1:n)
    return abs(area / 2)
end

function area_triangles(points::AbstractVector{Vector2D{T}}) where T
    n = length(points)
    area = sum(xdot(points[i] - points[1], points[i % n + 1] - points[1]) for i in 2:n)
    return abs(area / 2) 
end

function area_gauss(points::Vector{Vector2D{T}}) where T
    n = length(points)
    #area = sum(points[i].x*points[i % n + 1].y - points[i % n + 1].x*points[i].y  for i in 1:n)
    area = sum(xdot(points[i], points[i % n + 1]) for i in 1:n)
    return abs(area / 2)
end


#=
area_trapezoid(Jarvis_polygon)
area_triangles(Jarvis_polygon)
area_gauss(Jarvis_polygon)
area_trapezoid(Graham_polygon)
area_triangles(Graham_polygon)
area_gauss(Graham_polygon)
=#








function view(polygon::AbstractArray{Vector2D{T}}) where T
    X = [point.x for point in polygon]
    Y = [point.y for point in polygon]
    
    plot!(X, Y, seriestype = :shape, aspect_ratio = :equal, legend = false)
end

function view(segment::Segment2D{T}) where T
    plot!([segment.A.x, segment.B.x], [segment.A.y, segment.B.y], label = "Segment")
end

function view(v::Vector2D{T}) where T
    scatter!([v.x], [v.y], markersize = 4, legend = false)
end

