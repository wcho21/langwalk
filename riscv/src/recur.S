  .text
  .align 2

  .global _start
_start:
  /* sum(10) */
  li    a0, 10
  jal   sum

  /* exit(sum(10)) */
  li    a7, 93
  ecall

sum:
  /* allocate stack */
  addi sp, sp, -16
  /* push ra to stack */
  sd ra, 8(sp)

  /* if (n <= 0) */
  bgt a0, x0, if_end
  /* return 0 */
  li a0, 0
  ret
if_end:

  /* push a0 to stack */
  sw    a0, 4(sp)

  /* sum(n-1) */
  addi  a0, a0, -1
  jal   sum

  /* pop a0 from stack */
  lw    a1, 4(sp)
  add   a0, a0, a1
  /* pop ra from stack */
  ld    ra, 8(sp)
  /* deallocate stack */
  addi  sp, sp, 16

  ret
