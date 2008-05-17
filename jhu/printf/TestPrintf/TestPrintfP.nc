#include <printf.h>

module TestPrintfP
{
  uses {
    interface Boot;
    interface Leds;
    interface Timer<TMilli> as Timer;
  }
}

implementation
{
  int i;

  event void Boot.booted()
  {
    call Timer.startPeriodic(1024);
  }

  event void Timer.fired()
  {
    printf("Counter %d\n", i);
    i++;
    printf("Counter %d\n", i);
    i++;
  }
}
