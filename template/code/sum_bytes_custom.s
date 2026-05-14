.data
arr:        .byte 10,240,120,200,180,50,170,210
arr_len:    .word 8

.text
.globl main

main:
  la a0, arr
  lw a1, arr_len
  jal ra, sum_bytes
 
  # print sum
  addi a1, a0, 0 
  addi a0, zero, 1
  ecall

  # exit
  addi a0, zero, 10
  ecall

sum_bytes:
  addi t0, a0, 0 # store adress in t0
  addi t1, a1, 0 # store length in t1
  addi a0, zero, 0 # store sum in a0

loop:
  beq t1, zero, done

  lw t2, 0(t0)
  nop # bytesum t2, t2
  add a0, a0, t2

  addi t0, t0, 4
  addi t1, t1, -4
  jal zero, loop

done:
  jalr ra, ra, 0
