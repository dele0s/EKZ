struct Vector_2D{T <: Real}
    x::T
    y::T
end

# Операции
Base.:+(u::Vector_2D, v::Vector_2D) = Vector_2D(u.x + v.x, u.y + v.y)
Base.:-(u::Vector_2D, v::Vector_2D) = Vector_2D(u.x - v.x, u.y - v.y)
Base.:*(k::Real, v::Vector_2D) = Vector_2D(k * v.x, k * v.y)
Base.:*(v::Vector_2D, k::Real) = k * v
Base.:/(v::Vector_2D, k::Real) = Vector_2D(v.x / k, v.y / k)

# Длина вектора
Base.abs(v::Vector_2D) = sqrt(v.x^2 + v.y^2)

# Скалярное произведение
dot(u::Vector_2D, v::Vector_2D) = u.x * v.x + u.y * v.y

# Векторное произведение
cross(u::Vector_2D, v::Vector_2D) = u.x * v.y - u.y * v.x

# Угол между векторами
angle(u::Vector_2D, v::Vector_2D) = acos(dot(u, v) / (abs(u) * abs(v)))

# Нормализация вектора
normalize(v::Vector_2D) = v / abs(v)

# Поворот вектора на угол
rotate(v::Vector_2D, θ::Real) = Vector_2D(v.x * cos(θ) - v.y * sin(θ), v.x * sin(θ) + v.y * cos(θ))

v1 = Vector_2D{Int64}(1, 2)
v2 = Vector_2D{Float64}(3.0, 4.0)

println("Вектор v1: $v1")
println("Вектор v2: $v2")

# Сложение и вычитание векторов
v3 = v1 + v2
v4 = v2 - v1
println("Сумма векторов v1 + v2: $v3")
println("Разность векторов v2 - v1: $v4")

# Умножение вектора на скаляр
v5 = 2 * v1
println("Вектор v1, умноженный на 2: $v5")

# Длина вектора
len = abs(v1)
println("Длина вектора v1: $len")

# Скалярное произведение
dot_product = dot(v1, v2)
println("Скалярное произведение векторов v1 и v2: $dot_product")

# Векторное произведение
cross_product = cross(v1, v2)
println("Векторное произведение векторов v1 и v2: $cross_product")

# Угол между векторами
angle_rad = angle(v1, v2)
angle_deg = angle_rad * 180 / π
println("Угол между векторами v1 и v2 (в радианах): $angle_rad")
println("Угол между векторами v1 и v2 (в градусах): $angle_deg")

# Нормализация вектора
norm_v1 = normalize(v1)
println("Нормализованный вектор v1: $norm_v1")

# Поворот вектора на угол
rotated_v1 = rotate(v1, π/4)
println("Вектор v1, повернутый на угол π/4: $rotated_v1")