# intro

prereq: basic c programming

we're going to "translate" (or "compile") virtual c code to asm.
so we'll see how cond & loop & func & var work.
since asm has nearly one-to-one correspond. to machine code,
you'll know how c code "translated" to machine code,
and they works directly with cpu and mem.


## why learn asm?

todo

## why choose riscv?

simple to learn (small instruction set)

for the details, we cover later.



# how to compile(?)

## setup

install:
- gcc-riscv64-linux-gcc: cross compiler for risc-v
- qemu-user: virt env for risc-v

check if installed with:

```
$ riscv64-linux-gnu-gcc --version
riscv64-linux-gnu-gcc (Ubuntu 14.2.0-4ubuntu2) 14.2.0
Copyright (C) 2024 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

```
$ qemu-riscv64 --version
qemu-riscv64 version 9.0.2 (Debian 1:9.0.2+ds-4ubuntu5.3)
Copyright (c) 2003-2024 Fabrice Bellard and the QEMU Project developers
```

## empty program

for now, we're going to write empty program.
the "hello world" program is easier once we write this, which we'll cover sooon.

```
.text
.global _start
_start:
  li a0, 0
  li a7, 93
  ecall
```

the `.text` is section: we declare the following is "code" (instruction)
as we'll see, data will be usually placed in other section.

`.global` says the `_start` needs to be known to assembler.
the `_start` is called "symbol"
note that, like `main` in c, `_start` is the entry point of asm (TODO: reference?)

`li` is just "load immediate", which load numbers to registers.
"immediate" means instruction has "constant", register is mem of cpu, which we'll cover soon.

now, we write `_start` "function" (yet asm itself has no concept like this) in the following the symbol.

now assembling:

```
$ riscv64-linux-gnu-as empty.S -o empty.o
```

and linking:

```
$ riscv64-linux-gnu-ld empty.o -o empty
```

execute:

```
$ ./empty
```

does nothing, but you can check the exit code

```
$ echo $?
0
```

## some explanation

actually, the code we've written is exit system call.
so, effectively it is the same with:

```c
#include <stdlib.h>

int main(void) {
  exit(0);
}
```

this is somewhat platform-agnostic version of exit.
what we've written is actually only for linux.
so, in this level:

```c
#include <unistd.h>
#include <sys/syscall.h>

int main(void) {
  syscall(SYS_exit, 0);
}
```

if you see the `SYS_exit` value, it will be `93`.
(see the reference (TODO))

actually, we've written is just calling syscall 93.

```
  li a0, 0
  li a7, 93
  ecall
```

in this code:
- `a0` takes the first argument
- `a7` determines the syscall num
we'll cover the details later.

but, does c compiler readlly translate code like this?
to answer that, we need to cover asm.
since above c code actually generate other codes, yet effectively the same with the one we've written.



# hello, world

here we're going to write less boring asm: printing something

## what is reg?

cpu only handles arithmetics with regs, not mem.
we'll cover arithmetics soon.

## what is section?

we can see the section in executable file, using objdump.



# implementing variables



# implementing cond



# implementing array



# implementing loop



# implementing string



# implementing func



# abi (calling convention)



# interrupt (i/o)



# syscall



# linker and executable formats



# details on risc-v

not a generic asm, but if you interested in RISC-V, see this section.
