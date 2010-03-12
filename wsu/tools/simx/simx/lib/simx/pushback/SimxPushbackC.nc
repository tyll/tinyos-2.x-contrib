#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include "pushback.h"

#ifndef TOSSIM
#error "SimX/Pushback only works when compiled under Tossim"
#endif

#define XASSIGN(ptr, value) if (ptr) {*ptr = value;}

int simx_pushback_invoke(const char *name, pushback_result_t *result, ...);
int simx_pushback_invoke_va(const char *name, pushback_result_t *result,
                            va_list va);

typedef struct pushback_chain {
  pushback_t pushback;
  struct pushback_chain *prev; /* NULL at BEOL */
  struct pushback_chain *next; /* NULL at EOL */
} pushback_chain_t;

pushback_chain_t *pushback_head = NULL;


module SimxPushbackC {
  provides interface SimxPushback as Pushback;
}
implementation {

  int hack_dirty;
  int hack_err;

  command void Pushback.resetHack() {
    hack_dirty = 0;
    hack_err = 0;
  }

  command int Pushback.pushVa(const char *name,
                              pushback_result_t *result,
                              va_list va) {
    int err = simx_pushback_invoke_va(name, result, va);
    if (err) {
      fprintf(stderr, "Could not invoke '%s' pushback: is it registered?\n",
              name);
    }
    return err;
  }

  // PST- does not free result of string type!
  command int Pushback.pushLongVa(const char *name,
                                  long *long_result,
                                  va_list va) {
    pushback_result_t result;
    int err;

    if (hack_dirty) {
      return hack_err;
    }
    hack_dirty = 1;

    err = simx_pushback_invoke_va(name, &result, va);
    if (err) {
      XASSIGN(long_result, -1);
    } else if (PUSHBACK_LONG != result.type) {
      XASSIGN(long_result, -1);
      err = PUSHBACK_EXPECTING_LONG;
    } else {
      XASSIGN(long_result, result.data.l);
    }

    hack_err = err;
    return err;
  }

  /* 
     Lookup a pushback for a given name. Returns NULL if no
     corresponding pushback exists.
  */
  pushback_chain_t *simx_pushback_find(const char *name) {
    pushback_chain_t *n;
    for (n = pushback_head; n != NULL; n = n->next) {
      if (strcmp(name, n->pushback.name) == 0) {
        return n;
      }
    }
    return NULL;
  }

  /*
    Run the pushback with given name. The result, on success, is
    stored in result. Returns 0 on success.
  */
  int simx_pushback_invoke_va(const char *name, pushback_result_t *result,
                              va_list va)
    __attribute__ ((C, spontaneous)) {
    pushback_chain_t *n = simx_pushback_find(name);
    if (!n) {
      return PUSHBACK_UNKNOWN_PUSHBACK;
    } else {
      pushback_t *pb = &n->pushback;
      pushback_result_t temp = pb->fn(pb, va);
      if (result) {
        *result = temp;
        if (PUSHBACK_EXCEPTION == result->type) {
          return PUSHBACK_INVOKE_ERROR;
        }
      }
      return 0;
    }
  }

  int simx_pushback_invoke(const char *name, pushback_result_t *result, ...)
    __attribute__ ((C, spontaneous)) {
    va_list va;
    int res;

    va_start(va, result);
    res = simx_pushback_invoke_va(name, result, va);
    va_end(va);

    return res;
  }

  /*
    Add a new pushback. If a pushback of the same name already exists
    it is only replaced if overwrite is specified. Returns 0 on
    success. If the pushback is not added, the caller is responsible
    to free any data in pushback.
  */
  int simx_pushback_add(pushback_t pushback, int overwrite)
    __attribute__ ((C, spontaneous)) {
    pushback_chain_t *f = simx_pushback_find(pushback.name);
    if (f) {
      // found existing
      if (!overwrite) {
        return PUSHBACK_DUPLICATE_NAME;
      }

      // if replacing, free existing data
      f->pushback.dtor(&f->pushback);
      f->pushback = pushback;
    } else {
      // new
      pushback_chain_t *n = malloc(sizeof(pushback_chain_t));
      if (!n) {
        perror(__FILE__ ": Failed to allocate memory");
        return PUSHBACK_ERROR;
      }

      // add at beginning
      n->prev = NULL;
      n->next = pushback_head;
      n->pushback = pushback;
      pushback_head = n;
    }
    return 0;
  }

  /*
    Remove the pushback with the specified name. 0 is returned if a
    pushback is removed.
  */
  int simx_pushback_remove(char *name)
    __attribute__ ((C, spontaneous)) {
    pushback_chain_t *n = simx_pushback_find(name);
    if (!n) {
      return PUSHBACK_UNKNOWN_PUSHBACK;
    }

    // if removing first item...
    if (n == pushback_head) {
      if (n->next) {
        pushback_head = n->next;
      } else {
        pushback_head = NULL;
      }
    }

    // remove links
    if (n->next) {
      n->next->prev = n->prev;
    }
    if (n->prev) {
      n->prev->next = n->next;
    }
    
    // free
    n->pushback.dtor(&n->pushback);
    free(n);

    return 0;
  }

  const char *simx_pushback_errstr(int err) {
    switch(err) {
    case PUSHBACK_SUCCESS:        return "Success";
    case PUSHBACK_ERROR:          return "Error (unspecified)";
    case PUSHBACK_DUPLICATE_NAME: return "Duplicate name";
    case PUSHBACK_INVOKE_ERROR:   return "Invocation raised exception";
    case PUSHBACK_EXPECTING_LONG: return "Expecting long result type";
    default: return "Unknown error";
    }
  }   

}
