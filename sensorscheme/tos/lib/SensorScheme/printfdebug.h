#ifndef PRINTFDEBUG_H
#define PRINTFDEBUG_H

#ifndef TOSSIM
#ifdef PRINTF_DBG
#include "printf.h"
#define DO_PRINTF_DBG PRINTF_DBG
#endif
#endif // TOSSIM

#ifdef DO_PRINTF_DBG 
#define pr_dbg_doprint(tag, ...) \
  if (tag == DO_PRINTF_DBG) { \
    printf(__VA_ARGS__); } 
#else
#define pr_dbg_doprint(tag, str ...) 
#endif

#ifdef DO_PRINTF_DBG 
#define pr_dbg_doflush() \
    printfflush();
#else
#define pr_dbg_doflush() 
#endif

#define pr_dbg(tag, ...) \
  dbg(tag, __VA_ARGS__); \
  pr_dbg_doprint(tag, "DEBUG: "); \
  pr_dbg_doprint(tag, __VA_ARGS__); 

#define pr_dbg_clear(tag, ...) \
  dbg_clear(tag, __VA_ARGS__); \
  pr_dbg_doprint(tag, __VA_ARGS__); 

#define pr_dbgerror(s, ...) \
  dbgerror(tag, __VA_ARGS__); \
  pr_dbg_doprint(tag, "ERROR: "); \
  pr_dbg_doprint(tag, __VA_ARGS__); 
  
#define pr_dbgerror_clear(s, ...) \
  dbgerror_clear(tag, __VA_ARGS__); \
  pr_dbg_doprint(tag, __VA_ARGS__); 
  

#define pr_dbg_f(tag, ...) \
  pr_dbg(tag, __VA_ARGS__); \
  pr_dbg_doflush();

#define pr_dbg_clear_f(tag, ...) \
  pr_dbg_clear(tag, __VA_ARGS__); \
  pr_dbg_doflush();

#define pr_dbgerror_f(tag, ...) \
  pr_dbgerror(tag, __VA_ARGS__); \
  pr_dbg_doflush();

#define pr_dbgerror_clear_f(tag, ...) \
  pr_dbgerror_clear(tag, __VA_ARGS__); \
  pr_dbg_doflush();


#endif //PRINTFDEBUG
