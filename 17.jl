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

function comb_sort!(a)
    n = length(a)
    gap = n
    swaps = true
    while gap > 1 || swaps
        gap = max(1, Int(floor(gap / 1.25)))
        swaps = false
        for i in 1:n-gap
            if a[i] > a[i+gap]
                a[i], a[i+gap] = a[i+gap], a[i]
                swaps = true
            end
        end
    end
    return a
end

arr = rand(1:100, 10)
println("Исходный массив: ", arr)

# Сортируем массив с помощью сортировки "расческой"
sorted_arr = bubble_sort!(arr)
println("Отсортированный массив: ", sorted_arr)

# Сортируем массив с помощью сортировки "расческой"
sorted_arr = comb_sort!(arr)
println("Отсортированный массив: ", sorted_arr)