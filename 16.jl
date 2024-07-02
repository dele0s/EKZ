function det(A::Matrix{T}) where {T<:Number}
    n = size(A, 1)
    if n != size(A, 2)
        error("Матрица должна быть квадратной")
    end

    det_val = 1.0
    for i in 1:n
        # Найти ненулевой элемент в текущем столбце
        j = i
        while j <= n && A[j, i] == 0
            j += 1
        end

        # Если все элементы в столбце равны 0, определитель равен 0
        if j > n
            return 0
        end

        # Поменять местами строки, если необходимо
        if j != i
            temp = A[i, :]
            A[i, :] = A[j, :]
            A[j, :] = temp
            det_val *= -1
        end

        # Нормализовать ведущую строку
        det_val *= A[i, i]
        for k in 1:n
            A[i, k] /= A[i, i]
        end

        # Обнулить элементы под ведущим
        for j in i+1:n
            lv = A[j, i]
            for k in 1:n
                A[j, k] -= lv * A[i, k]
            end
        end
    end

    return det_val
end

A = [2.0 2.0 3.0;
     0.0 2.0 4.0;
     1.0 0.0 4.0]
B = det(A)
println(B)  # Вывод: 16.0