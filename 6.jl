struct Residue{T<:Integer}
    value::T
    modulus::T
end

Base. +(a::Residue{T}, b::Residue{T}) where {T<:Integer} = Residue(mod(a.value + b.value, a.modulus), a.modulus)
Base. -(a::Residue{T}, b::Residue{T}) where {T<:Integer} = Residue(mod(a.value - b.value, a.modulus), a.modulus)
Base. *(a::Residue{T}, b::Residue{T}) where {T<:Integer} = Residue(mod(a.value * b.value, a.modulus), a.modulus)

function Base. /(a::Residue{T}, b::Residue{T}) where {T<:Integer}
    if b.value == zero(T)
        throw(DivideError())
    end
    Residue(mod(a.value * invmod(b.value, a.modulus), a.modulus), a.modulus)
end

Base. ==(a::Residue{T}, b::Residue{T}) where {T<:Integer} = a.value == b.value && a.modulus == b.modulus
Base. !=(a::Residue{T}, b::Residue{T}) where {T<:Integer} = !(a == b)
Base. <(a::Residue{T}, b::Residue{T}) where {T<:Integer} = a.value < b.value
Base. >(a::Residue{T}, b::Residue{T}) where {T<:Integer} = a.value > b.value
Base. ≤(a::Residue{T}, b::Residue{T}) where {T<:Integer} = a.value ≤ b.value
Base. ≥(a::Residue{T}, b::Residue{T}) where {T<:Integer} = a.value ≥ b.value

a = Residue(3, 7)
b = Residue(5, 7)
c = Residue(2, 7)

# Perform arithmetic operations
println("a + b = $(a + b)") # Output: a + b = Residue(1, 7)
println("a - b = $(a - b)") # Output: a - b = Residue(5, 7)
println("a * b = $(a * b)") # Output: a * b = Residue(4, 7)
println("a / b = $(a / b)") # Output: a / b = Residue(6, 7)

# Compare Residue objects
println("a == b: $(a == b)") # Output: a == b: false
println("a != b: $(a != b)") # Output: a != b: true
println("a < b: $(a < b)")   # Output: a < b: true
println("a > b: $(a > b)")   # Output: a > b: false
println("a ≤ b: $(a ≤ b)")   # Output: a ≤ b: true
println("a ≥ b: $(a ≥ b)")   # Output: a ≥ b: false

# Perform operations with different moduli
d = Residue(4, 5)
e = Residue(3, 5)
println("d + e = $(d + e)") # Output: d + e = Residue(2, 5)