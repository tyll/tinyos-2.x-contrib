

configuration CheckRadioC{

  provides interface CheckRadio;

}

implementation{

  components CheckRadioP;
  components HplMsp430GeneralIOC;
  
  CheckRadioP.MISO -> HplMsp430GeneralIOC.SOMI0;

  CheckRadio = CheckRadioP;


}



