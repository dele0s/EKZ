function quicksort!(a, lo=1, hi=length(a))
    lo < hi || return a
    pivot = partition!(a, lo, hi)
    quicksort!(a, lo, pivot-1)
    quicksort!(a, pivot+1, hi)
    return a
end

function partition!(a, lo, hi)
    pivot = a[hi]
    i = lo-1
    for j in lo:hi-1
        if a[j] <= pivot
            i += 1
            a[i], a[j] = a[j], a[i]
        end
    end
    a[i+1], a[hi] = a[hi], a[i+1]
    return i+1
end

# Генерируем случайный массив
arr = rand(1:100, 100);

# Сортируем массив с помощью quicksort
println("Исходный массив: ", arr)

start_time = time()
quicksort!(arr)
end_time = time()

println("Отсортированный массив: ", arr)
println("Время сортировки: ", end_time - start_time, " секунд")