using LinearAlgebra
using StaticArrays

struct Vector2D{T<:Real} <: FieldVector{2, T}
    x::T
    y::T
end

struct Segment2D{T<:Real}
    A::Vector2D{T}
    B::Vector2D{T}
end

xdot(a::Vector2D,b::Vector2D{T}) where T =  a.x*b.y - a.y*b.x

Base. sin(a::Vector2D{T}, b::Vector2D{T}) where T = xdot(a,b)/norm(a)/norm(b)


# Первый способ: используя векторное произведение
function is_one(P::Vector2D{T}, Q::Vector2D{T}, s::Segment2D{T}) where T 
    l = s.B-s.A
    return sin(l, P-s.A)*sin(l,Q-s.A)>0    
end

# Второй способй
is_one_area(F::Function, P::Vector2D{T}, Q::Vector2D{T}) where T = ( F(P...) * F(Q...) > 0 )


# Пример использования
s = Segment2D(Vector2D(0.0, 0.0), Vector2D(1.0, 1.0))
f(x,y) = y > x

# Точки, лежащие по одну сторону от прямой
P1 = Vector2D(0.0, 1.5)
Q1 = Vector2D(0.1, 1.7)
println("Точки лежат по одну сторону от прямой? ", is_one(P1, Q1, s))   # true
println("Точки лежат по одну сторону от прямой? ", is_one_area(f, P1, Q1), "\n")   # true

# Точки, лежащие по разные стороны от прямой
P2 = Vector2D(0.0, 1.5)
Q2 = Vector2D(3.0, 0.7)
println("Точки лежат по одну сторону от прямой? ", is_one(P2, Q2, s))   # false
println("Точки лежат по одну сторону от прямой? ", is_one_area(f, P2, Q2))   # false
