#include "PowerState.h"
generic configuration PowerStateC(uint8_t global_res_id) {
    provides interface PowerState;
}
implementation {
    enum { LOCAL_ID = unique(POWER_STATE_UNIQUE) };
    
    components PowerStateG, PowerStateP;
    
    PowerState = PowerStateG.PowerState[global_res_id];
    
    PowerStateG.PowerStateLocal[global_res_id] ->
                PowerStateP.PowerState[LOCAL_ID];
    PowerStateG.PowerStateTrackLocal[global_res_id] ->
                PowerStateP.PowerStateTrack[LOCAL_ID];
}
