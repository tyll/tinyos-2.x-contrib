/**
 * The Pushback interface is a generaly interface to invoke an
 * arbitrary callback. The callback itself is dispatched dynamically
 * according to the supplied string lookup.
 */

#include "pushback.h"

interface SimxPushback {

  /**
   * There is a problem with (at least some version of) TOSSIM 2.x
   * "double-running" the calls to commands. To get around the bug
   * this command must be invoked before each call to one of the push*
   * commands (it resets some internal tracking state).
   */
  command void resetHack();

  /**
   * Invoke a pushback.
   *
   * Execution is suspended until the pushback corresponding to
   * command completes.
   */  
  command int pushVa(const char *name,
                     pushback_result_t *result,
                     va_list va);
  
  /**
   * Invoke a pushback and acquire a long result.
   * 
   * If the pushback does not return a long then
   * PUSHBACK_EXPECTING_LONG is returned.
   */
  command int pushLongVa(const char *name,
                         long *long_result, va_list va);
  
}
