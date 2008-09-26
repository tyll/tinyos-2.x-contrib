includes AM;
includes StatusMsg;
includes TinyStream;

module StargateM
{
  provides
  {
    interface StdControl;
    interface SGWakeup;
  }

  uses
  {
  	interface StdControl as CommControl;
    interface Timer;
    interface Timer as WakeTimer;
    interface SendMsg as SleepSend;
    interface ReceiveMsg as StatusRecv;
    interface ReceiveMsg as PathDoneRecv;
    interface Connect;
    interface Leds;
  }

}

implementation
{

	enum {
		ASLEEP =0, 
		SLEEPY =1,
		WANTSLEEP =2, 
		AWAKE  =3,
		WAKING =4,
		UNINIT  = 5,
		RESET = 6,
	};

	int state;
  bool awake, ready, connected;
  uint16_t load;
  bool sleepy;
  TOS_MsgPtr statusBuffer;
  TOS_Msg sleepBuffer;
  uint16_t connection;
  
  PathDoneMsg_t pathdoneBuf;


  command result_t StdControl.init ()
  {
  	atomic state = UNINIT;
  	
    awake = FALSE;
    ready = FALSE;
    sleepy = FALSE;
    connected = FALSE;
    connection = load = 0;
    TOSH_MAKE_GIO3_OUTPUT ();
    TOSH_MAKE_GIO2_OUTPUT ();
    call Leds.init ();
	call CommControl.init();
    return SUCCESS;
  }

  command result_t StdControl.start ()
  {
  	//TOSH_SET_GIO3_PIN();
    TOSH_CLR_GIO3_PIN ();	//power on the stargate
    TOSH_SET_GIO2_PIN ();	//wake pin defaults to HIGH
    ready = TRUE;
    call CommControl.start();
    return SUCCESS;
  }


  command result_t StdControl.stop ()
  {
    call Timer.stop ();
    call WakeTimer.stop();
    TOSH_SET_GIO3_PIN ();	//cut power to the stargate
	call CommControl.stop();
    
    return SUCCESS;
  }

  event result_t Timer.fired ()
  {
    load = 0;
    
    if (state == SLEEPY)
    {
    	call CommControl.stop();
    	call Timer.start(TIMER_ONE_SHOT, 300);
    }
    if (state == RESET)
    {
    	call CommControl.start();
    }
    
  	atomic {
  		if (state == SLEEPY)
  		{
			state = RESET;
		} 
		else if (state == RESET)
		{
			state = ASLEEP;
		}
	}	
    
    if (state == ASLEEP)
    {
    	signal SGWakeup.sleepDone (SUCCESS);
    }

    return SUCCESS;
  }

  command result_t SGWakeup.wake ()
  {
  	
  	if (state != ASLEEP)
  	{
  		return FAIL;
  	}
  		
    
	
	TOSH_CLR_GIO2_PIN ();	//falling edge should trigger wakeup
	TOSH_uwait (500);	//wait 1ms
	TOSH_SET_GIO2_PIN ();
	
	state = WAKING;
    
    return SUCCESS;
  }

  command result_t SGWakeup.sleep ()
  {
    SleepMsg_t *mptr = (SleepMsg_t *) sleepBuffer.data;
    result_t res;
    //need to send a sleep message
    if (state != AWAKE)
      {
      	return FAIL;
      }
	
	load = 0;
    mptr->finishload = FALSE;
    res = call SleepSend.send (TOS_UART_ADDR, sizeof (SleepMsg_t),
				&sleepBuffer);
	if (res == SUCCESS)
	{
		state = WANTSLEEP;
	}
	return res;
  }

  event result_t SleepSend.sendDone (TOS_MsgPtr msg, result_t success)
  {
    if (msg != &sleepBuffer)
    {
    	return SUCCESS;
    }
    
	if (success == FAIL)
	{
		state = AWAKE;
	   	signal SGWakeup.sleepDone (FAIL);
	   	return SUCCESS;
	}
	
    return SUCCESS;
  }


  command bool SGWakeup.isawake ()
  {
  	if (state == AWAKE)
  	{
  		return TRUE;
  	}
  	return FALSE;
  }

  command bool SGWakeup.isready ()
  {
    return (state != UNINIT);
  }

  command uint16_t SGWakeup.getLoad ()
  {
    return load;
  }
  
  command result_t SGWakeup.upLoad()
  {
  	if (state != AWAKE) return FAIL;
  	atomic load++;
  	return SUCCESS;
  }

  command bool SGWakeup.getConnection (uint16_t * idx)
  {
    bool result = FALSE;
    atomic
    {
      if (connected)
	{
	  *idx = connection;
	  result = TRUE;
	}
    }				//atomic


    return result;
  }



  task void receiveTask ()
  {
  	bool change = FALSE;
    StatusMsg_t *msgptr = (StatusMsg_t *) statusBuffer->data;
    load = msgptr->load;
	
	
	atomic
	{
    	if (state == UNINIT || state == WANTSLEEP)
    	{
    		state = SLEEPY;
			change = TRUE;
    	}
    }
    
    if (!change) return;

	
    //Don't allow wake trigger for 3 seconds
    call Timer.start (TIMER_ONE_SHOT, 3 * 1024);

  }


  event TOS_MsgPtr StatusRecv.receive (TOS_MsgPtr m)
  {
    TOS_MsgPtr tmp;
    tmp = statusBuffer;
    statusBuffer = m;
    post receiveTask ();
    return tmp;
  }
  
  task void pathDoneTask()
  {
  	signal SGWakeup.pathDone(pathdoneBuf.pathnum, pathdoneBuf.elapsed_us);  
  }
  
	event TOS_MsgPtr PathDoneRecv.receive (TOS_MsgPtr m)
  	{
		PathDoneMsg_t *ptr;
		
		atomic load--;
		ptr = (PathDoneMsg_t*)m->data;
		
		memcpy(&pathdoneBuf, ptr, sizeof(PathDoneMsg_t));	
    	post pathDoneTask();
    	return m;
  	}

  event result_t Connect.connectDone (uint16_t addr,
				      uint8_t uid,
				      uint8_t connid, relyresult success)
  {
    return SUCCESS;
  }

  event relyresult Connect.accept (uint16_t srcaddr, uint8_t connid)
  {
    atomic
    {
      connection = connid;
    }
    
    call WakeTimer.start (TIMER_ONE_SHOT, 500);

    return RELY_OK;
  }

  event result_t WakeTimer.fired()
  {
  	connected = TRUE;
	if (state == WAKING)
	{
		state = AWAKE;
		signal SGWakeup.wakeDone();
	}
    return SUCCESS;
  }

}
