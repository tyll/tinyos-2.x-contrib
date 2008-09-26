#ifndef MKTIME_C_INCLUDE
#define MKTIME_C_INCLUDE

#ifdef MKTIME_TEST
#include <stdint.h>
#include <time.h>
#endif

#define YEAR0                   1900
#define EPOCH_YR                1970
#define SECS_DAY                (24L * 60L * 60L)
#define LEAPYEAR(year)          (!((year) % 4) && (((year) % 100) || !((year) % 400)))
#define YEARSIZE(year)          (LEAPYEAR(year) ? 366 : 365)

#define TIME_MAX                2147483647L

//int _daylight = 0;                  // Non-zero if daylight savings time is used
//long _dstbias = 0;                  // Offset for Daylight Saving Time


/*const char *_days[] = 
{
  "Sunday", "Monday", "Tuesday", "Wednesday",
  "Thursday", "Friday", "Saturday"
};*/

/*const char *_days_abbrev[] = 
{
  "Sun", "Mon", "Tue", "Wed", 
  "Thu", "Fri", "Sat"
};*/

/*const char *_months[] = 
{
  "January", "February", "March",
  "April", "May", "June",
  "July", "August", "September",
  "October", "November", "December"
};*/

/*const char *_months_abbrev[] = 
{
  "Jan", "Feb", "Mar",
  "Apr", "May", "Jun",
  "Jul", "Aug", "Sep",
  "Oct", "Nov", "Dec"
};*/

const int _ytab[2][12] = 
{
  {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31},
  {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
};



uint32_t my_mktime(uint16_t yr, uint16_t mo, uint16_t dy, uint16_t hr, uint16_t min, uint16_t sec)
{
  int32_t day, year;
  int32_t tm_year;
  int32_t yday, month;
  uint32_t seconds;
  int32_t overflow;
  int32_t dst;
  
  
  
  min += sec / 60;
  sec = sec % 60;
  
  hr += min / 60;
  min = min % 60;
  
  day = hr / 24;
  hr= hr % 24;
  
  yr += mo / 12;
  mo = mo % 12;
  
 
  day += (dy - 1);
  while (day < 0) 
  {
    if(--mo < 0) 
    {
      yr--;
      mo = 11;
    }
    day += _ytab[LEAPYEAR(YEAR0 + yr)][mo];
  }
  while (day >= _ytab[LEAPYEAR(YEAR0 + yr)][mo]) 
  {
    day -= _ytab[LEAPYEAR(YEAR0 + yr)][mo];
    if (++(mo) == 12) 
    {
      mo = 0;
      yr++;
    }
  }
  dy = day + 1;
  year = EPOCH_YR;
  if (yr < year - YEAR0) return 0;
  seconds = 0;
  day = 0;                      // Means days since day 0 now
  overflow = 0;

  // Assume that when day becomes negative, there will certainly
  // be overflow on seconds.
  // The check for overflow needs not to be done for leapyears
  // divisible by 400.
  // The code only works when year (1970) is not a leapyear.
  tm_year = yr + YEAR0;

  if (TIME_MAX / 365 < tm_year - year) overflow++;
  day = (tm_year - year) * 365;
  if (TIME_MAX - day < (tm_year - year) / 4 + 1) overflow++;
  day += (tm_year - year) / 4 + ((tm_year % 4) && tm_year % 4 < year % 4);
  day -= (tm_year - year) / 100 + ((tm_year % 100) && tm_year % 100 < year % 100);
  day += (tm_year - year) / 400 + ((tm_year % 400) && tm_year % 400 < year % 400);

  yday = month = 0;
  while (month < mo)
  {
    yday += _ytab[LEAPYEAR(tm_year)][month];
    month++;
  }
  yday += (dy - 1);
  if (day + yday < 0) overflow++;
  day += yday;

  //tmbuf->tm_yday = yday;
  //tmbuf->tm_wday = (day + 4) % 7;               // Day 0 was thursday (4)

  seconds = ((hr * 60L) + min) * 60L + sec;

  if ((TIME_MAX - seconds) / SECS_DAY < day) overflow++;
  seconds += day * SECS_DAY;

  // Now adjust according to timezone and daylight saving time
  /*if (((_timezone > 0) && (TIME_MAX - _timezone < seconds))
      || ((_timezone < 0) && (seconds < -_timezone)))
          overflow++;
  seconds += _timezone;
*/
  dst = 0;

  if (dst > seconds) overflow++;        // dst is always non-negative
  seconds -= dst;

  if (overflow) return 0;

  if ((uint32_t) seconds != seconds) return 0;
  return seconds;
}


uint32_t tl_mktime(uint16_t yr, uint16_t mo, uint16_t dy, uint16_t hr, uint16_t min, uint16_t sec)
{
	//translates from real values.
	if (yr < 2008 || yr > 2100) return 0;
	if (mo < 1 || mo > 12) return 0;
	if (dy < 1 || dy > 31) return 0;
	if (hr > 25) return 0;
	if (min > 61) return 0;
	if (sec > 61) return 0;
	return my_mktime(yr-1900, mo-1, dy, hr, min, sec);
}

#ifdef MKTIME_TEST
int main(int argc, char **argv)
{
	uint32_t mt;
	time_t my_t;
	struct tm *mytm;
	
	my_t = time(NULL);
	mytm = gmtime(&my_t);
    printf("%s\n %u secs since the Epoch(%u)\n",asctime(mytm),(uint32_t)my_t, sizeof(time_t));
                  
	printf("(mktime)%u secs since the Epoch\n",mktime(mytm));

	printf("calling my_mktime(%u,%u,%u,%u,%u,%u);\n",mytm->tm_year, mytm->tm_mon, mytm->tm_mday, mytm->tm_hour, mytm->tm_min, mytm->tm_sec);
	
	mt = my_mktime(mytm->tm_year, mytm->tm_mon, mytm->tm_mday, mytm->tm_hour, mytm->tm_min, mytm->tm_sec);
	printf("my unix time %u secs since the Epoch\n", (uint32_t)mt);
	
	printf("difference = %d\n", mt-my_t);
	return(0);
}
#endif


#endif
