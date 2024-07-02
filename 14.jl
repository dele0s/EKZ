function gauss_solve(A::Matrix{Float64}, b::Vector{Float64})
    n = size(A, 1)
    
    # Прямой ход
    for k = 1:n-1
        # Поиск ведущего элемента
        max_row = k
        for i = k+1:n
            if abs(A[i,k]) > abs(A[max_row,k])
                max_row = i
            end
        end
        
        # Перестановка строк
        if max_row != k
            A[[k, max_row], :] = A[[max_row, k], :]
            b[[k, max_row]] = b[[max_row, k]]
        end
        
        # Исключение переменных
        for i = k+1:n
            factor = A[i,k] / A[k,k]
            A[i,k:n] -= factor * A[k,k:n]
            b[i] -= factor * b[k]
        end
    end
    
    # Обратный ход
    x = zeros(n)
    for i = n:-1:1
        sum = b[i]
        for j = i+1:n
            sum -= A[i,j] * x[j]
        end
        x[i] = sum / A[i,i]
    end
    
    return x
end
A = [2.0 1.0 1.0; 1.0 2.0 1.0; 1.0 1.0 2.0]
b = [4.0, 3.0, 3.0]
x = gauss_solve(A, b)
println(x)

