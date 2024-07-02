function polygon_area(vertices::Vector{Tuple{Float64, Float64}})
    area = 0.0
    n = length(vertices)
    
    for i in 1:n
        j = (i % n) + 1
        area += (vertices[i][1] + vertices[j][1]) * (vertices[j][2] - vertices[i][2])
    end
    
    return abs(area) / 2
end

vertices = [(0.0, 0.0), (1.0, 0.0), (1.0, 1.0), (0.0, 1.0)]
println(polygon_area(vertices))