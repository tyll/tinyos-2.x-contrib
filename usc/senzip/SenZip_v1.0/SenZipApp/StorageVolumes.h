#ifndef STORAGE_VOLUMES_H
#define STORAGE_VOLUMES_H

enum {
  VOLUME_BLOCKTEST, 
};

#endif
#if defined(VS)
VS(VOLUME_BLOCKTEST, 1024)
#undef VS
#endif
#if defined(VB)
VB(VOLUME_BLOCKTEST, 0)
#undef VB
#endif
