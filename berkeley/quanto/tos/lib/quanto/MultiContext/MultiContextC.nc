#include "MultiContext.h"
generic configuration MultiContextC(uint8_t global_res_id) {
    provides interface MultiContext;
}
implementation {
    enum { LOCAL_ID = unique(MULTI_CONTEXT_UNIQUE) };
   
    components MultiContextG, MultiContextImplP;
    
    MultiContext = MultiContextG.MultiContext[global_res_id];
    
    MultiContextG.MultiContextLocal[global_res_id] -> 
                MultiContextImplP.MultiContext[LOCAL_ID];
    MultiContextG.MultiContextTrackLocal[global_res_id] ->
                MultiContextImplP.MultiContextTrack[LOCAL_ID];
}
