includes TinyStream;

module UARTTinyStreamM {
  provides {
    interface StdControl;
    interface Connect;
    interface StreamRead;
    interface StreamWrite;
  }
  uses {
    interface StdControl as SubControl;
    interface RelySend;
    interface RelyRecv;
    interface Connect as SubConnect;
  }

}
implementation {
  TSStr buffers[RELY_MAX_CONNECTIONS];
  int senders;

  /***********************************************
   * Random Accessory functions
  *********************************************/


   /*Does just what you think it does it tests to see if the variable
    pointed to by testvar is false.  if it is, then it is set to true
    and the function returns true.  Otherwise the function returns
    FALSE.  All is done atomically.
  */
  bool testAndSet(bool* testvar)
    {
      bool setit = FALSE;
 
      atomic {
	if (*testvar == FALSE)
	  {
	    setit = TRUE;
	    *testvar = TRUE;
	  }
      }//atomic

      return setit;
    }

  bool isValidConnectionID(int connid)
    {
      return (connid > RELY_IDX_INVALID && connid < RELY_MAX_CONNECTIONS);
    }
  
  bool isValidBuffer(int connid)
    {
      return (isValidConnectionID(connid) && buffers[connid].valid);
    }

  bool tryLockBuffer(int connid)
    {
      if (!isValidConnectionID(connid))
	{
	  return FALSE;
	}

      return testAndSet(&buffers[connid].lock);
    }

  //You're on your honor not to call this unless
  //you have the lock.  Bad things will happen if you do.
  bool releaseBuffer(int connid)
    {
      buffers[connid].lock = FALSE;
      return TRUE;
    }


  uint16_t getCount(uint16_t head, uint16_t tail)
    {
      
      
      if (head <= tail)
	{
	  return (tail - head);
	}
      return (TS_BUF_LENGTH - (head-tail));
    }
  
  uint16_t getFreeCount(uint16_t head, uint16_t tail)
    {
      return ((TS_BUF_LENGTH-1) - getCount(head,tail));
    }

  uint16_t getRxCount(int connid)
    {

      if (!isValidConnectionID(connid)) return 0;
      
      return getCount(buffers[connid].rxhead, buffers[connid].rxtail);
    }

  uint16_t getTxCount(int connid)
    {

      if (!isValidConnectionID(connid)) return 0;
      
      return getCount(buffers[connid].txhead, buffers[connid].txtail);
    }

  uint16_t getRxFreeCount(int connid)
    {

      if (!isValidConnectionID(connid)) return 0;
      
      return getFreeCount(buffers[connid].rxhead, buffers[connid].rxtail);
    }

  uint16_t getTxFreeCount(int connid)
    {

      if (!isValidConnectionID(connid)) return 0;
      
      return getFreeCount(buffers[connid].txhead, buffers[connid].txtail);
    }

  /*******************************************
   *Buffer management
   ******************************************/

  uint16_t addDataToBuf(uint8_t* dest,
			uint16_t* head,
			uint16_t* tail,
			uint8_t* buf,
			uint16_t size)
    {
      uint16_t toedge;
      
      toedge = (TS_BUF_LENGTH-(*tail));

      if (size <= toedge)
	{
	  memcpy(dest+(*tail), buf, size);
	  *tail = (*tail + size) % TS_BUF_LENGTH;
	} else {
	  memcpy(dest + (*tail), buf, toedge);
	  memcpy(dest, buf+toedge, size-toedge);
	  *tail = size-toedge;
	}
      return size;
      
    } //addDataToBuf
  
  uint16_t addDataToTxBuf(int connid,
			uint8_t* buf,
			uint16_t size)
    {
      uint16_t retval;

      dbg(DBG_USR1,"addDataToTxBuf (%d, %d)\n",connid, size);


      dbg(DBG_USR1,"(addDataTx) Before (head=%d,tail=%d)\n", 
	  buffers[connid].txhead, buffers[connid].txtail );

      //todo: some sanity checking right here.
      
      retval= (addDataToBuf(buffers[connid].txdata, 
			   &buffers[connid].txhead, 
			   &buffers[connid].txtail,
			   buf,
			   size));

       dbg(DBG_USR1,"(addDataTx) After (head=%d,tail=%d,ret=%d)\n", 
	  buffers[connid].txhead, buffers[connid].txtail, retval );

      return retval;

    } //addDataToTxBuf

  uint16_t addDataToRxBuf(int connid,
			uint8_t* buf,
			uint16_t size)
    {

      uint16_t retval;

      dbg(DBG_USR1,"addDataToRxBuf (%d, %d)\n",connid, size);
      //todo: some sanity checking right here.

      dbg(DBG_USR1,"(addDataRx) Before (head=%d,tail=%d)\n", 
	  buffers[connid].rxhead, buffers[connid].rxtail );
      
      retval =  (addDataToBuf(buffers[connid].rxdata, 
			   &buffers[connid].rxhead, 
			   &buffers[connid].rxtail,
			   buf,
			   size));
      
      dbg(DBG_USR1,"(addDataRx) After (head=%d,tail=%d,returning %d)\n", 
	  buffers[connid].rxhead, buffers[connid].rxtail, retval );

      return retval;

    } //addDataToTxBuf

  /*******************************************
   *End of Buffer management
   ******************************************/



  /***********************************************
    StdControl functions
  *********************************************/

  command result_t StdControl.init()
    {
      call SubControl.init();
      return SUCCESS;
    }

  command result_t StdControl.start()
    {
      call SubControl.start();
      senders = 0;
      return SUCCESS;
    }

  command result_t StdControl.stop()
    {
      call SubControl.stop();
      return SUCCESS;
    }

  /***********************************************
   * END StdControl
   ***********************************************/

  /***********************************************
   * Connect stuff -- mostly pass-through, with a little initialization
   ***********************************************/

  command uint8_t Connect.connect(uint16_t addr)
    {
      return call SubConnect.connect(addr);
    }

  command result_t Connect.close(uint8_t connid)
    {
      return call SubConnect.close(connid);
    }

  event result_t SubConnect.connectDone(uint16_t addr,
					uint8_t uid,
					uint8_t connid,
					relyresult success)
    {
      atomic
	{
	  if (success == RELY_OK)
	    {
	      buffers[connid].valid = TRUE;
	      buffers[connid].uid = uid;
	      buffers[connid].rxhead = 0;
	      buffers[connid].rxtail = 0;
	      buffers[connid].txhead = 0;
	      buffers[connid].txtail = 0;
	    }
	} //atomic
      
      return signal Connect.connectDone(addr,uid,connid,success);
    }



  event relyresult SubConnect.accept(uint16_t srcaddr, uint8_t connid)
    {
      relyresult res;

      //Do you want this connection?
      res = signal Connect.accept(srcaddr,connid);

      atomic
	{
	  if (res == RELY_OK)
	    {
	      buffers[connid].valid = TRUE;
	      buffers[connid].uid = 0;
	      buffers[connid].rxhead = 0;
	      buffers[connid].rxtail = 0;
	      buffers[connid].txhead = 0;
	      buffers[connid].txtail = 0;
	    }
	} //atomic

      return res;
    }

  default event relyresult Connect.accept(uint16_t srcaddr,uint8_t connid)
    {
      return RELY_ERR;
    }

  default event result_t Connect.connectDone(uint16_t addr,
					uint8_t uid,
					uint8_t connid,
					relyresult success)
    {
      return SUCCESS;
    }

  /***********************************************
   * END Connect
   ***********************************************/

  /***********************************************
   * StreamRead
   ***********************************************/

  command result_t StreamRead.read(uint8_t connid,
			uint8_t* buffer,
			uint16_t size,
			uint16_t* bytesread)
    {
      uint16_t avail, howmany;
      int i;

      dbg(DBG_USR1,"StreamRead.read(%d,%d,%d)\n",connid,(int)buffer,size);

      *bytesread = 0;
      //Valid Buffer?;
      if (!isValidBuffer(connid))
	{
	  dbg(DBG_USR1,"(read)Invalid Buffer(%d)\n",connid);
	  return FAIL;
	}
      
      if (!tryLockBuffer(connid))
	{
	  dbg(DBG_USR1,"(read)Could not get lock for (%d)\n",connid);
	  //keep trying : better luck next time
	  *bytesread = 0;
	  return SUCCESS;
	}

      //I have the lock.  Don't forget to release it.
      //how many available rx bytes are there
      avail = getRxCount(connid);
      dbg(DBG_USR1,"(read) Buffer %d had %d bytes available to read.\n",connid, avail);
      
      if (avail < size)
	{
	  //no partial reads
	  howmany = 0;
	} else {
	  howmany = size;
	}

      dbg(DBG_USR1,"(read)Read (%d) bytes from %d (head=%d, tail=%d)\n",
	  howmany, connid, buffers[connid].rxhead, buffers[connid].rxtail);

      //replace with memcpy if too slow
      for (i=0; i < howmany; i++)
	{
	  buffer[i] = buffers[connid].rxdata[(buffers[connid].rxhead + i) % TS_BUF_LENGTH];
	}

      //adjust head;
      buffers[connid].rxhead = (buffers[connid].rxhead + howmany) % TS_BUF_LENGTH;
      *bytesread = howmany;
      
      dbg(DBG_USR1,"(read)After read head=%d, tail=%d\n",
	  buffers[connid].rxhead, buffers[connid].rxtail);



      releaseBuffer(connid);
      dbg(DBG_USR1,"(read)Release Buffer (%d)\n",connid);

      return SUCCESS;
      
    }

  event result_t RelyRecv.receive(uint8_t connid,
				  RelySegmentPtr msg)
    {
      uint16_t bytesfree;
      uint16_t bytes;


      dbg(DBG_USR1,"RelyRecv.receive (%d,%d)\n",connid, msg->length);

      //Valid Buffer?;
      if (!isValidBuffer(connid))
	{
	  return FAIL;
	}
      
      if (!tryLockBuffer(connid))
	{
	  return FAIL;
	}

      //I have the lock.  Don't forget to release it.
      bytesfree = getRxFreeCount(connid);
      dbg(DBG_USR1,"(recv) Buffer %d has %d bytes free\n",connid, bytesfree);

      if (bytesfree < msg->length)
	{
	  //no room in the buffer
	  dbg(DBG_USR1,"(recv) No room (%d)\n",connid);
	  releaseBuffer(connid);
	  return FAIL;
	}

      //okay there's room.  Copy it in
      bytes = addDataToRxBuf(connid, msg->data, msg->length);

      dbg(DBG_USR1,"(recv) added %d bytes to %d\n",bytes, connid);
      
      releaseBuffer(connid);
      
      if (bytes != msg->length)
	{
	  return FAIL;
	}

      return SUCCESS;
    }

  /***********************************************
   * END StreamRead
   ***********************************************/

  /***********************************************
   * StreamWrite
   ***********************************************/


  task void SendTask()
    {
      int i,j;
      RelySegment segment;
      uint16_t bytes, fullbytes;

      atomic
	{
	  senders--;
	}

      for (i=0; i < RELY_MAX_CONNECTIONS; i++)
	{
	  if (buffers[i].valid && buffers[i].sending)
	    {
	      
	      //this connection has stuff that needs to be sent
	      fullbytes = getTxCount(i);
	      dbg(DBG_USR1,"Connection %d has %d bytes to send\n",i,fullbytes);
	      //copy data into the segment
	      if (fullbytes > 0)
		{
		  if (fullbytes > RELY_PAYLOAD_LENGTH)
		    {
		      bytes = RELY_PAYLOAD_LENGTH;
		    } else {
		      bytes = fullbytes;
		    }
		  dbg(DBG_USR1,"bytes to send=%d (h:%d,t:%d)\n",
		      bytes,buffers[i].txhead,buffers[i].txtail);
  
		  for (j=0; j < bytes; j++)
		    {
		      
		      segment.data[j] = buffers[i].txdata[buffers[i].txhead];
		      buffers[i].txhead = (buffers[i].txhead + 1) % TS_BUF_LENGTH;
		    }//for (j)
		  segment.length = bytes;

		  dbg(DBG_USR1,"copied %d bytes (h:%d,t:%d)\n",
		      segment.length,buffers[i].txhead,buffers[i].txtail);

		  //SEND THE SEGMENT--Failure means bad connection.
		  if (call RelySend.send(i,&segment) == FAIL)
		    {
		      //connection is bad
		      dbg(DBG_USR1,"ERROR!!! Bad connection!\n");
		      buffers[i].valid = FALSE;
		    }
		  
		} else {
		  //shouldn't happen...just in case.
		  buffers[i].sending = FALSE;
		}	      
	    }//if

	}//for
    }//SendTask


  command result_t StreamWrite.write(uint8_t connid,
			uint8_t* buffer,
			uint16_t size,
			uint16_t* byteswritten)
    {
      uint16_t bytesfree, howmany;
      

      //Valid Buffer?;
      if (!isValidBuffer(connid))
	{
	  return FAIL;
	}
      
      if (!tryLockBuffer(connid))
	{
	  //keep trying : better luck next time
	  *byteswritten = 0;
	  return SUCCESS;
	}

      //I have the lock.  Don't forget to release it.
      //how much space is free for tx bytes?
      bytesfree = getTxFreeCount(connid);
      
      if (bytesfree < size)
	{
	  //no partial writes
	  howmany = 0;
	} else {
	  howmany = size;
	}
     
      *byteswritten = addDataToTxBuf(connid, buffer, howmany);
      

      if (howmany > 0 && !buffers[connid].sending) 
	{
	  buffers[connid].sending = TRUE;
	  post SendTask();
	}

      releaseBuffer(connid);
      return SUCCESS;
    }

  event result_t RelySend.sendDone(uint8_t connid,
				   relyresult success)
    {
      if (success == RELY_OK)
	{
	  atomic 
	    {
	      if (senders <= 2)
		{
		  if (post SendTask())
		    {
		      senders++;
		    }//if
		}//if
	    }//atomic
	  
	} else {
	  buffers[connid].valid = FALSE;
	}

      return SUCCESS;
    }

  /***********************************************
   * END StreamWrite
   ***********************************************/

  

}
