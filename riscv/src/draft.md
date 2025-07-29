FIX (TODO):
- do not objdump on executable,
  for simplicity, do on object file
- add `ip64` -mabi flag



# Introduction

(Motivation to learn ASM)
When we programming, with compiler-language like C, it's actually high-level formal language, which means that it abstracts away the machine-level details.
C makes you don't need to care about these details.
But it doesn't not necessarilly means you don't have to know that.

The machine actually understands the machine code, not C language.
Most people usually don't care about assembly language, and most time it is okay.
But when we learn assembly language, we can learn the machine-level details such as:
- Overall memory layout, so you'll understand data and instruction is treated in the same way.
- Why using local variable is cheap, while using dynamic allocation is expensive.
- Why manual optimizing is poor, which is responsitibility of compiler (unrolling, tail-recursion)
- How OS interacts hardwares, which is delegated by our C or assembly codes.
and so on

(Prereq)
You need to have basic programming experience to understand this page.
C programming is preferable, since the example code will use C, but not mandatory.

(What we'll do)
We're going to manually "translate" (or "compile") virtual c code to assembly.
That is, to be a manual compiler, to understand how assembler works and assembly language.
Specifically, we'll cover:
- How variables are made.
- How conditional statements (if-else) are made.
- How loops (for) are made
- How functions are made.
Also, we'll learn that:
- How processor execute instructions from memory.
- How I/O interaction with hardware is made.
- How program is made.
- How O/S load program and execute.

Note that assembly language nearly corresponds to the machine code, or "native code".
And the native code is the code that processor can directly run without translation.
So, there are various kinds of assembly languages, from simple ones to complex ones.
Here we choose RISC-V assembly language, as a simple one, and it'll reduces learning time, but covering core concepts among assembly languages.

(Environment)
In this article, we don't cover how to set up environment, but you can refer the (TODO: reference to langwalk readme).
We need a cross-compiler for RISC-V.
Second, we need RISC-V environment emulator, since we don't have "real" RISC-V machine.
In Ubuntu, install the following package and you can check:
```
$ riscv64-linux-gnu-gcc --version
riscv64-linux-gnu-gcc (Ubuntu 14.2.0-4ubuntu2) 14.2.0
Copyright (C) 2024 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```
In Ubuntu, install `qemu-user` package and you can check:
```
$ qemu-riscv64 --version
qemu-riscv64 version 9.0.2 (Debian 1:9.0.2+ds-4ubuntu5.3)
Copyright (c) 2003-2024 Fabrice Bellard and the QEMU Project developers
```



# Empty program

For now, we're goint to write an empty program, to learn how to make a program with assembler.
Once we've done this, we'll understand more easily the "Hello-world" program, which we'll write soon.

## Writing assembly

Make a file `empty.S`:

```asm
.text
.global _start
_start:
  li a0, 0
  li a7, 93
  ecall
```

If you curious what this code is doing, here is a basic assembly language concepts:

`.text` is called a section, and declares the following lines are instructions.
We'll see other sections later.

`.global` says the `_start` needs to be known to assembler, which is assembler directives, according to [assembler manual][gnu-as-dir].
The `_start` is called symbol.
Note that, like `main` in C, `_start` is the entry point.

[gnu-as-dir]: https://sourceware.org/binutils/docs-2.41/as/Pseudo-Ops.html

Then we start writing instructions.
`li` is just "load immediate", which load a constant number to a register.
Here "immediate" means instruction has "constant", and register is a memory of processor, which we'll cover soon.

The last two lines returns exit code with `a0`, here `0`.
We'll cover what these line exactly mean later.

Now we translate this assembly code to machine code.

```
$ riscv64-linux-gnu-gcc -nostdlib -static -march=rv64g -mabi=lp64d empty.S
```

The output file `a.out` has machine code, and called executable.
We'll cover what these options mean in the last section, when we can understand.
To avoid tedious typing, here is a tip: make an alias.

```
$ alias gcc="riscv64-linux-gnu-gcc -nostdlib -static -march=rv64g -mabi=lp64d"
$ gcc empty.S
```

We'll only cross-compile for risc-v here, so it is okay to hide original meaning.
Note that the alias is gone when restarting the shell.

Execute:

```
$ ./a.out
```

Actually, it implicitly runs:

```
$ qemu-riscv64 ./a.out
```

By execute, we mean this process.
We'll stick to the first simpler one.

It does nothing, but you can check the exit code:

```
$ echo $?
0
```

Try change `0` in the following line:

```
  li a0, 0
```

Make an executable, and execute it to see the changed exit code.




# Hello example

Here we're going to write more interesting one: printing something.

## what is reg?

cpu only handles arithmetics with regs, not mem.
we'll cover arithmetics soon.

## what is section?

we can see the section in executable file, using objdump.



# implementing variables

asm is "native" code, which means "directly executed by machine"
so here we translate arch-agnostic C code to arch-specific machine code

basically, asm has no abstract concept provided in C,
such as
- typed, scoped variable
- struct and array
- conditiona (if-else)
- loop (for, while)
- function
but in other words, we "can" implement this features
only using the basic features of asm.

now we'll implement this features one by one.
the first one is (global) int variable

```c
int foo = 42;
```

## initialization

note that variable is just a memory allocation.
here, we define a memory using like this:
```
.data
foo: .word 42
```

the `.data` section tells this is not a instructions, but just (global) data.
by `num:` we make a label (or symbol).
`.word` makes 4-byte (32-bit) allocation in executable code, and write `42` there.
(we assume `int` is 4-byte)

## run

now we return the `num` with exit as before:
```
.text
.global _start
_start:
  lw a0, foo
  li a7, 93
  ecall
```

here `lw` means "load word".

this should return `42` as exit code

```
$ echo $?
42
```

## really does compiler do that?

we can "compile" only, by which we mean translating c to asm, but not making to executable.

make `int_c.c` file:

```
int foo = 42;

int main(void) {
  return 0;
}
```

run

```
$ riscv64-linux-gnu-gcc -S int_c.c
```

and take a look at `int_c.s`.
then it includes something like this:

```
foo:
	.word	42
```

as we've manually written.

## other sizes?

TODO

## other types?

of source risc-v supports floating-point types, but we won't cover here.


# implementing arith

now that we've implemented global int variable,
let's do that for addition.

the virtual c code is:
```
foo + 99;
```

it's simple, because asm support this arithmetics directly:
```
  lw a0, foo
  addi a0, a0, 99
  li a7, 93
  ecall
```

execute and we get:
```
$ echo $?
141
```

you can find c assembler generate similar code for:
```
int foo = 42;

int main(void) {
  return foo + 99;
}
```

do the check again as we've done above.

TODO: why gcc generate addiw instead of addi?


# implement assign

TODO: (use sw)


# implementing cond

## how computer read instructions: pc register

here's how computer basically works:
- program is loaded to memory
- cpu fetch next instruction from memory
- exec instruction
- repeat

this is basically called von neumann arch,
and this cycle is called fetch-and-execute.

fetching next instruction is common here,
so cpu uses a special register, program counter,
to save the memory address of current instruction
and automatically incremented when a single cycle is done.
so instruction is executed sequentially.

but sometimes we don't need this sequential execution.
for example, see this if-statement:
```c
if (foo == 42) {
  // ...
}
```

to implement this code, we need to "jump" for the case when `foo` is not `42`.
so we need to change the value of pc register.
by setting pc to be address forward,
we can impelement cond.
as we'll see, by setting it backward,
loop is implemented.

of course, asm has no concept of "cond" and "loop".
but we're going to implement this here.

## impl if

let's implement this virtual c code:
```c
if (foo == 42) {
  foo++;
}
```

asm code, with foo as above:
```
_start:
  lw t0, foo
  li t1, 42
```

we prepare foo and 42 to temporary registers t0, t1

now, if they are not the same, jump the body:

```
  bne t0, t1, if_end
  addi t0, t0, 1
if_end:
```

`bne` is branch when not equal.
note that we use opposite condition when writing asm.

now, end with exit syscall
```
  mv a0, t0
  li a7, 93
  ecall
```

here `mv` is simply copy `t0` to `a0`.

execute:
```
$ echo $?
43
```

why? the foo was 42, and the body has been executed.
change foo other value and try again.
the body will not executed

in this way, we can implement if-else.
if-else is left as an exercise.

short-circuit behaviour also left as an exercise

## c compiler

compile this code to executable:
```c
int foo = 42;

int main(void) {
  if (foo == 42) {
    foo++;
  }

  return 0;
}
```

with:
```
$ gcc -static -g if_c.c
```

now you can "disassemble":
```
riscv64-linux-gnu-objdump --disassemble=main -S --no-show-raw-insn a.out
```

this prints source codes with asm codes.

then you can find similar code with this:
```
  if (foo == 42) {
   10664:       auipc   a5,0x76
   10668:       addi    a5,a5,-1628 # 86008 <foo>
   1066c:       lw      a4,0(a5)
   1066e:       li      a5,42
   10672:       bne     a4,a5,10690 <main+0x34>
```

you can see the `bne` asm.
and the address is the end of if block.

# implementing array

TODO

# implementing loop

virtual c code:

```c
int arr[5] = { 1, 2, 3, 4, 5 };
int sum = 0;
int i = 0;

int main(void) {
  for (i = 0; i < 5; i++) {
    sum += i;
  }
}
```

note that `+=` is a shorthand for this:
```
sum = sum + i
```

as we mentioned, for loop can be implemented using branching.

TODO: show the code

# implementing func

so far, cond and loop are jump in functions.
now, we implement function.
so we jump other code.

but it turns out that func is not as simple as cond or loop,
becuase it should handle the recursion, calling itself.
this requires stack, as we'll see.

first we implement a simple "leaf" function.
second we'll implement recursion.

## simple leaf function

virtual c code:

```c
int foo = 42;

void set_foo(int n) {
  foo = n;
}

int main(void) {
  set_foo(99);
}
```

here we implement parameters.
return values are covered later.

with `foo` as above:
```
_start:
  li a0, 99
  jal set_foo
```

`a0` is the first argument
this jump to set_foo symbol.
this is jump and link, but we cover the meaning later.

the following code just sends normal exit code
```
  la t0, foo
  lw a0, 0(t0)
  li a7, 93
  ecall
```

`la` is load address, so the first two lines load the foo's value to `a0`

now, below the _start, make set_foo symbol and function body:
```
set_foo:
  la t0, foo
  sw a0, 0(t0)
  
  ret
```

noe that `a0` is first parameter.
so it stores first parameter to foo.
last `ret` returns to caller, which is the next instruction of the `jal`

in this way, `jal` and `ret` are used in pair.
but, how can `ret` know where to return without explicit address?

## ret

TODO

## recursion

TODO

## stack

TODO

# abi (calling convention)

this section explains why we used first arg as a0.

TODO




# implementing string

application example: atoi



# interrupt (i/o)



# syscall

we need to understand: previleged level
note that this is abstract concept in other asm, possibly different names though.

TODO


# linker and executable formats



# details on risc-v

not a generic asm, but if you interested in RISC-V, see this section.


---

# fridge

---

MOVE: maybe better in assembling and linking section

If you're curious, run:
```
$ riscv64-linux-gnu-ld --verbose | grep ENTRY
ENTRY(_start)
```

---

MOVE: maybe better in syscall section

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

---
