
enum
{
  AM_STATUS_MSG = 10,
  AM_SLEEP_MSG = 11,
  AM_PATHDONE_MSG = 12
};

typedef struct
{
  bool sleepy;			//indicates that the stargate has started sleep sequence
  uint16_t load;
} StatusMsg_t;

typedef struct
{
  bool finishload;
} SleepMsg_t;

typedef struct
{
	uint16_t pathnum;
	uint32_t elapsed_us; //time 
} PathDoneMsg_t;
