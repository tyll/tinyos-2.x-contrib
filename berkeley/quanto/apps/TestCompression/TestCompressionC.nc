#define SIZE 100
#include "BitBuffer.h"
module TestCompressionC {
    uses interface Boot;
    uses interface MoveToFront;
    uses interface BitBuffer;
    uses interface EliasGamma;
}
implementation {
   uint8_t clist[SIZE];
   uint8_t list[SIZE] = {
       //100 numbers from a zipf distribution with a=1.5
       112,  51,  68, 133, 133, 239,  20,  20, 112, 239, 
       239, 239, 139,   0,  20, 223,  20, 239, 239, 223, 
       239, 239, 112,  22,   0, 239, 255,   0,  20, 244, 
       239,   0, 173, 204,  20, 239, 137,  20,  47, 253, 
       239, 112, 173,  20, 220, 204, 116, 239,  76, 239, 
       239, 112, 173, 239, 171, 173,  59, 239, 239, 187, 
       239, 173, 133, 213, 173, 204, 239, 239,  20, 239, 
       239, 239, 216,   0, 239,   0, 239, 239, 239,  20, 
       204, 109,  82, 239, 207,  82,  20, 173,  20, 112, 
       204, 133, 239, 173,  20, 239, 239,   0, 239, 173, 
   };
 
    error_t testMoveToFront() {
        int i;
        uint8_t tmp;
        bool ok = 1;
        dbg_clear("TC", "List:\n");
        for (i = 0; i < SIZE; i++) {
           dbg_clear("TC", "%4d", list[i]);
        }
        dbg_clear("TC", "\n");
        dbg_clear("TC", "MoveToFront:\n");
        call MoveToFront.init();
        for (i = 0; i < SIZE; i++) {
            clist[i] = call MoveToFront.encode(list[i]);    
            dbg_clear("TC", "%4d", clist[i]);
        }
        dbg_clear("TC", "\n");
        dbg_clear("TC", "Decoded:\n");
        call MoveToFront.init();
        for (i = 0; i < SIZE; i++) {
            tmp = call MoveToFront.decode(clist[i]);            
            ok &= (tmp == list[i]);
            dbg_clear("TC", "%4d", tmp);
        }
        dbg_clear("TC", "\n");
        return (ok?SUCCESS:FAIL);
    }
    
    error_t testEliasGamma()
    {
        uint16_t t;
        int i;
        int errors = 0;
        int bits = 0;
        int total_bits = 0;

        bitBuf* buf = call BitBuffer.getBuffer();
        //Encode list.
        call BitBuffer.clear();
        for (i = 0; i < SIZE; i++) {
            t = list[i] + 1; //can't encode 0
            bits = call EliasGamma.encode16(buf, t);
            total_bits += bits;
            if (!bits) {
                errors++;
                dbg_clear("TC", "Error encoding %d \n",t);
            }
        }
        dbg_clear("TC", "Encoded original list, %d integers, %d bits, %d errors\n",
                         i, total_bits, errors);
        bits = total_bits = 0;
        //Decode. No need to reset the buffer position, as encoding only changes
        //the writing position, not the reading position.
        for (i = 0; i < SIZE; i++) {
            t = call EliasGamma.decode16(buf) - 1;
            dbg_clear("TC", "%4d", t);
        }
        dbg_clear("TC","\n");
 
        //Encode clist. Assumes testMTF has been called already
        call BitBuffer.clear();
        for (i = 0; i < SIZE; i++) {
            t = clist[i] + 1; //can't encode 0
            bits = call EliasGamma.encode16(buf, t);
            total_bits += bits;
            if (!bits) {
                errors++;
                dbg_clear("TC", "Error encoding %d \n",t);
            }
        }
        dbg_clear("TC", "Encoded mtf list, %d integers, %d bits, %d errors\n",
                         i, total_bits, errors);
        //Decode. No need to reset the buffer position, as encoding only changes
        //the writing position, not the reading position.
        for (i = 0; i < SIZE; i++) {
            t = call EliasGamma.decode16(buf) - 1;
            dbg_clear("TC", "%4d", t);
        }
        dbg_clear("TC","\n");
        return (errors)?FAIL:SUCCESS;
    }



    event void Boot.booted()
    {
        error_t r;
        dbg("TC", "TestCompressionC Booted\n");
        r = testMoveToFront();
        if (r != SUCCESS)
            dbg("TC", "testMoveToFront() failed\n");
        else 
            dbg("TC", "testMoveToFront() ok\n");
        r = testEliasGamma();
        if (r != SUCCESS)
            dbg("TC", "testEliasGamma() failed\n");
        else
            dbg("TC", "testEliasGamma() ok\n");
    }
}
