//#include "DSN.h" 
uint8_t var;
uint16_t lasterr;

void sx1211error(uint8_t loc, uint8_t value_)  __attribute__ ((noinline)) {
  // this is just to make sure the compiler doesn't optimize 
  // out calls to this function, since we use it as a gdb breakpoint
  atomic var += value_ + loc;
}


void sx1211check(uint8_t loc, error_t err)   __attribute__ ((noinline)) {
  if (err != SUCCESS) {
    atomic lasterr = loc;
    sx1211error(loc, err);
    //dsnlog("sx1211error %i %i\r",(uint32_t)loc,(uint32_t)err);
  }
}

