#ifndef TASK_H
#define TASK_H

typedef struct task {
  int id;
  char* name;
  int status;
} task;

enum status { to_do, done };

task* free_task(task* task);

#endif
