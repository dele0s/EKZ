struct Polynomial{T}
    c::Vector{T}
    
    function Polynomial{T}(c::Vector{T}) where T
        while length(c) > 1 && iszero(c[begin])
            popfirst!(c)
        end
        new(c)
    end
    
end

P(arr) = Polynomial{eltype(arr)}(arr)

Base. zero(p::Polynomial{T}) where T = Polynomial{T}([zero(T)])
Base. one(p::Polynomial{T}) where T = Polynomial{T}([one(T)])
ord(p::Polynomial) = length(p.c)-1
Base.copy(p::Polynomial{T}) where T = Polynomial{T}(copy(p.c))
Base. iszero(p::Polynomial{T}) where T = p.c == [0]
Base. isone(p::Polynomial{T}) where T = p.c == [1]


#Сложение многочленов
Base. +(p::Polynomial, q::Polynomial)  = begin
    lp, lq = length(p.c), length(q.c)
    if lp > lq
        coeff = map(x -> type(p.c,q.c)(x), p.c)
        coeff[end-lq+1:end] .+= q.c
    else
        coeff = map(x -> type(p.c,q.c)(x), q.c)
        coeff[end-lp+1:end] .+= p.c
    end
    return Polynomial{type(p.c,q.c)}(coeff)
end
#Сложение с числом
Base. +(p::Polynomial, q)  = begin
    n = map(x -> type(p.c,q)(x), p.c)
    n[end]+=q
    return Polynomial{type(p.c,q)}(n) 
end

Base. +(q::T,p::Polynomial{T}) where T = p+q

# Унарный минус
Base. -(p::Polynomial{T}) where T = Polynomial{T}(-p.c)
# Вычитание
Base. -(p::Polynomial{T}, q::Polynomial{T}) where T = p+(-q)
Base. -(p::Polynomial{T}, q::T) where T = p+(-q)
Base. -(p::T, q::Polynomial{T}) where T = p+(-q)

Base. *(p::Polynomial, q::Polynomial) = begin
    n = zeros(type(p.c,q.c), ord(p)+ord(q)+1)
    for x in 1:((length(p.c)-1)+1), y in 1:((length(q.c)-1)+1)
        n[x+y-1] += p.c[x]*q.c[y]
    end
    return Polynomial{type(p.c,q.c)}(n) 
end

Base. *(p::Polynomial, q) = Polynomial{type(p.c,q)}(p.c*q)
Base. *(q, p::Polynomial) = p*q

Base. /(p::Polynomial, q) = Polynomial{type(p.c/q,q)}(p.c/q)


Base. ^(p::Polynomial{T}, x) where T = begin
    ans = p
    if x > 0
        for i in 1:x-1
            ans*=p
        end
    else
        for i in 0:abs(x)
            ans/=p
        end
    end
    return ans
end

#Нахождение значения многочлена в точке
(q::Polynomial)(x) = begin 
    p::promote_type(eltype(q.c),typeof(x)) = zero(typeof(x)) 
    for i in 1:length(q.c) 
        p = p*x +q.c[i] 
    end 
    return p 
end

# Деление многочлена
function divrem(p::Polynomial{T}, q::Polynomial{T}) where T
    if iszero(q)
        throw(DivideError("division by zero polynomial"))
    end
    lp = ord(p)
    lq = ord(q)
    if lp < lq
        return (Polynomial{T}([zero(T)]), p)
    end

    quotient = zeros(T, lp - lq + 1)
    remainder = copy(p.c)
    for i in 0:(lp - lq)
        coeff = remainder[i + 1] / q.c[1]
        quotient[i + 1] = coeff
        for j in 1:length(q.c)
            remainder[i + j] -= coeff * q.c[j]
        end
    end
    while length(remainder) > 1 && iszero(remainder[begin])
        popfirst!(remainder)
    end
    return (Polynomial{T}(quotient), Polynomial{T}(remainder))
end

Base. /(p::Polynomial, q::Polynomial) = divrem(p, q)
Base. div(p::Polynomial, q::Polynomial) = divrem(p, q)[1]
Base. rem(p::Polynomial, q::Polynomial) = ord(divrem(p, q)[2]) == -1 ? zero(p) : divrem(p, q)[2]

Base. rem(p::Polynomial, x::Tuple) = rem(p, P([i for i in x]))
Base. /(p::Polynomial, x::Tuple) = p/P([i for i in x])
Base. div(p::Polynomial, q::Polynomial) = div(p, q)[1]



Base. <(p::Polynomial, q::Polynomial) = ord(p)<ord(q)
Base. >(p::Polynomial, q::Polynomial) = ord(p)>ord(q)
Base. <=(p::Polynomial, q::Polynomial) = ord(p)<=ord(q)
Base. >=(p::Polynomial, q::Polynomial) = ord(p)>=ord(q)

valder(p::Polynomial,x) = begin
    T = type(p.c, x)
    Q, Q′ = zero(T), zero(T)
    for i in eachindex(p.c)
        Q′, Q = Q′*x+Q,Q*x+p.c[i]
    end
    return Q, Q′
end

derivative(p::Polynomial) = begin
    n = [zero(T) for x in 1:(length(p.c)-1)]
    if (ord(p)) == 0
        return zero(p)
    end
    for i in 1:ord(p)
        n[i] = (length(p.c)-i)*p.c[length(p.c)-i+1]
    end
    return Polynomial(n)
end

convert(p::Polynomial) = tuple(p.c...)

type(a,b) = promote_type(eltype(a),eltype(b))

# Создание многочленов
p1 = P([1, 2, 3])
p2 = P([4, 5, 6, 7])

# Сложение многочленов
p3 = p1 + p2
println(p3) # 3x^2 + 7x + 10

# Вычитание многочленов
p4 = p2 - p1
println(p4) # 3x^2 + 3x + 4

# Умножение многочленов
p5 = p1 * p2
println(p5) # 4x^5 + 13x^4 + 26x^3 + 31x^2 + 18x + 21

# Деление многочленов
q, r = divrem(p5, p1)
println(q) # 4x^2 + 5x + 7
println(r) # 0x^2 + 0x + 0

# Вычисление значения многочлена в точке
println(p1(2)) # 17

# Вычисление значения многочлена и производной в точке
value(p::Polynomial,x) = valder(p,x)[1]
der(p::Polynomial,x) = valder(p,x)[2]
println(value) # 17
println(der) # 13

# Проверка на ноль
println(iszero(P([0, 0, 0]))) # true
println(iszero(p1)) # false

# Проверка на единицу
println(isone(P([1, 0]))) # true
println(isone(p1)) # false