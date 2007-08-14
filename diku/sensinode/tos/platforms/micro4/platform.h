
/* Changes the clock frequency from the default 4 MHz to 1 MHz */
#ifndef __4MHz__
#ifndef __1MHz__
#define __1MHz__
#endif
#endif


/* old TOSH_uwait - more precise than the new TOS2 timers */
inline void TOSH_uwait(uint16_t u)
{
  uint16_t i;

  // 1MHz clock - not 4
#ifdef __1MHz__
  u /= 8;
#endif

  if (u < 500)
    for (i=2; i < u; i++) {
      asm volatile("nop\n\t"
                   "nop\n\t"
                   "nop\n\t"
                   "nop\n\t"
                   ::);
    }
  else
    for (i=0; i < u; i++) {
      asm volatile("nop\n\t"
                   "nop\n\t"
                   "nop\n\t"
                   "nop\n\t"
                   ::);
    }
}

