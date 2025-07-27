#include <stdio.h>

extern "C" {
  void asmMain( void );
}

int main(void) {
  printf( "Calling asmMain:\n" );
  asmMain();
  printf( "Returned from asmMain\n" );
}
