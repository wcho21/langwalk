  .data
foo:
  .word 42

  .text
  .align 2

  .global _start
_start:
  /* exit(99 - foo) */
  li a0, 99
  lw a1, foo
  sub a0, a0, a1
  li a7, 93
  ecall
