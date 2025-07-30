.data
message: .asciz "Hello, assembly.\n"
.set len, . - message

.text
.align 2
.global _start
_start:
  # write(stdout, message, len)
  li a0, 1
  la a1, message
  li a2, len
  li a7, 64
  ecall

  # exit(0)
  li a0, 0
  li a7, 93
  ecall
