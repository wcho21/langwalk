  .data
foo:
  .word 42

  .text
  .align 2

  .global _start
_start:
  /* initialize */
  lw a0, foo
  li a1, 42
  li a2, 44
  
  /* if (42 <= foo */
  blt a0, a1, if_end
  /* && foo <= 44) */
  bgt a0, a2, if_end
  /* foo++ */
  addiw a0, a0, 1
  la a1, foo
  sw a0, 0(a1)
if_end:

  /* exit(foo) */
  lw a0, foo
  li a7, 93
  ecall
