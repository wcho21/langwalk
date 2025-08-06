  .data
msg:
  .asciz "Hello, world!\n"
  .set len, . - msg

  .text
  .align 2

  .global _start
_start:
  /* write(stdout, msg, len) */
  li a0, 1
  la a1, msg
  li a2, len
  li a7, 64
  ecall

  /* exit(0) */
  li a0, 0
  li a7, 93
  ecall
