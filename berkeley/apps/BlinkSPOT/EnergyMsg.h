enum
{
  AM_ENERGYMSG = 13,
};

typedef struct EnergyMsg
{
	uint16_t src;
	uint32_t base;
	uint32_t energy;
} EnergyMsg_t;
