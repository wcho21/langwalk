FIX (TODO):
- add explicitly `-O0` when compile, to show the naive assembly

TODO: solve quizzes and add solution codes.
TODO: Why `sext.w` needed? (when compiled `if`)
TODO: Why `lw a0, foo` works? (Original format: `lw a0, 0(a1)`)
      -> A. this is a pseudo-instruction

TODO: introduce Byte-addressable
TODO: introduce registers alias and description (in ABI)
TODO: how can I load `pc` and why that works?

TODO: signed, and unsigned: representation and value
TODO: introduct relocation

TODO: immediate is constant encoded in instruction

TODO: explain the structure of an instruction, with each bit fields. With this, explain why 32 registers are there, plus source and destination register concepts, with opcode, which speicifies operation to perform. (Top-down: from objdump to binary)


TODO: use `/* */` format. there is an issue when using `# if` (figure out what is this.)

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
.align 2
.global _start
_start:
  # exit(0)
  li a0, 0
  li a7, 93
  ecall
```

If you curious what this code is doing, here is a basic assembly language concepts:

`.text` is called a section, and declares the following lines are instructions.
We'll see other sections later.

For `.align 2`, we omit explanation here, and will cover this later.

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
$ alias gcc="riscv64-linux-gnu-gcc -static -march=rv64g -mabi=lp64d"
$ gcc -nostdlib empty.S
```

We'll only cross-compile for risc-v here, so it is okay to hide original meaning.
We'll stick to this shorten `gcc` afterward.
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
We've written a program without explanation before, but here we'll explain some details.

## Writing a program

First, we write `.data` section:

```
.data
message: .asciz "Hello, assembly.\n"
.set len, . - message
```

`message` is called label, and we've already seen when using `_start`.
Basically label is a name to a memory address.
The directive `.asciz` is a C string, which ends with a null character.

The `.set` directive says what the `len` is to the assembler.
Here, the value is the length of the string at `message`.
The dot `.` means the current address, so the subtraction results in the difference in bytes, which is the length.

In the `.text` section, we start as before with:

```
.text
.align 2
.global _start
_start:
```

and write:

```
  # write(stdout, message, len)
  li a0, 1
  la a1, message
  li a2, len
  li a7, 64
  ecall
```

The system call with `64` is `write`, which takes three arguments.
Here we pass three values with `a0`, `a1`, and `a2` registers.
These are the file descriptor of `stdout`, and the address of `message`, and `len`, respectively.

The second instruction `la` is "load address", so `a1` is the address of `message`.

Finally, we write:

```
  # exit(0)
  li a0, 0
  li a7, 93
  ecall
```

to send the normal exit code `0`.

Execute and we'll get:

```
Hello, assembly.
```

Try different `message` string.
Try setting `len` manually and see the result.
What do you get?

## Registers

So far, we've been using registers, to use "variables".
In fact, processors only handle registers, not the memory, to do computation.
That is, the computation does not happen on memory, including arithmetics and even calling "function".
We'll cover registers in detail later.



# Section: Memory layout: Disassembling

We've written `.text` and `.data` section, which are instruction and constants, respectively.
This sets memory layout of executable.
To check this, we're going to see how executable is made in detail.

(TODO: divide contents into sections (good names?))

The following is making partial executable.

```
$ gcc -nostdlib -c hello.S
```

This yields `hello.o`, which is called an object file.
You can think of this as a partial block of executable.
We'll cover this in detail later.
Now let's look inside this file with:

```
$ riscv64-linux-gnu-objdump -h hello.o
```

or, to reduce typing

```
$ alias objdump=riscv64-linux-gnu-objdump
$ objdump -h hello.o
```

This will show the result something like this:

```
Sections:
Idx Name          Size      VMA               LMA               File off  Algn
  0 .text         00000024  0000000000000000  0000000000000000  00000040  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  1 .data         00000012  0000000000000000  0000000000000000  00000064  2**0
                  CONTENTS, ALLOC, LOAD, DATA
```

You can see the `.text` section has `READONLY`.
This means that the instruction won't be able to be changed in runtime, which makes sense.
So, the generated machine code in `.text` section will be proected.

In each section, there are what we've written.

```
$ objdump -d -j .text hello.o
```

The `-d` option restores the assembly from machine code, which we call disassemble,
and `-j` option choose the `.text` section.

```
Disassembly of section .text:

0000000000000000 <_start>:
   0:   00100513                li      a0,1
   4:   00000597                auipc   a1,0x0
   8:   0005b583                ld      a1,0(a1) # 4 <_start+0x4>
   c:   01200613                li      a2,18
  10:   04000893                li      a7,64
  14:   00000073                ecall
  18:   00000513                li      a0,0
  1c:   05d00893                li      a7,93
  20:   00000073                ecall
```

Note that the second and third instruction, `auipc` and `ld`.
What we've written is:

```
  li a1, message
```

It turns out that `li` is actually not a "real" instruction,
but provided as a shorthand for convenience by assembler, which is called pseudo-instruction.
This is why assembly language doesn't 100% corresponds to machine code, but almost.

There are many pseudo-instruction we'll use, but in most case we'll don't care.

Also, the following instruction:

```
  li a2, len
```

is changed to, by assembler:

```
  li a2, 18
```

That is, the `len` is calculated by assembler as `18`.

Note that 18 is 12_(16) in hexadecimal, which is the size of the `.data` section, as we've seen.

```
Idx Name          Size      VMA               LMA               File off  Algn
  1 .data         00000012  0000000000000000  0000000000000000  00000064  2**0
                  CONTENTS, ALLOC, LOAD, DATA
```

See the result for `.data` section.
Note that all sections starts with address `0`.
Actually, they're not yet determined.
In larger project, there may be more than one assembly files, so more than one object files.
The address of each section is determined when creating executable.

```
$ riscv64-linux-gnu-ld hello.o
```

This makes `a.out`, and we call this process linking.
So, what we've done first using `gcc` is assembly-and-linking, and this makes:

```
$ objdump -d -j .text a.out
```

```
Disassembly of section .text:

0000000000010120 <_start>:
   10120:       00100513                li      a0,1
   10124:       00002597                auipc   a1,0x2
   10128:       ec45b583                ld      a1,-316(a1) # 11fe8 <_GLOBAL_OFFSET_TABLE_+0x8>
   1012c:       01200613                li      a2,18
   10130:       04000893                li      a7,64
   10134:       00000073                ecall
   10138:       00000513                li      a0,0
   1013c:       05d00893                li      a7,93
   10140:       00000073                ecall
```

Now we can see the starting address is determined.
See the `.data` section yourself.

When we execute this executable, operating system loads this onto memory, and this process is done by what we call "loader".

Specifically, this file has ELF format, yet we don't cover in detail.
What matters is, this contains data about how to be loaded, as you can see like this:

```
$ riscv64-linux-gnu-readelf -h a.out
```

This prints ELF file header.
In this result, you can see something like this:

```
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00 
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              EXEC (Executable file)
  Machine:                           RISC-V
  Version:                           0x1
  Entry point address:               0x10120
```

See the entry point address.
This is the address of the `_start`.
So, when we execute this executable, all instructions and data in loaded onto memory, with the first instruction at the entry point address.

(TODO: memory layout)

The current instruction address is pointed by a special register, program counter, usually called `pc`.
Now, what computer is doing is just load the instruction at `pc`, execute it, and advance `pc` to the next instruction.
This is called fetch-and-execute cycle, and this is all the computer is doing.
It's that simple.

Note that instruction and memory are stored in a single memory organ.
We may design to separate this into two, but we didn't.
This architecture is called von Neumann architecture.

(TODO: von Neumann architecture)

He designed this architecture, in the first computer EDVAC.
As he said:

> While it appeared that various parts of this memory have to perform functions which differ somewhat in their nature and considerably in their purpose, it is nevertheless tempting to treat the entire memory as one organ...

-- First Draft of a Report on the EDVAC (1945)



# Implementing variables

Machine code is "native" code, which means directly executable by the machine.
So here we translate architecture-agnostic C code to architecture-specific machine code.

Basically, the assembly language has no abstract concept like in C:
- typed, scoped variable
- struct and array
- conditional (`if` and `else `statement)
- loop (`for` and `while`statement)
- function

However, in other words, we can implement this features only using the assembly.

Now we'll implement this features one by one.
That is, we're going to be a compiler itself for given virtual C code.

Here the first goal is (global) int variable:

```c
int foo = 42;
```

## Initialization

Note that variable is just a memory allocation.
Here, we define a memory space like this:

```
.data
foo: .word 42
```

The `.word` label makes 4-byte (32-bit) allocation, and write `42`.
Here we assume `int` is 4-byte.

To see the result, return the number with exit code as before:
With the usual starting `.text` section, write `_start`:

```
_start:
  lw a0, foo
  li a7, 93
  ecall
```

here `lw` means "load word".
Note that word is 4-byte here.

This should return `42` as exit code, after execution:

```
$ echo $?
42
```

## Really does compiler do that?

Make `int_c.c` file:

```
int foo = 42;

int main(void) {
  return foo;
}
```

This is C version of what we've done.
Let's compile only (not assemble nor link).

run

```
$ gcc -nostdlib -S int_c.c
```

Take a look at the output file `int_c.s`.
It includes something like this:

```
foo:
	.word	42
```

As we've manually written.



# Other variable sizes

(TODO: introduce hybrid C and memory alignment first here)

What if we need a size other than 4-byte `int`?
Note that `char` is a single byte in C.
For example, suppose that `short` and `long` are 2-byte and 8-byte, respectively.
Assembler supports this size with:

```
# long
baz: .dword 1234
# short
bar: .half 99
# char
foo: .byte 42
```

Of course, there are other types like floating-point, but we don't cover that kind of type here.

Note that it's our resposibility to keep track of types.

## Hybrid C

Here, we're going to make an executable with C, to use `printf`.
To do so, we'll learn how to "embed" assembly in C.

First, make C file `types.c`:

```c
#include <stdio.h>

extern char foo;
extern short bar;
extern long baz;

int main(void) {
  printf("foo: %d, bar: %hd, baz: %ld\n", foo, bar, baz);
  return 0;
}
```

Here we declare variables with `extern`, which come from assembly.
Make an assembly `types.S`:

```
.data
.global baz
baz: .dword 1234
.global bar
bar: .half 99
.global foo
foo: .byte 42
```

And we make an executable:

```
$ gcc types.c types.S
```

Execute:

```
foo: 42, bar: 99, baz: 1234
```

## Alignment

Does C compiler really do this?
Actually, there is a reason to write larger memory first, and it's due to memory alignment.
But, First, we'll see how C is compiled with these data types.
Write this `align_c.c` code:

```
char foo = 42;
int bar = 99;
long baz = 1234;

int main(void) {
  return 0;
}
```

Now compile as before:

```
$ gcc -S align_c.c
```

and see `align_c.s`. Then you'll see something like:

```
	.globl	bar
	.align	2
	.type	bar, @object
	.size	bar, 4
bar:
	.word	99
```

The `.globl` directive is another name of `.global`.
We'll ignore `.type` and `.size` directive, since it's not essential here.
So basically it declares a `bar` global `int` (4-byte) variable.
But notice the following `.align` directive line.

```
	.align	2
```

The number `2` is the exponent of 2, so it aligns 4-byte.

It's meaning gets clearer when we disassemble:

```
$ gcc -c align_c.c
$ objdump -d -j .data --no-show-raw-insn align_c.o
```

Then you'll get

```
Disassembly of section .data:

0000000000000000 <foo>:
   0:   *...

0000000000000004 <bar>:
   4:   c...

0000000000000008 <baz>:
   8:   ........
```

Note that, though `foo` is 1-byte, but `bar` starts at the address `4`.
Since we've aligned the address by `4`.

Here is a mini quiz.
Explain why `baz` starts at `8`.
See the compiled assembly code, and how it is aligned (you will find `.align 3`, which is 8-byte alignment.)

This memory alignment is necessary, not mandatory but strongly recommended.
Some execution environment may support the unaligned memory, but it'll have performance panelty, though we don't cover this in detail of hardware implementation.

Also, `.text` section must be aligned by 4-byte.
So, you'll find this code in `align_c.s`:

```
	.text
	.align	2
```

RISC-V spec states it requires this alignment.

See the C code:

See the disassemble of `.data` (aligned):

Introduce `.aligned`, and why we need this, using reference.



# Implementing arithmetics

Now that we've implemented global variables, let's compile addition.

The virtual c code is:
```c
int foo = 42;

int main(void) {
  return foo + 99;
}
```

The point is the addition.

It's simple, because this arithmetic is directly supported.
Copy the `int.S` file to `add.S` file, and just add a single line:
```
  # exit(foo + 99)
  lw a0, foo
  addiw a0, a0, 99
  li a7, 93
  ecall
```

Execute and we get the exit code `141`.

You can find c assembler generate similar code for this `add_c.c`:
```
int foo = 42;

int main(void) {
  return foo + 99;
}
```

Check again as we've done above.
You'll find somethign like this:

```
	lw	a5,0(a5)
	addiw	a5,a5,99
```

## See the detail in add instruction

(TODO: analyze hex dump and introduce how bits in the instruction are organized)

## Subtraction

(TODO: make this a quiz and omit the details)

How about subtraction?

```c
int foo = 42;

int main(void) {
  return 99 - foo;
}
```

If you want to do yourself first, use the `sub` instruction:
```
sub rd, rs1, rs2
```

Here `rd` is the destination register, and other two is the source registers. It results in `rs1 - rs2`.

Note that it doesn't have immediate version, so it requires two registers.

The example answer is:

```
  # exit(foo - 42)
  lw a0, foo
  li a1, 42
  sub a0, a0, a1
  li a7, 93
  ecall
```

Execute it and you'll get `57`.



# Implementing assignment

So far we loaded values from memory, using `lw` instruction:

```
  lw a1, foo
```

Now it's time to save value to memory.
The key is `sw` instruction, which means "save word":

```
  sw rs1, offset(rs2)
```

The virtual C code is assignment:

```c
int foo = 42;

int main(void) {
  foo = 99;
  return foo;
}
```

Let's implement using assembly, with `foo` as before:

```
.text
.global _start
_start:
  # foo = 99
  la a0, foo
  li a1, 99
  sw a1, 0(a0)
```

Here `la` is load address, so `a0` has the address of `foo`.
Now, `sw` instruction stores the value `a1` to the address `a0`.

Return the exit code:

```
  # exit(foo)
  lw a0, foo
  li a7, 93
  ecall
```

Execute and you'll get `99`.

Now we covered how to load from and save to memory.

Quiz: do the following, which loads `foo`, increment the value, and save it to `foo`

```c
int foo = 42;

int main(void) {
  foo++;
  return foo;
}
```



# Implementing conditional

Now we'll cover conditional and loop.
Note that all the program we've seen is sequentially executed, with fetch-and-execute cycle and incrementing program counter as described before.

But sometimes we have to jump to other instruction, not incrementing program counter.
For example, see this `if` statement:

```c
if (foo == 42) {
  // ...
}
```

To implement this code, we need to "jump" when `foo` is not `42`.
This requires program counter to be directly changed.

By jumping forward, we'll implement conditional statement.
By jumping backward, loop statement.

Of course, assembly has no concept of conditional or loop.
But we're going to implement these features using only "jump".

## Implementing `if`

Let's implement this virtual C code:

```c
if (foo == 42) {
  foo++;
}
```

Write assembly code:
```
_start:
  lw a0, foo
  li a1, 42
```

We prepare foo and 42 to registers.

Now, this is `if` statement:

```
  bne a0, a1, if_end
  # foo++
  addi a1, a1, 1
  la a0, foo
  sw a1, 0(a0)
if_end:
```

`bne` is "branch when not equal", so jump to `if_end` if not equal.
The addition won't be executed if `foo` (`a0`) and `42` (`a1`) are the the same.
Note that we use opposite condition in assembly, so it may be somewhat confusing.

Now, `a0` is already `foo`
```
  lw a0, foo
  li a7, 93
  ecall
```

Execute:
```
$ echo $?
43
```

This means the body has been executed.
Change `foo` to other value and try again, to see the body is not executed.

Mini quizzes:
- In this way, we can implement if-else..
- Short-circuit behaviour of `&&`. Suppose that we need a condition that `foo` and `bar` both equal to `42`.



# Implementing array

(TODO: add string if necessary, for now, the contents is too short and already briefly introduce in the first section, so omitted)

Before implementing loop, we shortly introduce how to implement array and string.
These are simply a block of memory with arbitrarily determined size.

## Array

Let's compile this virtual C code:

```c
int arr[] = { 42, 99, 1 };
```

Arrays are contiguous memory allocation, which is specified by:

```
.data
arr: .skip 12
```

with filled with `0`'s.
Since we have three elements of 4-byte.
And, as before, `arr` will be the base address of the array.

Or, we can specify each element by:
```
.data
arr:
  .word 42
  .word 99
  .word 1
```

Can we add up the elements?
Let's initialize registers:
```
_start:
  /* initialize */
  li a0, 0
  la a1, arr
```

We can add the first element:
```
  /* a2 += arr[0]  */
  lw a2, 0(a1)
  addw a0, a0, a2
```
and second one:
```
  /* a2 += arr[1]  */
  lw a2, 4(a1)
  addw a0, a0, a2
```

Note that `4` in ``4(a1)` is offset.
Add the third element in this way (Do it).

Since `a0` already has the value, we just call exit:
```
  /* exit(a0) */
  li a7, 93
  ecall
```

The result exit code will be `142` (check it).



# Implementing loop

Is there a better way to sum up the elements?
Maybe we can use a loop.
The virtual c code:

```c
int arr[3] = { 42, 99, 1 };
int i = 0;
int sum = 0;

int main(void) {
  for (; i < 3; i++) {
    sum += arr[i];
  }

  return sum;
}
```

As we mentioned, the loop can be implemented using branching.
With the same data as before, initialize:
```
_start:
  /* initialize */
  li a0, 0 /* sum */
  li a1, 3
  li a2, 0 /* i */
```

Note that we simply use registers, instaed of memory.

Now we add a label for loop beginning:
```
loop_start:
  /* jump if i >= 3 */
  bge a2, a1, loop_end
```

This make `pc` jump to the end of the loop.
We'll add the `loop_end` label when needed.

To access an element, we calculate address from the index variable `i`, or the register `a2`:
```
  /* get offset */
  mv a4, a2
  slli a4, a4, 2
```

Here, `mv` is just copy the value, and `slli` is bit shifting to the left, with immedaite value `2`.
Note that when you shift left the binary `1` to `100`, it is effectively same with multiplying by `4`.
Since `i` represent the byte, we multiplied it by `4`.

Now the address of the element is:
```
  /* a3 = arr + i */
  la a3, arr
  add a3, a3, a4
```
and the value is:
```
  /* a5 = arr[i] */
  lw a5, 0(a3)
```

Finally, we add the element to `sum`, or `a0`:
```
  /* sum += arr[i] */
  add a0, a0, a5
```

Now, we increment `i` and jump to the beginning.
This is the loop, so we mark there as the end.
```
  /* i += 1 */
  addi a2, a2, 1
  j loop_start
loop_end:
```

Here, `j` is unconditional jump.
The instruction as `bne` is called conditional jump.

As before, since `a0` is already the sum, we return it:
```
  /* exit(a0) */
  li a7, 93
  ecall
```

The result should be `142`, as before.



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





# syscall

we need to understand: previleged level
note that this is abstract concept in other asm, possibly different names though.

TODO

introduce: mmap

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

## what is section?

we can see the section in executable file, using objdump.

TODO: cover memory layout -> executable

---

# Reference

[An Introduction to Assembly Programming with RISC-V][intro-asm-riscv]

[The RISC-V Instruction Set Manual][riscv-manual]

[RISC-V ABIs Specification][riscv-abi]

https://gcc.gnu.org/onlinedocs/gcc/Link-Options.html
https://gcc.gnu.org/onlinedocs/gcc/RISC-V-Options.html
https://sourceware.org/binutils/docs-2.41/as/index.html

http://riscvbook.com/korean/risc-v-reader-korean-v1p0.pdf

[intro-asm-riscv]: https://riscv-programming.org/book/riscv-book.html
[riscv-manual]: https://github.com/riscv/riscv-isa-manual
[riscv-abi]: https://github.com/riscv-non-isa/riscv-elf-psabi-doc
