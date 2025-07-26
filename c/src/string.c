#include <stdio.h>

int main(void) {
  char* name = "Learn C";
  printf("%c\n", *name);

  char array[] = { 'L', 'e', 'a', 'r', 'n', ' ', 'C', '\0' };
  printf("%s\n", array);
  printf("%s\n", name);
  printf("%s\n", &array[0]);
}
