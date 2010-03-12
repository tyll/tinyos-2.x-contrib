#include "pushback.h"

Pushback::Pushback() {
}

Pushback::~Pushback() {
}

int Pushback::addPushback(pushback_t pushback, bool overwrite) {
  return simx_pushback_add(pushback, overwrite);
}

int Pushback::removePushback(char *name) {
  return simx_pushback_remove(name);
}

int Pushback::invokePushback(char *name, pushback_result_t *result, ...) {
  //  return simx_pushback_invoke_va(name, result);
  return -1;
}
