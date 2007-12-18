#ifndef C_INPUT_H
#define C_INPUT_H


//// c_input.h ////
#define   ACTUAL_AD_RES                 1023L
#define   SENSOR_RESOLUTION             1023L
#define   DEBOUNCERELOAD                100
#define   THRESHOLD_FALSE               (UWORD)(ACTUAL_AD_RES * 45L / 100L)
#define   THRESHOLD_TRUE                (UWORD)(ACTUAL_AD_RES * 55L / 100L)

#define   ANGLELIMITA                   (UWORD)(ACTUAL_AD_RES * 4400L / 10000L)
#define   ANGLELIMITB                   (UWORD)(ACTUAL_AD_RES * 6600L / 10000L)
#define   ANGLELIMITC                   (UWORD)(ACTUAL_AD_RES * 8900L / 10000L)

#define   FWDDIR                        1
#define   RWDDIR                        2
#define   MAXSAMPLECNT                  5

typedef   struct
{
  UWORD   InvalidTimer[NO_OF_INPUTS];
  UBYTE   InputDebounce[NO_OF_INPUTS];
  UBYTE   EdgeCnt[NO_OF_INPUTS];
  UBYTE   LastAngle[NO_OF_INPUTS];
  UBYTE   OldSensorType[NO_OF_INPUTS];
  UBYTE   SampleCnt[NO_OF_INPUTS];
}VARSINPUT;

#endif
