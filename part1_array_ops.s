# #include <stdio.h>
#
# int sum_array(int *arr, int size) {
#     int sum = 0;
#     while(size > 0) {
#         sum += *(arr + size - 1);
#         size -= 1;
#     }
#     return sum;
# }
#
# int find_min(int *arr, int size){
#     int min = *(arr + 0);
#     while(size > 1){
#         if(*(arr + size - 1) < min){
#             min = *(arr + size - 1);
#         }
#         size -= 1;
#     }
#     return min;
# }
#
# int find_max(int *arr, int size){
#     int max = *(arr + 0);
#     while(size > 1){
#         if(*(arr + size - 1) > max){
#             max = *(arr + size - 1);
#         }
#         size -= 1;
#     }
#     return max;
# }
#
# int count_negative(int *arr, int size){
#     int count = 0;
#     while(size > 0){
#         if (*(arr + size - 1) < 0){
#             count += 1;
#         }
#     size -= 1;
#     }
#     return count;
# }
#
# int main(void){
#     int data[12] = {-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6};
#     int sum = sum_array(data, 12);
#     printf("Sum is %d\n", sum);
#     int min = find_min(data, 12);
#     printf("Min is %d\n", min);
#     int max = find_max(data, 12);
#     printf("Max is %d\n", max);
#     int count = count_negative(data, 12);
#     printf("count is %d\n", count);
#     return 0;
# }

.data 
array:      .word -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6
str_sum:    .string "Sum: "
str_min:    .string "\nMin: "
str_max:    .string "\nMax: "
str_neg:    .string "\nNegatives: "
newline:    .string "\n"

.text
.globl main




sum_array:
    li   t0, 0           # sum = 0
    mv   t1, a1          # t1 = size

sum_loop:
    blez t1, sum_done
    addi t2, t1, -1      # t2 = size - 1
    slli t2, t2, 2       # t2 = (size - 1) * 4
    add  t2, a0, t2      # t2 = &arr[size-1]
    lw   t3, 0(t2)       # t3 = arr[size-1]
    add  t0, t0, t3      # sum += t3
    addi t1, t1, -1      # size -= 1
    j    sum_loop

sum_done:
    mv   a0, t0          # Return sum
    ret




find_min:
    mv   t0, a1          # t0 = size
    slli t1, zero, 2     # t0 = 0
    add  t1, a0, t1      # t1 = &arr[0]
    lw   t1, 0(t1)       # t1 = arr[0] = min
    li   t2, 1
    
min_loop:
    ble  t0, t2, min_done
    addi t3, t0, -1      # t3 = size - 1
    slli t3, t3, 2       # t3 = (size - 1) * 4
    add  t3, a0, t3      # t3 = &arr[size - 1]
    lw   t4, 0(t3)       # t4 = arr[size - 1]
    bge  t4, t1, min_skip
    mv   t1, t4          # t1 = min = arr[size - 1]

min_skip:
    addi t0, t0, -1      # size -= 1
    j    min_loop

min_done:
    mv   a0, t1          # return min
    ret




find_max:
    mv   t0, a1          # t0 = size
    slli t1, zero, 2     # t0 = 0
    add  t1, a0, t1      # t1 = &arr[0]
    lw   t1, 0(t1)       # t1 = arr[0] = max
    li   t2, 1
    
max_loop:
    ble  t0, t2, max_done
    addi t3, t0, -1      # t3 = size - 1
    slli t3, t3, 2       # t3 = (size - 1) * 4
    add  t3, a0, t3      # t3 = &arr[size - 1]
    lw   t4, 0(t3)       # t4 = arr[size - 1]
    ble  t4, t1, max_skip
    mv   t1, t4          # t1 = max = arr[size - 1]

max_skip:
    addi t0, t0, -1      # size -= 1
    j    max_loop

max_done:
    mv   a0, t1          # return max
    ret  




count_negative:
    li   t0, 0           # count = 0
    mv   t1, a1          # t1 = size

count_loop:
    blez t1, count_done
    addi t2, t1, -1      # t2 = size - 1
    slli t2, t2, 2       # t2 = (size - 1) * 4
    add  t2, a0, t2      # t2 = &arr[size-1]
    lw   t3, 0(t2)       # t3 = arr[size-1]
    bgez t3, count_skip
    addi t0, t0, 1       # count += 1
    
count_skip:
    addi t1, t1, -1      # size -= 1
    j    count_loop
    
count_done:
    mv   a0, t0          # return count
    ret




main:
    addi sp, sp, -16
    sw   ra, 12(sp)
    sw   s0, 8(sp)
    sw   s1, 4(sp)
    la   s0, array       # s0 = pointer to array
    li   s1, 12          # s1 = array size (12 elements)

    # Print "Sum: "
    la   a1, str_sum
    li   a0, 4           # ecall 4 = print string
    ecall
    mv   a0, s0
    mv   a1, s1
    jal  ra, sum_array
    mv   a1, a0          # move result into argument reg
    li   a0, 1           # ecall 1 = print integer
    ecall

    # Print "\nMin: "
    la   a1, str_min
    li   a0, 4
    ecall
    mv   a0, s0
    mv   a1, s1
    jal  ra, find_min
    mv   a1, a0
    li   a0, 1
    ecall

    # Print "\nMax: "
    la   a1, str_max
    li   a0, 4
    ecall
    mv   a0, s0
    mv   a1, s1
    jal  ra, find_max
    mv   a1, a0
    li   a0, 1
    ecall

    # Print "\nNegatives: "
    la   a1, str_neg
    li   a0, 4
    ecall
    mv   a0, s0
    mv   a1, s1
    jal  ra, count_negative
    mv   a1, a0
    li   a0, 1
    ecall

    # Final newline
    la   a1, newline
    li   a0, 4
    ecall

    lw   ra, 12(sp)
    lw   s0, 8(sp)
    lw   s1, 4(sp)
    addi sp, sp, 16

    li   a0, 10          # exit
    ecall
