/*
 * timer: timing utilities
 * Copyright(c) 2004-2005 by wave++ "Yuri D'Elia" <wavexx@users.sf.net>
 * Distributed under GNU LGPL WITHOUT ANY WARRANTY.
 */

#ifndef timer_hh
#define timer_hh

// c system headers
#include <sys/time.h>


// Averaging stop-watch timer (with variable-bound precision)
class ATimer
{
  double delta;
  double cum;
  double le;
  double ini;
  double last;
  unsigned long sc;

  double now()
  {
    timeval n;
    gettimeofday(&n, 0);
    return (static_cast<double>(n.tv_sec) +
	.000001 * static_cast<double>(n.tv_usec));
  }


public:
  explicit
  ATimer(double delta)
  : delta(delta), cum(0), le(0), last(0), sc(0)
  {
    ini = now();
  }


  void
  start()
  {
    le = now();
  }


  void
  stop()
  {
    double n = now();

    cum += n - le;
    le = n;
    ++sc;
  }


  double
  avg()
  {
    double n = now();

    if((n - ini) >= delta)
    {
      last = cum / (sc? sc: 1);
      ini = n;
      cum = 0;
      sc = 0;
    }

    return last;
  }
};

#endif
