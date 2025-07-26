#include <stdio.h>

int main(void) {
  int some_value = 42;
  int* p = &some_value;

  printf("%d\n", *p);
}
