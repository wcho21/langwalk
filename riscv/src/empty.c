#include <unistd.h>
#include <sys/syscall.h>
#include <stdio.h>

int main(void) {
  syscall(SYS_exit, 0);
}
