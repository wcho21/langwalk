#include <limits.h>
#include <stdio.h>

int main(void) {
  printf("signed int  : min = %11d, max = %d\n", INT_MIN, INT_MAX);
  printf("unsigned int: min = %11u, max = %u\n", 0, UINT_MAX);

  long n1 = 42;
  long long n2 = 99;
  printf("n1 = %ld, n2 = %lld\n", n1, n2);

  char c = 'A';
  printf("char: %%d = %d, %%c = %c\n", c, c);

  printf("size_t: %zu bytes\n", sizeof(size_t));
}
