#include <stdio.h>

void bad_swap(int x, int y);
void swap(int* x, int* y);

int main(void) {
  int n = 42;
  int m = 99;

  int temp = n;
  n = m;
  m = temp;

  printf("Swapped directly: %d, %d\n", n, m);

  // Swap using functions
  bad_swap(n, m);
  printf("Using bad_swap: %d, %d\n", n, m);
  swap(&n, &m);
  printf("Using swap: %d, %d\n", n, m);
}

void bad_swap(int x, int y) {
  int temp = x;
  x = y;
  y = temp;
}

void swap(int* x, int* y) {
  int temp = *x;
  *x = *y;
  *y = temp;
}
