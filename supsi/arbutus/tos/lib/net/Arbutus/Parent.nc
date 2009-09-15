

#include "AM.h"

interface Parent {

 
  
command uint16_t getPreferredParent(bool forceChange);
command uint8_t getPreferredParent_hopcount();
command uint16_t getPreferredParent_csiCost();  
command uint8_t getPreferredParent_rssLinkNorm();
command uint8_t getPreferredParent_rssBtlNorm();
command uint8_t getPreferredParent_lqiLinkNorm();
command uint8_t getPreferredParent_lqiBtlNorm();
}
