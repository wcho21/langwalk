  .data
foo:
  .word 42

  .text
  .align 2

  .global _start
_start:
  /* exit(foo) */
  lw a0, foo
  li a7, 93
  ecall
