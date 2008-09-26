

includes common_header;
includes sizes;

configuration FlashStore {
	provides 
	{
		//interface StdControl;
		interface SingleStream;
		//interface Index as MyIndex;
		//interface BundleIndex as OtherIndex;
		interface BundleIndex as MyIndex;
		interface Stream as GPSStream;
		//interface StreamExport as GPSStreamExport;
		interface StreamExport;
		interface Stream as GPSLengthStream; // used as a value, not really a stream
		interface Stream as BundleNumStream; // used as a value too.
		interface Stream as ACKStream; // used to store the ACK array
		interface Stream as VERSIONStream; // used to store the ACK array
		//interface Stream as ACKLengthStream;
		interface Compaction;
		interface Checkpoint;
		interface GenericFlash;
	}
}

implementation {
	
#define UNIQE_OTHER_INDEX	1
#define UNIQE_MY_INDEX	0
	
	components FlashStoreM, ChunkStorageC, FlashM, FalC, Main, TimerC,
#ifdef CONSOLE_DEBUG
		ConsoleC as Console, HPLUARTC,
#else
		NoConsoleC as Console,
#endif
		NoLeds as Leds, StackC, ArrayC, Crc8C, StreamC, LedsC,
		//LedsC as Leds, StackC, ArrayC, Crc8C, StreamC,
		SingleStreamC, BundleIndexC, CheckpointC, RootDirectoryC;
		
#ifdef WITH_DELUGE
	components DelugeCustomC as Deluge;

	FlashStoreM.DelugeControl -> Deluge.StdControl;
	FlashStoreM.DelugeTimer->TimerC.Timer[unique ("Timer")];
#endif
				
	FlashStoreM.Timer->TimerC.Timer[unique ("Timer")];
	
	
	Main.StdControl -> FlashStoreM.StdControl;
	Main.StdControl -> FalC;
	Main.StdControl -> ChunkStorageC;

	SingleStream = SingleStreamC;
	//OtherIndex = BundleIndexC.BundleIndex[unique("BundleIndex")]; // 1
	MyIndex = BundleIndexC.BundleIndex[UNIQE_MY_INDEX]; // 0
	GPSStream = StreamC.Stream[unique("Stream")]; //0
	StreamExport = StreamC.StreamExport[0];
	GPSLengthStream = StreamC.Stream[unique("Stream")]; // 1
	ACKStream = StreamC.Stream[unique("Stream")]; // 2
	BundleNumStream = StreamC.Stream[unique("Stream")]; // 3
	VERSIONStream = StreamC.Stream[unique("Stream")];	// 4
//ACKLengthStream = StreamC.Stream[unique("Stream")];
	Compaction = BundleIndexC.Compaction[0];
	//Compaction = BundleIndexC.Compaction[1];
	
			/* Wire the chunk storage system */
//FlashM -> PageEEPROMC.PageEEPROM[unique("FAL")];
	ChunkStorageC.GenericFlash -> FalC.GenericFlash[unique("Flash")]; 
	ChunkStorageC.Leds -> Leds;
	ChunkStorageC.Crc8 -> Crc8C; 

/* Wire the data structures */
	StreamC.ChunkStorage -> ChunkStorageC.ChunkStorage[unique("Fal")]; // 0
	BundleIndexC.ChunkStorage -> ChunkStorageC.ChunkStorage[unique("Fal")]; // 1
	SingleStreamC.ChunkStorage -> ChunkStorageC.ChunkStorage[unique("Fal")]; // 2
	StackC.ChunkStorage -> ChunkStorageC.ChunkStorage[unique("Fal")]; // 3
	ArrayC.ChunkStorage -> ChunkStorageC.ChunkStorage[unique("Fal")]; // 4
	
	StreamC.Stack -> StackC.Stack[1];
	SingleStreamC.Stack -> StackC.Stack[2]; // used to be unique"stack"

	BundleIndexC.Array -> ArrayC.Array[unique("Array")];
	BundleIndexC.SingleCompaction -> SingleStreamC.SingleCompaction;

/* Debugging */
	StackC.Leds -> Leds;
	ArrayC.Leds -> Leds;
	SingleStreamC.Leds -> Leds;
	BundleIndexC.Leds -> Leds;
	StreamC.Leds -> Leds;
	ChunkStorageC.Leds -> Leds;
	CheckpointC.Leds -> Leds;
	
	FlashStoreM.Console -> Console;
	BundleIndexC.Console -> Console;
	SingleStreamC.Console -> Console;
	StackC.Console -> Console;
	ArrayC.Console -> Console;
	ChunkStorageC.Console -> Console;
	RootDirectoryC.Console -> Console;
#ifdef FLASH_DEBUG
	FlashM.Console -> Console;
#endif

	CheckpointC.Console -> Console;
	StreamC.Console -> Console;

#ifdef CONSOLE_DEBUG
    Console.HPLUART -> HPLUARTC;
#endif
    
/* Checkpointing */
	CheckpointC.ChunkStorage -> ChunkStorageC.ChunkStorage[unique("Fal")];
	CheckpointC.Stack -> StackC.Stack[0];
	CheckpointC.RootPtrAccess -> StackC.RootPtrAccess[0];
	CheckpointC.RootDirectory -> RootDirectoryC;

	CheckpointC.Serialize -> ChunkStorageC.Serialize;
	CheckpointC.Serialize -> BundleIndexC.Serialize[0];
	//CheckpointC.Serialize -> BundleIndexC.Serialize[1];
	
	CheckpointC.Serialize -> StreamC.Serialize[0];
	CheckpointC.Serialize -> StreamC.Serialize[1];
	CheckpointC.Serialize -> StreamC.Serialize[2];
	CheckpointC.Serialize -> StreamC.Serialize[3];
	CheckpointC.Serialize -> StreamC.Serialize[4];
	
	
	/* Compaction */
	ChunkStorageC.Compaction -> BundleIndexC.Compaction[0];
	//ChunkStorageC.Compaction -> BundleIndexC.Compaction[1];	
	ChunkStorageC.Compaction -> StreamC.Compaction[0];
	ChunkStorageC.Compaction -> StreamC.Compaction[1];
	ChunkStorageC.Compaction -> StreamC.Compaction[2];
	ChunkStorageC.Compaction -> StreamC.Compaction[3];
	ChunkStorageC.Compaction -> StreamC.Compaction[4];
	

	/* Application */
    //StressTestC.ChunkStorage -> ChunkStorageC.ChunkStorage[unique("Fal")];
	FlashStoreM.Leds -> Leds;
	GenericFlash = FlashM.GenericFlash[unique("Flash")];
	
	//StressTestC.GenericFlash -> FlashM.GenericFlash[unique("Flash")];
    //StressTestC.Index -> BundleIndexC.Index[unique("BundleIndex")];
	Checkpoint = CheckpointC.Checkpoint;
	FlashStoreM.RootDirectory -> RootDirectoryC;
	FlashStoreM.GpsStream -> StreamC.Stream[0];
	FlashStoreM.GpsLengthStream -> StreamC.Stream[1];
	FlashStoreM.ACKStream -> StreamC.Stream[2];
	FlashStoreM.BundleNumStream -> StreamC.Stream[3];
	FlashStoreM.VERSIONStream -> StreamC.Stream[4];

	FlashStoreM.MyIndex -> BundleIndexC.BundleIndex[UNIQE_MY_INDEX]; // 0
	//FlashStoreM.OtherIndex -> BundleIndexC.BundleIndex[0]; // 1
	
	FlashStoreM.Checkpoint -> CheckpointC.Checkpoint;
}
