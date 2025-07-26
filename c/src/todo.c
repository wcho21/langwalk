#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "task.h"

#define TODO_PATH "./.todo_list"
#define BUFFER_SIZE 1024

char* status_names[] = {
  [to_do] = "To-do",
  [done] = "Done"
};

int list(void);
int add(char* name);
task* parse_task(char* line);
void print_tasks(task tasks[], size_t size);
void print_task(task* t);
int get_last_id(void);
// Returns false if failed.
bool append_task(int id, char* name);

int main(int argc, char* argv[]) {
  if (argc == 1) {
    fprintf(stderr, "Error: no option given.\n");
    return EXIT_FAILURE;
  }

  if (strcmp(argv[1], "list") == 0) {
    return list();
  }
  if (strcmp(argv[1], "add") == 0) {
    return add(argv[2]);
  }

  fprintf(stderr, "Error: bad option '%s'.\n", argv[1]);
  return EXIT_FAILURE;
}

int list(void) {
  FILE* file = fopen("./.todo_list", "r");
  if (file == 0) {
    perror("fopen() failed");
    return EXIT_FAILURE;
  }

  char buffer[BUFFER_SIZE] = { 0 };
  while (fgets(buffer, sizeof buffer, file) != 0) {
    task* t = parse_task(buffer);
    print_task(t);
    t = free_task(t);
  }

  fclose(file);

  return EXIT_SUCCESS;
}

int add(char* name) {
  int last_id = get_last_id();
  if (append_task(last_id + 1, name)) {
    return EXIT_FAILURE;
  }

  printf("Task '%s' added\n", name);

  return EXIT_SUCCESS;
}

task* parse_task(char* line) {
  int id = 0;
  char name[BUFFER_SIZE] = { 0 };
  int status = 0;
  sscanf(line, "%d\t%[^\t]\t%d", &id, name, &status);

  task* t = malloc(sizeof(task));

  t->id = id;
  t->name = malloc(strlen(name) + 1);
  strcpy(t->name, name);
  t->status = status;

  return t;
}

int get_last_id(void) {
  FILE* file = fopen(TODO_PATH, "r");
  if (file == 0) {
    perror("fopen() failed");
    return 0;
  }

  char buffer[BUFFER_SIZE] = { 0 };
  while (fgets(buffer, sizeof buffer, file) != 0) /* do nothing */;

  task* task = parse_task(buffer);
  if (task == 0) {
    return -1;
  }

  int last_id = task->id;

  free_task(task);
  fclose(file);

  return last_id;
}

bool append_task(int id, char* name) {
  FILE* file = fopen(TODO_PATH, "a");
  if (file == 0) {
    perror("fopen() failed");
    return false;
  }

  fprintf(file, "%u\t%s\t%u\n", id, name, to_do);

  fclose(file);

  return true;
}

void print_tasks(task tasks[], size_t size) {
  for (size_t i = 0; i < size; i++) {
    print_task(tasks + i);
  }
}

void print_task(task* t) {
  char* status = status_names[t->status];

  printf("%d: %s\t%s\n", t->id, t->name, status);
}

