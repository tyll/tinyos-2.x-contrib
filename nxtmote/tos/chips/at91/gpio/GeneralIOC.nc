configuration GeneralIOC 
{
  provides {
    interface GeneralIO[uint8_t pin];
  }
}

implementation 
{
  components HalAT91_GeneralIOM;
  components HplAT91_GPIOC;

  GeneralIO = HalAT91_GeneralIOM;

  HalAT91_GeneralIOM.HplAT91_GPIOPin -> HplAT91_GPIOC;

}
