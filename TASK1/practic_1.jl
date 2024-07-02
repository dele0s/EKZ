# Номер 3
include("Dual.jl")

function valdiff(f::Function, x::T) where T
    x_dual = Dual(x, one(T))
    y_dual = f(x_dual)
return y_dual.real, y_dual.dual
    

# Номер 4
include("P.jl")
function valdiff(p, x, d) 
    d = Dual(p(x), derivative(p)(x))
    return (d.real, d.dual)
end

(p::Polynomial)(x::Dual{T}) where T = Dual(p(x.real), derivative(p)(x.real)) end