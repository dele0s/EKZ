function bubble_sort!(a)
    n = length(a)
    for k in 1:n-1
        istranspose = false
        for i in 1:n-k
            if a[i] > a[i+1]
                a[i], a[i+1] = a[i+1], a[i]
                istranspose = true
            end
        end
        if !istranspose
            break
        end
    end
    return a
end
function binary_search(a, target)
    lo = 1
    hi = length(a)
    while lo <= hi
        mid = (lo + hi) ÷ 2
        if a[mid] == target
            return mid
        elseif a[mid] < target
            lo = mid + 1
        else
            hi = mid - 1
        end
    end
    return -1 # Элемент не найден
end

# Генерируем отсортированный массив
arr = sort(rand(1:10, 10));
println("Исходный массив: ", arr)
sorted_arr = bubble_sort!(copy(arr))
println("Отсортированный массив: ", sorted_arr)
# Ищем элементы в массиве с помощью binary search
target1 = rand(1:10)
target2 = rand(1:10)

start_time = time()
index1 = binary_search(arr, target1)
end_time = time()

println("Элемент $target1 найден по индексу $index1")
println("Время поиска: ", end_time - start_time, " секунд")

start_time = time()
index2 = binary_search(arr, target2)
end_time = time()

println("Элемент $target2 найден по индексу $index2")
println("Время поиска: ", end_time - start_time, " секунд")