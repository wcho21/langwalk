.data
foo: .word 42

.text
.global _start
_start:
  lw a0, foo
  li a7, 93
  ecall
