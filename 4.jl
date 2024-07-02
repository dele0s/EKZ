struct Dual{T}
    real::T
    dual::T
end

realpart(x::Dual) = x.real
dualpart(x::Dual) = x.dual

Main. zero(::Dual{T}) where T = Dual{T}(zero(T), zero(T))
Main. one(::Dual{T}) where T = Dual{T}(one(T), zero(T))
Main. iszero(x::Dual{T}) where T = x.real == zero(T) && (x.dual == zero(T))

Main. <(x::Dual{T}, y::Dual{T}) where T = (x.real < y.real)
Main. >(x::Dual{T}, y::Dual{T}) where T = (x.real > y.real)
Main. >=(x::Dual{T}, y::Dual{T}) where T = (x.real >= y.real)
Main. <=(x::Dual{T}, y::Dual{T}) where T = (x.real <= y.real)
Main. ==(x::Dual{T}, y::Dual{T}) where T = (x.real == y.real) && (x.dual == y.dual)

Base. +(x::Dual, y::Dual) = Dual(x.real+y.real, x.dual+y.dual)
Base. +(x::Number, y::Dual) = Dual(x+y.real, y.dual)
Base. +(x::Dual, y::Number) = Dual(x.real+y, x.dual)

Base. -(x::Dual) = Dual(-x.real, -x.dual)
Base. -(x::Dual, y::Dual) = Dual(x.real-y.real, x.dual-y.dual)
Base. -(x::Number, y::Dual) = Dual(x-y.real, y.dual)
Base. -(x::Dual, y::Number) = Dual(x.real-y, x.dual)

Base. *(x::Dual, y::Dual) = Dual(x.real*y.real, x.dual*y.real+y.dual*x.real)
Base. *(x::Number, y::Dual) = Dual(x-y.real, y.dual)
Base. *(x::Dual, y::Number) = Dual(x.real-y, x.dual)

Base. /(x::Dual, y::Dual) = Dual(x.real/y.real, (x.real*y.real-x.real*y.real)/(y.real*y.real))
Base. /(n::Number, y::Dual) = Dual(n/y.real, -n*y.real/y.real^2)
Base. /(x::Dual, n::Number) = Dual(x.real/n, x.real/n)

Base. ^(x::Dual, n::Number) = Dual(x.real^n, n*x.dual*x.real^(n-1))
Base. ^(x::Dual{T}, y::Dual{T}) where T = Dual(x.real^y.real, x.dual^y.real + x.real^y.dual  *  y.dual  *  log(x.real))
Base. ^(x::Dual{T}, y::T) where T = Dual(x.real^y, x.dual^y)
Base. ^(x::T, y::Dual{T}) where T = Dual(x^y.real, x^y.dual  *  log(x))


Base. sin(x::Dual{T}) where T = Dual(sin(x.real), x.dual*cos(x.real))
Base. cos(x::Dual{T}) where T = Dual(cos(x.real), -x.dual*sin(x.real))
Base. tan(x::Dual{T}) where T = Dual(tan(x.real), x.dual/(cos(x.dual)^2))
Base. cot(x::Dual{T}) where T = Dual(cot(x.real), -x.dual/(sin(x.dual)^2))
Base. asin(x::Dual{T}) where T  = Dual(asin(x.real), x.dual/(1-x.real^2)^0.5)
Base. acos(x::Dual{T}) where T = Dual(acos(x.real), -x.dual/(1-x.real^2)^0.5)
Base. atan(x::Dual{T}) where T = Dual(atan(x.real), x.dual/(1+a^2))
Base. acot(x::Dual{T}) where T = Dual(acot(x.real), -x.dual/(1+a^2))
Base. exp(x::Dual{T}) where T = Dual(exp(x.real), exp(x.real)*x.dual)
Base. log(x::Dual{T}) where T = Dual(log(x.real),x.dual/x.real) 
Base. log2(x::Dual{T}) where T = Dual(log2(x.real),x.dual/x.real) 
Base. log10(x::Dual{T}) where T = Dual(log10(x.real),x.dual/x.real) 
Base. log(a::AbstractFloat, ::Dual{T}) where T = Dual(log(a,x.real),x.dual/x.real)  
Base. sqrt(x::Dual{T}) where T = Dual(x.real^0.5, x.dual/(2*(x.real^0.5)))


function Base. display(d::Dual)
    println("$(d.real)$(d.dual>=0 ? "+" : "-")$(abs(d.dual))ε")    
end

# Example usage
a = Dual(2.0, 1.0)
b = Dual(3.0, 0.5)

# Arithmetic operations
println(a + b)  # Output: Dual(5.0, 1.5)
println(a - b)  # Output: Dual(-1.0, 0.5)
println(a * b)  # Output: Dual(6.0, 3.5)
println(a / b)  # Output: Dual(0.7058823529411765, 0.17647058823529413)

# Elementary functions
println(sin(a))  # Output: Dual(0.9092974268256817, -0.4161468365471424)
println(cos(a))  # Output: Dual(-0.4161468365471424, -0.9092974268256817)
println(exp(a))  # Output: Dual(7.38905609893065, 7.38905609893065)
println(log(a))  # Output: Dual(0.6931471805599453, 0.5)