#include <stdio.h>

#include "libquantocode.h"
   enum {
      SIZE = 100,
   };
   uint32_t list[100] = {
       1,  2,  3, 4, 5, 6,  20,  20, 112, 239, 
       100, 239, 139,   30,  20, 223,  20, 239, 239, 223, 
       2390, 2039, 1012,  2432,   4055, 2139, 2955,  6000, 9920, 8244, 
       24539,  550, 15573, 32204, 34120, 32239, 11137,  20,  47, 253, 
       239, 112, 173,  20, 220, 204, 116, 239,  76, 239, 
       239, 112, 173, 239, 171, 173,  59, 239, 239, 1332332187u, 
       239, 173, 133, 213, 173, 204, 239, 2093333321u,  20, 239, 
       239, 239, 216,   20, 239,  10, 239, 239, 239,  20, 
       204, 109,  82, 239, 207,  82,  20, 173,  20, 112, 
       204, 133, 239, 173,  20, 239, 239,   22, 239, 173, 
   };

enum {
 OK = 1,
 FAIL = 0,
};

int testEliasDelta() {
   int i;
   uint32_t d;
   bitBuf *buf;
   bool ok = 1;

   buf = bitBuf_new(400);
   for (i = 0; i < SIZE; i++) {
     elias_delta_encode(list[i], buf); 
   }
   for (i = 0; i < SIZE; i++) {
     d = elias_delta_decode(buf); 
     ok &= (d == list[i]);
     printf("decoded %u (should be %u)\n", d, list[i]);
   }
   return (ok)?OK:FAIL;
}

int main() {
   int r;
   r = testEliasDelta();
   printf("testEliasDelta : %s\n", (r == OK)?"ok":"fail");
   return (r == OK)?0:1;
}
