.data
foo: .word 42

.text
.align 2
.global _start
_start:
  li a0, 99
  jal set_foo

  lw a0, foo
  li a7, 93
  ecall

set_foo:
  la t0, foo
  sw a0, 0(t0)
  
  ret
