configuration PlatformLedsC
{
  provides interface GeneralIO as Led0;
  provides interface GeneralIO as Led1;
  provides interface GeneralIO as Led2;
  uses interface Init;
}
implementation  {
  
  components new NoPinC();
  components PlatformP;

  Init = PlatformP.LedsInit;

  Led0 = NoPinC;
  Led1 = NoPinC;
  Led2 = NoPinC;
}
