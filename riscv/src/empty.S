  .text
  .align 2

  .global _start
_start:
  /* exit(0) */
  li a0, 0
  li a7, 93
  ecall
