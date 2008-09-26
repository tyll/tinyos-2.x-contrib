/*
 * Measuring the performance of the data structures
 */
includes chunk_header;
includes sizes;

module FlashStoreM {
    provides interface StdControl;
    
    uses {
        //interface ChunkStorage;
        interface Leds;
        interface Console;
        //interface GenericFlash;
        //interface Index;
        interface Checkpoint;
        interface RootDirectory;
		interface Stream as GpsLengthStream;
		interface Stream as GpsStream;
		interface Stream as BundleNumStream;
		interface Stream as VERSIONStream;
		interface Stream as ACKStream;
		
		interface BundleIndex as MyIndex;
		//interface BundleIndex as OtherIndex;
		
		interface Timer;
#ifdef WITH_DELUGE
		interface StdControl as DelugeControl;
		interface Timer as DelugeTimer;
#endif
    }
}

implementation {
//save every 6 hours
#define SAVE_TIMER 6L*60L*60L*1024L
//#define SAVE_TIMER 60L*2L*1024L
#define DELUGE_WAIT_PERIOD 10L*1024L
	task void format();
	
	int state;

    command result_t StdControl.init() 
    {
		
		call Leds.init();

		call MyIndex.init();
		//call OtherIndex.init();
		
		call Console.init();

		call GpsLengthStream.init(FALSE);
		call GpsStream.init(FALSE);
		call BundleNumStream.init(FALSE);
		call VERSIONStream.init(FALSE);	
		call ACKStream.init(FALSE);
#ifdef WITH_DELUGE
		call DelugeControl.init();
#endif
		
        return SUCCESS;
    }

    command result_t StdControl.start() 
    {    
        //pages = 2048;
		
		//call Leds.redOn();
        
		
		//call Console.string("Initing root dir..\n");
		
		
		
		//call Console.string("Initing root dir..\n");
		//call Leds.redOn();
		call Timer.start (TIMER_REPEAT, (uint32_t)SAVE_TIMER);  
		call Checkpoint.init(0);
		call RootDirectory.init();

        //post format();

        return SUCCESS;
    }
    
    command result_t StdControl.stop() 
    {
        return SUCCESS;
    }

	event void Console.input(char *s)
	{
	
	}


    event void RootDirectory.initDone(result_t result)
    {
		call Console.string("Root dir init done\n");
#ifdef WITH_DELUGE
		call DelugeTimer.start (TIMER_ONE_SHOT, (uint32_t)DELUGE_WAIT_PERIOD); 
#endif
    }

    event void RootDirectory.setRootDone(result_t result)
    {
    }

    event void RootDirectory.getRootDone(result_t res)
    {
    }

    event void RootDirectory.restore(flashptr_t *restore_ptr)
    {
        call Console.string("Restoring...\n");
    }
	
	event void GpsStream.appendDone(result_t res)
	{
	
	}
  
	event void GpsStream.nextDone(result_t res)
	{
  
	}
  
	event void GpsLengthStream.appendDone(result_t res)
	{

	}
  
	event void GpsLengthStream.nextDone(result_t res)
	{
	
	}
	
	event void 	BundleNumStream.appendDone(result_t res)
	{

	}
  
	event void 	BundleNumStream.nextDone(result_t res)
	{
	
	}
	


	event void 	VERSIONStream.appendDone(result_t res)
	{

	}
  
	event void 	VERSIONStream.nextDone(result_t res)
	{
	
	}

	
	event void 	ACKStream.appendDone(result_t res)
	{

	}
  
	event void 	ACKStream.nextDone(result_t res)
	{
	
	}
	
	event void Checkpoint.checkpointDone(result_t result)
	{
		// STUB
	}

	event void Checkpoint.rollbackDone(result_t result)
	{
		call MyIndex.load(FALSE);
		
	}
	
	event void MyIndex.AppendDone(result_t res)
	{
	
	}
	
	event void MyIndex.GetBundleDone(result_t res, bool valid)
	{
  
	}
	
	event void MyIndex.DeleteBundleDone(result_t res)
	{
	
	}
	
	event void MyIndex.loadDone(result_t res)
	{

	}
	
	task void checkpointTask()
	{
		call Checkpoint.checkpoint();
	}
	
	event void MyIndex.saveDone(result_t res)
	{
		
		if (res == SUCCESS) // Now we checkpoint.
		{
			//call Leds.redToggle();
			post checkpointTask();
		}
	}

#ifdef WITH_DELUGE
	event result_t DelugeTimer.fired ()
	{
		call DelugeControl.start();
		return SUCCESS;
	}
#endif
	
	event result_t Timer.fired ()
	{
		call MyIndex.save(NULL);
		return SUCCESS;
	}
	
}
