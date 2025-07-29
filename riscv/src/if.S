.data
foo: .word 42

.text
.global _start
_start:
  lw t0, foo
  li t1, 42
  
  bne t0, t1, if_end
  addi t0, t0, 1
if_end:

  mv a0, t0
  li a7, 93
  ecall
