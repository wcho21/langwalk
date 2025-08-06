  .data
foo:
  .word 42

  .text
  .align 2

  .global _start
_start:
  /* set_foo(99) */
  li a0, 99
  jal set_foo

  /* exit(foo) */
  lw a0, foo
  li a7, 93
  ecall

set_foo:
  /* foo = a1 */
  la a1, foo
  sw a0, 0(a1)

  ret
