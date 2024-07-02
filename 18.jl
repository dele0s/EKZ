function insert_sort!(vector)
    n = 1
    # ИНВАРИАНТ: срез vector[1:n] - отсортирован
    while n < length(vector)
        n += 1
        i = n
        while i > 1 && vector[i-1] > vector[i]
            vector[i], vector[i-1] = vector[i-1], vector[i]
            i -= 1
        end
        #УТВ: vector[1] <= vector[2] <= ... <= vector[n]
    end
    return vector
end

function shell_sort!(a::AbstractVector)
    n = length(a)
    step_series = (n÷2^i for i in 1:Int(floor(log2(n))))
    # при n=1000: 500, 250, 125, 62,31, 15, 7, 3, 1
    for step in step_series
        for i in firstindex(a):lastindex(a)-step
            # - тут записано без привязки к способу индексации массива
            # (имеется ввиду индексация c 0, или с 1, или ещё как)
            j = i
            while j >= firstindex(a) && a[j] > a[j+step]
                a[j], a[j+step] = a[j+step], a[j]
                j -= step
            end
        end
    end
    return a
end

# Создаем случайный массив
arr = rand(1:100, 10)
println("Исходный массив: ", arr)

# Сортируем массив с помощью сортировки вставками
sorted_arr1 = insert_sort!(copy(arr))
println("Отсортированный массив (вставками): ", sorted_arr1)

# Сортируем массив с помощью сортировки Шелла
sorted_arr2 = shell_sort!(copy(arr))
println("Отсортированный массив (Шелла): ", sorted_arr2)