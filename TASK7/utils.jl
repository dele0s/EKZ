v = [true,false,true,false,false,false,true]
u= [1,5,7,2,3,4]
#Генерация всех размещений с повторениями из n элементов
function next_repit_placement!(p::Vector{T}, n::T) where T<:Integer
    i = findlast(x->(x < n), p) 

    isnothing(i) && (return nothing)
    p[i] += 1
    p[i+1:end] .= 1 

    return p
end

#= 

n = 2; k = 3
p = ones(Int,k)
println(p)
while !isnothing(p)
    p = next_repit_placement!(p,n)
    println(p)
end

for i in 0:n^k-1
    digits(i; base=n, pad=k) |> println
end

=#

#Генерация вcех перестановок 1,2,...,n
function next_permute!(p::AbstractVector)
    n = length(p)
    k = 0 
    for i in reverse(1:n-1) 
        if p[i] < p[i+1]
            k=i; break
        end
    end
    k == firstindex(p)-1 && return nothing 
    i=k+1
    while i<n && p[i+1]>p[k] 
        i += 1
    end

    p[k], p[i] = p[i], p[k]

    reverse!(@view p[k+1:end])
    return p
end
#Тестирование:
#=
p=[1,2,3]
println(p)
while !isnothing(p)
    p = next_permute!(p)
    println(p)
end    
=#

# Генерация всех всех подмножеств nэлементного множества
#=
indicator(i::Integer, n::Integer) = digits(Bool, i; base=2, pad=n)

function next_indicator!(ind::AbstractVector{Bool})
    i = findlast(x->(x==0), ind)
    isnothing(i) && return nothing
    ind[i] = 1
    ind[i+1:end] .= 0
    return ind
end
=#

#=

n=5; A=1:n
ind = zeros(Bool, n)
println(ind)
while !isnothing(ind)
    A[findall(ind)] |> println
    ind = next_ind!(ind)
    println(ind)
end

=#


# Генерация всех k-элементных подмножеств n-элементного множества

#indicator(i::Integer, n::Integer) = digits(Bool, i; base=2, pad=n)

function next_indicator!(ind::AbstractVector{Bool})
    i = findlast(x->(x==0), ind)
    isnothing(i) && return nothing
    ind[i] = 1
    ind[i+1:end] .= 0
    return ind
end

#=
n=5; A=1:n
ind = zeros(Bool, n)
println(ind)
while !isnothing(ind)
A[findall(ind)] |> println
    ind = next_indicator!(ind)
    println(ind)
end
=#

# Генерация всех разбиений натуральногочисла на положительные слагаемые
#=
function next_split!(s, k, n)
    k < 1 && return nothing 
    if k == 1
        ans = zeros(5)
        ans[1] = n
        return ans
    end
    i = k-1 
    while i > 1 && s[i-1] == s[i]
        i -= 1
    end
    s[i] += 1

    r = sum(@view(s[i+1:k]))
    k = i+r-1 
    s[i+1:n-k]  .= 1

    summa = 0
    index = 1
    while summa < n
        summa +=s[index]
        index +=1
    end
    s[index:n]  .= 0


    return s, k
end
=#
#=
function next_partition(n)
    s = ones(Int, n)
    k = n
    result = nothing
    while true
        println(s)
        result = next_split!(s, k, n)
        if result === nothing
            break
        end
        s, k = result
    end
end
=#


function next_split!(s::AbstractVector{Int}, k)
    k == 1 && return nothing
    
    i = k - 1
    while i > 1 && s[i-1] == s[i]
        i -= 1
    end

    s[i] += 1

    r = sum(@view(s[i+1:k]))
    k = i + r - 1 # - это с учетом s[i] += 1
    for j in (i + 1):k
        s[j] = 1
    end
    summa = 0
    index = 1
    while summa < n
        summa += s[index]
        index += 1
    end
    s[index:n] .= 0

    return s, k
end
#=
n=5; s=ones(Int, n); k=n
println(s)
while !isnothing(s)
    println(s[1:k])
    s, k = next_split!(s, k)
    println(s)
end

=#