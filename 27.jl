struct Vector_2D{T <: Real}
    x::T
    y::T
end
struct Segment2D{T <: Real}
    p1::Vector_2D{T}
    p2::Vector_2D{T}
end

function intersection_point(s1::Segment2D, s2::Segment2D)
    try
        # Вычисляем вектора, определяющие направления отрезков
        v1 = s1.p2 - s1.p1
        v2 = s2.p2 - s2.p1

        # Вычисляем определитель системы уравнений
        det = v1.x * v2.y - v1.y * v2.x

        # Если определитель равен нулю, отрезки параллельны
        if abs(det) < 1e-10
            return nothing
        end

        # Вычисляем коэффициенты в системе уравнений
        a = (s2.p1.x - s1.p1.x) * v2.y - (s2.p1.y - s1.p1.y) * v2.x
        b = (s2.p1.x - s1.p1.x) * v1.y - (s2.p1.y - s1.p1.y) * v1.x

        # Вычисляем координаты точки пересечения
        t = a / det
        u = b / det
        x = s1.p1.x + t * v1.x
        y = s1.p1.y + t * v1.y

        # Если точка пересечения лежит на обоих отрезках, возвращаем ее
        if 0 <= t <= 1 && 0 <= u <= 1
            return Vector_2D(x, y)
        else
            return nothing
        end
    catch e
        if e isa DomainError
            # Если возникла ошибка, связанная с делением на ноль,
            # значит отрезки параллельны
            return nothing
        else
            rethrow(e)
        end
    end
end

# Создаем два отрезка
s1 = Segment2D(Vector_2D(3, 1), Vector_2D(2, 8))
s2 = Segment2D(Vector_2D(4, 2), Vector_2D(1, 5))

# Находим точку пересечения
intersection = intersection_point(s1, s2)

if intersection !== nothing
    println("Точка пересечения: $intersection")
else
    println("Отрезки не пересекаются")
end