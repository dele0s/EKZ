function median(a)
    n = length(a)
    if n % 2 == 1
        # Если длина массива нечетная, возвращаем средний элемент
        return quickselect!(a, (n+1) ÷ 2)
    else
        # Если длина массива четная, возвращаем среднее двух средних элементов
        m1 = quickselect!(a, n ÷ 2)
        m2 = quickselect!(a, (n ÷ 2) + 1)
        return (m1 + m2) / 2
    end
end

function quickselect!(a, k)
    lo, hi = 1, length(a)
    while lo < hi
        pivot = partition!(a, lo, hi)
        if pivot == k
            return a[pivot]
        elseif pivot > k
            hi = pivot - 1
        else
            lo = pivot + 1
        end
    end
    return a[lo]
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
arr = rand(1:10, 10);

# Вычисляем медиану массива
println("Исходный массив: ", arr)
median_value = median(arr)
println("Медиана массива: ", median_value)