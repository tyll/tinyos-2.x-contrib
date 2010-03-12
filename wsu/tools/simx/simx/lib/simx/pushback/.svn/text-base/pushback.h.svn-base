#ifndef PUSHBACK_H
#define PUSHBACK_H

#include <stdarg.h>

#ifdef __cplusplus
extern "C" {
#endif
#if 0 /* To keep emacs indent nice */
}
#endif

/* PST-- SWIG 1.3.35 does not supported nested unions */
typedef union {
  double d;
  long l;
  void *h;
} pushback_result_union_t;

/* possible error return values */
enum {
  PUSHBACK_SUCCESS = 0,
  PUSHBACK_ERROR = -1,     /* general error */
  PUSHBACK_DUPLICATE_NAME = -42,
  PUSHBACK_INVOKE_ERROR,
  PUSHBACK_EXPECTING_LONG,
  PUSHBACK_UNKNOWN_PUSHBACK
};

/* possible values of pushback_result_t.type */
enum {
  PUSHBACK_NONE = 1,
  PUSHBACK_EXCEPTION,
  PUSHBACK_LONG,
  PUSHBACK_DOUBLE,
  PUSHBACK_STRING
};

typedef struct {
  /* Caller-responsible to free data.h if type is PUSHBACK_STRING */
  unsigned char type;
  pushback_result_union_t data;
} pushback_result_t;

typedef pushback_result_t (*pushback_fn_t)(void *pushback, /* pushback_t* */
                                           va_list vargs);

typedef struct pushback {
  char *name;
  /* See http://docs.python.org/api/arg-parsing.html. May be NULL. */
  char *format;
  pushback_fn_t fn;
  void *data;
  /* Used to free pushback_t: name, format, data, etc... */
  void (*dtor)(struct pushback *pb);
} pushback_t;

int simx_pushback_add(pushback_t pushback, int overwrite);
int simx_pushback_remove(char *name);
const char *simx_pushback_errstr(int err);

#ifdef __cplusplus
} /* extern "C" */
#endif

#ifdef __cplusplus

class Pushback {
 public:
  Pushback();
  ~Pushback();
  int addPushback(pushback_t cb, bool overwrite);
  int removePushback(char *name);
  int invokePushback(char *name, pushback_result_t *result, ...);
};

#endif

#endif /* PUSHBACK_H */
