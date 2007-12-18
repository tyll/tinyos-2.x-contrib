configuration HalOutputC {
	provides {
		interface HalOutput;
	}
	uses {
	  interface Boot;
	}
}
implementation{
  components HalOutputP, HplOutputC;
  
  HalOutput = HalOutputP;
  
  Boot = HalOutputP;
  
  HalOutputP.HplOutput -> HplOutputC;
  
}
