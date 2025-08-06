  .data
arr:
  .word 42
  .word 99
  .word 1

  .text
  .align 2

  .global _start
_start:
  /* initialize */
  li a0, 0 /* sum */
  la a1, arr

  /* a0 += arr[0] */
  lw a2, 0(a1)
  addw a0, a0, a2
  /* a0 += arr[1] */
  lw a2, 4(a1)
  addw a0, a0, a2
  /* a0 += arr[2] */
  lw a2, 8(a1)
  addw a0, a0, a2

  /* exit(a0) */
  li a7, 93
  ecall
