function sieve_of_eratosthenes(n::Int)
    is_prime = fill(true, n+1)
    is_prime[1] = false
    
    for i in 2:isqrt(n)
        if is_prime[i]
            for j in i*i:i:n
                is_prime[j] = false
            end
        end
    end
    
    return [i for i in 2:n if is_prime[i]]
end

primes = sieve_of_eratosthenes(100)
println(primes) # [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]