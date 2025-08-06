#include <stdio.h>

extern char foo;
extern short bar;
extern long baz;

int main(void) {
  printf("foo: %d, bar: %hd, baz: %ld\n", foo, bar, baz);
  return 0;
}
