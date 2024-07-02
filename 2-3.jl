struct Polynomial{T<:Number}
    coefficients::Vector{T}
end

# Конструктор по умолчанию
Polynomial{T}() where {T<:Number} = Polynomial{T}([zero(T)])

# Конструктор с вектором коэффициентов
Polynomial{T}(coefficients::Vector{T}) where {T<:Number} = begin
    k = findfirst(!iszero, coefficients)
    if k == nothing
        Polynomial{T}([zero(T)])
    else
        Polynomial{T}(coefficients[k:end])
    end
end

# Конструктор с единичным коэффициентом
Polynomial{T}(x::T) where {T<:Number} = Polynomial{T}([x])

# Конструктор с единичным коэффициентом
Polynomial(x::Number) = Polynomial{typeof(x)}([x])

# Конструктор с вектором коэффициентов
Polynomial(coefficients::Vector{T}) where {T<:Number} = begin
    k = findfirst(!iszero, coefficients)
    if k == nothing
        Polynomial{T}([zero(T)])
    else
        Polynomial{T}(coefficients[k:end])
    end
end

# Возвращает порядок полинома
ord(p::Polynomial) = length(p.coefficients) - 1

# Сложение полиномов
function Base. +(p::Polynomial{T}, q::Polynomial{T}) where {T<:Number}
    maxlen = max(length(p.coefficients), length(q.coefficients))
    coefficients = zeros(T, maxlen)
    for i in 1:maxlen
        coefficients[i] = (i <= length(p.coefficients) ? p.coefficients[i] : zero(T)) +
                          (i <= length(q.coefficients) ? q.coefficients[i] : zero(T))
    end
    Polynomial{T}(coefficients)
end

# Вычитание полиномов
function Base. -(p::Polynomial{T}, q::Polynomial{T}) where {T<:Number}
    maxlen = max(length(p.coefficients), length(q.coefficients))
    coefficients = zeros(T, maxlen)
    for i in 1:maxlen
        coefficients[i] = (i <= length(p.coefficients) ? p.coefficients[i] : zero(T)) -
                          (i <= length(q.coefficients) ? q.coefficients[i] : zero(T))
    end
    Polynomial{T}(coefficients)
end

# Умножение полиномов
function Base. *(p::Polynomial{T}, q::Polynomial{T}) where {T<:Number}
    coefficients = zeros(T, length(p.coefficients) + length(q.coefficients) - 1)
    for i in 1:length(p.coefficients)
        for j in 1:length(q.coefficients)
            coefficients[i+j-1] += p.coefficients[i] * q.coefficients[j]
        end
    end
    Polynomial{T}(coefficients)
end

# Умножение полинома на число
Base. *(p::Polynomial{T}, x::T) where {T<:Number} = Polynomial{T}(p.coefficients .* x)
Base. *(x::T, p::Polynomial{T}) where {T<:Number} = p * x

# Деление полиномов с остатком
function Base.divrem(p::Polynomial{T}, q::Polynomial{T}) where {T<:Number}
    if iszero(q)
        throw(DivideError())
    end
    
    if length(p.coefficients) < length(q.coefficients)
        return Polynomial{T}([zero(T)]), p
    end
    
    quo = zeros(T, length(p.coefficients) - length(q.coefficients) + 1)
    rem = copy(p.coefficients)
    
    for i in 1:length(quo)
        quo[i] = rem[1] / q.coefficients[1]
        rem = rem .- quo[i] .* q.coefficients
        shift!(rem)
    end
    
    Polynomial{T}(quo), Polynomial{T}(rem)
end

# Деление полиномов
Base. ÷(p::Polynomial{T}, q::Polynomial{T}) where {T<:Number} = divrem(p, q)[1]

# Остаток от деления полиномов
Base. %(p::Polynomial{T}, q::Polynomial{T}) where {T<:Number} = divrem(p, q)[2]

# Вычисление значения полинома в точке
function (p::Polynomial{T})(x::T) where {T<:Number}
    val = zero(promote_type(T, typeof(x)))
    for c in p.coefficients
        val = val * x + c
    end
    val
end

# Вычисление значения полинома и его производной в точке
function valdiff(p::Polynomial{T}, x::T) where {T<:Number}
    val = zero(promote_type(T, typeof(x)))
    der = zero(promote_type(T, typeof(x)))
    for (i, c) in enumerate(p.coefficients)
        val = val * x + c
        der = der * x + i * c
    end
    val, der
end

# Вывод полинома в строковом виде
function Base.show(io::IO, p::Polynomial{T}) where {T<:Number}
    print(io, "Polynomial{$T}([")
    for (i, c) in enumerate(p.coefficients)
        print(io, c)
        if i < length(p.coefficients)
            print(io, ", ")
        end
    end
    print(io, "])")
end

# Создание полиномов
p1 = Polynomial([1, 2, 3])
p2 = Polynomial([4, 5, 6, 7])

# Сложение полиномов
p3 = p1 + p2
println(p3) # Polynomial{Int64}([5, 7, 9, 7])

# Вычитание полиномов
p4 = p2 - p1
println(p4) # Polynomial{Int64}([3, 3, 3, 7])

# Умножение полиномов
p5 = p1 * p2
println(p5) # Polynomial{Int64}([4, 13, 26, 31, 18, 21])

# Деление полиномов
q, r = divrem(p5, p1)
println(q) # Polynomial{Int64}([4, 5, 7])
println(r) # Polynomial{Int64}([0, 0, 0])

# Вычисление значения полинома в точке
println(p1(2)) # 17

# Вычисление значения полинома и производной в точке
val, der = valdiff(p1, 2)
println(val) # 17
println(der) # 13