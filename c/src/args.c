#include <stdio.h>

int main(int argc, char* argv[]) {
  for (int i = 0; i < argc; i++) {
    printf("argv[%d]: %s\n", i, argv[i]);
  }
  printf("argv[%d]: %p\n", argc, argv[argc]);

  return 0;
}
