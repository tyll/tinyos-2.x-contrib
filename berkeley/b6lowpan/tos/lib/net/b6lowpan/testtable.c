
#include <stdio.h>
#include <stdlib.h>
#include "table.h"

struct foo {
  int k1;
  int k2;
  char str[10];
};

struct foo data[5] = {{1,10, "foo"},
                      {2,9, "bar"}, 
                      {3,8, "baz"},
                      {4,7, "boop"},
                      {5,6, "razz"}};

void printrow(void * a){ 
  struct foo *f = (struct foo *)a;
  printf("%i: %i: %s\n", f->k1, f->k2, f->str);
}

int pred(void *a) {
  struct foo *f = (struct foo *)a;
  return (f->k2 == 6);
}

int main() {
  table_t t;

  table_init(&t, (void *)data, sizeof(struct foo), 5);
  table_map(&t, printrow);

  struct foo *found = (struct foo *)table_search(&t, pred);
  printrow(found);
}
