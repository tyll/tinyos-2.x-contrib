#include "SingleContext.h"
generic configuration SingleContextC(uint8_t global_res_id) {
    provides interface SingleContext;
}
implementation {
   enum { LOCAL_ID = unique(SINGLE_CONTEXT_UNIQUE) };

   components SingleContextG, SingleContextP; 

   SingleContext = SingleContextG.SingleContext[global_res_id];

   SingleContextG.SingleContextLocal[global_res_id] -> 
                  SingleContextP.SingleContext[LOCAL_ID];
   SingleContextG.SingleContextTrackLocal[global_res_id] -> 
                  SingleContextP.SingleContextTrack[LOCAL_ID];
}
