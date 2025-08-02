.text
.global _start
_start:
    li    a0, 10
    jal   sum

    li    a7, 93
    ecall

sum:
  addi sp, sp, -16
  sw ra, 12(sp)

  bgt a0, x0, if_end
  li a0, 0
  ret
if_end:

  sw    a0, 8(sp)

  addi  a0, a0, -1
  jal   sum

  lw    t0, 8(sp)
  add   a0, a0, t0

  lw    ra, 12(sp)
  addi  sp, sp, 16
  ret
