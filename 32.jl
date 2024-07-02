using StaticArrays

struct Vector2D{T<:Real} <: FieldVector{2, T} 
    x::T
    y::T
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
Graham_polygon = graham(points)