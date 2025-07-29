.data
foo: .word 42

.text
.global _start
_start:
  li a0, 99
  jal set_foo

  la t0, foo
  lw a0, 0(t0)
  li a7, 93
  ecall

set_foo:
  la t0, foo
  sw a0, 0(t0)
  
  ret
