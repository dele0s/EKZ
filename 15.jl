function rank(A::Matrix{T}) where {T<:Number}
    m, n = size(A)
    lead = 1
    rank = 0
    
    for r in 1:m
        if lead > n
            return rank
        end
        
        i = r
        while A[i,lead] == 0
            i += 1
            if i > m
                i = r
                lead += 1
                if lead > n
                    return rank
                end
            end
        end
        
        A[[r,i],:] = A[[i,r],:]
        lv = A[r,lead]
        A[r,:] ./= lv
        
        for i in 1:m
            if i != r
                lv = A[i,lead]
                A[i,:] -= lv .* A[r,:]
            end
        end
        
        rank += 1
        lead += 1
    end
    
    return rank
end

A = [1 0 4; 
     0 3 6;
     2 0 0]

R = rank(A)
println(R)  # Вывод: 2