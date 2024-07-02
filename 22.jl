function heapsort!(a)
    n = length(a)
    build_heap!(a)
    for i in n:-1:2
        a[1], a[i] = a[i], a[1]
        heapify!(a, 1, i-1)
    end
    return a
end

function build_heap!(a)
    n = length(a)
    for i in div(n, 2):-1:1
        heapify!(a, i, n)
    end
end

function heapify!(a, i, n)
    left = 2i
    right = 2i + 1
    largest = i
    if left <= n && a[left] > a[largest]
        largest = left
    end
    if right <= n && a[right] > a[largest]
        largest = right
    end
    if largest != i
        a[i], a[largest] = a[largest], a[i]
        heapify!(a, largest, n)
    end
end

# Генерируем случайный массив
arr = rand(1:10, 10);

# Сортируем массив с помощью heapsort
println("Исходный массив: ", arr)

start_time = time()
heapsort!(arr)
end_time = time()

println("Отсортированный массив: ", arr)
println("Время сортировки: ", end_time - start_time, " секунд")