/*
* Copyright (c) 2009 Centre for Electronics Design and Technology (CEDT),
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

/*
*
*   Implementation of the Trivium Stream cipher designed by
*   Christophe De Cannière and Bart Preneel
*   following the implementation avalaible at
*   http://www.ecrypt.eu.org/stream/svn/viewcvs.cgi/ecrypt/trunk/submissions/trivium/
*
*   Warning of the original version:
*
*   *** WARNING ***
*
*   This implementation uses the following ordering of the key and iv
*   bits during initialization:
*
*   (s_1,s_2,...,s_93)      <- (K_80,...,K_1,0,...,0)
*   (s_94,s_95,...,s_177)   <- (IV_80,...,IV_1,0,...,0)
*   (s_178,s_279,...,s_288) <- (0,...,0,1,1,1)
*
*   This ordering is more natural than the reversed one used in the
*   original specs (as pointed out by both Paul Crowly and Tim Good).
*
*/

#ifndef TRIVIUM_H
#define TRIVIUM_H

/*
*   Compilation done for 8-bit microcontroller by default.
*/
#if ! defined(SIXTEEN_BIT_MICROCONTROLLER) && ! defined(EIGHT_BIT_MICROCONTROLLER)
#define EIGHT_BIT_MICROCONTROLLER
#endif

/*
*   16-bit definitions.
*/
#ifdef SIXTEEN_BIT_MICROCONTROLLER
#define WORD 16
#define KEYLENGTH 5
#define IVLENGTH  5
#define GEN_WORD 4

typedef uint16_t uint_t;
typedef int16_t int_t;

#endif

/*
*   8-bit definitions.
*/
#ifdef EIGHT_BIT_MICROCONTROLLER
#define WORD 8
#define KEYLENGTH 10
#define IVLENGTH  10
#define GEN_WORD 8

typedef uint8_t uint_t;
typedef int8_t int_t;

#endif

/*
 *  Boolean operations
 */
#define OR(a, b) ((a) | (b))
#define AND(a, b) ((a) & (b))
#define XOR(a, b) ((a) ^ (b))
#define SL(m, i) ((m) << (i))
#define SR(m, i) ((m) >> (i))

/*
 *  Macros to access useful bits of the internal state
 *  of the algorithm.
 */
#ifdef EIGHT_BIT_MICROCONTROLLER
#define S1_66_1  OR( SL( s1[7]  , 2 ) , SR( s1[8]  , 6))
#define S1_66_2  OR( SL( s1[6]  , 2 ) , SR( s1[7]  , 6))
#define S1_66_3  OR( SL( s1[5]  , 2 ) , SR( s1[6]  , 6))
#define S1_66_4  OR( SL( s1[4]  , 2 ) , SR( s1[5]  , 6))
#define S1_66_5  OR( SL( s1[3]  , 2 ) , SR( s1[4]  , 6))
#define S1_66_6  OR( SL( s1[2]  , 2 ) , SR( s1[3]  , 6))
#define S1_66_7  OR( SL( s1[1]  , 2 ) , SR( s1[2]  , 6))
#define S1_66_8  OR( SL( s1[0]  , 2 ) , SR( s1[1]  , 6))

#define S1_69_1  OR( SL( s1[7]  , 5 ) , SR( s1[8]  , 3))
#define S1_69_2  OR( SL( s1[6]  , 5 ) , SR( s1[7]  , 3))
#define S1_69_3  OR( SL( s1[5]  , 5 ) , SR( s1[6]  , 3))
#define S1_69_4  OR( SL( s1[4]  , 5 ) , SR( s1[5]  , 3))
#define S1_69_5  OR( SL( s1[3]  , 5 ) , SR( s1[4]  , 3))
#define S1_69_6  OR( SL( s1[2]  , 5 ) , SR( s1[3]  , 3))
#define S1_69_7  OR( SL( s1[1]  , 5 ) , SR( s1[2]  , 3))
#define S1_69_8  OR( SL( s1[0]  , 5 ) , SR( s1[1]  , 3))

#define S1_91_1  OR( SL( s1[10] , 3 ) , SR( s1[11] , 5))
#define S1_91_2  OR( SL( s1[9]  , 3 ) , SR( s1[10] , 5))
#define S1_91_3  OR( SL( s1[8]  , 3 ) , SR( s1[9]  , 5))
#define S1_91_4  OR( SL( s1[7]  , 3 ) , SR( s1[8]  , 5))
#define S1_91_5  OR( SL( s1[6]  , 3 ) , SR( s1[7]  , 5))
#define S1_91_6  OR( SL( s1[5]  , 3 ) , SR( s1[6]  , 5))
#define S1_91_7  OR( SL( s1[4]  , 3 ) , SR( s1[5]  , 5))
#define S1_91_8  OR( SL( s1[3]  , 3 ) , SR( s1[4]  , 5))

#define S1_92_1  OR( SL( s1[10] , 4 ) , SR( s1[11] , 4))
#define S1_92_2  OR( SL( s1[9] ,  4 ) , SR( s1[10] , 4))
#define S1_92_3  OR( SL( s1[8] ,  4 ) , SR( s1[9]  , 4))
#define S1_92_4  OR( SL( s1[7] ,  4 ) , SR( s1[8]  , 4))
#define S1_92_5  OR( SL( s1[6] ,  4 ) , SR( s1[7]  , 4))
#define S1_92_6  OR( SL( s1[5] ,  4 ) , SR( s1[6]  , 4))
#define S1_92_7  OR( SL( s1[4] ,  4 ) , SR( s1[5]  , 4))
#define S1_92_8  OR( SL( s1[3] ,  4 ) , SR( s1[4]  , 4))

#define S1_93_1  OR( SL( s1[10] , 5 ) , SR( s1[11]  , 3))
#define S1_93_2  OR( SL( s1[9]  , 5 ) , SR( s1[10]  , 3))
#define S1_93_3  OR( SL( s1[8]  , 5 ) , SR( s1[9]   , 3))
#define S1_93_4  OR( SL( s1[7]  , 5 ) , SR( s1[8]   , 3))
#define S1_93_5  OR( SL( s1[6] , 5 )  , SR( s1[7]   , 3))
#define S1_93_6  OR( SL( s1[5]  , 5 ) , SR( s1[6]   , 3))
#define S1_93_7  OR( SL( s1[4]  , 5 ) , SR( s1[5]   , 3))
#define S1_93_8  OR( SL( s1[3]  , 5 ) , SR( s1[4]   , 3))

#define S2_69_1  OR( SL( s2[7]  , 5 ) , SR( s2[8]   , 3))
#define S2_69_2  OR( SL( s2[6]  , 5 ) , SR( s2[7]   , 3))
#define S2_69_3  OR( SL( s2[5]  , 5 ) , SR( s2[6]   , 3))
#define S2_69_4  OR( SL( s2[4]  , 5 ) , SR( s2[5]   , 3))
#define S2_69_5  OR( SL( s2[3]  , 5 ) , SR( s2[4]   , 3))
#define S2_69_6  OR( SL( s2[2]  , 5 ) , SR( s2[3]   , 3))
#define S2_69_7  OR( SL( s2[1]  , 5 ) , SR( s2[2]   , 3))
#define S2_69_8  OR( SL( s2[0]  , 5 ) , SR( s2[1]   , 3))

#define S2_78_1  OR( SL( s2[8] , 6 ) , SR( s2[9]    , 2))
#define S2_78_2  OR( SL( s2[7] , 6 ) , SR( s2[8]    , 2))
#define S2_78_3  OR( SL( s2[6] , 6 ) , SR( s2[7]    , 2))
#define S2_78_4  OR( SL( s2[5] , 6 ) , SR( s2[6]    , 2))
#define S2_78_5  OR( SL( s2[4] , 6 ) , SR( s2[5]    , 2))
#define S2_78_6  OR( SL( s2[3] , 6 ) , SR( s2[4]    , 2))
#define S2_78_7  OR( SL( s2[2] , 6 ) , SR( s2[3]    , 2))
#define S2_78_8  OR( SL( s2[1] , 6 ) , SR( s2[2]    , 2))

#define S2_82_1  OR( SL( s2[9] , 2 ) , SR( s2[10]  , 6))
#define S2_82_2  OR( SL( s2[8] , 2 ) , SR( s2[9]   , 6))
#define S2_82_3  OR( SL( s2[7] , 2 ) , SR( s2[8]   , 6))
#define S2_82_4  OR( SL( s2[6] , 2 ) , SR( s2[7]   , 6))
#define S2_82_5  OR( SL( s2[5] , 2 ) , SR( s2[6]  , 6))
#define S2_82_6  OR( SL( s2[4] , 2 ) , SR( s2[5]   , 6))
#define S2_82_7  OR( SL( s2[3] , 2 ) , SR( s2[4]   , 6))
#define S2_82_8  OR( SL( s2[2] , 2 ) , SR( s2[3]   , 6))

#define S2_83_1  OR( SL( s2[9] , 3 ) , SR( s2[10]  , 5))
#define S2_83_2  OR( SL( s2[8] , 3 ) , SR( s2[9]   , 5))
#define S2_83_3  OR( SL( s2[7] , 3 ) , SR( s2[8]   , 5))
#define S2_83_4  OR( SL( s2[6] , 3 ) , SR( s2[7]   , 5))
#define S2_83_5  OR( SL( s2[5] , 3 ) , SR( s2[6]  , 5))
#define S2_83_6  OR( SL( s2[4] , 3 ) , SR( s2[5]   , 5))
#define S2_83_7  OR( SL( s2[3] , 3 ) , SR( s2[4]   , 5))
#define S2_83_8  OR( SL( s2[2] , 3 ) , SR( s2[3]   , 5))

#define S2_84_1  OR( SL( s2[9] , 4 ) , SR( s2[10]  , 4))
#define S2_84_2  OR( SL( s2[8] , 4 ) , SR( s2[9]   , 4))
#define S2_84_3  OR( SL( s2[7] , 4 ) , SR( s2[8]   , 4))
#define S2_84_4  OR( SL( s2[6] , 4 ) , SR( s2[7]   , 4))
#define S2_84_5  OR( SL( s2[5] , 4 ) , SR( s2[6]   , 4))
#define S2_84_6  OR( SL( s2[4] , 4 ) , SR( s2[5]   , 4))
#define S2_84_7  OR( SL( s2[3] , 4 ) , SR( s2[4]   , 4))
#define S2_84_8  OR( SL( s2[2] , 4 ) , SR( s2[3]   , 4))

#define S3_66_1  OR( SL( s3[7]  , 2 ) , SR( s3[8]   ,  6))
#define S3_66_2  OR( SL( s3[6]  , 2 ) , SR( s3[7]   ,  6))
#define S3_66_3  OR( SL( s3[5]  , 2 ) , SR( s3[6]   ,  6))
#define S3_66_4  OR( SL( s3[4]  , 2 ) , SR( s3[5]   ,  6))
#define S3_66_5  OR( SL( s3[3]  , 2 ) , SR( s3[4]   ,  6))
#define S3_66_6  OR( SL( s3[2]  , 2 ) , SR( s3[3]   ,  6))
#define S3_66_7  OR( SL( s3[1]  , 2 ) , SR( s3[2]   ,  6))
#define S3_66_8  OR( SL( s3[0]  , 2 ) , SR( s3[1]   ,  6))

#define S3_87_1  OR( SL( s3[9] , 7 ) , SR( s3[10]  , 1))
#define S3_87_2  OR( SL( s3[8] , 7 ) , SR( s3[9]   , 1))
#define S3_87_3  OR( SL( s3[7] , 7 ) , SR( s3[8]   , 1))
#define S3_87_4  OR( SL( s3[6] , 7 ) , SR( s3[7]   , 1))
#define S3_87_5  OR( SL( s3[5] , 7 ) , SR( s3[6]  , 1))
#define S3_87_6  OR( SL( s3[4] , 7 ) , SR( s3[5]   , 1))
#define S3_87_7  OR( SL( s3[3] , 7 ) , SR( s3[4]   , 1))
#define S3_87_8  OR( SL( s3[2] , 7 ) , SR( s3[3]   , 1))

#define S3_109_1 OR( SL( s3[12] , 5 ) , SR( s3[13]   , 3))
#define S3_109_2 OR( SL( s3[11] , 5 ) , SR( s3[12]   , 3))
#define S3_109_3 OR( SL( s3[10] , 5 ) , SR( s3[11]   , 3))
#define S3_109_4 OR( SL( s3[9]  , 5 ) , SR( s3[10]   , 3))
#define S3_109_5 OR( SL( s3[8] , 5 ) , SR(  s3[9]    , 3))
#define S3_109_6 OR( SL( s3[7] , 5 ) , SR(  s3[8]   , 3))
#define S3_109_7 OR( SL( s3[6] , 5 ) , SR(  s3[7]   , 3))
#define S3_109_8 OR( SL( s3[5] , 5 ) , SR( s3[6]    , 3))

#define S3_110_1 OR( SL( s3[12] , 6 ) , SR( s3[13]  , 2))
#define S3_110_2 OR( SL( s3[11] , 6 ) , SR( s3[12]  , 2))
#define S3_110_3 OR( SL( s3[10] , 6 ) , SR( s3[11]  , 2))
#define S3_110_4 OR( SL( s3[9]  , 6 ) , SR( s3[10]  , 2))
#define S3_110_5 OR( SL( s3[8] , 6 ) , SR( s3[9]  , 2))
#define S3_110_6 OR( SL( s3[7] , 6 ) , SR( s3[8]  , 2))
#define S3_110_7 OR( SL( s3[6] , 6 ) , SR( s3[7]  , 2))
#define S3_110_8 OR( SL( s3[5]  , 6 ) , SR( s3[6]  , 2))

#define S3_111_1 OR( SL( s3[12] , 7 ) , SR( s3[13]   , 1))
#define S3_111_2 OR( SL( s3[11] , 7 ) , SR( s3[12]   , 1))
#define S3_111_3 OR( SL( s3[10] , 7 ) , SR( s3[11]   , 1))
#define S3_111_4 OR( SL( s3[9]  , 7 ) , SR( s3[10]   , 1))
#define S3_111_5 OR( SL( s3[8] , 7 ) , SR( s3[9]   , 1))
#define S3_111_6 OR( SL( s3[7] , 7 ) , SR( s3[8]   , 1))
#define S3_111_7 OR( SL( s3[6] , 7 ) , SR( s3[7]   , 1))
#define S3_111_8 OR( SL( s3[5]  , 7 ) , SR( s3[6]   , 1))
#endif

#ifdef SIXTEEN_BIT_MICROCONTROLLER
#define S1_66_1  OR( SL( s1[3] ,  2) , SR( s1[4] , 14))
#define S1_66_2  OR( SL( s1[2] ,  2) , SR( s1[3] , 14))
#define S1_66_3  OR( SL( s1[1] ,  2) , SR( s1[2] , 14))
#define S1_66_4  OR( SL( s1[0] ,  2) , SR( s1[1] , 14))

#define S1_69_1  OR( SL( s1[3] ,  5) , SR( s1[4] , 11))
#define S1_69_2  OR( SL( s1[2] ,  5) , SR( s1[3] , 11))
#define S1_69_3  OR( SL( s1[1] ,  5) , SR( s1[2] , 11))
#define S1_69_4  OR( SL( s1[0] ,  5) , SR( s1[1] , 11))

#define S1_91_1  OR( SL( s1[4] , 11) , SR( s1[5] ,  5))
#define S1_91_2  OR( SL( s1[3] , 11) , SR( s1[4] ,  5))
#define S1_91_3  OR( SL( s1[2] , 11) , SR( s1[3] ,  5))
#define S1_91_4  OR( SL( s1[1] , 11) , SR( s1[2] ,  5))

#define S1_92_1  OR( SL( s1[4] , 12) , SR( s1[5] ,  4))
#define S1_92_2  OR( SL( s1[3] , 12) , SR( s1[4] ,  4))
#define S1_92_3  OR( SL( s1[2] , 12) , SR( s1[3] ,  4))
#define S1_92_4  OR( SL( s1[1] , 12) , SR( s1[2] ,  4))

#define S1_93_1  OR( SL( s1[4] , 13) , SR( s1[5] ,  3))
#define S1_93_2  OR( SL( s1[3] , 13) , SR( s1[4] ,  3))
#define S1_93_3  OR( SL( s1[2] , 13) , SR( s1[3] ,  3))
#define S1_93_4  OR( SL( s1[1] , 13) , SR( s1[2] ,  3))

#define S2_69_1  OR( SL( s2[3] ,  5) , SR( s2[4] , 11))
#define S2_69_2  OR( SL( s2[2] ,  5) , SR( s2[3] , 11))
#define S2_69_3  OR( SL( s2[1] ,  5) , SR( s2[2] , 11))
#define S2_69_4  OR( SL( s2[0] ,  5) , SR( s2[1] , 11))

#define S2_78_1  OR( SL( s2[3] , 14) , SR( s2[4] ,  2))
#define S2_78_2  OR( SL( s2[2] , 14) , SR( s2[3] ,  2))
#define S2_78_3  OR( SL( s2[1] , 14) , SR( s2[2] ,  2))
#define S2_78_4  OR( SL( s2[0] , 14) , SR( s2[1] ,  2))

#define S2_82_1  OR( SL( s2[4] , 2 ) , SR( s2[5] , 14))
#define S2_82_2  OR( SL( s2[3] , 2 ) , SR( s2[4] , 14))
#define S2_82_3  OR( SL( s2[2] , 2 ) , SR( s2[3] , 14))
#define S2_82_4  OR( SL( s2[1] , 2 ) , SR( s2[2] , 14))

#define S2_83_1  OR( SL( s2[4] , 3 ) , SR( s2[5] , 13))
#define S2_83_2  OR( SL( s2[3] , 3 ) , SR( s2[4] , 13))
#define S2_83_3  OR( SL( s2[2] , 3 ) , SR( s2[3] , 13))
#define S2_83_4  OR( SL( s2[1] , 3 ) , SR( s2[2] , 13))

#define S2_84_1  OR( SL( s2[4] , 4 ) , SR( s2[5] , 12))
#define S2_84_2  OR( SL( s2[3] , 4 ) , SR( s2[4] , 12))
#define S2_84_3  OR( SL( s2[2] , 4 ) , SR( s2[3] , 12))
#define S2_84_4  OR( SL( s2[1] , 4 ) , SR( s2[2] , 12))

#define S3_66_1  OR( SL( s3[3] , 2 ) , SR( s3[4] , 14))
#define S3_66_2  OR( SL( s3[2] , 2 ) , SR( s3[3] , 14))
#define S3_66_3  OR( SL( s3[1] , 2 ) , SR( s3[2] , 14))
#define S3_66_4  OR( SL( s3[0] , 2 ) , SR( s3[1] , 14))

#define S3_87_1  OR( SL( s3[4] , 7 ) , SR( s3[5]  , 9))
#define S3_87_2  OR( SL( s3[3] , 7 ) , SR( s3[4]  , 9))
#define S3_87_3  OR( SL( s3[2] , 7 ) , SR( s3[3]  , 9))
#define S3_87_4  OR( SL( s3[1] , 7 ) , SR( s3[2]  , 9))

#define S3_109_1 OR( SL( s3[5] , 13 ) , SR( s3[6] , 3))
#define S3_109_2 OR( SL( s3[4] , 13 ) , SR( s3[5] , 3))
#define S3_109_3 OR( SL( s3[3] , 13 ) , SR( s3[4] , 3))
#define S3_109_4 OR( SL( s3[2] , 13 ) , SR( s3[3] , 3))

#define S3_110_1 OR( SL( s3[5] , 14 ) , SR( s3[6] , 2))
#define S3_110_2 OR( SL( s3[4] , 14 ) , SR( s3[5] , 2))
#define S3_110_3 OR( SL( s3[3] , 14 ) , SR( s3[4] , 2))
#define S3_110_4 OR( SL( s3[2] , 14 ) , SR( s3[3] , 2))

#define S3_111_1 OR( SL( s3[5] , 15 ) , SR( s3[6] , 1))
#define S3_111_2 OR( SL( s3[4] , 15 ) , SR( s3[5] , 1))
#define S3_111_3 OR( SL( s3[3] , 15 ) , SR( s3[4] , 1))
#define S3_111_4 OR( SL( s3[2] , 15 ) , SR( s3[3] , 1))

#endif

#endif
