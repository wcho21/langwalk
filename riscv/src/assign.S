  .data
foo:
  .word 42

  .text
  .align 2

  .global _start
_start:
  /* foo = 99 */
  la a0, foo
  li a1, 99
  sw a1, 0(a0)

  /* exit(foo) */
  lw a0, foo
  li a7, 93
  ecall
