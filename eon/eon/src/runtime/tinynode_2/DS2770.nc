

includes DS2770;


interface DS2770
{


  command error_t init ();

  command error_t getData (int16_t * voltage, 
  					int32_t * current,	//in 0.00001 mA
				  int16_t * acr,	//in .25mAh
				  int16_t * temperature);



}
