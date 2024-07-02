struct Dual{T<:Number}
    a::T
    b::T
end

# Основные операции
Base.real(x::Dual) = x.a
Base.imag(x::Dual) = x.b
Base.conj(x::Dual{T}) where {T} = Dual{T}(x.a, -x.b)
Base.zero(::Type{Dual{T}}) where {T} = Dual{T}(zero(T), zero(T))
Base.one(::Type{Dual{T}}) where {T} = Dual{T}(one(T), zero(T))

# Арифметические операции
Base. +(x::Dual{T}, y::Dual{T}) where {T} = Dual{T}(x.a + y.a, x.b + y.b)
Base. +(x::Dual{T}, y::T) where {T} = Dual{T}(x.a + y, x.b)
Base. +(x::T, y::Dual{T}) where {T} = y + x
Base. +(x::Dual{T}, y::Int) where {T<:Number} = Dual{T}(x.a + y, x.b)
Base. +(x::Int, y::Dual{T}) where {T<:Number} = y + x
Base. -(x::Dual{T}) where {T} = Dual{T}(-x.a, -x.b)
Base. -(x::Dual{T}, y::Dual{T}) where {T} = Dual{T}(x.a - y.a, x.b - y.b)
Base. -(x::Dual{T}, y::T) where {T} = Dual{T}(x.a - y, x.b)
Base. -(x::T, y::Dual{T}) where {T} = Dual{T}(x - y.a, -y.b)
Base. *(x::Dual{T}, y::Dual{T}) where {T} = Dual{T}(x.a * y.a, x.a * y.b + x.b * y.a)
Base. *(x::Dual{T}, y::T) where {T} = Dual{T}(x.a * y, x.b * y)
Base. *(x::T, y::Dual{T}) where {T} = y * x
Base. *(x::Int, y::Dual{T}) where {T<:Number} = Dual{T}(x * y.a, x * y.b)
Base. *(x::Dual{T}, y::Int) where {T<:Number} = Dual{T}(x.a * y, x.b * y)

# Adding method to handle multiplication with Int
Base. *(x::Int, y::Dual{T}) where {T} = Dual{T}(x * y.a, x * y.b)
Base. *(x::Dual{T}, y::Int) where {T} = Dual{T}(x.a * y, x.b * y)

Base. /(x::Dual{T}, y::Dual{T}) where {T} = Dual{T}((x.a * y.a + x.b * y.b) / (y.a^2 + y.b^2), (x.b * y.a - x.a * y.b) / (y.a^2 + y.b^2))
Base. /(x::Dual{T}, y::T) where {T} = Dual{T}(x.a / y, x.b / y)
function Base. /(x::T, y::Dual{T}) where {T}
    Dual{T}(x / y.a, -x * y.b / (y.a^2 + y.b^2))
end

# Возведение в степень
Base. ^(x::Dual{T}, y::Integer) where {T} = Dual{T}(x.a^y, y * x.a^(y-1) * x.b)
Base. ^(x::Dual{T}, y::Dual{T}) where {T} = exp(y * log(x))
Base. ^(x::Dual{T}, y::T) where {T} = exp(y * log(x))
Base. ^(x::T, y::Dual{T}) where {T} = exp(y * log(x))

# Элементарные функции
Base.sin(x::Dual{T}) where {T} = Dual{T}(sin(x.a), x.b * cos(x.a))
Base.cos(x::Dual{T}) where {T} = Dual{T}(cos(x.a), -x.b * sin(x.a))
Base.tan(x::Dual{T}) where {T} = Dual{T}(tan(x.a), x.b * (1 + tan(x.a)^2))
Base.asin(x::Dual{T}) where {T} = Dual{T}(asin(x.a), x.b / sqrt(1 - x.a^2))
Base.acos(x::Dual{T}) where {T} = Dual{T}(acos(x.a), -x.b / sqrt(1 - x.a^2))
Base.atan(x::Dual{T}) where {T} = Dual{T}(atan(x.a), x.b / (1 + x.a^2))
Base.exp(x::Dual{T}) where {T} = Dual{T}(exp(x.a), x.b * exp(x.a))
Base.log(x::Dual{T}) where {T} = Dual{T}(log(x.a), x.b / x.a)
Base.log2(x::Dual{T}) where {T} = Dual{T}(log2(x.a), x.b / (x.a * log(2)))
Base.log10(x::Dual{T}) where {T} = Dual{T}(log10(x.a), x.b / (x.a * log(10)))
Base.log(a::AbstractFloat, x::Dual{T}) where {T} = Dual{T}(log(a, x.a), x.b / (x.a * log(a)))
Base.sqrt(x::Dual{T}) where {T} = Dual{T}(sqrt(x.a), x.b / (2 * sqrt(x.a)))

# Функция для дифференцирования
function differentiate(f::Function, x::Real)
    dx = Dual(x, 1.0)
    y = f(dx)
    return (real(y), imag(y))
end

# Пример использования
f(x) = x^2 + 2x + 1
x = 3.0
value, derivative = differentiate(f, x)
println("f($x) = $value")
println("f'($x) = $derivative")