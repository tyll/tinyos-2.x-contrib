
#include "BitTable.h"

configuration BitTableC {
  provides {
    interface BitTable;
  }
}

implementation {
  
  components BitTableP;
  BitTable = BitTableP;

}

