using Statistics
function sort_matrix_columns!(matrix)
    # Вычисляем среднее квадратическое отклонение для каждого столбца
    stdevs = [std(view(matrix, :, j)) for j in 1:size(matrix, 2)]

    # Сортируем столбцы в порядке не убывания стандартного отклонения
    perm = sortperm(stdevs)
    matrix[:, :] = matrix[:, perm]

    return matrix
end

# Создаем случайную матрицу размера 3x3 с числами от 1 до 10
matrix = rand(1:10, 3, 3)
println("Исходная матрица:")
println(matrix)

sorted_matrix = sort_matrix_columns!(matrix)
println("Отсортированная матрица:")
println(sorted_matrix)