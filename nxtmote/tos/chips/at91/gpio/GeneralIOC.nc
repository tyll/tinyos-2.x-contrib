configuration GeneralIOC 
{
  provides {
    interface GeneralIO[uint8_t pin];
    interface GpioInterrupt[uint8_t pin]; //TODO: Implement
    interface HalAT91GpioInterrupt[uint8_t pin];
  }
}

implementation 
{
  components HalAT91_GeneralIOM;
  components HplAT91_GPIOC;

  GeneralIO = HalAT91_GeneralIOM;
  HalAT91GpioInterrupt = HalAT91_GeneralIOM;
  GpioInterrupt = HalAT91_GeneralIOM;

  HalAT91_GeneralIOM.HplAT91_GPIOPin -> HplAT91_GPIOC;

}
