struct Residue{T, M}<:Number
    value::T
    Residue{T,M}(value) where {T, M} = new(rem(value,M))
end

R(v,m) = Residue{typeof(v),m::typeof(m)}(v)
# a = R(5,8); b = R(3,8)


#R(p::Polynomial, q::Polynomial) = Residue{typeof(p),convert(q)}(p)
# С многочленами не работает
Base. zero(::Residue{T,M}) where {T, M} = Residue{T,M}(zero(T))
Base. one(::Residue{T,M}) where {T, M} = Residue{T,M}(one(T))
Base. iszero(a::Residue{T,M}) where {T, M} = a.value == zero(T)
Base. isone(a::Residue{T,M}) where {T, M} = a.value == one(T)

Base. +(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = Residue{T,M}(a.value + b.value)
Base. +(a::Residue{T,M},b::Int64) where {T,M} = Residue{T,M}(a.value + b)
Base. +(b::Int64,a::Residue{T,M}) where {T,M} = a+b


Base. -(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = Residue{T,M}(a.value - b.value)
Base. -(a::Residue{T,M}) where {T,M} = Residue{T,M}(-a.value)

Base. *(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = Residue{T,M}(a.value * b.value)
Base. *(a::Residue{T,M},b::Int64) where {T,M} = Residue{T,M}(a.value * b)
Base. *(b::Int64,a::Residue{T,M}) where {T,M} = a*b

Base. >(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = a.value > b.value
Base. <(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = a.value > b.value
Base. >=(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = a.value >= b.value
Base. <=(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = a.value <= b.value
Base. ==(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = a.value == b.value
Base. !=(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = a.value != b.value


Base. copy(a::Residue{T,M}) where {T,M} = Residue{T,M}(copy(a.value))

function gcd_(a::T, b::T) where T 
    while !iszero(b) 
        a, b = b, rem(a, b) 
    end
    if a < zero(a)
        a=-a
    end
    return a
end

function gcdx_(a::T, b::T) where T 
    u, v = one(a), zero(b) 
    u_, v_ = v, u
    while !iszero(b) 
        k, r = divrem(a,b) 
        a, b = b, r 
        u, u_ = u_, u-k*u_
        v, v_ = v_, v-k*v_
    end
    if a < zero(b)
        a, u, v = -a, -u, -v
    end
        return a, u, v
end

function diaphant_solve(a ::T,b ::T,c ::T) where T 
    m = gcd(a,b)
    if c%m != 0
        return nothing 
    end
    a,b,c = a/m,b/m,c/m
    m, a1, b1,  = gcdx_(a,b)
    return a1*c, b1*c 
end  

function eratosphenes_sieve(n::Integer)
    prime_indexes::Vector{Bool} = ones(Bool, n)
    prime_indexes[begin] = false
    i = 2
    prime_indexes[i^2:i:n] .= false 
    i=3
    while i <= n
        prime_indexes[i^2:2i:n] .= false
        i+=1
        while i <= n && prime_indexes[i] == false
            i+=1
        end
    end
    return findall(prime_indexes)
end

function isprime(n::IntType) where IntType <: Integer 
    for d in 2:IntType(ceil(sqrt(abs(n))))
        if n % d == 0
            return false
        end
    end
    return true
end
        

function multy(a::Residue{T,M}) where {T, M}
    ans = []
    for i in 1:M
        if gcd(i, M) == 1
            push!(ans, Residue{T,M}(i))
        end
    end
    return ans
end



function inverse(a::Residue{T,M}) where {T,M} 
    if gcd_(a.value, M)!=1 
        return(nothing) 
    end 
    return Residue{T,M}(gcd_(a.value, M)) 
end 



function factorize(n::T) where T <: Integer
    list = NamedTuple{(:div, :deg), Tuple{T, T}}[]
    for p in eratosphenes_sieve(Int(ceil(n/2)))
        k = degree(n, p) # кратность делителя
        if k > 0
            push!(list, (div=p, deg=k))
        end
    end
    return list
end

function degree(n, p) # кратность делителя `p` числа `n`
    k=0
    n, r = divrem(n,p)
    while n > 0 && r == 0
        k += 1
        n, r = divrem(n,p)
    end
    return k
end





Base. display(v::Residue{T,M} ) where {T, M} = print("$(v.value) (mod $(M))")


























