/*
* Copyright (c) 2010 Centre for Electronics Design and Technology (CEDT),
*  Indian Institute of Science (IISc) and Laboratory for Cryptologic
*  Algorithms (LACAL), Ecole Polytechnique Federale de Lausanne (EPFL).
*
* Author: Sylvain Pelissier <sylvain.pelissier@gmail.com>
*
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* - Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the
*   distribution.
* - Neither the name of INSERT_AFFILIATION_NAME_HERE nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
*	Implementation of the trivium interface for 16-bit and 8-bit
*	microcontrollers.
*/

#include "trivium.h"

module triviumC{
	provides interface trivium;
}

implementation{

	command void trivium.key_init(uint_t *s1,uint_t *s2, uint_t *s3, uint8_t *K, uint8_t *IV){
   		int_t i;
        uint_t s12,s22,s32,t1,t2,t3,temp;

        #ifdef SIXTEEN_BIT_MICROCONTROLLER
        for (i = 0; i < 2*KEYLENGTH; i+=2){
            s1[i/2] = (uint_t) K[2*KEYLENGTH-i-1] << 8 | (uint_t) K[2*KEYLENGTH-i-2];
        }
        for (i = 0; i < 2*IVLENGTH; i+=2){
            s2[i/2] = (uint_t) IV[2*IVLENGTH-i-1] << 8 | (uint_t) IV[2*IVLENGTH-i-2];
        }
        s1[KEYLENGTH] = 0;
        #endif

        #ifdef EIGHT_BIT_MICROCONTROLLER
        for (i = 0; i < KEYLENGTH; ++i){
            s1[i] = K[KEYLENGTH-i-1] ;
        }
        for (i = 0; i < IVLENGTH; ++i){
            s2[i] = IV[IVLENGTH-i-1];
        }
        s1[KEYLENGTH] = 0;
        s1[KEYLENGTH+1] = 0;
        #endif

        s2[IVLENGTH]  = 0;

        for (i = 0; i < 112/WORD; ++i){
            s3[i] = 0;
        }

        #ifdef EIGHT_BIT_MICROCONTROLLER
        s3[112/WORD-1] = 0x0e;
        #endif

        #ifdef SIXTEEN_BIT_MICROCONTROLLER
        s3[112/WORD-1] = 0x000e;
        #endif

        for(i=0;i<18;i++){

            #ifndef SIXTEEN_BIT_MICROCONTROLLER
            s12 = XOR(S1_66_1 , S1_93_1);
       	 	s22 = XOR(S2_69_1, S2_84_1);
        	s32 = XOR(S3_66_1, S3_111_1);
        	t1 = XOR(AND(S3_109_1, S3_110_1), S1_69_1);
        	t1 = XOR(t1, s32);
        	t2 = XOR(AND(S1_91_1, S1_92_1), S2_78_1);
        	t2 = XOR(t2, s12);
        	t3 = XOR(AND(S2_82_1, S2_83_1), S3_87_1);
        	t3 = XOR(t3, s22);
        	s1[11] = t1;
        	s2[10] = t2;
        	s3[13] = t3;

        	s12 = XOR(S1_66_2 , S1_93_2);
        	s22 = XOR(S2_69_2, S2_84_2);
        	s32 = XOR(S3_66_2, S3_111_2);
        	t1 = XOR(AND(S3_109_2, S3_110_2), S1_69_2);
        	t1 = XOR(t1, s32);
        	t2 = XOR(AND(S1_91_2, S1_92_2), S2_78_2);
        	t2 = XOR(t2, s12);
        	t3 = XOR(AND(S2_82_2, S2_83_2), S3_87_2);
        	t3 = XOR(t3, s22);
        	s1[10] = t1;
        	s2[9] = t2;
        	s3[12] = t3;

        	s12 = XOR(S1_66_3 , S1_93_3);
        	s22 = XOR(S2_69_3, S2_84_3);
        	s32 = XOR(S3_66_3, S3_111_3);
        	t1 = XOR(AND(S3_109_3, S3_110_3), S1_69_3);
        	t1 = XOR(t1, s32);
        	t2 = XOR(AND(S1_91_3, S1_92_3), S2_78_3);
        	t2 = XOR(t2, s12);
        	t3 = XOR(AND(S2_82_3, S2_83_3), S3_87_3);
        	t3 = XOR(t3, s22);
        	s1[9] = t1;
        	s2[8] = t2;
        	s3[11] = t3;

        	s12 = XOR(S1_66_4 , S1_93_4);
        	s22 = XOR(S2_69_4, S2_84_4);
        	s32 = XOR(S3_66_4, S3_111_4);
        	t1 = XOR(AND(S3_109_4, S3_110_4), S1_69_4);
        	t1 = XOR(t1, s32);
        	t2 = XOR(AND(S1_91_4, S1_92_4), S2_78_4);
        	t2 = XOR(t2, s12);
        	t3 = XOR(AND(S2_82_4, S2_83_4), S3_87_4);
        	t3 = XOR(t3, s22);
        	s1[8] = t1;
        	s2[7] = t2;
        	s3[10] = t3;

        	s12 = XOR(S1_66_5, S1_93_5);
        	s22 = XOR(S2_69_5, S2_84_5);
        	s32 = XOR(S3_66_5, S3_111_5);
        	t1 = XOR(AND(S3_109_5, S3_110_5), S1_69_5);
        	t1 = XOR(t1, s32);
        	t2 = XOR(AND(S1_91_5, S1_92_5), S2_78_5);
        	t2 = XOR(t2, s12);
        	t3 = XOR(AND(S2_82_5, S2_83_5), S3_87_5);
        	t3 = XOR(t3, s22);
        	s1[7] = t1;
        	s2[6] = t2;
        	s3[9] = t3;

        	s12 = XOR(S1_66_6 , S1_93_6);
        	s22 = XOR(S2_69_6, S2_84_6);
        	s32 = XOR(S3_66_6, S3_111_6);
        	t1 = XOR(AND(S3_109_6, S3_110_6), S1_69_6);
        	t1 = XOR(t1, s32);
        	t2 = XOR(AND(S1_91_6, S1_92_6), S2_78_6);
        	t2 = XOR(t2, s12);
        	t3 = XOR(AND(S2_82_6, S2_83_6), S3_87_6);
        	t3 = XOR(t3, s22);
  			s1[6] = t1;
        	s2[5] = t2;
        	s3[8] = t3;

        	s12 = XOR(S1_66_7 , S1_93_7);
        	s22 = XOR(S2_69_7, S2_84_7);
        	s32 = XOR(S3_66_7, S3_111_7);
        	t1 = XOR(AND(S3_109_7, S3_110_7), S1_69_7);
        	t1 = XOR(t1, s32);
        	t2 = XOR(AND(S1_91_7, S1_92_7), S2_78_7);
        	t2 = XOR(t2, s12);
        	t3 = XOR(AND(S2_82_7, S2_83_7), S3_87_7);
        	t3 = XOR(t3, s22);
 			s1[5] = t1;
        	s2[4] = t2;
        	s3[7] = t3;

        	s12 = XOR(S1_66_8 , S1_93_8);
        	s22 = XOR(S2_69_8, S2_84_8);
        	s32 = XOR(S3_66_8, S3_111_8);
        	t1 = XOR(AND(S3_109_8, S3_110_8), S1_69_8);
        	t1 = XOR(t1, s32);
        	t2 = XOR(AND(S1_91_8, S1_92_8), S2_78_8);
        	t2 = XOR(t2, s12);
        	t3 = XOR(AND(S2_82_8, S2_83_8), S3_87_8);
        	t3 = XOR(t3, s22);
        	s1[4] = t1;
        	s2[3] = t2;
        	s3[6] = t3;

            temp=s1[3];
            s1[3] = s1[7];
            s1[7] = s1[11];
            s1[11]= temp;

            temp=s1[2];
            s1[2] = s1[6];
            s1[6] = s1[10];
            s1[10]= temp;

            temp=s1[1];
            s1[1] = s1[5];
            s1[5] = s1[9];
            s1[9] = temp;

            temp=s1[0];
            s1[0] = s1[4];
            s1[4] = s1[8];
            s1[8] = temp;

            temp = s2[3];
            s2[3] = s2[6];
            s2[6] = s2[9];
            s2[9] = s2[1];
            s2[1] = s2[4];
            s2[4] = s2[7];
            s2[7] = s2[10];
            s2[10]= s2[2];
            s2[2] = s2[5];
            s2[5] = s2[8];
            s2[8] = s2[0];
            s2[0] = temp;

            temp = s3[1];
            s3[1] = s3[7];
            s3[7] = s3[13];
            s3[13]= s3[5];
            s3[5] = s3[11];
            s3[11]= s3[3];
            s3[3] = s3[9];
            s3[9] = temp;

            temp = s3[6];
            s3[6] = s3[12];
            s3[12]= s3[4];
            s3[4] = s3[10];
            s3[10]= s3[2];
            s3[2] = s3[8];
            s3[8] = s3[0];
			s3[0] = temp;

            #else
            s12 = XOR(S1_66_1 , S1_93_1);
       	 	s22 = XOR(S2_69_1, S2_84_1);
        	s32 = XOR(S3_66_1, S3_111_1);
        	t1 = XOR(AND(S3_109_1, S3_110_1), S1_69_1);
        	t1 = XOR(t1, s32);
        	t2 = XOR(AND(S1_91_1, S1_92_1), S2_78_1);
        	t2 = XOR(t2, s12);
        	t3 = XOR(AND(S2_82_1, S2_83_1), S3_87_1);
        	t3 = XOR(t3, s22);
        	s1[5] = t1;
        	s2[5] = t2;
        	s3[6] = t3;

        	s12 = XOR(S1_66_2 , S1_93_2);
        	s22 = XOR(S2_69_2, S2_84_2);
        	s32 = XOR(S3_66_2, S3_111_2);
        	t1 = XOR(AND(S3_109_2, S3_110_2), S1_69_2);
        	t1 = XOR(t1, s32);
        	t2 = XOR(AND(S1_91_2, S1_92_2), S2_78_2);
        	t2 = XOR(t2, s12);
        	t3 = XOR(AND(S2_82_2, S2_83_2), S3_87_2);
        	t3 = XOR(t3, s22);
        	s1[4] = t1;
        	s2[4] = t2;
        	s3[5] = t3;

        	s12 = XOR(S1_66_3 , S1_93_3);
        	s22 = XOR(S2_69_3, S2_84_3);
        	s32 = XOR(S3_66_3, S3_111_3);
        	t1 = XOR(AND(S3_109_3, S3_110_3), S1_69_3);
        	t1 = XOR(t1, s32);
        	t2 = XOR(AND(S1_91_3, S1_92_3), S2_78_3);
        	t2 = XOR(t2, s12);
        	t3 = XOR(AND(S2_82_3, S2_83_3), S3_87_3);
        	t3 = XOR(t3, s22);
        	s1[3] = t1;
        	s2[3] = t2;
        	s3[4] = t3;

        	s12 = XOR(S1_66_4 , S1_93_4);
        	s22 = XOR(S2_69_4, S2_84_4);
        	s32 = XOR(S3_66_4, S3_111_4);
        	t1 = XOR(AND(S3_109_4, S3_110_4), S1_69_4);
        	t1 = XOR(t1, s32);
        	t2 = XOR(AND(S1_91_4, S1_92_4), S2_78_4);
        	t2 = XOR(t2, s12);
        	t3 = XOR(AND(S2_82_4, S2_83_4), S3_87_4);
        	t3 = XOR(t3, s22);
        	s1[2] = t1;
        	s2[2] = t2;
        	s3[3] = t3;

            temp = s1[3];
            s1[3] = s1[5];
            s1[5] = s1[1];
            s1[1] = temp;

            temp = s1[2];
            s1[2] = s1[4];
            s1[4] = s1[0];
            s1[0] = temp;

            temp = s2[3];
            s2[3] = s2[5];
            s2[5] = s2[1];
            s2[1] = temp;

            temp = s2[2];
            s2[2] = s2[4];
            s2[4] = s2[0];
            s2[0] = temp;

            temp = s3[3];
            s3[3] = s3[6];
            s3[6] = s3[2];
            s3[2] = s3[5];
            s3[5] = s3[1];
            s3[1] = s3[4];
            s3[4] = s3[0];
            s3[0] = temp;
            #endif
        }
}

	command void trivium.gen_keystream(uint_t *s1,uint_t *s2, uint_t *s3,uint_t *z){
        uint_t s12,s22,s32;
        uint_t t1,t2,t3;
        uint_t temp;

        #ifndef SIXTEEN_BIT_MICROCONTROLLER
       	s12 = XOR(S1_66_1 , S1_93_1);
       	s22 = XOR(S2_69_1, S2_84_1);
       	s32 = XOR(S3_66_1, S3_111_1);
        z[0] = XOR(XOR(s12, s22), s32);
      	t1 = XOR(AND(S3_109_1, S3_110_1), S1_69_1);
      	t1 = XOR(t1, s32);
       	t2 = XOR(AND(S1_91_1, S1_92_1), S2_78_1);
       	t2 = XOR(t2, s12);
       	t3 = XOR(AND(S2_82_1, S2_83_1), S3_87_1);
       	t3 = XOR(t3, s22);
       	s1[11] = t1;
       	s2[10] = t2;
       	s3[13] = t3;

       	s12 = XOR(S1_66_2 , S1_93_2);
       	s22 = XOR(S2_69_2, S2_84_2);
        s32 = XOR(S3_66_2, S3_111_2);
        z[1] = XOR(XOR(s12, s22), s32);
       	t1 = XOR(AND(S3_109_2, S3_110_2), S1_69_2);
       	t1 = XOR(t1, s32);
       	t2 = XOR(AND(S1_91_2, S1_92_2), S2_78_2);
       	t2 = XOR(t2, s12);
       	t3 = XOR(AND(S2_82_2, S2_83_2), S3_87_2);
       	t3 = XOR(t3, s22);
       	s1[10] = t1;
       	s2[9] = t2;
       	s3[12] = t3;

       	s12 = XOR(S1_66_3 , S1_93_3);
       	s22 = XOR(S2_69_3, S2_84_3);
       	s32 = XOR(S3_66_3, S3_111_3);
       	z[2] = XOR(XOR(s12, s22), s32);
       	t1 = XOR(AND(S3_109_3, S3_110_3), S1_69_3);
       	t1 = XOR(t1, s32);
       	t2 = XOR(AND(S1_91_3, S1_92_3), S2_78_3);
       	t2 = XOR(t2, s12);
       	t3 = XOR(AND(S2_82_3, S2_83_3), S3_87_3);
 	  	t3 = XOR(t3, s22);
       	s1[9] = t1;
       	s2[8] = t2;
       	s3[11] = t3;

        s12 = XOR(S1_66_4 , S1_93_4);
       	s22 = XOR(S2_69_4, S2_84_4);
       	s32 = XOR(S3_66_4, S3_111_4);
       	z[3] = XOR(XOR(s12, s22), s32);
       	t1 = XOR(AND(S3_109_4, S3_110_4), S1_69_4);
       	t1 = XOR(t1, s32);
       	t2 = XOR(AND(S1_91_4, S1_92_4), S2_78_4);
       	t2 = XOR(t2, s12);
        t3 = XOR(AND(S2_82_4, S2_83_4), S3_87_4);
       	t3 = XOR(t3, s22);
       	s1[8] = t1;
       	s2[7] = t2;
       	s3[10] = t3;


       	s12 = XOR(S1_66_5, S1_93_5);
       	s22 = XOR(S2_69_5, S2_84_5);
       	s32 = XOR(S3_66_5, S3_111_5);
       	z[4] = XOR(XOR(s12, s22), s32);
        t1 = XOR(AND(S3_109_5, S3_110_5), S1_69_5);
       	t1 = XOR(t1, s32);
       	t2 = XOR(AND(S1_91_5, S1_92_5), S2_78_5);
       	t2 = XOR(t2, s12);
       	t3 = XOR(AND(S2_82_5, S2_83_5), S3_87_5);
       	t3 = XOR(t3, s22);
       	s1[7] = t1;
       	s2[6] = t2;
       	s3[9] = t3;

        s12 = XOR(S1_66_6 , S1_93_6);
       	s22 = XOR(S2_69_6, S2_84_6);
       	s32 = XOR(S3_66_6, S3_111_6);
       	z[5] = XOR(XOR(s12, s22), s32);
       	t1 = XOR(AND(S3_109_6, S3_110_6), S1_69_6);
       	t1 = XOR(t1, s32);
        t2 = XOR(AND(S1_91_6, S1_92_6), S2_78_6);
       	t2 = XOR(t2, s12);
       	t3 = XOR(AND(S2_82_6, S2_83_6), S3_87_6);
       	t3 = XOR(t3, s22);
  		s1[6] = t1;
       	s2[5] = t2;
       	s3[8] = t3;

        s12 = XOR(S1_66_7 , S1_93_7);
       	s22 = XOR(S2_69_7, S2_84_7);
       	s32 = XOR(S3_66_7, S3_111_7);
       	z[6] = XOR(XOR(s12, s22), s32);
       	t1 = XOR(AND(S3_109_7, S3_110_7), S1_69_7);
        t1 = XOR(t1, s32);
       	t2 = XOR(AND(S1_91_7, S1_92_7), S2_78_7);
       	t2 = XOR(t2, s12);
       	t3 = XOR(AND(S2_82_7, S2_83_7), S3_87_7);
       	t3 = XOR(t3, s22);
 		s1[5] = t1;
       	s2[4] = t2;
        s3[7] = t3;

       	s12 = XOR(S1_66_8 , S1_93_8);
       	s22 = XOR(S2_69_8, S2_84_8);
       	s32 = XOR(S3_66_8, S3_111_8);
     	z[7] = XOR(XOR(s12, s22), s32);
        t1 = XOR(AND(S3_109_8, S3_110_8), S1_69_8);
       	t1 = XOR(t1, s32);
       	t2 = XOR(AND(S1_91_8, S1_92_8), S2_78_8);
       	t2 = XOR(t2, s12);
       	t3 = XOR(AND(S2_82_8, S2_83_8), S3_87_8);
       	t3 = XOR(t3, s22);
       	s1[4] = t1;
       	s2[3] = t2;
       	s3[6] = t3;

        temp=s1[3];
        s1[3] = s1[7];
        s1[7] = s1[11];
        s1[11]= temp;

        temp=s1[2];
        s1[2] = s1[6];
        s1[6] = s1[10];
        s1[10]= temp;

        temp=s1[1];
        s1[1] = s1[5];
        s1[5] = s1[9];
        s1[9] = temp;

        temp=s1[0];
        s1[0] = s1[4];
        s1[4] = s1[8];
        s1[8] = temp;

        temp = s2[3];
        s2[3] = s2[6];
        s2[6] = s2[9];
        s2[9] = s2[1];
        s2[1] = s2[4];
        s2[4] = s2[7];
        s2[7] = s2[10];
        s2[10]= s2[2];
        s2[2] = s2[5];
        s2[5] = s2[8];
        s2[8] = s2[0];
        s2[0] = temp;

        temp = s3[1];
        s3[1] = s3[7];
        s3[7] = s3[13];
        s3[13]= s3[5];
        s3[5] = s3[11];
        s3[11]= s3[3];
        s3[3] = s3[9];
        s3[9] = temp;

        temp = s3[6];
        s3[6] = s3[12];
        s3[12]= s3[4];
        s3[4] = s3[10];
        s3[10]= s3[2];
        s3[2] = s3[8];
        s3[8] = s3[0];
        s3[0] = temp;

        #else
        s12 = XOR(S1_66_1 , S1_93_1);
        s22 = XOR(S2_69_1, S2_84_1);
        s32 = XOR(S3_66_1, S3_111_1);
        z[0] = XOR(XOR(s12, s22), s32);
        t1 = XOR(AND(S3_109_1, S3_110_1), S1_69_1);
        t1 = XOR(t1, s32);
        t2 = XOR(AND(S1_91_1, S1_92_1), S2_78_1);
        t2 = XOR(t2, s12);
        t3 = XOR(AND(S2_82_1, S2_83_1), S3_87_1);
        t3 = XOR(t3, s22);
        s1[5] = t1;
        s2[5] = t2;
        s3[6] = t3;

        s12 = XOR(S1_66_2 , S1_93_2);
        s22 = XOR(S2_69_2, S2_84_2);
        s32 = XOR(S3_66_2, S3_111_2);
        z[1] = XOR(XOR(s12, s22), s32);
        t1 = XOR(AND(S3_109_2, S3_110_2), S1_69_2);
        t1 = XOR(t1, s32);
        t2 = XOR(AND(S1_91_2, S1_92_2), S2_78_2);
        t2 = XOR(t2, s12);
        t3 = XOR(AND(S2_82_2, S2_83_2), S3_87_2);
        t3 = XOR(t3, s22);
        s1[4] = t1;
        s2[4] = t2;
        s3[5] = t3;

        s12 = XOR(S1_66_3 , S1_93_3);
        s22 = XOR(S2_69_3, S2_84_3);
        s32 = XOR(S3_66_3, S3_111_3);
        z[2] = XOR(XOR(s12, s22), s32);
        t1 = XOR(AND(S3_109_3, S3_110_3), S1_69_3);
        t1 = XOR(t1, s32);
        t2 = XOR(AND(S1_91_3, S1_92_3), S2_78_3);
        t2 = XOR(t2, s12);
        t3 = XOR(AND(S2_82_3, S2_83_3), S3_87_3);
        t3 = XOR(t3, s22);
        s1[3] = t1;
        s2[3] = t2;
        s3[4] = t3;

        s12 = XOR(S1_66_4 , S1_93_4);
        s22 = XOR(S2_69_4, S2_84_4);
        s32 = XOR(S3_66_4, S3_111_4);
        z[3] = XOR(XOR(s12, s22), s32);
        t1 = XOR(AND(S3_109_4, S3_110_4), S1_69_4);
        t1 = XOR(t1, s32);
        t2 = XOR(AND(S1_91_4, S1_92_4), S2_78_4);
        t2 = XOR(t2, s12);
        t3 = XOR(AND(S2_82_4, S2_83_4), S3_87_4);
        t3 = XOR(t3, s22);
        s1[2] = t1;
        s2[2] = t2;
        s3[3] = t3;

        temp = s1[3];
        s1[3] = s1[5];
        s1[5] = s1[1];
        s1[1] = temp;

        temp = s1[2];
        s1[2] = s1[4];
        s1[4] = s1[0];
        s1[0] = temp;

        temp = s2[3];
        s2[3] = s2[5];
        s2[5] = s2[1];
        s2[1] = temp;

        temp = s2[2];
        s2[2] = s2[4];
        s2[4] = s2[0];
        s2[0] = temp;

        temp = s3[3];
        s3[3] = s3[6];
        s3[6] = s3[2];
        s3[2] = s3[5];
        s3[5] = s3[1];
        s3[1] = s3[4];
        s3[4] = s3[0];
        s3[0] = temp;


        #endif
	}

    command void trivium.process_bytes(uint_t *s1,uint_t *s2, uint_t *s3,uint8_t *input, uint8_t *output, int32_t length){
        int32_t i,j;
        uint_t z[64/WORD];

        for(i=0;(length-=8) > 0;i+=8)
        {
            call trivium.gen_keystream(s1,s2,s3,z);

            #ifdef EIGHT_BIT_MICROCONTROLLER
            output[i  ] = XOR(input[i],z[0]);
            output[i+1] = XOR(input[i+1],z[1]);
            output[i+2] = XOR(input[i+2],z[2]);
            output[i+3] = XOR(input[i+3],z[3]);
            output[i+4] = XOR(input[i+4],z[4]);
            output[i+5] = XOR(input[i+5],z[5]);
            output[i+6] = XOR(input[i+6],z[6]);
            output[i+7] = XOR(input[i+7],z[7]);
            #endif

            #ifdef SIXTEEN_BIT_MICROCONTROLLER
            output[i]   = XOR(input[i] , (uint8_t)z[0]);
            output[i+1] = XOR(input[i+1],(uint8_t)(z[0]>>8));
            output[i+2] = XOR(input[i+2],(uint8_t)z[1]);
            output[i+3] = XOR(input[i+3],(uint8_t)(z[1]>>8));
            output[i+4] = XOR(input[i+4],(uint8_t)z[2]);
            output[i+5] = XOR(input[i+5],(uint8_t)(z[2]>>8));
            output[i+6] = XOR(input[i+6],(uint8_t)z[3]);
            output[i+7] = XOR(input[i+7],(uint8_t)(z[3]>>8));
            #endif

        }

        call trivium.gen_keystream(s1,s2,s3,z);

        #ifdef EIGHT_BIT_MICROCONTROLLER
        for(j=0,length+=8;length>0;i++,j++,length--)
        {
         	output[i] = XOR(input[i],z[j]);
		}
		#endif

		#ifdef SIXTEEN_BIT_MICROCONTROLLER
		for(j=0,length+=8;length>1;i+=2,j++,length-=2)
		{

			output[i] = XOR(input[i],(uint8_t)z[j]);
			output[i+1] = XOR(input[i+1],(uint8_t)(z[j]>>8));
		}

		if(length){
			output[i] = XOR(input[i],(uint8_t)z[j]);
		}

        #endif
    }
}
