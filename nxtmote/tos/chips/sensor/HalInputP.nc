//#include  "c_output.iom"
#include "c_input.iom"
#include "c_input.h"


#define   INVALID_RELOAD_NORMAL         20
#define   INVALID_RELOAD_SOUND          300

#define   ROT_SLOW_SPEED                30
#define   ROT_OV_SAMPLING               7

#define   VCC_SENSOR                    5000L
#define   VCC_SENSOR_DIODE              4300L
#define   AD_MAX                        1023L

#define   REFLECTIONSENSORMIN           (1906L/(VCC_SENSOR/AD_MAX))
#define   REFLECTIONSENSORMAX           ((AD_MAX * 4398L)/VCC_SENSOR)
#define   REFLECTIONSENSORPCTDYN        (UBYTE)(((REFLECTIONSENSORMAX - REFLECTIONSENSORMIN) * 100L)/AD_MAX)

#define   NEWLIGHTSENSORMIN             (800L/(VCC_SENSOR/AD_MAX))
#define   NEWLIGHTSENSORMAX             ((AD_MAX * 4400L)/VCC_SENSOR)
#define   NEWLIGHTSENSORPCTDYN          (UBYTE)(((NEWLIGHTSENSORMAX - NEWLIGHTSENSORMIN) * 100L)/AD_MAX)

#define   NEWSOUNDSENSORMIN             (650L/(VCC_SENSOR/AD_MAX))
#define   NEWSOUNDSENSORMAX             ((AD_MAX * 4980L)/VCC_SENSOR)
#define   NEWSOUNDSENSORPCTDYN          (UBYTE)(((NEWSOUNDSENSORMAX - NEWSOUNDSENSORMIN) * 100L)/AD_MAX)

module HalInputP {
  provides {
    interface HalInput;
  }
  uses {
    interface HplInput;
    interface Boot;
  }
  
}
implementation {
	enum
	{
		POWER         = 0x00,
		NO_POWER      = 0x01,
		ACTIVE        = 0x02,
		ALWAYS_ACTIVE = 0x04,
		DIGI_0_HIGH   = 0x08,
		DIGI_1_HIGH   = 0x10,
		CUSTOM_SETUP  = 0x20
	};

	static const UBYTE ActiveList[NO_OF_SENSOR_TYPES] =
	{
		NO_POWER,                                     /* NO_SENSOR        */
		NO_POWER,                                     /* SWITCH           */
		NO_POWER,                                     /* TEMPERATURE      */
		ACTIVE,                                       /* REFLECTION       */
		ACTIVE,                                       /* ANGLE            */
		DIGI_0_HIGH,                                  /* LIGHT_ACTIVE     */
		POWER,                                        /* LIGHT_INACTIVE   */
		DIGI_0_HIGH,                                  /* SOUND_DB         */
		DIGI_1_HIGH,                                  /* SOUND_DBA        */
		CUSTOM_SETUP,                                 /* CUSTOM           */
		DIGI_0_HIGH | DIGI_1_HIGH,                    /* LOWSPEED         */
		ALWAYS_ACTIVE | DIGI_0_HIGH | DIGI_1_HIGH     /* LOWSPEED_9V on   */

	};

	IOMAPINPUT   IOMapInput;
	VARSINPUT    VarsInput;

//	const     HEADER       cInput =
//	{
//		0x00030001L,
//		"Input",
//		cInputInit,
//		cInputCtrl,
//		cInputExit,
//		(void *)&IOMapInput,
//		(void *)&VarsInput,
//		(UWORD)sizeof(IOMapInput),
//		(UWORD)sizeof(VarsInput),
//		0x0000                      //Code size - not used so far
//	};

	void      cInputCalcSensorRaw(UWORD *pRaw, UBYTE Type, UBYTE No);
	void      cInputCalcFullScale(UWORD *pRawVal, UWORD ZeroPointOffset, UBYTE PctFullScale, UBYTE InvState);
	void      cInputCalcSensorValue(UWORD *pRaw, UBYTE Slope, UBYTE Mode, UBYTE Tmp);
	void      cInputCalcSensor(UBYTE Tmp);
	void      cInputSetupType(UBYTE Port);
	void      cInputSetupCustomSensor(UBYTE Port);

  command void HalInput.nothing(){}
  void cInputInit();
  
  event void Boot.booted() {
	  cInputInit();
  }
  
	//void      cInputInit(void* pHeader)
	void      cInputInit()
	{
		UBYTE   Tmp;

		/* Init IO map */
		for (Tmp = 0; Tmp < NO_OF_INPUTS; Tmp++)
		{
			IOMapInput.Inputs[Tmp].SensorType         = NO_SENSOR;
			IOMapInput.Inputs[Tmp].SensorMode         = RAWMODE;
			IOMapInput.Inputs[Tmp].SensorRaw          = 0;
			IOMapInput.Inputs[Tmp].SensorValue        = 0;
			IOMapInput.Inputs[Tmp].SensorBoolean      = 0;
			IOMapInput.Inputs[Tmp].InvalidData        = INVALID_DATA;
			IOMapInput.Inputs[Tmp].DigiPinsDir        = 0;
			IOMapInput.Inputs[Tmp].DigiPinsOut        = 0;
			IOMapInput.Inputs[Tmp].CustomActiveStatus = CUSTOMINACTIVE;
			IOMapInput.Inputs[Tmp].CustomZeroOffset   = 0;
			IOMapInput.Inputs[Tmp].CustomPctFullScale = 0;
			call HplInput.dInputRead0(Tmp, &(IOMapInput.Inputs[Tmp].DigiPinsIn));
			call HplInput.dInputRead1(Tmp, &(IOMapInput.Inputs[Tmp].DigiPinsIn));

			VarsInput.EdgeCnt[Tmp]       = 0;
			VarsInput.InputDebounce[Tmp] = 0;
			VarsInput.LastAngle[Tmp]     = 0;
			VarsInput.SampleCnt[Tmp]     = 0;
			VarsInput.InvalidTimer[Tmp]  = INVALID_RELOAD_NORMAL;
			VarsInput.OldSensorType[Tmp] = NO_SENSOR;
		}
		call HplInput.dInputInit();
	}

	void      cInputCtrl()
	{
		UBYTE   Tmp;

		for (Tmp = 0; Tmp < NO_OF_INPUTS; Tmp++)
		{

			if ((IOMapInput.Inputs[Tmp].SensorType) != (VarsInput.OldSensorType[Tmp]))
			{

				/* Clear all variables for this sensor */
				VarsInput.EdgeCnt[Tmp]       = 0;
				VarsInput.InputDebounce[Tmp] = 0;
				VarsInput.LastAngle[Tmp]     = 0;
				VarsInput.SampleCnt[Tmp]     = 0;

				/* Has the type change any influence on pin setup? */
				if ((ActiveList[IOMapInput.Inputs[Tmp].SensorType]) != (ActiveList[VarsInput.OldSensorType[Tmp]]))
				{

					/* The type change has influence on pin setup - therefore a delay is inserted    */
					/* to ensure valid data representation (delay is: time for data to get down into */
					/* the avr + delay before ad conversion + time for data to get up to the ARM     */
					/* processor                                                                     */
					if ((SOUND_DB == IOMapInput.Inputs[Tmp].SensorType) || (SOUND_DBA == IOMapInput.Inputs[Tmp].SensorType))
					{

						/* Sound Sensors have a long hardware stabilizing time */
						VarsInput.InvalidTimer[Tmp] = INVALID_RELOAD_SOUND;
					}
					else
					{
						VarsInput.InvalidTimer[Tmp] = INVALID_RELOAD_NORMAL;
					}

					/* Setup the pins for the new sensortype */
					cInputSetupType(Tmp);
					IOMapInput.Inputs[Tmp].InvalidData  = INVALID_DATA;
				}
				VarsInput.OldSensorType[Tmp] = IOMapInput.Inputs[Tmp].SensorType;
			}
			else
			{
				if (VarsInput.InvalidTimer[Tmp])
				{

					/* A type change has bee carried out earlier - waiting for valid data   */
					(VarsInput.InvalidTimer[Tmp])--;
					if (0 == VarsInput.InvalidTimer[Tmp])
					{

						/* Time elapsed - data are now valid */
						IOMapInput.Inputs[Tmp].InvalidData &= ~INVALID_DATA;
					}
				}
				else
				{

					/* The invalid bit could have been set by the VM due to Mode change    */
					/* but input module needs to be called once to update the values       */
					IOMapInput.Inputs[Tmp].InvalidData &= ~INVALID_DATA;
				}
			}

			if (!(INVALID_DATA & (IOMapInput.Inputs[Tmp].InvalidData)))
			{
				cInputCalcSensor(Tmp);
			}
		}
	}


	void      cInputCalcSensor(UBYTE Tmp)
	{
		UWORD   InputRaw;

		/* Get the RCX hardware compensated AD values put values in     */
		/* InputRaw array                                               */
		call HplInput.dInputGetRawAd(&InputRaw, Tmp);
		IOMapInput.Inputs[Tmp].ADRaw = InputRaw;

		/* Calculate the sensor hardware compensated AD values and put then */
		/* in IOMapInput.Inputs[Tmp].SensorRaw                              */
		cInputCalcSensorRaw(&InputRaw, IOMapInput.Inputs[Tmp].SensorType, Tmp);

		/* Calculate the sensor value compensated for sensor mode and put   */
		/* them in IOMapInput.Inputs[Tmp].SensorValue                       */
		cInputCalcSensorValue( &InputRaw,
													((IOMapInput.Inputs[Tmp].SensorMode) & SLOPEMASK),
													((IOMapInput.Inputs[Tmp].SensorMode) & MODEMASK),
														Tmp);

	}



	void      cInputCalcSensorValue(UWORD *pRaw, UBYTE Slope, UBYTE Mode, UBYTE Tmp)
	{
		SWORD   Delta;
		UBYTE   PresentBoolean;
		UBYTE   Sample;

		if (0 == Slope)
		{

			/* This is absolute measure method */
			if (*pRaw > THRESHOLD_FALSE)
			{
				PresentBoolean = FALSE;
			}
			else
			{
				if (*pRaw < THRESHOLD_TRUE)
				{
					PresentBoolean = TRUE;
				}
			}
		}
		else
		{

			/* This is dynamic measure method */
			if (*pRaw > (ACTUAL_AD_RES - Slope))
			{
				PresentBoolean = FALSE;
			}
			else
			{
				if (*pRaw < Slope)
				{
					PresentBoolean = TRUE;
				}
				else
				{
					Delta = IOMapInput.Inputs[Tmp].SensorRaw - *pRaw;
					if (Delta < 0)
					{
						if (-Delta > Slope)
						{
							PresentBoolean = FALSE;
						}
					}
					else
					{
						if (Delta > Slope)
						{
							PresentBoolean = TRUE;
						}
					}
				}
			}
		}
		IOMapInput.Inputs[Tmp].SensorRaw = *pRaw;

		switch(Mode)
		{

			case RAWMODE:
			{
				IOMapInput.Inputs[Tmp].SensorValue   = *pRaw;
			}
			break;

			case BOOLEANMODE:
			{
				IOMapInput.Inputs[Tmp].SensorValue    = PresentBoolean;
			}
			break;

			case TRANSITIONCNTMODE:
			{
				if (VarsInput.InputDebounce[Tmp] > 0)
				{
					VarsInput.InputDebounce[Tmp]--;
				}
				else
				{
					if (IOMapInput.Inputs[Tmp].SensorBoolean != PresentBoolean)
					{
						VarsInput.InputDebounce[Tmp] = DEBOUNCERELOAD;
						(IOMapInput.Inputs[Tmp].SensorValue)++;
					}
				}
			}
			break;

			case PERIODCOUNTERMODE:
			{
				if (VarsInput.InputDebounce[Tmp] > 0)
				{
					VarsInput.InputDebounce[Tmp]--;
				}
				else
				{
					if (IOMapInput.Inputs[Tmp].SensorBoolean != PresentBoolean)
					{
						VarsInput.InputDebounce[Tmp] = DEBOUNCERELOAD;
						IOMapInput.Inputs[Tmp].SensorBoolean = PresentBoolean;
						if (++VarsInput.EdgeCnt[Tmp] > 1)
						{
							if (PresentBoolean == 0)
							{
								VarsInput.EdgeCnt[Tmp] = 0;
								(IOMapInput.Inputs[Tmp].SensorValue)++;
							}
						}
					}
				}
			}
			break;

			case PCTFULLSCALEMODE:
			{

				/* Output is 0-100 pct */
				IOMapInput.Inputs[Tmp].SensorValue   = ((*pRaw) * 100)/SENSOR_RESOLUTION;
			}
			break;

			case FAHRENHEITMODE:
			{

				/* Fahrenheit mode goes from -40 to 158 degrees */
				IOMapInput.Inputs[Tmp].SensorValue   = (((ULONG)(*pRaw) * 900L)/SENSOR_RESOLUTION) - 200;
				IOMapInput.Inputs[Tmp].SensorValue   =  ((180L * (ULONG)(IOMapInput.Inputs[Tmp].SensorValue))/100L) + 320;
			}
			break;

			case CELSIUSMODE:
			{

				/* Celsius mode goes from -20 to 70 degrees */
				IOMapInput.Inputs[Tmp].SensorValue   = (((ULONG)(*pRaw) * 900L)/SENSOR_RESOLUTION) - 200;
			}
			break;

			case ANGLESTEPSMODE:
			{
				IOMapInput.Inputs[Tmp].SensorBoolean = PresentBoolean;

				if (*pRaw < ANGLELIMITA)
				{
					Sample = 0;
				}
				else
				{
					if (*pRaw < ANGLELIMITB)
					{
						Sample = 1;
					}
					else
					{
						if (*pRaw < ANGLELIMITC)
						{
							Sample = 2;
						}
						else
						{
							Sample = 3;
						}
					}
				}

				switch (VarsInput.LastAngle[Tmp])
				{
					case 0 :
					{
						if (Sample == 1)
						{
							if (VarsInput.SampleCnt[Tmp] >= ROT_SLOW_SPEED )
							{

								if (++(VarsInput.SampleCnt[Tmp]) >= (ROT_SLOW_SPEED + ROT_OV_SAMPLING))
								{
									(IOMapInput.Inputs[Tmp].SensorValue)++;
									VarsInput.LastAngle[Tmp] = Sample;
								}
							}
							else
							{
								(IOMapInput.Inputs[Tmp].SensorValue)++;
								VarsInput.LastAngle[Tmp] = Sample;
							}
						}
						if (Sample == 2)
						{
							(IOMapInput.Inputs[Tmp].SensorValue)--;
							VarsInput.LastAngle[Tmp] = Sample;
						}
						if (Sample == 0)
						{
							if (VarsInput.SampleCnt[Tmp] < ROT_SLOW_SPEED)
							{
								(VarsInput.SampleCnt[Tmp])++;
							}
						}
					}
					break;
					case 1 :
					{
						if (Sample == 3)
						{
							(IOMapInput.Inputs[Tmp].SensorValue)++;
							VarsInput.LastAngle[Tmp] = Sample;
						}
						if (Sample == 0)
						{
							(IOMapInput.Inputs[Tmp].SensorValue)--;
							VarsInput.LastAngle[Tmp] = Sample;
						}
						VarsInput.SampleCnt[Tmp] = 0;
					}
					break;
					case 2 :
					{
						if (Sample == 0)
						{
							(IOMapInput.Inputs[Tmp].SensorValue)++;
							VarsInput.LastAngle[Tmp] = Sample;
						}
						if (Sample == 3)
						{
							(IOMapInput.Inputs[Tmp].SensorValue)--;
							VarsInput.LastAngle[Tmp] = Sample;
						}
						VarsInput.SampleCnt[Tmp] = 0;
					}
					break;
					case 3 :
					{
						if (Sample == 2)
						{
							if (VarsInput.SampleCnt[Tmp] >= ROT_SLOW_SPEED)
							{

								if (++(VarsInput.SampleCnt[Tmp]) >= (ROT_SLOW_SPEED + ROT_OV_SAMPLING))
								{
									(IOMapInput.Inputs[Tmp].SensorValue)++;
									VarsInput.LastAngle[Tmp] = Sample;
								}
							}
							else
							{
								(IOMapInput.Inputs[Tmp].SensorValue)++;
								VarsInput.LastAngle[Tmp] = Sample;
							}
						}
						if (Sample == 1)
						{
							(IOMapInput.Inputs[Tmp].SensorValue)--;
							 VarsInput.LastAngle[Tmp] = Sample;
						}
						if (Sample == 3)
						{
							if (VarsInput.SampleCnt[Tmp] < ROT_SLOW_SPEED)
							{
								(VarsInput.SampleCnt[Tmp])++;
							}
						}
					}
					break;
				}
			}
		}

		IOMapInput.Inputs[Tmp].SensorBoolean  = PresentBoolean;
	}


	const SWORD TempConvTable[] =
	{
		1500, 1460, 1430, 1400, 1380, 1360, 1330, 1310, 1290, 1270, 1250, 1230, 1220, 1200, 1190, 1170,
		1160, 1150, 1140, 1130, 1110, 1100, 1090, 1080, 1070, 1060, 1050, 1040, 1030, 1020, 1010, 1000,
		 994,  988,  982,  974,  968,  960,  954,  946,  940,  932,  926,  918,  912,  906,  900,  894,
		 890,  884,  878,  874,  868,  864,  858,  854,  848,  844,  838,  832,  828,  822,  816,  812,
		 808,  802,  798,  794,  790,  786,  782,  780,  776,  772,  768,  764,  762,  758,  754,  750,
		 748,  744,  740,  736,  732,  730,  726,  722,  718,  716,  712,  708,  704,  700,  696,  694,
		 690,  688,  684,  682,  678,  674,  672,  668,  666,  662,  660,  656,  654,  650,  648,  644,
		 642,  640,  638,  634,  632,  630,  628,  624,  622,  620,  616,  614,  612,  610,  608,  604,
		 602,  600,  598,  596,  592,  590,  588,  586,  584,  582,  580,  578,  576,  574,  572,  570,
		 568,  564,  562,  560,  558,  556,  554,  552,  550,  548,  546,  544,  542,  540,  538,  536,
		 534,  532,  530,  528,  526,  524,  522,  520,  518,  516,  514,  512,  510,  508,  508,  506,
		 504,  502,  500,  498,  496,  494,  494,  492,  490,  488,  486,  486,  484,  482,  480,  478,
		 476,  476,  474,  472,  470,  468,  468,  466,  464,  462,  460,  458,  458,  456,  454,  452,
		 450,  448,  448,  446,  444,  442,  442,  440,  438,  436,  436,  434,  432,  432,  430,  428,
		 426,  426,  424,  422,  420,  420,  418,  416,  416,  414,  412,  410,  408,  408,  406,  404,
		 404,  402,  400,  398,  398,  396,  394,  394,  392,  390,  390,  388,  386,  386,  384,  382,
		 382,  380,  378,  378,  376,  374,  374,  372,  370,  370,  368,  366,  366,  364,  362,  362,
		 360,  358,  358,  356,  354,  354,  352,  350,  350,  348,  348,  346,  344,  344,  342,  340,
		 340,  338,  338,  336,  334,  334,  332,  332,  330,  328,  328,  326,  326,  324,  322,  322,
		 320,  320,  318,  316,  316,  314,  314,  312,  310,  310,  308,  308,  306,  304,  304,  302,
		 300,  300,  298,  298,  296,  296,  294,  292,  292,  290,  290,  288,  286,  286,  284,  284,
		 282,  282,  280,  280,  278,  278,  276,  274,  274,  272,  272,  270,  270,  268,  268,  266,
		 264,  264,  262,  262,  260,  260,  258,  258,  256,  254,  254,  252,  252,  250,  250,  248,
		 248,  246,  244,  244,  242,  240,  240,  240,  238,  238,  236,  236,  234,  234,  232,  230,
		 230,  228,  228,  226,  226,  224,  224,  222,  220,  220,  218,  218,  216,  216,  214,  214,
		 212,  212,  210,  210,  208,  208,  206,  204,  204,  202,  202,  200,  200,  198,  198,  196,
		 196,  194,  194,  192,  190,  190,  188,  188,  186,  186,  184,  184,  182,  182,  180,  180,
		 178,  178,  176,  176,  174,  174,  172,  172,  170,  170,  168,  168,  166,  166,  164,  164,
		 162,  162,  160,  160,  158,  156,  156,  154,  154,  152,  152,  150,  150,  148,  148,  146,
		 146,  144,  144,  142,  142,  140,  140,  138,  136,  136,  136,  134,  134,  132,  130,  130,
		 128,  128,  126,  126,  124,  124,  122,  122,  120,  120,  118,  118,  116,  116,  114,  114,
		 112,  110,  110,  108,  108,  106,  106,  104,  104,  102,  102,  100,  100,  98,  98,  96,
		 94,  94,  92,  92,  90,  90,  88,  88,  86,  86,  84,  82,  82,  80,  80,  78,
		 78,  76,  76,  74,  74,  72,  72,  70,  70,  68,  68,  66,  66,  64,  62,  62,
		 60,  60,  58,  56,  56,  54,  54,  52,  52,  50,  50,  48,  48,  46,  46,  44,
		 44,  42,  40,  40,  38,  38,  36,  34,  34,  32,  32,  30,  30,  28,  28,  26,
		 24,  24,  22,  22,  20,  20,  18,  16,  16,  14,  14,  12,  12,  10,  10,  8,
		 6,  6,  4,  2,  2,  0,  0,  -2,  -4,  -4,  -6,  -6,  -8,  -10,  -10,  -12,
		 -12,  -14,  -16,  -16,  -18,  -20,  -20,  -22,  -22,  -24,  -26,  -26,  -28,  -30,  -30,  -32,
		 -34,  -34,  -36,  -36,  -38,  -40,  -40,  -42,  -42,  -44,  -46,  -46,  -48,  -50,  -50,  -52,
		 -54,  -54,  -56,  -58,  -58,  -60,  -60,  -62,  -64,  -66,  -66,  -68,  -70,  -70,  -72,  -74,
		 -76,  -76,  -78,  -80,  -80,  -82,  -84,  -86,  -86,  -88,  -90,  -90,  -92,  -94,  -94,  -96,
		 -98,  -98,  -100,  -102,  -104,  -106,  -106,  -108,  -110,  -112,  -114,  -114,  -116,  -118,  -120,  -120,
		 -122,  -124,  -126,  -128,  -130,  -130,  -132,  -134,  -136,  -138,  -140,  -142,  -144,  -146,  -146,  -148,
		 -150,  -152,  -154,  -156,  -158,  -160,  -162,  -164,  -166,  -166,  -168,  -170,  -172,  -174,  -176,  -178,
		 -180,  -182,  -184,  -186,  -188,  -190,  -192,  -194,  -196,  -196,  -198,  -200,  -202,  -204,  -206,  -208,
		 -210,  -212,  -214,  -216,  -218,  -220,  -224,  -226,  -228,  -230,  -232,  -234,  -236,  -238,  -242,  -246,
		 -248,  -250,  -254,  -256,  -260,  -262,  -264,  -268,  -270,  -274,  -276,  -278,  -282,  -284,  -286,  -290,
		 -292,  -296,  -298,  -300,  -306,  -308,  -312,  -316,  -320,  -324,  -326,  -330,  -334,  -338,  -342,  -344,
		 -348,  -354,  -358,  -362,  -366,  -370,  -376,  -380,  -384,  -388,  -394,  -398,  -404,  -410,  -416,  -420,
		 -428,  -432,  -440,  -446,  -450,  -460,  -468,  -476,  -484,  -492,  -500,  -510,  -524,  -534,  -546,  -560,
		 -572,  -588,  -600,  -630,  -656,  -684,  -720,  -770
	};


	void      cInputCalcSensorRaw(UWORD *pRaw, UBYTE Type, UBYTE No)
	{

		switch (Type)
		{
			case SWITCH:
			{
			}
			break;
			case TEMPERATURE:
			{
				if (*pRaw < 290)
				{
					*pRaw = 290;
				}
				else
				{
					if (*pRaw > 928)
					{
						*pRaw = 928;
					}
				}
				*pRaw = TempConvTable[(*pRaw) - 197];
				*pRaw = *pRaw + 200;
				*pRaw = (UWORD)(((SLONG)*pRaw * (SLONG)1023)/(SLONG)900);
			}
			break;
			case REFLECTION:
			{

				/* Sensor dynanmic is restricted by a double diode connected to ground,  */
				/* and it cannot go to the top either, dynamic is approx. 390 - 900 count*/
				 cInputCalcFullScale(pRaw, REFLECTIONSENSORMIN, REFLECTIONSENSORPCTDYN, TRUE);
			}
			break;
			case ANGLE:
			{
			}
			break;
			case LIGHT_ACTIVE:
			{
				cInputCalcFullScale(pRaw, NEWLIGHTSENSORMIN, NEWLIGHTSENSORPCTDYN, TRUE);
			}
			break;
			case LIGHT_INACTIVE:
			{
				cInputCalcFullScale(pRaw, NEWLIGHTSENSORMIN, NEWLIGHTSENSORPCTDYN, TRUE);
			}
			break;
			case SOUND_DB:
			{
				cInputCalcFullScale(pRaw, NEWSOUNDSENSORMIN, NEWSOUNDSENSORPCTDYN, TRUE);
			}
			break;
			case SOUND_DBA:
			{
				cInputCalcFullScale(pRaw, NEWSOUNDSENSORMIN, NEWSOUNDSENSORPCTDYN, TRUE);
			}
			break;
			case LOWSPEED:
			{
				/* Intended empty Low Speed module takes over     */
			}
			break;
			case HIGHSPEED:
			{
			}
			break;
			case CUSTOM:
			{

				/* Setup and read digital IO */
				cInputSetupCustomSensor(No);
				call HplInput.dInputRead0(No, &(IOMapInput.Inputs[No].DigiPinsIn));
				call HplInput.dInputRead1(No, &(IOMapInput.Inputs[No].DigiPinsIn));
				cInputCalcFullScale(pRaw, IOMapInput.Inputs[No].CustomZeroOffset, IOMapInput.Inputs[No].CustomPctFullScale, FALSE);
			}
			break;
			case NO_SENSOR:
			{
			}
			break;
			default:
			{
			}
			break;
		}
	}

	void      cInputCalcFullScale(UWORD *pRawVal, UWORD ZeroPointOffset, UBYTE PctFullScale, UBYTE InvStatus)
	{
		if (*pRawVal >= ZeroPointOffset)
		{
			*pRawVal -= ZeroPointOffset;
		}
		else
		{
			*pRawVal = 0;
		}

		*pRawVal = (*pRawVal * 100)/PctFullScale;
		if (*pRawVal > SENSOR_RESOLUTION)
		{
			*pRawVal = SENSOR_RESOLUTION;
		}
		if (TRUE == InvStatus)
		{
			*pRawVal = SENSOR_RESOLUTION - *pRawVal;
		}
	}

	void      cInputSetupType(UBYTE Port)
	{
		UBYTE   Setup;

		Setup = (ActiveList[IOMapInput.Inputs[Port].SensorType]);

		if (CUSTOM_SETUP & Setup)
		{
			cInputSetupCustomSensor(Port);
		}
		else
		{
			if (NO_POWER & Setup)
			{

				/* Setup is not used - set pins in unconfigured state */
				call HplInput.dInputSetInactive(Port);
				call HplInput.dInputSetDirInDigi0(Port);
				call HplInput.dInputSetDirInDigi1(Port);
			}
			else
			{
				if (ACTIVE & Setup)
				{
					call HplInput.dInputSetActive(Port);
				}
				else
				{
					if(ALWAYS_ACTIVE & Setup)
					{
						call HplInput.dInputSet9v(Port);
					}
					else
					{
						call HplInput.dInputSetInactive(Port);
					}
				}
				if (DIGI_0_HIGH & Setup)
				{
					call HplInput.dInputSetDigi0(Port);
					call HplInput.dInputSetDirOutDigi0(Port);
				}
				else
				{
					call HplInput.dInputClearDigi0(Port);
					call HplInput.dInputSetDirOutDigi0(Port);
				}

				if (DIGI_1_HIGH & Setup)
				{
					call HplInput.dInputSetDigi1(Port);
					call HplInput.dInputSetDirOutDigi1(Port);
				}
				else
				{
					call HplInput.dInputClearDigi1(Port);
					call HplInput.dInputSetDirOutDigi1(Port);
				}
			}
		}
	}

	void      cInputSetupCustomSensor(UBYTE Port)
	{
		if ((IOMapInput.Inputs[Port].DigiPinsDir) & 0x01)
		{
			if ((IOMapInput.Inputs[Port].DigiPinsOut) & 0x01)
			{
				call HplInput.dInputSetDigi0(Port);
			}
			else
			{
				call HplInput.dInputClearDigi0(Port);
			}
			call HplInput.dInputSetDirOutDigi0(Port);
		}
		if ((IOMapInput.Inputs[Port].DigiPinsDir) & 0x02)
		{
			if ((IOMapInput.Inputs[Port].DigiPinsOut) & 0x02)
			{
				call HplInput.dInputSetDigi1(Port);
			}
			else
			{
				call HplInput.dInputClearDigi1(Port);
			}
			call HplInput.dInputSetDirOutDigi1(Port);
		}
		else
		{
			call HplInput.dInputSetDirInDigi1(Port);
		}

		if (CUSTOMACTIVE == (IOMapInput.Inputs[Port].CustomActiveStatus))
		{
			call HplInput.dInputSetActive(Port);
		}
		else
		{
			if (CUSTOM9V == (IOMapInput.Inputs[Port].CustomActiveStatus))
			{
				call HplInput.dInputSet9v(Port);
			}
			else
			{
				call HplInput.dInputSetInactive(Port);
			}
		}
	}

	void      cInputExit()
	{
		call HplInput.dInputExit();
	}

}
