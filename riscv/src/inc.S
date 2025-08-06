  .data
foo:
  .word 42

  .text
  .align 2

  .global _start
_start:
  /* foo++ */
  la a0, foo
  lw a1, foo
  addiw a1, a1, 1
  sw a1, 0(a0)

  /* exit(foo) */
  lw a0, foo
  li a7, 93
  ecall
