#include <stdio.h>

#int cache[20] = {0};

#int fib(int n, int cache[]) {
#   if (n <= 0) return 0;
#   if (n == 1) return 1;

#    if (cache[n] != 0) {
#        return cache[n];
#    }

#    int result = fib(n - 1, cache) + fib(n - 2, cache);

#    cache[n] = result;
#    return result;
#}

#int main() {
#    printf("fib(7) = %d\n", fib(7, cache));
#    printf("fib(10) = %d\n", fib(10, cache));
#    printf("fib(20) = %d\n", fib(20, cache));
#    return 0;
#}


.data
cache: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

fib_7:      .string "fib(7) = "
fib_10:     .string "fib(10) = "
fib_20:     .string "fib(20) = "
newline:    .string "\n"

.text
.globl main

main:
    addi sp, sp, -16
    sw   ra, 12(sp)
    sw   s0, 8(sp)

    la   s0, cache        # s0 = cache pointer

    # fib(7)
    la   a1, fib_7
    li   a0, 4
    ecall
    li   a0, 7            # n = 7
    mv   a1, s0           # cache[]
    jal  ra, fib
    mv   a1, a0
    li   a0, 1
    ecall
    la   a1, newline
    li   a0, 4
    ecall

    # fib(10)
    la   a1, fib_10
    li   a0, 4
    ecall
    li   a0, 10
    mv   a1, s0
    jal  ra, fib
    mv   a1, a0
    li   a0, 1
    ecall
    la   a1, newline
    li   a0, 4
    ecall

    # fib(20)
    la   a1, fib_20
    li   a0, 4
    ecall
    li   a0, 20
    mv   a1, s0
    jal  ra, fib
    mv   a1, a0
    li   a0, 1
    ecall
    la   a1, newline
    li   a0, 4
    ecall

    lw   ra, 12(sp)
    lw   s0, 8(sp)
    addi sp, sp, 16
    li   a0, 10
    ecall

fib:
    # --- PROLOGUE ---
    addi sp, sp, -16
    sw   ra, 12(sp)
    sw   s0, 8(sp)        # holds n
    sw   s1, 4(sp)        # holds cache pointer
    sw   s2, 0(sp)        # holds result of fib(n-1)

    mv   s0, a0           # n
    mv   s1, a1           # cache pointer

    # 1. Base Cases
    blez s0, return_zero
    li   t0, 1
    beq  s0, t0, return_one

    # 2. Check Cache
    slli t0, s0, 2
    add  t0, s1, t0
    lw   t1, 0(t0)        # t1 = cache[n]
    bnez t1, return_cache 

    # 3. Recursion
    addi a0, s0, -1       # call fib(n-1)
    mv   a1, s1
    jal  ra, fib
    mv   s2, a0           # save fib(n-1)

    addi a0, s0, -2       # call fib(n-2)
    mv   a1, s1
    jal  ra, fib     
    
    add  a0, a0, s2       # total = fib(n-1) + fib(n-2)

    # 4. Store in Cache
    slli t0, s0, 2
    add  t0, s1, t0
    sw   a0, 0(t0)
    j    epilogue

return_zero:
    li   a0, 0
    j    epilogue

return_one:
    li   a0, 1
    j    epilogue

return_cache:
    mv   a0, t1
    # Fall through to epilogue

epilogue:
    lw   ra, 12(sp)
    lw   s0, 8(sp)
    lw   s1, 4(sp)
    lw   s2, 0(sp)
    addi sp, sp, 16
    ret
