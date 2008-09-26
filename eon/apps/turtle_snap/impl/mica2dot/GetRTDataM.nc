includes structs;

module GetRTDataM
{
  provides
  {
    interface StdControl;
    interface IGetRTData;
  }
}
implementation
{
#include "fluxconst.h"

  command result_t StdControl.init ()
  {
    return SUCCESS;
  }

  command result_t StdControl.start ()
  {
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    return SUCCESS;
  }

  command bool IGetRTData.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  command result_t IGetRTData.nodeCall (GetRTData_in ** in,
					GetRTData_out ** out)
  {
//PUT NODE IMPLEMENTATION HERE

//Done signal can be moved if node makes split phase calls.
    signal IGetRTData.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}


/*

Solar Energy Harvested (Hourly)                 1 bytes/X
Energy Consumed (Hourly)                        1 bytes/X
Average Path Energy (Hourly or Daily?)          1 bytes/path/X

# of paths depends on whether or not the DTN code is in there.  With it there are around 40 paths.  Without it around 15-20.

Path Frequencies                                1 byte / path/ X
Connectivity (Beacons heard)                    4 bytes / turtle met / X
Battery Voltage                                 1 byte / X
Battery State (remaining energy)                1 byte / X
EFlux system state. (energy state and %)        2 bytes / X
Temperature (Hourly average, or based)          1 byte / X (or 1 byte/change)

*/

