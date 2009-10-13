/**
 * TransformCounterArbC decreases precision.
 *
 * <p>See TEP102 for more details.
 *
 * @param size_type A type indicating the size of the Counter.
 * @param to_precision_tag A type indicating the precision of the transformed
 *   Counter.
 * @param from_precision_tag A type indicating the precision of the original
 *   Counter.
 * @param divider Original time units will be divider timers larger than transformed time units.
 *
 * @author Cory Sharp <cssharp@eecs.berkeley.edu>
 */

generic module TransformCounterArbC(
  typedef size_type @integer(), 
  typedef to_precision_tag,
  typedef from_precision_tag,
  uint8_t divider) @safe()
{
  provides interface Counter<to_precision_tag,size_type> as Counter;
  uses interface Counter<from_precision_tag,size_type> as CounterFrom;
}
implementation
{
	size_type m_upper;

	const size_type PART = ((size_type)-1) / divider + (((size_type)-1) % divider + 1) / divider;
	const size_type REST = (((size_type)-1) % divider + 1) %  divider;
  	
  async command size_type Counter.get()
  {
	  size_type rv=0;
    atomic
    {
    	size_type high = m_upper;
    	size_type low = call CounterFrom.get();
    	size_type low_ = low;
      if (call CounterFrom.isOverflowPending())
      {
	// If we signalled CounterFrom.overflow, that might trigger a
	// Counter.overflow, which breaks atomicity.  The right thing to do
	// increment a cached version of high without overflow signals.
	// m_upper will be handled normally as soon as the out-most atomic
	// block is left unless Clear.clearOverflow is called in the interim.
	// This is all together the expected behavior.
    	  high++;
    	  if (high >= divider)
    		  high=0;
    	  low = call CounterFrom.get();
      }
      if (high) {
    	  low += high * REST;
          if (low_ > low) // test overflow
        		high++;
      }
      rv = high * PART;
      low /= divider;
      rv += low;
    }
    return rv;
  }

  // isOverflowPending only makes sense when it's already part of a larger
  // async block, so there's no async inside the command itself, where it
  // wouldn't do anything useful.

  async command bool Counter.isOverflowPending()
  {
    return m_upper >= divider && call CounterFrom.isOverflowPending();
  }

  // clearOverflow also only makes sense inside a larger atomic block, but we
  // include the inner atomic block to ensure consistent internal state just in
  // case someone calls it non-atomically.

  async command void Counter.clearOverflow()
  {
    atomic
    {
      if (call Counter.isOverflowPending())
      {
    	  m_upper=0;;
    	  call CounterFrom.clearOverflow();
      }
    }
  }

  async event void CounterFrom.overflow()
  {
    atomic
    {
      m_upper++;
      if (m_upper >= divider) {
    	  m_upper=0;
    	  signal Counter.overflow();
      }
    }
  }
}

