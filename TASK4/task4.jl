# Решение СЛАУ

function reverse_gauss(A::AbstractMatrix{T}, b::AbstractVector{T}) where T
    x = similar(b)
    N = size(A, 1)
    @inbounds for k in 0:N-1
        @views x[N-k] = (b[N-k] - sum(A[N-k,N-k+1:end] .* x[N-k+1:end])) / A[N-k,N-k]
    end
    return x
end

function reverse_gauss(A::AbstractMatrix{T}, b::AbstractMatrix{T}) where T
    x = similar(b)
    N = size(A, 1)
    @inbounds for k in 0:N-1
        @views x[N-k] = (b[N-k] - sum(A[N-k,N-k+1:end] .* x[N-k+1:end])) / A[N-k,N-k]
    end
    return x
end

function reverse_gauss_columns(A::AbstractMatrix{T}, b::AbstractVector{T}) where T
    x = similar(b)
    N = size(A, 1)
    for k in 0:N-1
        x[N-k] = (b[N-k] - sumprod(@view(A[N-k,N-k+1:end]), @view(x[N-k+1:end]))) / A[N-k,N-k]
    end
    return x
end
     
function reverse_gauss(A::AbstractMatrix{T}, b::AbstractMatrix{T}) where T
    x = similar(b)
    N = size(A, 1)
    for k in 0:N-1
        x[N-k] = (b[N-k] - sumprod(@view(A[N-k,N-k+1:end]), @view(x[N-k+1:end]))) / A[N-k,N-k]
    end
    return x
end

@inline function sumprod(vec1::AbstractVector{T}, vec2::AbstractVector{T})::T where T
    s = zero(T)
    @inbounds for i in eachindex(vec1)
    s = fma(vec1[i], vec2[i], s) # fma(x, y, z) вычисляет выражение x*y+z
    end
    return s
end

# @time reverse_gauss(A,B)
# @time reverse_gauss_columns(A,B)


n = 2000
A = zeros(n, n)
for i in 1:n
    for j in i:n
        A[i, j] = randn()
    end
end
B = [0.0]
for i in 1:n-1
    push!(B,randn())
end

###########
# Приведение матрицы к Ступенчатому Виду


M = Int.(round.(randn(1000,1000)*1000))

@inline function swap!(A,B)
    @inbounds for i in eachindex(A)
    A[i], B[i] = B[i], A[i]
    end
end

function transform_to_steps(A::AbstractMatrix; epsilon = 1e-5, for_det = false)
    A = copy(A)
    c = 1
    @inbounds for k ∈ 1:size(A, 1)
        try
            absval, Δk = findmax(abs, @view(A[k:end,k]))
            (absval <= epsilon) && throw("Вырожденая матрица")
            if Δk > 1 c=-c; swap!(@view(A[k,k:end]), @view(A[k+Δk-1,k:end])) end
            for i in k+1:size(A,1)
                t = A[i,k]/A[k,k]
                @. @views A[i,k:end] = A[i,k:end] .- t .* A[k,k:end]
            end
        catch
            continue
        end
    end
    if for_det return A, c end
    return A
end
    
# метод Гаусса решение СЛАУ для произвольной невырожденной матрицы.

function gauss(A::AbstractMatrix, b)
    A = transform_to_steps(A)
    return reverse_gauss_columns(A,b)
end

# Вычисление определителя

function det_(A::AbstractMatrix)
    M, z = transform_to_steps(A, for_det = true)
    return z*prod([M[i, i] for i in 1:size(M)[1]])
end

det(A::AbstractMatrix) = eltype(typeof(A)).(det_(Rational.(A)))

function rang(A::AbstractMatrix)
    A = transform_to_steps(A)
    k = 0
    for i in 1:size(A, 1)
        k+= !iszero(@view A[i,:])
    end
    return k
end

function inv_(M::Matrix{T}, epsilon = 1e-5) where T
    A = copy(M)
    n = size(A, 1)
    Ans = one(M)

    @inbounds for k ∈ 1:n
        absval, Δk = findmax(abs, @view(A[k:n, k]))
        Δk += k - 1 

        absval <= epsilon && throw("Вырожденая матрица")

        if Δk != k
            A[k, :], A[Δk, :] = A[Δk, :], A[k, :]
            Ans[k, :], Ans[Δk, :] = Ans[Δk, :], Ans[k, :]
        end

        Akk = A[k, k]
        @. A[k, :] = A[k, :] / Akk
        @. Ans[k, :] = Ans[k, :] / Akk

        for i ∈ 1:n
            if i != k
                t = A[i, k]
                @. A[i, :] = A[i, :] - t * A[k, :]
                @. Ans[i, :] = Ans[i, :] - t * Ans[k, :]
            end
        end
    end

    return Ans
end
 


function test()
    for n in 100:500:10100
        println("Матрица порядка ",n,"×",n,":")
        A = randn(n,n);B = randn(n)
        @time reverse_gauss(A,B)
        @time reverse_gauss_columns(A,B)
    end
end


m = Rational.([2 5 -2; 3 7 -3 ; 1 0 -2])


