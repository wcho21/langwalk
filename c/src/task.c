#include <stdlib.h>
#include "task.h"

task* free_task(task* t) {
  if (t == 0) {
    return 0;
  }

  if (t->name != 0) {
    free(t->name);
    t->name = 0;
  }

  free(t);

  return 0;
}
