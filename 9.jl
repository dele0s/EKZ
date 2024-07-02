x = 113
k = 0
for i in range(2, x//2+1)
    global k
    if x%i==0
        k+=1
        break
    end
end
if k == 0
    print("Число простое, нихуя")
else
    print("Число непростое нихуя")
end