.data
instructions:
    .word 0x00838333   # add  x6, x7, x8
    .word 0xFF608293   # addi x5, x1, -10
    .word 0x00912423   # sw   x9, 8(x2)
    .word 0x00418663   # beq  x3, x4, 12
    .word 0x12345537   # lui  x10, 0x12345
    .word 0x010000EF   # jal  x1, 16

num_instr: .word 6

lbl_op:   .string "  opcode  = "
lbl_rd:   .string "  rd      = "
lbl_f3:   .string "  funct3  = "
lbl_rs1:  .string "  rs1     = "
nl:       .string "\n"

.text
.globl main
main:
    la   s0, instructions   # s0 = base address of instruction array
    lw   s1, num_instr      # s1 = 6 (loop count)
    li   s2, 0              # s2 = i (loop index)

loop:
    bge  s2, s1, done        # if i >= 6, exit loop

    # load the instruction word: word = instructions[i]
    slli t0, s2, 2           # t0 = i * 4 (byte offset)
    add  t1, s0, t0          # t1 = &instructions[i]
    lw   t2, 0(t1)           # t2 = raw 32-bit instruction word

    # opcode = word & 0x7F  (bits [6:0])
    andi t3, t2, 0x7F
    li   a0, 4
    la   a1, lbl_op
    ecall
    li   a0, 1
    mv   a1, t3
    ecall
    li   a0, 4
    la   a1, nl
    ecall

    # rd = (word >> 7) & 0x1F  (bits [11:7])
    srli t3, t2, 7
    andi t3, t3, 0x1F
    li   a0, 4
    la   a1, lbl_rd
    ecall
    li   a0, 1
    mv   a1, t3
    ecall
    li   a0, 4
    la   a1, nl
    ecall

    # funct3 = (word >> 12) & 0x7  (bits [14:12])
    srli t3, t2, 12
    andi t3, t3, 0x7
    li   a0, 4
    la   a1, lbl_f3
    ecall
    li   a0, 1
    mv   a1, t3
    ecall
    li   a0, 4
    la   a1, nl
    ecall

    # rs1 = (word >> 15) & 0x1F  (bits [19:15])
    srli t3, t2, 15
    andi t3, t3, 0x1F
    li   a0, 4
    la   a1, lbl_rs1
    ecall
    li   a0, 1
    mv   a1, t3
    ecall
    li   a0, 4
    la   a1, nl
    ecall

    # print extra newline to separate instructions
    li   a0, 4
    la   a1, nl
    ecall

    addi s2, s2, 1            # i++
    j    loop

done:
    li   a0, 10                # ecall 10 = exit
    ecall
