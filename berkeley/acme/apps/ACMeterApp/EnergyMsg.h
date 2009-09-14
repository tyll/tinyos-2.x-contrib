enum
{
  AM_ENERGYMSG = 8,
};

typedef nx_struct EnergyMsg
{
	nx_uint16_t src;
	nx_uint32_t energy;
} EnergyMsg_t;



enum
{
	AM_SWITCHMSG = 9,
};

typedef nx_struct SwitchMsg
{
	nx_uint8_t nodeID;
	nx_uint16_t toggle;
} SwitchMsg_t;
