struct Polynomial{T<:Number}
    coeffs::Vector{T}
end

function Base.show(io::IO, p::Polynomial{T}) where T
    print(io, "Polynomial(", join(p.coeffs, ", "), ")")
end

function Base. +(p1::Polynomial{T}, p2::Polynomial{T}) where T
    len = max(length(p1.coeffs), length(p2.coeffs))
    coeffs = zeros(T, len)
    for i in 1:len
        coeffs[i] = (i <= length(p1.coeffs) ? p1.coeffs[i] : zero(T)) +
                    (i <= length(p2.coeffs) ? p2.coeffs[i] : zero(T))
    end
    return Polynomial(coeffs)
end

function Base. -(p1::Polynomial{T}, p2::Polynomial{T}) where T
    len = max(length(p1.coeffs), length(p2.coeffs))
    coeffs = zeros(T, len)
    for i in 1:len
        coeffs[i] = (i <= length(p1.coeffs) ? p1.coeffs[i] : zero(T)) -
                    (i <= length(p2.coeffs) ? p2.coeffs[i] : zero(T))
    end
    return Polynomial(coeffs)
end

function Base. *(p1::Polynomial{T}, p2::Polynomial{T}) where T
    len1, len2 = length(p1.coeffs), length(p2.coeffs)
    coeffs = zeros(T, len1 + len2 - 1)
    for i in 1:len1
        for j in 1:len2
            coeffs[i+j-1] += p1.coeffs[i] * p2.coeffs[j]
        end
    end
    return Polynomial(coeffs)
end

function Base.div(p1::Polynomial{T}, p2::Polynomial{T}) where T
    if iszero(p2)
        throw(DivideError())
    end
    
    deg_p1, deg_p2 = length(p1.coeffs) - 1, length(p2.coeffs) - 1
    if deg_p1 < deg_p2
        return Polynomial{T}([]), copy(p1)
    end
    
    q_coeffs = zeros(T, deg_p1 - deg_p2 + 1)
    r = copy(p1)
    
    for i in deg_p1:-1:deg_p2
        q_coeffs[i-deg_p2+1] = r.coeffs[i+1] / p2.coeffs[end]
        r = r - q_coeffs[i-deg_p2+1] * Polynomial([zeros(T, i-deg_p2), p2.coeffs...])
    end
    
    return Polynomial(q_coeffs), r
end

Base.zero(::Type{Polynomial{T}}) where T<:Number = Polynomial{T}(T[])
Base.zero(p::Polynomial{T}) where T<:Number = Polynomial{T}(T[])

Base.iszero(p::Polynomial{T}) where T<:Number = isempty(p.coeffs) || all(iszero, p.coeffs)

Base.copy(p::Polynomial{T}) where T<:Number = Polynomial{T}(copy(p.coeffs))

struct GCDResult{T}
    gcd::Polynomial{T}
    s::Polynomial{T}
    t::Polynomial{T}
end

function gcd_extended(a::Polynomial{T}, b::Polynomial{T}) where T<:Number
    s, t, r = Polynomial{T}([1]), Polynomial{T}([0]), a
    old_s, old_t, old_r = Polynomial{T}([0]), Polynomial{T}([1]), b
    
    while !iszero(old_r)
        q, r = div(r, old_r)
        s, old_s = old_s, s - q * old_s
        t, old_t = old_t, t - q * old_t
        old_r = r
    end
    
    return GCDResult(old_r, s, t)
end

# Пример использования
a = Polynomial([1, 2, 1])
b = Polynomial([1, 1])
result = gcd_extended(a, b)
println("GCD($a, $b) = $(result.gcd)")
println("s = $(result.s), t = $(result.t)")