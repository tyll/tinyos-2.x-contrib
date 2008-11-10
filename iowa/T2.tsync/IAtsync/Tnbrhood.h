#ifndef TS_TNBRHOOD
enum { NUM_NEIGHBORS = 12,    // 12 because of payload in TinyOS msg 
            /*** Note: don't make NUM_NEIGHBORS too big or you'll
             * have trouble with the health message -- see TnbrhoodM
             * to see why this would be an error ***/
       NUM_TYPES = 4,         //  how many AM_types for Neighbor iface
       INIT_WAIT = 8*5,       //  five second wait between beacons
       INIT_MAIN = 8*30,      //  one half minute to first main task
       INIT_COUNT = 5,        //  number of initializing beacons
       NORM_WAIT = 8*60,        //  normal time between beacons (1 min)
       // NORM_WAIT = 8*60*2,   //  normal time between beacons (2 min)
       // NORM_WAIT = 8*60*5,   //  normal time between beacons (5min)
       // NORM_WAIT = 8*60*10,  //  normal time between beacons (10min)
       // NORM_WAIT = 8*60*15,  //  normal time between beacons (15min)
       EXCHANGE_INTERVAL = 2,    //  2 slots (2/8 second)
       EXCHANGE_LMARGIN = 1,     //  1 slots "left" margin (1/8 second)
       EXCHANGE_RMARGIN = 0,     //  0 slots "right" margin (0/8 second)
       HEALTH_CHECK_FREQ = 8*60, //  check once per minute nbr health
       OUTLIER_LIMIT = 16,    // this is two seconds in eighth-sec units
       // These modes are for both neighbor tables and control
       MODE_NORMAL = 0x80,
       MODE_RECOVERING = 0x40,
       MODE_GOTSYNC = 0x20,
       MODE_BIDIRECTIONAL = 0x04,  // communication goes two-way 
       MODE_EVALUATE = 0x02,  // protect from restart until evaluated
       MODE_DISCARD = 0x01,   // discard next message (a special case) 
       DEMO_SYNC = 3*8,       // waiting period between beeps (3 sec)
       MAX_MAC_DELAY = 16000, // max jiffies allowed for MAC delay
       MAX_DRIFT = 65,        //  how many jiffies 
                              //    two motes can drift in one second
       SANE_JIFFIES = 1500,   //  threshold for automatically sane  
       SKEW_PU = ONE_BYTE_TIME_UNIT*MAX_DRIFT, 
                              //  allowed # jiffies skew per 1-byte unit 
       SKEW_NOISE_WAIT = 8*60*12, // wait this long before calculating skew
       SKEW_DIFFUSION_TIME = 8*60*3, // a few minutes to diffuse  
       // following are unused, but may be useful someday ...
       // values of zero for radio power => do not adjust
       CC2420_RADIO_POWER = 15, // 1 is lowest, 31 is highest 
           //  2 => max about 2 feet,  3 => up to 20 feet or so
       MICA128_RADIO_POWER = 0, 
           // 99 => 0 inches,90 => 1-2 inches, 80 => 3 inches
           //     // 64 => 8 inches, 32 => 15 inches, 16 => 25 inches
           //         // 8, 4, 2, 0  => 3 feet or maybe a bit more
       MICA2_RADIO_POWER = 0, 
           //  Allowed (from datasheet, p.32) are  
           //  01,02,03,04,05,06,07,08,09,0A,0B,0C,0D,0E,0F,
           //  40,50,60,70,80,90,C0,E0,FF which relate to range
           //  highly dependent on elevation, antenna, etc -- 
           //  typical could be (using antenna)  80 => 50meters,  
           //  FF => 70meters, 09 => 15meters, 02 => 2meters
     };  

/**
  * Neighborhood Structures (internal and for interface)
  */
typedef struct neighbor_t {
  #ifdef TRACK
  /*--- Local and RemoteVirtual are used in evaluation -----*/
  /*      "         "      also are used in containment     */
  timeSync_t Local;  // our local clock  
  timeSync_t RemoteVirtual;  // neighbor's virtual clock

  /*--- oldRemoteLocal and oldLocal are used for slope -----*/
  timeSync_t oldRemoteLocal; // an older value of RemoteLocal
  timeSync_t oldLocal;       // with accompanying Local clock
  float slope;               // current computed slope
  uint8_t byteMem;           // 8 bits:  
                             //   First four bits are for index into
			     //   diffs array, below.  Second four bits
			     //   are history of recent beacons being
			     //   "sane" or not;  these bits are managed
			     //   as a shift register (newest on front)
  int8_t  diffs[5];          // circular buffer:  last 5 "diff" values for
                             // incoming beacons of this neighbor, but divided
			     // by 256 so as to fit into a single byte
  #endif

  /*--- state variables to track a neighbor ----------------*/
  uint8_t connected; // indications of connectedness;
                     // implementation assumes NUM_TYPES <= 8
  uint8_t rcvHist[NUM_TYPES]; // history of receive events
  uint16_t Id;      // identifier of the neighbor
  #ifdef TRACK
  uint8_t mode;     // modality of the neighbor
  int8_t eights;    // number of 1/8 seconds this neighbor is 
  // ahead or behind the neighbor "base" time (range is +127 
  // to -127, but we floor and ceiling, so that +/-127 can 
  // signify anything out of range).  The "base" time is 
  // approximately the median time of all in the neighborhood.
  uint8_t DebugAge;
  #endif
  } neighbor_t;       
typedef neighbor_t * neighborPtr;
#define TS_TNBRHOOD
#endif
