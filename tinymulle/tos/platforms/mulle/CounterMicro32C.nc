// $Id$
/*
 * Copyright (c) 2005-2006 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
/**
 * 32-bit microsecond Counter component as per TEP102 HAL guidelines. The
 * mulle family microsecond clock is built on hardware timerB, and actually
 * runs at CPU frequency 10Mhz. 
 *
 * @author Fan Zhang <fanzha@ltu.se>
 */


configuration CounterMicro32C
{
  provides interface Counter<TMicro, uint32_t>;
}
implementation
{
  components CounterMicro16C as Counter16, 
    new TransformCounterC(TMicro, uint32_t, TMicro, uint16_t,
			  0, uint16_t) as Transform32;

  Counter = Transform32;
  Transform32.CounterFrom -> Counter16;
}
