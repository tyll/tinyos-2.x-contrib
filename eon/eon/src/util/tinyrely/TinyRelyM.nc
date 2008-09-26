includes TinyRely;
includes AM;

module TinyRelyM
{
  provides {
    interface StdControl as Control;
    interface RelySend;
    interface RelyRecv;
    interface Connect;
  }
  uses {
    interface StdControl as LowerControl;

    interface SendMsg as ConnectSend;
    interface SendMsg as LowerSend;
    interface SendMsg as AckSend;

    interface ReceiveMsg as ConnectRecv;
    interface ReceiveMsg as LowerReceive;
    interface ReceiveMsg as AckReceive;


    interface Timer as MainTimer;
    //interface Timer as FragTimer;
    //interface Timer as RecvTimer;
    //interface Timer as Throttle;
  }
}

implementation
{
  //connection variables
  uint8_t suid=0;
  ConnStr connections[RELY_MAX_CONNECTIONS];
  TOS_Msg connMsg;
  ConnMsgPtr connBufPtr;
  bool connPending;
  
  //sending variables
  uint8_t sendidx=0;
  bool taskresending = FALSE;



	
  bool resetConnection(int connid);

  
  command result_t Control.init()
    {
      suid = 0;
      connPending = FALSE;
      
      
      return call LowerControl.init();
      
    }

  command result_t Control.start()
    {

      int i=0;

      atomic {
	//reset all connections upon start.
	for (i=0; i < RELY_MAX_CONNECTIONS; i++)
	  {
	    connections[i].valid = FALSE;
	  }
      }

      call MainTimer.start(TIMER_REPEAT, RELY_TIME_STEP);
      return call LowerControl.start();
    }

  command result_t Control.stop()
    {
      call MainTimer.stop();
      return call LowerControl.stop();
    }

  
  task void connectionTimeoutTask()
    {
      int i;
      uint32_t elapsed;
      atomic {
	for (i=0; i < RELY_MAX_CONNECTIONS; i++)
	  {
	    if (connections[i].valid)
	      {
		connections[i].count++;
		elapsed = connections[i].count * RELY_TIME_STEP;

		if (elapsed >= RELY_CONN_TIMEOUT)
		  {
		    //time's up.  Abort connection
		    resetConnection(i);
		  }
	      }//if valid
	  }//for
      }
    } //connectionTimeoutTask


  task void resendTask();

  event result_t MainTimer.fired()
    {
      atomic {
	if (taskresending == FALSE)
	  {
	    taskresending = TRUE;
	    post connectionTimeoutTask();
	    sendidx=0;
	    post resendTask();
	  }
      }//atomic
	
      return SUCCESS;
    }


  //**********************************************************/
  //CONNECT-related commands/events
  //*********************************************************/

  /*Does just what you think it does
    it tests to see if the variable pointed to by testvar is false.
    if it is, then it is set to true and the function returns true.  Otherwise the function
    returns FALSE.  All is done atomically.
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

  /* Increments the global SUID and returns the next one.  Should
     never return a value of zero.  This would be an error.
  */
  uint8_t getNextUID()
    {
      bool isunique = FALSE;
      int i=0;

      dbg(DBG_USR3, "getNextUID(%d)\n",suid);

      atomic {
	while (!isunique)
	  {
	    isunique = TRUE;

	    //get next UID
	    suid = (suid + 1) % 255;
	    if (suid == 0)
	      suid++;

	    //check for uniqueness
	    for (i=0; i < RELY_MAX_CONNECTIONS; i++)
	      {
		if (connections[i].valid && connections[i].suid == suid)
		  {
		    isunique = FALSE;
		    break;
		  }
	      } //for
	  }//while

      }//atomic
      return suid;
    }

 

  /* Tries to find an available slot for the connection.  Returns a -1 if one is not
     found.  Returns the slot index otherwise.
  */
  int getNewConnection()
    {
      int connid = -1;
      int i=0;
      atomic {
	for (i=0; i < RELY_MAX_CONNECTIONS; i++)
	  {
	    if (connections[i].valid == FALSE)
	      {
		//found a free slot
		connections[i].valid = TRUE;
		connid = i;
		break;
	      }
	  }//for

      }//atomic
      return connid;
    }


  bool makeConnMsg(uint16_t addr, ConnMsgPtr msg)
    {
      if (msg == NULL) return FALSE;


      msg->src = TOS_LOCAL_ADDRESS;
      msg->suid = getNextUID();
      msg->duid = 0;
      msg->type = CONN_TYPE_REQUEST;
      msg->ok = RELY_OK;

      return TRUE;
      
    }

  bool makeCloseMsg(uint16_t addr, ConnMsgPtr msg)
    {
      if (msg == NULL) return FALSE;


      msg->src = TOS_LOCAL_ADDRESS;
      msg->suid = getNextUID();
      msg->duid = 0;
      msg->type = CONN_TYPE_CLOSE;
      msg->ok = RELY_OK;

      return TRUE;
      
    }

  bool makeCloseRequest(uint16_t addr, TOS_MsgPtr msg)
    {
      ConnMsgPtr connPtr;

      if (msg == NULL) return FALSE;
      
      connPtr = (ConnMsgPtr)&msg->data;
      return makeCloseMsg(addr, connPtr);

    }


  bool isValidConnectionID(int connid)
    {
      return (connid > RELY_IDX_INVALID && connid < RELY_MAX_CONNECTIONS);
    }
  
  bool isValidConnection(int connid)
    {
      return (isValidConnectionID(connid) && connections[connid].valid);
    }

  bool resetConnection(int connid)
    {
      dbg(DBG_USR3,"RESET CONNECTION!!! ID=%d\n",connid);

      if (!isValidConnection(connid))
	{
	  return FALSE;
	}
      
      if (connections[connid].sending)
	{
	  signal RelySend.sendDone(connid, RELY_ERR);
	}
      connections[connid].valid = FALSE;
      return TRUE;
    }


  bool makeConnRequest(uint16_t addr, TOS_MsgPtr msg)
    {
      ConnMsgPtr connPtr;

      if (msg == NULL) return FALSE;
      
      connPtr = (ConnMsgPtr)&msg->data;
      return makeConnMsg(addr, connPtr);

    }

  bool makeConnAck(int idx, uint8_t ok)
    {
      ConnMsgPtr connPtr;
      TOS_MsgPtr msgPtr;
      if (connections[idx].valid == FALSE) return FALSE;
      
      msgPtr = &connections[idx].txbuf;
      connPtr = (ConnMsgPtr)msgPtr->data;
      
      connPtr->src = TOS_LOCAL_ADDRESS;
      connPtr->suid = connections[idx].suid;
      connPtr->duid = connections[idx].duid;
      connPtr->type = CONN_TYPE_ACK;
      connPtr->ok = RELY_OK;
      return TRUE;
    }

  int getIndexByUID(uint8_t whatsuid)
    {
      int idx = RELY_IDX_INVALID;
      int i;

      atomic {
	for (i=0; i < RELY_MAX_CONNECTIONS; i++)
	{
	  if (connections[i].valid && connections[i].suid == whatsuid)
	    {
	      idx = i;
	      break;
	    }
	} //for
      } //atomic

      return idx;
    }

  /*
    connectionCompleteTask

    Fired when a connection is acknowledged.  This task
    goes through the list and signals all appropriate connections.
  */

  task void connectionCompleteTask()
    {
      int i;
      bool complete = FALSE;

      for (i=0; i < RELY_MAX_CONNECTIONS; i++)
	{
	  atomic {
	    complete = FALSE;
	    //Has the connection been requested, sent, and ack-ed?
	    if (connections[i].valid && connections[i].pending && connections[i].full)
	      {
		complete = TRUE;
		connections[i].pending = FALSE;
		connections[i].full = FALSE;
	      }
	  } //atomic

	  if (complete)
	    {
	      //signal that it is finished -- ignore result
	      signal Connect.connectDone(connections[i].addr,
					 connections[i].suid,
					 i,
					 RELY_OK);	      
	      
	    } //if

	} // for

    } //connectionCompleteTask()


  /*
    Establish a connection to a device with given address.
    returns RELY_UID_INVALID(0) if there is an error.  Otherwise, it returns a unique
    identifier with which to match the ConnectDone event.
   */
  command uint8_t Connect.connect(uint16_t addr)
    {
      ConnMsgPtr cmptr;
      result_t res;
      int idx;
     
      //return invalid uid.
      if (!testAndSet(&connPending)) return RELY_UID_INVALID;
      
      idx = getNewConnection();
      if (idx == RELY_IDX_INVALID)
	{
	  connPending = FALSE;
	  return RELY_UID_INVALID;
	}

      if (!makeConnRequest(addr, &connections[idx].txbuf)) 
	{
	  connections[idx].valid = FALSE;
	  connPending = FALSE;
	  return RELY_UID_INVALID;
	}

      //Set up connection data structure
      connections[idx].pending = TRUE;
      connections[idx].full = FALSE;

      cmptr = (ConnMsgPtr)&connections[idx].txbuf.data;
      connections[idx].count = 0;
      connections[idx].suid = cmptr->suid;
      connections[idx].txseq = 0;
      connections[idx].rxseq = 0;
      connections[idx].addr = addr;
      connections[idx].sending = FALSE;

      res = call ConnectSend.send(addr, sizeof(ConnMsg), &connections[idx].txbuf);
      if (res == FAIL)
	{
	  connections[idx].valid = FALSE;
	  connections[idx].pending = FALSE;
	  connPending = FALSE;
	  return RELY_UID_INVALID;
	} //if

      connPending = FALSE;
      return connections[idx].suid;
      
    } //end connect
  

  /*
    Closes an open connection.
    returns SUCCESS if the connection was
    successfully closed.
    returns FAIL if the connection does not exist
  */

  command result_t Connect.close(uint8_t connid)
    {
      result_t res;

      dbg(DBG_USR3,"Connect.close(%d)\n",connid);

      if (connections[connid].valid == FALSE)
	{
	  return FAIL;
	}

      //Send the close message
      makeCloseRequest(connections[connid].addr, &connections[connid].txbuf);
      res = call ConnectSend.send(connections[connid].addr, 
				  sizeof(ConnMsg), 
				  &connections[connid].txbuf);
      if (res == FAIL)
	{
	  //just reset it, they'll figure it out soon enough
	  resetConnection(connid);
	} else {
	  connections[connid].closing = TRUE;
	}
      return SUCCESS;
    }


  event result_t ConnectSend.sendDone(TOS_MsgPtr msg, result_t success)
    {
      int idx;
      ConnMsgPtr cmsgptr = (ConnMsgPtr)msg->data;

      idx = getIndexByUID(cmsgptr->suid);

      dbg(DBG_USR3,"ConnectSend.sendDone(%d,%d)\n",idx,success);

      //sanity checks
      if (idx ==  RELY_IDX_INVALID)
	{
	  //I have no record of this.  Should never happen.
	  //do nothing
	  return SUCCESS;
	}

      if (connections[idx].closing == TRUE && cmsgptr->type == CONN_TYPE_CLOSE)
	{
	  dbg(DBG_USR3,"I sent a close request\n");
	  resetConnection(idx);
	  return SUCCESS;
	}

      if (success == FAIL && cmsgptr->type == CONN_TYPE_REQUEST)
	{
	  signal Connect.connectDone(connections[idx].addr, 
				     connections[idx].suid, 
				     idx, 
				     RELY_ERR); 
	  return SUCCESS;
	}

      return SUCCESS;
      
    }

  event TOS_MsgPtr ConnectRecv.receive(TOS_MsgPtr msg)
     {
       int idx;
       relyresult rres;
       result_t res;
       ConnMsgPtr cmsgptr = (ConnMsgPtr)msg->data;
       
       //Is this a request, ack, or close?
       dbg(DBG_USR3,"ConnectRecv.receive\n");

       if (cmsgptr->type == CONN_TYPE_REQUEST) {

	 dbg(DBG_USR3,"It's a request\n");
	 //this is an incoming connection request
	 //check for valid suid
	 if (cmsgptr->suid == RELY_UID_INVALID)
	   {
	     dbg(DBG_USR3,"BAD SUID!\n");
	     //ignore a bad suid
	     return msg;
	   }
	 
	 //reserve a connection slot
	 atomic {
	   idx = getNewConnection();
	   if (idx != RELY_IDX_INVALID)
	     {
	       connections[idx].valid = TRUE; //just make sure that nobody gets it while we're waiting
	     }
	 }//atomic

	 if (idx == RELY_IDX_INVALID) return msg;
	 
	 //ask the higher powers whether to accept this
	 //connection or not.
	 rres = signal Connect.accept(cmsgptr->src, idx);

	 if (rres == RELY_OK)
	   {
	     atomic {
	       //we want this one, so send an ack
	       connections[idx].suid = getNextUID();
	       connections[idx].duid = cmsgptr->suid;
	       connections[idx].addr = cmsgptr->src;
	       connections[idx].pending = FALSE;
	       connections[idx].sending = FALSE;
	       connections[idx].full = FALSE;
	       connections[idx].txseq = 0;
	       connections[idx].rxseq = 0;
	       connections[idx].count = 0;
	     } //atomic
	     if (!makeConnAck(idx, RELY_OK)) 
	       {
		 //this shouldn't happen.  Should always
		 //be able to form the packet--just in case
		 dbg(DBG_USR3,"makeConnAck(%d) failes\n",idx);
		 resetConnection(idx);
		 return msg;
	       } //if
	     
	     dbg(DBG_USR3,"Try to send Ack!\n");
	     //try to send the ack
	     res = call ConnectSend.send(connections[idx].addr, 
					 sizeof(ConnMsg), 
					 &connections[idx].txbuf);
	     if (res == FAIL)
	       {
		 //I'm taking a very reckless approach to this.
		 //basically if I can't send, I abort and leave the connection to be
		 //reestablished later--no retries.  I'll rethink this if it becomes
		 //a problem.
		 dbg(DBG_USR3,"Reckless abandonment of connection(%d)\n",idx);
		 resetConnection(idx);
		 return msg;
	       }
	     
	     return msg;
		 
	   } else {
	     return msg;
	   }//if
       }

       if (cmsgptr->type == CONN_TYPE_ACK) {
	 //Someone is ack-ing our request
	 dbg(DBG_USR3,"It's a connection ACK!\n");

	 atomic {
	   idx = getIndexByUID(cmsgptr->duid);
	   dbg(DBG_USR3,"DUID: %d -> INDEX: %d\n",cmsgptr->duid,idx);


	   if (idx != RELY_IDX_INVALID && connections[idx].pending == TRUE)
	     { 
	       dbg(DBG_USR3,"Valid Connection (%d,%d)\n",idx,connections[idx].pending);
	       connections[idx].duid = cmsgptr->suid;
	       connections[idx].txseq = 0;
	       connections[idx].rxseq = 0;
	       connections[idx].full = TRUE;
	       connections[idx].count = 0;
	       post connectionCompleteTask();
	     } else {
	       dbg(DBG_USR3,"Invalid Connection (%d,%d)\n",idx,connections[idx].pending);
	     }
	 } //atomic
	 return msg;
       }

       if (cmsgptr->type == CONN_TYPE_CLOSE) {
	 atomic {
	   idx = getIndexByUID(cmsgptr->duid);
	   if (idx != RELY_IDX_INVALID)
	     {
	       dbg(DBG_USR3,"Close with BAD IDX.\n");
	       resetConnection(idx);
	     } //if
	 } //atomic
	 return msg;
       }//if (close)
       
       return msg;
      
     }//receive
       
  
  //End - Connect-related calls
  //*********************************************************/


  //*********************************************************/
  //SENDING RELATED CALLS


  

  bool sendSegment(int connid)
    {
      
      if (isValidConnection(connid) == FALSE)
	{
	  return FALSE;
	}

      //Send the segment
      //Note : this may be inefficient.  It sends a full segment even if the length is much shorter.
      //Depending on the underlying implementation, this may not matter. If it becomes a problem
      //it will be fixed.  Note, this was never intended to be the worlds most efficient communication
      //protocol.  It just needs to work reasonably well.
      if (call LowerSend.send(connections[connid].addr, 
			      sizeof(TinyRelyMsg), 
			      &connections[connid].txbuf) == SUCCESS)
	{
	  return TRUE;
	} else {
	  //Only return false if the connection is invalid;
	  return TRUE;
	}

    }

  bool initSegment(RelySegmentPtr seg, int connid)
    {

      TinyRelyMsgPtr msg;

      if (seg->length > RELY_PAYLOAD_LENGTH)
	return FALSE;

      if (isValidConnection(connid) == FALSE)
	return FALSE;

      atomic {
	msg = (TinyRelyMsgPtr)&connections[connid].txbuf.data;
	memcpy(msg->data, seg->data, seg->length);
	msg->src = TOS_LOCAL_ADDRESS;
	msg->suid = connections[connid].suid;
	msg->duid = connections[connid].duid;
	msg->seq = connections[connid].txseq;
	connections[connid].txseq++;
	msg->length = seg->length;
	
      } //atomic
      return TRUE;
    }//initSegment


  command result_t RelySend.send(uint8_t connid, RelySegmentPtr seg)
  {
    if (connid >= RELY_MAX_CONNECTIONS) return FAIL;

    if (seg->length > RELY_PAYLOAD_LENGTH)
      {
	return FAIL;
      }

    //does connid exist?
    if (connections[connid].valid == FALSE)
      {
	return FAIL;
      }

    //Is this connection currently waiting on a previous segment?
    if (connections[connid].sending == TRUE)
      {
	//sorry, I'm busy
	//should never happen.  You should not try to send another segment
	//until you get a sendDone from me.
	dbg(DBG_USR3,"Busy Fail.\n");
	resetConnection(connid);
	return FAIL;
      }

    //put the data in the txbuf;
    if (initSegment(seg, connid) == FALSE)
      {
	dbg(DBG_USR3,"InitSegment Failed (%d.%d)\n",seg,connid);
	resetConnection(connid);
	return FAIL;
      }

     if (sendSegment(connid) == FALSE)
      {
	dbg(DBG_USR3,"Failed on send (idx=%d)\n",connid);
	resetConnection(connid);
	return FAIL;
      }
     connections[connid].sending = TRUE;

     return SUCCESS;

  }



  event result_t LowerSend.sendDone(TOS_MsgPtr msg, result_t success)
    {
      return SUCCESS;
    }

  event result_t AckSend.sendDone(TOS_MsgPtr msg, result_t success)
    {
      return SUCCESS;
    }
  

  event TOS_MsgPtr AckReceive.receive(TOS_MsgPtr msg)
     {
       int idx;
       TinyRelyAckPtr ackptr = (TinyRelyAckPtr)msg->data;

       if (ackptr->suid == RELY_UID_INVALID || ackptr->duid == RELY_UID_INVALID)
	 {
	   //invalid do nothing
	   dbg(DBG_USR3,"AckReceive.recv: Invalid id (s:%d,d:%d)\n",ackptr->suid, ackptr->duid);
	   return msg;
	 }

       idx = getIndexByUID(ackptr->duid);
       if (!isValidConnection(idx))
	 {
	   //not my connection!
	   dbg(DBG_USR3,"AckReceive.recv: Invalid connection: %d -> %d\n",ackptr->duid, idx);
	   return msg;
	 }

       //check sequence number
       if (connections[idx].txseq != ackptr->seq || connections[idx].sending == FALSE)
	 {
	   //out of synch. ignore
	   dbg(DBG_USR3,"AckReceive.recv: Out of Synch (sending=%d) or (%d <> %d)\n",connections[idx].sending,
	       connections[idx].txseq, ackptr->seq);

	   //resetConnection(idx);
	   return msg;
	 }

       //check the status
       if (ackptr->ok != RELY_OK)
	 {
	   resetConnection(idx);
	   return msg;
	 }

       connections[idx].sending = FALSE;
       connections[idx].resending = FALSE;
       connections[idx].count = 0;
       signal RelySend.sendDone(idx, RELY_OK);
       return msg;

     }//AckReceive.receive
       
  task void resendTask()
    {
      int start = sendidx;
    
      int i, idx;
      //uint32_t elapsed;

      atomic {
	for (idx=0; idx < RELY_MAX_CONNECTIONS; idx++)
	  {
	    i = (start + idx) % RELY_MAX_CONNECTIONS;

	    if (connections[i].valid)
	      {
		if (connections[i].sending)
		  {
		    if (connections[i].resending)
		      {
			//resend the message
			if (!sendSegment(i))
			  {
			    //need to try again.
			    sendidx = i;
			  } else {
			    sendidx = (i+1) % RELY_MAX_CONNECTIONS;
			  }
			
		      } else {
			//give one more cycle before we start resending.
			connections[i].resending = TRUE;
		      }
		  } 
	      }//if valid
	  }//for
      }//atomic
      taskresending = FALSE;
    }//resendTask

  //*********************************************************/


  //*********************************************************/
  //RECVING RELATED CALLS

  bool sendMsgAck(int idx)
    {
      TinyRelyAckPtr pack;
      result_t res;

      if (!isValidConnection(idx))
	{
	  dbg(DBG_USR3,"sendMsgAck: Invalid connection: %d\n",idx);
	  return FALSE;
	}

      //dbg(DBG_USR3,"sendMsgAck: Valid connection: %d\n",idx);
      
      pack = (TinyRelyAckPtr)connections[idx].ackbuf.data;
      pack->src = TOS_LOCAL_ADDRESS;
      pack->suid = connections[idx].suid;
      pack->duid = connections[idx].duid;
      pack->seq = connections[idx].rxseq;
      pack->ok = RELY_OK;

      
      res = call AckSend.send(connections[idx].addr, sizeof(TinyRelyAck), &connections[idx].ackbuf);
      dbg(DBG_USR3,"sendMsgAck: Sending ACK -> %d. returned %d(SUCCESS=%d)\n",connections[idx].addr, res,SUCCESS);
      return res;
      
    }


  task void RecvTask()
    {
      int idx=-1;
      int i;
      RelySegment rseg;
      TinyRelyMsgPtr pmsg;
      result_t res;

      atomic
	{
	  for (i=0; i < RELY_MAX_CONNECTIONS; i++)
	    {
	      if (connections[i].valid && connections[i].full && !connections[i].pending)
		{
		  //ready to receive
		  idx = i;
		  break;
		}
	    } //for
	} //atomic
      
      if (idx > -1)
	{
	  pmsg = (TinyRelyMsgPtr)&connections[idx].rxbuf.data;
	  rseg.length = pmsg->length;
	  memcpy(rseg.data, pmsg->data, RELY_PAYLOAD_LENGTH); 
	  res = signal RelyRecv.receive(idx, &rseg);
	  
	  //did it take?
	  if (res == SUCCESS)
	    {
	      connections[idx].full = FALSE;
	      connections[idx].rxseq++;
	      connections[idx].count=0;
	      //now send ack.
	      sendMsgAck(idx);
	    } else {

	      //the message wasn't received.
	      //DO NOTHING.  Forces the sender to resend this segment.
	      //We don't, however, want the connection to timeout
	      connections[idx].count = 0;
	    }
	  
	}

    }//RelyTask

  event TOS_MsgPtr LowerReceive.receive(TOS_MsgPtr msg) 
    {
      
      TinyRelyMsgPtr pmsg;
      int idx;

      pmsg = (TinyRelyMsgPtr)msg->data;
      idx = getIndexByUID(pmsg->duid);

      dbg(DBG_USR3,"LowerReceive.receive. (duid:%d->idx:%d)\n",pmsg->duid,idx);

      if (idx == RELY_IDX_INVALID)
	{
	  return msg;
	}

      //It is a valid connection!
      //is it full?

      atomic {

	if (!connections[idx].full && connections[idx].rxseq == pmsg->seq) 
	  {	  
	 
	    //copy the contents to the rxbuf
	    
	    memcpy(&connections[idx].rxbuf, msg, sizeof(TOS_Msg));
	    connections[idx].full = TRUE;
	    connections[idx].count = 0;
	    post RecvTask();
	  } else {
	    dbg(DBG_USR3,"FULL(%d) or BAD Seq#(%d <> %d)\n",connections[idx].full, 
		connections[idx].rxseq, pmsg->seq);

	    sendMsgAck(idx);
	  }
      }//atomic
      
      return msg;
    }


  //*********************************************************/



}
