
#include "TestCase.h"

module AutomaticPorP {
  uses {
    interface TestCase as TestAutomaticPor;
    interface RadioReset;
    interface GeneralIO as Power;
    
  }
}

implementation {

  event void TestAutomaticPor.run() {
    call Power.set();
    call RadioReset.blockUntilPowered();
    assertSuccess();
    call TestAutomaticPor.done();
  }

}

