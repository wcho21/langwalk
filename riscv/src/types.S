  .data
foo:
  .byte 42
  .align 1
bar:
  .half 99
  .align 3
baz:
  .dword 1

  .global baz
  .global bar
  .global foo
