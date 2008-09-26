#ifndef NODEPOWER_H_INCLUDED
#define NODEPOWER_H_INCLUDED

//StatePower in mW
double
getStatePower (uint8_t state, bool max)
{
  int i;
  double power = 0.0;
  for (i = 0; i < NUMPATHS; i++)
    {
      if (state <= minPathState[i])
	{
	  //good
	  if (max)
	    {
	      power +=
		(avgPathRate[i] * getMaxPathEnergy (i, state) *
		 PATHRATESECONDS);
	    }
	  else
	    {
	      power +=
		(avgPathRate[i] * getMinPathEnergy (i, state) *
		 PATHRATESECONDS);
	    }
	  //factor in wakeups
	  power += (avgPathRate[i] * wakeupProb[i] * WAKEPOWER * wakeTimeMS);

	}
    }
  //factor in stargate idle power
  power += (STARGATEIDLEPOWER * 1000) * stargateDutyCycle[state];
  power += (IDLEPOWER * 1000);
  return power;
}



uint8_t
getStateFromPower (double targetpower, float *scale)
{
  int i;
  uint8_t state = 0;
  double minp, maxp;

  for (i = NUMSTATES - 1; i > 0; i--)
    {
      minp = getStatePower (i, FALSE);
      maxp = getStatePower (i, TRUE);
      if (targetpower >= minp)
	{
	  state = i;
	  break;
	}
    }
  //figure scale
  if (targetpower >= maxp)
    {
      *scale = 1.0;
    }
  else if (targetpower <= minp)
    {
      *scale = 0.0;
    }
  else
    {
      *scale = (targetpower - minp) / (maxp - minp);
    }
  return state;
}


#endif
