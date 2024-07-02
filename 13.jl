function rref(A)
    m, n = size(A)
    lead = 1
    for r = 1:m
        if n < lead
            return A
        end
        i = r
        while A[i, lead] == 0
            i += 1
            if m < i
                i = r
                lead += 1
                if n < lead
                    return A
                end
            end
        end
        A[[r, i], :] = A[[i, r], :]
        lv = A[r, lead]
        A[r, :] = A[r, :] / lv
        for i = 1:m
            if i != r
                lv = A[i, lead]
                A[i, :] = A[i, :] - lv * A[r, :]
            end
        end
        lead += 1
    end
    return A
end

A = [1 2 3; 0 1 4; 0 0 0]
B = rref(A)
println(B)