

includes gps;

interface GpsFix
{
	//return the number of satelites with an SNR value higher than the provided threshold.
	//I recommend using 30 for our GPS units (both Sirf star III and the Sony ones)
	command uint8_t numSNRHigh(uint8_t threshold);
  event result_t gotFix(GpsFixPtr fix);
  event result_t gotDateTime(bool valid, char *gpsdate, char *gpstime);
}
