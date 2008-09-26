

includes gps;

interface GpsFix
{
  event result_t gotFix(GpsFixPtr fix);
  event result_t gotDateTime(char *gpsdate, char *gpstime);
}
