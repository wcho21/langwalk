.data
foo: .word 42

.text
.global _start
_start:
  # exit(foo + 99)
  lw a0, foo
  addiw a0, a0, 99
  li a7, 93
  ecall
