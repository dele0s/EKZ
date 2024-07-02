function counting_sort!(a, max_val=maximum(a))
    n = length(a)
    counts = zeros(Int, max_val+1)

    # Подсчитываем количество вхождений каждого элемента
    for x in a
        counts[x+1] += 1
    end

    # Преобразуем counts в кумулятивную сумму
    for i in 2:length(counts)
        counts[i] += counts[i-1]
    end

    # Формируем отсортированный массив
    sorted_a = similar(a)
    for x in reverse(a)
        sorted_a[counts[x+1]] = x
        counts[x+1] -= 1
    end

    return sorted_a
end

# Генерируем случайный массив
arr = rand(1:10, 10);

# Сортируем массив с помощью counting sort
println("Исходный массив: ", arr)

start_time = time()
sorted_arr = counting_sort!(copy(arr))
end_time = time()

println("Отсортированный массив: ", sorted_arr)
println("Время сортировки: ", end_time - start_time, " секунд")

# Сравниваем с быстрой сортировкой
start_time = time()
quicksort!(copy(arr))
end_time = time()

println("Время сортировки quicksort: ", end_time - start_time, " секунд")