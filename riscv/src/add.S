.data
foo: .word 42

.text
.global _start
_start:
  lw a0, foo
  addi a0, a0, 99
  li a7, 93
  ecall
