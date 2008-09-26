




interface DS2770
{


  async command result_t init ();

  async command result_t getData (int16_t * voltage, 
  					int32_t * current,	//in 0.00001 mA
				  int16_t * acr,	//in .25mAh
				  int16_t * temperature);



}
