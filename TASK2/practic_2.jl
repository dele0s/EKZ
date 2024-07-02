function newthon(r, x; epsilon = 1e-8, num_max = 100)
    dx = r(x); x += dx; k=1
    while abs(dx) > epsilon && k < num_max
        dx = r(x)
        x += dx
        k += 1
    end
    println("some")
    abs(dx) > epsilon && @warn("Требуемая точность не достигнута")
    return x
end
    
#= Задание 2

f(x)= cos(x) - x
newthon(f, 1.0,num_max =50)
0.7390851366465718

=#


include("P.jl")
#Задание 3 | Чтобы работало нужно задать начальное приближение комплексным числом α + βi : β != 0
function root(p::Polynomial, start_value,tool::AbstractFloat = 1e-8)
    newthon(complex(start_value), epsilon=tool) do x
        val, diff = valder(p, x)
        return -val/diff
    end
end
#=
p = P([1,2,3,4])
a = root(p,1+im)
p(a)
Действительно 0
=#


# Задание 5
function logarifm(a, z; ε =10e-8)
    t=1.0; y=0.0

    while z < 1/a || z > a || t > ε
        if z < 1/a
        z *= a 
        y -= t 
        elseif z > a
        z /= a 
        y += t 
        elseif t > ε
        t /= 2 
        z *= z 
        end
    end
    return y
end



# Задание 6
cosinus(x, n) = begin
    s = 1.0      
    a = 1.0      
    for k in 1:n-1
        a *= -x^2 / ((2k) * (2k - 1)) 
        s += a
    end
    return s
end

# cosinus(pi,5); cosinus(pi,10)

# Задание 7
cosinus(x) = begin
    s = 0.0
    a = 1
    k=1
    while s+a !=s
        s += a
        a=-a*x*x/2k/(2k-1)
        k+=1
    end
    return s
end

# Задание 8
ex(x) = begin
    s = 0
    a = 1
    k=0
    while s+a !=s
        s += a
        a=a*x/(k+1)
        k+=1
    end
    return s
end



# ex(5) ex(5, epsilon=10e-20, num=20)
# e = 2.718281828459045 e^5
# 148.4131470673818  
# 148.41315910257657


# Задание 9


function Jα(x::T;α = 0, epsilon = 10e-8, num = 50) where T
    s = zero(T)
    a = (x/2)^α/factorial(α)
    k=0
    while s+a !=s
        s += a
        a=-a*x^2/(k+1)/4/(k+α+1)
        k+=1
    end
    return s
end

using Plots 
xx = 0.0:0.001:20
yy = Jα.(xx)
plot(xx,yy)



# Задание 10
# newthon(Jα,2)
# f(x) = Jα(x)-x
# a = newthon(f, 2)










#=
using Plots
xx = 0:0.01:2π
yy = sin.(xx)

p=plot(xx, yy) 
yy = cos.(xx)
plot!(p, xx,yy) 
display(p)
=#



