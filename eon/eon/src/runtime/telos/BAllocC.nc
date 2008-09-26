

/*
 * TINY_ALLOC is a simple, handle-based compacting memory manager.  It
 * allocates bytes from a fixed size frame and returns handles
 * (pointers to pointers) into that frame.  Because it components handles,
 * TINY_ALLOC can move memory around in the frame without changing all
 * the external references.  Moving memory is a good thing because it
 * allows frame compacting and tends to reduce wasted space.  Handles
 * can be accessed via a double dereference (**), and a single
 * dereference can be used wherever a pointer is needed, but if a
 * single dereference is to be stored, the handle must be locked first
 * as otherwise TINY_ALLOC may move the handle and make the reference
 * invalid.
 *
 * Example:
 *
 * Handle foo; // A handle to 20 allocated bytes
 * (*foo)[12] // The 12th byte of foo
 * **foo      // The 0th byte of foo
 *
 * Like all good TinyOS components, TINY_ALLOC is split phase with
 * respect to allocation and compaction.  Allocation/reallocation
 * completion is signalled via a TINY_ALLOC_COMPLETE signal and
 * compaction via a TINY_ALLOC_COMPACT_COMPLETE signal.  All other
 * operations complete and return in a single phase. Note that
 * compaction may be triggered automatically from allocation; in this
 * case a COMPACT_COMPLETE event is not generated.
 *
 * Handles are laid out in the frame as follows:
 *
 *  [LOCKED][SIZE][user data] 
 *
 * Where: 
 *   LOCKED     : a single bit indicating if the handle is locked 
 *   SIZE       : 7 bits representing the size of the handle 
 *   user data  : user-requested number of bytes (**h) points to
 *               [user data], not [LOCKED].
 *
 * Calling TOS_COMMAND(TINY_ALLOC_SIZE(h)) returns the size of [user
 * data] (note that the internal function size() returns the size of
 * the entire handle, including the header byte.)
 * 
 */

/**
 * @author Sam Madden
 * @author Phil Levis
 */

includes MarkovAlloc;


module BAllocC
{
  provides
  {
    interface StdControl;
    interface BAlloc;
    command void allocDebug ();
  }
  uses
  {
    interface Leds;
  }
}


implementation
{
  enum
  {
    FRAME_SIZE = 1024,		//may change this to 2048, 4096 or 3072
    FREE_SIZE = FRAME_SIZE >> 3,
    MAX_SIZE = 32765,
    HEADER_SIZE = 2,
    MAX_HANDLES = 20
  };

  uint8_t mFrame[FRAME_SIZE];	//the heap
  uint8_t mFree[FREE_SIZE];	//free bit map
  int8_t mAllocing;		//are we allocating?
  int8_t mCompacting;		//are we compacting?
  int16_t mSize;		//how many bytes are we allocing?
  int16_t mLast;		//where were we in the last task invocation
  Handle *mHandle;		//handle we are allocating
  int8_t **mTmpHandle;		//temporary handle for realloc
  Handle mOldHandle;		//old user handle for realloc
  int8_t *mHandles[MAX_HANDLES];	//handles we know about
  int8_t mReallocing;		//are we mReallocing
  int8_t mCompacted;		//already mCompacted this allocation
  int8_t mNeedFree;		//looking for free bits in current byte?
  int16_t mContig;		//mContig bytes seen so far 
  int16_t mStartByte;		//start of free section (in bytes)
  uint16_t mFreeBytes;

  /* DEBUGGING FIELDS */
  //  int8_t buf[512];
  //int16_t cur;
  //int16_t len;

  result_t doAlloc (int16_t startByte, int16_t endByte);
  void shiftUp (Handle handle, int bytes);
  int16_t start_offset (int8_t * ptr);
  void setFreeBits (int16_t startByte, int16_t endByte, int8_t on);
  void remapAddr (int8_t * oldAddr, int8_t * newAddr);
  int8_t isValid (Handle h);
  int16_t getSize (int8_t * p);
  int8_t isLocked (int8_t * ptr);
  int8_t finish_realloc (Handle * handle, int8_t success);
  Handle getH (int8_t * p);
  int16_t getNewHandleIdx ();
  void markHandleFree (Handle hand);

  static inline Handle ToHandle (int8_t * ptr)
  {
    return (Handle) (&ptr);
  }
  static inline int8_t *deref (Handle h)
  {
    return (int8_t *) (*h);
  }

  result_t compactTask ();
  result_t allocTask ();
  result_t reallocDone ();

  /*command result_t BAlloc.compact() {
     if (!mCompacting && !mAllocing) {
     compactTask();
     }
     return SUCCESS;
     } */

  command result_t StdControl.init ()
  {
    int16_t i;
    mAllocing = 0;
    mReallocing = 0;
    for (i = 0; i < FREE_SIZE >> 4; i++)
      {
	((int32_t *) mFree)[i] = 0;
      }
    for (i = 0; i < MAX_HANDLES; i++)
      {
	mHandles[i] = 0;
      }
    mFreeBytes = FRAME_SIZE;
    return SUCCESS;
  }

  command result_t StdControl.start ()
  {
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    return SUCCESS;
  }

  command result_t BAlloc.allocate (HandlePtr handlePtr, int16_t size)
  {
    result_t result;
    if (size > MAX_SIZE || mAllocing)
      {

	return FAIL;
      }

    atomic
    {

      mAllocing = 1;
      mSize = size + HEADER_SIZE;	//need extra bytes for header info
      mHandle = handlePtr;
      mCompacted = 0;
      mNeedFree = 0;
      mContig = 0;
      mLast = 0;
      mStartByte = 0;
      mFreeBytes -= mSize;
      result = allocTask ();
    }				//atomic
    return result;
  }

  result_t allocTask ()
  {
    int16_t endByte;
    int16_t i, j;


  start_alloc_task:

    i = mLast++;
    if (i == FREE_SIZE)
      {
	if (mCompacted)
	  {			//try to compact if can't allocate
	    //already mCompacted -- signal failure
	    mAllocing = 0;
	    if (mReallocing)
	      {
		//return finish_realloc(mHandle, 0);
		return FAIL;	//since we don't allow realloc, should never happen
	      }
	    else
	      {
		return FAIL;
	      }
	  }
	else
	  {
	    mCompacted = 1;
	    //CLR_RED_LED_PIN();
	    //try compacting
	    //return compactTask();
	    return FAIL;
	  }
	return SUCCESS;
      }

    if (mNeedFree && mFree[i] != 0xFF)
      {				//some free space
	mStartByte = i << 3;
	for (j = 0; j < 8; j++)
	  {
	    if (mFree[i] & (1 << j))
	      {
		if (mContig >= mSize)
		  {		//is enough free space
		    //alloc it and return
		    endByte = mStartByte + mSize;
		    return doAlloc (mStartByte, endByte);
		  }
		else
		  {
		    mStartByte += (mContig + 1);
		    mContig = 0;
		  }
	      }
	    else
	      {
		mContig++;
	      }
	  }

	if (mContig >= mSize)
	  {
	    endByte = mStartByte + mSize;
	    return doAlloc (mStartByte, endByte);
	    //alloc it and return
	  }
	else
	  {
	    //some free space at end of byte, but need more
	    mNeedFree = 0;
	  }
      }
    else if (mNeedFree == 0)
      {				//mNeedFree sez there are free bits
	//in the current byte, and we should scan to find them on
	//the next pass
	if (mFree[i] == 0)
	  {
	    mContig += 8;
	  }
	else
	  {
	    for (j = 0; j < 8; j++)
	      {
		if ((mFree[i] & (1 << j)) == 0)
		  {
		    mContig++;
		  }
		else
		  {
		    break;
		  }
	      }
	  }
	if (mContig >= mSize)
	  {
	    endByte = mStartByte + mSize;
	    return doAlloc (mStartByte, endByte);
	    //alloc it and return

	  }
	else if (mFree[i] != 0)
	  {
	    mContig = 0;	//didn't find the needed amount of space
	    mNeedFree = 1;
	    mLast--;		//retry this byte
	  }
      }
    //use goto to avoid recursion
    //return allocTask();
    goto start_alloc_task;
  }

  result_t doAlloc (int16_t startByte, int16_t endByte)
  {
    int16_t newIdx = getNewHandleIdx ();
    if (newIdx == -1)
      {
	mAllocing = 0;
	return FAIL;
      }


    *(int16_t *) (&mFrame[startByte]) = (endByte - startByte) & 0x7FFF;

    //WARNING -- not going through standard accessors

    mHandles[newIdx] = (int8_t *) ((&mFrame[startByte]) + HEADER_SIZE);
    *mHandle = &mHandles[newIdx];

    //mark bits
    setFreeBits (startByte, endByte, 1);

    mAllocing = 0;
    if (mReallocing)
      {
	return FAIL;		//finish_realloc(mHandle,1);
      }
    else
      {
	return SUCCESS;
      }
    return FAIL;
  }

  result_t compactTask ()
  {
    int16_t i;
    uint8_t c;
    int8_t *p;
    int8_t endFree = 0;

  start_compact:

    if (mCompacting == 0)
      {
	mContig = 0;
	mLast = 0;
	mCompacting = 1;
	mStartByte = 0;
      }
    c = mFree[mLast++];
    if (mLast == FREE_SIZE)
      goto done_compact;	///AAAAAAAH  A GOTO!  I Read about those once!

    //call Leds.yellowToggle();
    //process:  scan forward in free bitmap, looking for runs of free space
    //at end of run, move bytes up

    if (c == 0)
      {				//byte not used at all
	mContig += 8;
      }
    else
      {
	if (c != 0xFF)
	  {			//byte not fully used
	    for (i = 0; i < 8; i++)
	      {
		if ((c & (1 << i)) == 0)
		  {
		    mContig++;
		    endFree = 1;	//endFree sez the last bit of this byte was free
		  }
		else if (mContig == 0)
		  {		//bit not free, no compaction to do
		    mStartByte++;
		    endFree = 0;
		  }
		else
		  {		//bit not free, but need to compact
		    endFree = 0;
		    break;
		  }
	      }
	  }

	if (mContig > 0 && !endFree)
	  {			//need to compact?
	    p = (int8_t *) & (mFrame[mStartByte + mContig + HEADER_SIZE]);	//get the handle
	    if (!isLocked (p))
	      {
		Handle h = getH (p);

		if (h == NULL)
		  {
		    dbg (DBG_USR1,
			 "BAD NEWS -- INVALID HANDLE START IN COMPACT.\n");
		    goto done_compact;
		  }
		dbg (DBG_USR1, "compacting, from %d, %d bytes\n",
		     mStartByte + mContig + HEADER_SIZE, mContig);
		shiftUp ((Handle) h, mContig);
		mStartByte += (getSize (*h) >> 3) << 3;
	      }
	    else
	      {
		//printf ("SOMETHING LOCKED, at %d", VAR(startByte) +
		//VAR(mContig) + 1);
		mStartByte += ((getSize (p) + mContig) >> 3) << 3;
		//make sure we don't retry the same byte again if this
		//handle is locked note that this can lead to holes of fewer
		//than 8 bytes at the end of allocations which occupy fewer
		//than 8 bytes
		if (mStartByte >> 3 == mLast - 1)
		  {
		    mStartByte += 8;
		  }
	      }

	    mLast = (mStartByte >> 3);
	    mStartByte = mLast << 3;
	    //printf("\nlast = %d, startByte = %d\n", mLast, mStartByte);
	    mContig = 0;
	  }
	else if (!endFree)
	  {			//not compacting, move to next byte 
	    mStartByte += 8;
	    mContig = 0;
	  }
      }

  done_compact:
    //scanned the whole thing
    if (mLast >= FREE_SIZE)
      {
	mCompacting = 0;
	mLast = 0;
	mContig = 0;
	mNeedFree = 0;
	mStartByte = 0;
	if (mAllocing)
	  {
	    return allocTask ();
	  }
	else
	  {
	    return SUCCESS;
	  }
      }
    else
      {
	//call Leds.redToggle();

	goto start_compact;	//keep compacting
      }
  }

  void shiftUp (Handle hand, int bytes)
  {
    int16_t start = start_offset (deref (hand));
    int16_t end = start + getSize (deref (hand));
    int16_t newstart;
    int16_t newend;

    int8_t *p = deref (hand) - HEADER_SIZE;
    int8_t *startp = deref (hand) - HEADER_SIZE - bytes, *q;
    int cnt = getSize (deref (hand));

    q = startp;
    while (cnt--)
      {
	*q++ = *p++;
      }

    remapAddr (*hand, startp + HEADER_SIZE);
    *hand = startp + HEADER_SIZE;

    newstart = start_offset (deref (hand));
    newend = newstart + getSize (deref (hand));

    //now, have to offset free bytes
    //do it by unsetting old bits, setting new ones
    setFreeBits (start, end, 0);
    setFreeBits (newstart, newend, 1);
  }


  command int16_t BAlloc.free (Handle hand)
  {
    int8_t *startPtr;
    int16_t start;
    int16_t end;

    if (mAllocing)
      return FAIL;		//don't do this if we're allocating right now

    if (!isValid (hand))
      return FAIL;
    // 16 bit architecture (e.g. mote)

    if (sizeof (int8_t *) == sizeof (int16_t))
      {
	startPtr = (deref (hand) - HEADER_SIZE);
	start = (int16_t) (startPtr - (int8_t *) & mFrame);
	end = start + getSize (deref (hand));
      }
    // 32-bit architecture (e.g. x86 simulator)
    else if (sizeof (int8_t *) == sizeof (int32_t))
      {
	startPtr = (deref (hand) - HEADER_SIZE);
	start = (int16_t) (startPtr - (int8_t *) & mFrame);
	end = start + getSize (deref (hand));
	//printf ("freeing from %d to %d", (int16_t)start, (int16_t)end);
      }
    else
      {
	return FAIL;
      }

    //track free bytes
    mFreeBytes += getSize (deref (hand));

    setFreeBits (start, end, 0);

    markHandleFree (hand);

    return (end - start);
  }

  /*command result_t MemAlloc.reallocate(Handle hand, int16_t newSize) {
     int16_t neededBytes = newSize + HEADER_SIZE;
     int8_t *p = *hand;

     if (mAllocing) return FAIL; //don't do this if we're allocing
     if (neededBytes > MAX_SIZE) return FAIL; //error!

     mOldHandle = hand;

     if (neededBytes == getSize(*hand)) {
     post reallocDone();
     return SUCCESS; //already the right size!
     }

     //adjust our counter of the number of free bytes
     if (neededBytes < getSize(*hand)) {
     int16_t oldSize = getSize(*hand);

     //change the size of the handle
     ((int16_t *)(p - HEADER_SIZE))[0] = neededBytes & 0x7FFF;

     //unset the used bits at the end
     setFreeBits(start_offset(p) + neededBytes , start_offset(p) + oldSize, 0); 

     mFreeBytes -= neededBytes;
     mFreeBytes += getSize(*hand);

     post reallocDone(); //schedule completion event
     return SUCCESS;
     }
     else if (neededBytes > getSize(*hand) && !isLocked(*hand)) { //handle must be be bigger
     //printf("MREALLOCING\n"); //fflush(stdout);
     //for now, just allocate a new handle and copy the old handle over
     mReallocing = 1;

     mFreeBytes += getSize(*hand);

     return call MemAlloc.allocate(&mTmpHandle, newSize);
     }
     return FAIL; //failure
     } */

  //task so that quick reallocations are split phase
  /*task void reallocDone() {
     signal MemAlloc.reallocComplete(mOldHandle, SUCCESS);
     } */

  //second half of split phase reallocation
  /*int8_t finish_realloc(Handle *hand, int8_t success) {

     //printf ("realloced, success = %d!\n\n",success); //fflush(stdout);
     if (success) {
     int8_t *p = **hand;
     int8_t *q = *mOldHandle;
     int16_t cnt = getSize(*mOldHandle);
     //printf("cnt = %d\n", cnt);//fflush(stdout);
     while(cnt--) {
     *p++ = *q++;
     }
     //clear bits the old handle used
     setFreeBits(start_offset(*mOldHandle), 
     start_offset(*mOldHandle) + getSize(*mOldHandle), 0); 
     //remap old handle to the new handle
     remapAddr(*mOldHandle, **hand);

     //and finally free the new handle in the handles list, since
     // the user still has the pointer to the old handle
     markHandleFree(*hand);

     mReallocing = 0;
     signal MemAlloc.reallocComplete(mOldHandle, SUCCESS);
     }
     else {
     mReallocing = 0;
     signal MemAlloc.reallocComplete(mOldHandle, FAIL);
     return FAIL;
     }
     return SUCCESS;
     } */

  // ------------------------- Lock / Unlock ----------------------------- //
  /* Lock the handle */
  /* command result_t MemAlloc.lock(Handle handle) {
     // Would it be good to check previous lockedness?
     int8_t *ptr = deref(handle);
     ((int16_t *)(ptr - HEADER_SIZE))[0] |= 0x8000;
     return SUCCESS;
     }

     // Unlock the handle 
     command result_t MemAlloc.unlock(Handle handle) {
     // Would it be good to check whether it was locked?
     int8_t *ptr = deref(handle);
     ((int16_t *)(ptr - HEADER_SIZE))[0] &= 0x7FFF;
     return SUCCESS;
     } */

  int8_t isLocked (int8_t * ptr);
  /* Return 1 iff h is locked, 0 o.w. */
  /*command bool MemAlloc.isLocked(Handle h) {
     return isLocked(*h);
     } */

  /* Return 1 iff the handle referencing ptr is locked */
  int8_t isLocked (int8_t * ptr)
  {
    return (((int16_t *) (ptr - HEADER_SIZE))[0] & 0x8000) != 0;
  }

  // -------------------- Utility Functions ----------------------------- //
  /* Return the size of the handle h, excluding the header */
  command int16_t BAlloc.size (Handle h)
  {
    return (getSize (*h) - HEADER_SIZE);
  }
  /* Return the size of the handle referencing ptr 
     including the header 
   */
  int16_t getSize (int8_t * ptr)
  {
    return (int16_t) (((int16_t *) (ptr - HEADER_SIZE))[0] & 0x7FFF);
  }

  /* Return the total number of free bytes (available after compaction) */
  command uint16_t BAlloc.freeBytes ()
  {
    return mFreeBytes;
  }

  //return 1 iff the handle points to a valid loc, 0 o.w.
  int8_t isValid (Handle h)
  {
    //pointers on motes are different size than on PC
    if (sizeof (int8_t *) == sizeof (int32_t))
      {				// 32 bit arch
	return ((*h >= (int8_t *) (&mFrame)[0])
		&& (*h < (int8_t *) & (mFrame[FRAME_SIZE])));
      }
    else if (sizeof (int8_t *) == sizeof (int16_t))
      {				// 16 bit arch
	return ((*h >= (int8_t *) (&mFrame)[0])
		&& (*h < (int8_t *) & (mFrame[FRAME_SIZE])));
      }
    else
      {
	return 0;
      }
  }

  //move all handles that used to point to oldAddr to
  //point to newAddr
  void remapAddr (int8_t * oldAddr, int8_t * newAddr)
  {
    int16_t i;
    for (i = 0; i < MAX_HANDLES; i++)
      {
	if ((mHandles[i]) == oldAddr)
	  {
	    (mHandles[i]) = newAddr;
	  }
      }
  }


  //return the handle with the address p
  Handle getH (int8_t * p)
  {
    int16_t i;
    for (i = 0; i < MAX_HANDLES; i++)
      {
	if ((mHandles[i]) == p)
	  {
	    return &mHandles[i];
	  }
      }
    return 0;
  }

  //find an unused handle slot
  int16_t getNewHandleIdx ()
  {
    int16_t i;
    for (i = 0; i < MAX_HANDLES; i++)
      {
	if ((mHandles[i]) == 0)
	  return i;
      }
    return -1;
  }

  //set the entry in mHandles to null for this handle
  //CAREFUL -- this is possibly a very dangerous thing to do
  //if someone external has a reference to hand... 
  void markHandleFree (Handle hand)
  {
    int i;
    for (i = 0; i < MAX_HANDLES; i++)
      {
	if (&mHandles[i] == hand)
	  {
	    //note that setting to 0 here means we'll have to 
	    //walk the handle list looking for free slots later
	    //we can't just keep a dense list of used handles
	    //since the application maintains pointers into
	    //the handle list
	    mHandles[i] = 0;
	    break;
	  }
      }
  }

  /* Mark the free bits corresponding to the specified
     range of bytes in the allocation buffer.
   */
  void setFreeBits (int16_t startByte, int16_t endByte, int8_t on)
  {
    int16_t leadInBits = (startByte - ((startByte >> 3) << 3));
    int16_t leadOutBits = endByte - ((endByte >> 3) << 3);
    int16_t i;
    int16_t startFree = startByte >> 3;
    int16_t endFree = endByte >> 3;

    dbg (DBG_USR1, "Setting bits from %d to %d to %d\n", startByte, endByte,
	 on);
    if (startFree == endFree)
      {
	leadInBits = 8;		//no leadin if both in same byte
      }

    //unroll this for efficiency, since it is called a lot
    if (on)
      {
	for (i = leadInBits; i < 8; i++)
	  {
	    mFree[startFree] |= (1 << i);
	  }
	for (i = 0; i < leadOutBits; i++)
	  {
	    mFree[endFree] |= (1 << i);
	  }
	startFree++;
	for (i = startFree; i < endFree; i++)
	  {
	    mFree[i] = 0xFF;
	  }
      }
    else
      {				//! on
	for (i = leadInBits; i < 8; i++)
	  {
	    mFree[startFree] &= (0xFF ^ (1 << i));
	  }
	for (i = 0; i < leadOutBits; i++)
	  {
	    mFree[endFree] &= (0xFF ^ (1 << i));
	  }
	startFree++;
	for (i = startFree; i < endFree; i++)
	  {
	    mFree[i] = 0x00;
	  }
      }
  }


  //return the offset in bits into free where this starts 
  //include the header byte
  int16_t start_offset (int8_t * ptr)
  {
    if (sizeof (int8_t *) == sizeof (int32_t))
      {				// 32 bit arch
	int16_t len =
	  (int16_t) ((ptr - (int8_t *) (&mFrame[0])) - HEADER_SIZE);
	return (int16_t) (len);
      }
    else if (sizeof (int8_t *) == sizeof (int16_t))
      {				// 16 bit arch
	int16_t len =
	  (int16_t) ((ptr - (int8_t *) (&mFrame[0])) - HEADER_SIZE);
	return len;
      }
    else
      {
	return -1;
      }
  }

/* Print out the current free bitmap */
  command void allocDebug ()
  {
#ifdef kDEBUG
    short i, j;
    dbg (DBG_USR1, "Debugging:");
    for (i = 0; i < FREE_SIZE; i++)
      {
	for (j = 0; j < 8; j++)
	  {
	    printf ("%d:", (mFree[i] & 1 << j) > 0 ? 1 : 0);
	  }
	printf (",");
      }
    dbg (DBG_USR1, "\n\n");
    for (i = 0; i < FRAME_SIZE; i++)
      {
	printf ("%c,", mFrame[i]);
      }
#endif
  }


}
