  .data
foo:
  .word 42

  .text
  .align 2

  .global _start
_start:
  /* exit(foo + 99) */
  lw a0, foo
  addiw a0, a0, 99
  li a7, 93
  ecall
