#include "Blaze.h"

interface BlazeCheckRadio {

  /**
   * Makes sure the radio is ready to be used. Does not return until
   * ready.
   */
  async command void check();

  
}
