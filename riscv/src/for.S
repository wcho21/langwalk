.data
arr:
  .word 42
  .word 99
  .word 1

.text
.align 2
.global _start
_start:
  /* initialize */
  li a0, 0 /* sum */
  li a1, 3
  li a2, 0 /* i */

loop_start:
  /* jump if i >= 3 */
  bge a2, a1, loop_end
  /* get offset */
  mv a4, a2
  slli a4, a4, 2
  /* a3 = arr + i */
  la a3, arr
  add a3, a3, a4
  /* a5 = arr[i] */
  lw a5, 0(a3)
  /* sum += arr[i] */
  add a0, a0, a5
  /* i += 1 */
  addi a2, a2, 1
  j loop_start
loop_end:

  /* exit(a0) */
  li a7, 93
  ecall
