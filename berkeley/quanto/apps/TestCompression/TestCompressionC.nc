#define SIZE 100
#include "BitBuffer.h"
module TestCompressionC {
    uses interface Boot;
    uses interface MoveToFront;
    uses interface BitBuffer;
    uses interface EliasGamma;
    uses interface EliasDelta;
    uses interface Leds;
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
   uint32_t biglist[8] = {
      1001u, 10002u, 100003u, 1000004u, 10000005u, 100000006u, 1000000007u, 2200000000u
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

    error_t testBigElias() {
        uint32_t d;
        int i;
        bitBuf* buf = call BitBuffer.getBuffer();
        call BitBuffer.clear();
        dbg_clear("TC", "encoding biglist: ");
        for (i = 0; i < 8; i++) {
            dbg_clear("TC", "%u ", biglist[i]);
            call EliasGamma.encode32(buf, biglist[i]);
        }  
        dbg_clear("TC", "\ndecoding biglist: ");
        for (i = 0; i < 8; i++) {
            d = call EliasGamma.decode32(buf); 
            dbg_clear("TC", "%u ", d);
        }
        d = call EliasGamma.decode32(buf);
        return (d == 0)? SUCCESS:FAIL;
    }

    
    error_t testEliasDelta()
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
            bits = call EliasDelta.encode16(buf, t);
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
            t = call EliasDelta.decode16(buf) - 1;
            dbg_clear("TC", "%4d", t);
        }
        dbg_clear("TC","\n");
 
        //Encode clist. Assumes testMTF has been called already
        call BitBuffer.clear();
        for (i = 0; i < SIZE; i++) {
            t = clist[i] + 1; //can't encode 0
            bits = call EliasDelta.encode16(buf, t);
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
            t = call EliasDelta.decode16(buf) - 1;
            dbg_clear("TC", "%4d", t);
        }
        dbg_clear("TC","\n");
        return (errors)?FAIL:SUCCESS;
    }

    error_t testBigEliasDelta() {
        uint32_t d;
        int i;
        bitBuf* buf = call BitBuffer.getBuffer();
        call BitBuffer.clear();
        dbg_clear("TC", "encoding biglist: ");
        for (i = 0; i < 8; i++) {
            dbg_clear("TC", "%u ", biglist[i]);
            call EliasDelta.encode32(buf, biglist[i]);
        }  
        dbg_clear("TC", "\ndecoding biglist: ");
        for (i = 0; i < 8; i++) {
            d = call EliasDelta.decode32(buf); 
            dbg_clear("TC", "%u ", d);
        }
        d = call EliasDelta.decode32(buf);
        return (d == 0)? SUCCESS:FAIL;
    }




    event void Boot.booted()
    {
        error_t r;
        dbg("TC", "TestCompressionC Booted\n");
        r = testMoveToFront();
        if (r == SUCCESS) call Leds.led1On();
        else call Leds.set(1);
        dbg("TC", "testMoveToFront() %s\n" , (r == SUCCESS)?"ok":"failed");

        r = testEliasGamma();
        if (r == SUCCESS) call Leds.led1On();
        else call Leds.set(2);
        dbg("TC", "testEliasGamma() %s\n" , (r == SUCCESS)?"ok":"failed");

        r = testBigElias();
        if (r == SUCCESS) call Leds.led1On();
        else call Leds.set(3);
        dbg("TC", "testBigElias() %s\n" , (r == SUCCESS)?"ok":"failed");

        r = testEliasDelta();
        if (r == SUCCESS) call Leds.led1On();
        else call Leds.set(4);
        dbg("TC", "testEliasDelta() %s\n" , (r == SUCCESS)?"ok":"failed");

        r = testBigEliasDelta();
        if (r == SUCCESS) call Leds.led1On();
        else call Leds.set(5);
        dbg("TC", "testBigEliasDelta() %s\n" , (r == SUCCESS)?"ok":"failed");

    }
}
