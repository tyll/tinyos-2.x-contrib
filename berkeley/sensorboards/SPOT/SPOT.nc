//SPOT Energy Meter Interface
//@author Fred Jiang <fxjiang@eecs.berkeley.edu>

interface SPOT
{
  command error_t sample();
  event void sampleDone(uint32_t time, uint32_t energy);
  command uint32_t getCalTime1();
  command uint32_t getCalTime2();
  command uint32_t getCalEnergy1();
  command uint32_t getCalEnergy2();
}

