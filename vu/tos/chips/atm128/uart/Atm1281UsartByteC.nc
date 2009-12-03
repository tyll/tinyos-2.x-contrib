#include "Atm128Usart.h"

configuration Atm1281UsartByteC {
  uses {
    interface HplAtm1281Usart as Hpl;
  }

  provides {
    interface SplitControl;
    interface UsartByteReceive;
    interface UsartByteSend;
  }
}
implementation {

  components HplAtm1281UsartSetupC as SetupC, HplAtm1281UsartUtilC as UtilC, Atm1281UsartByteP as UsartByteP;

  SplitControl  = UsartByteP;
  Hpl           = UsartByteP;
  UsartByteReceive = UsartByteP;
  UsartByteSend = UsartByteP;

  UsartByteP.Setup -> SetupC;
  UsartByteP.Util -> UtilC;

  SetupC.Hpl = Hpl;
  UtilC.Hpl = Hpl;

}
