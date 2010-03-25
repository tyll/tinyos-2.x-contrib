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
*	Implementation of the AES interface.
*/

#include "AES.h"


module AESC{
	provides interface AES;
}

implementation{

    /**
     *  AddRoundKey function. XOR the state to the expanded key.
     *  @param state The current state of the algorithm.
     *  @param key  The expanded key.
     */
    void addRoundKey(uint8_t *state, uint8_t *key){
        uint8_t i;

        for(i = 0;i<16;i++)
        {
            state[i] ^= key[i];
        }
    }

    /*
        Internal functions for encryption.
    */

    /**
     *  Performs the three operations: SubBytes, ShiftRows and MixColumns.
     *  @param state The current state of the algorithm.
     */
    void mixSubColumns(uint8_t *state){
        uint8_t tmp[4 * Nb];

        /*
            Mixing column 0
        */
        tmp[0] = Xtime2Sbox[state[0]] ^ Xtime3Sbox[state[5]] ^ Sbox[state[10]] ^ Sbox[state[15]];
        tmp[1] = Sbox[state[0]] ^ Xtime2Sbox[state[5]] ^ Xtime3Sbox[state[10]] ^ Sbox[state[15]];
        tmp[2] = Sbox[state[0]] ^ Sbox[state[5]] ^ Xtime2Sbox[state[10]] ^ Xtime3Sbox[state[15]];
        tmp[3] = Xtime3Sbox[state[0]] ^ Sbox[state[5]] ^ Sbox[state[10]] ^ Xtime2Sbox[state[15]];

        /*
            Mixing column 1
        */
        tmp[4] = Xtime2Sbox[state[4]] ^ Xtime3Sbox[state[9]] ^ Sbox[state[14]] ^ Sbox[state[3]];
        tmp[5] = Sbox[state[4]] ^ Xtime2Sbox[state[9]] ^ Xtime3Sbox[state[14]] ^ Sbox[state[3]];
        tmp[6] = Sbox[state[4]] ^ Sbox[state[9]] ^ Xtime2Sbox[state[14]] ^ Xtime3Sbox[state[3]];
        tmp[7] = Xtime3Sbox[state[4]] ^ Sbox[state[9]] ^ Sbox[state[14]] ^ Xtime2Sbox[state[3]];

        /*
            Mixing column 2
        */
        tmp[8] = Xtime2Sbox[state[8]] ^ Xtime3Sbox[state[13]] ^ Sbox[state[2]] ^ Sbox[state[7]];
        tmp[9] = Sbox[state[8]] ^ Xtime2Sbox[state[13]] ^ Xtime3Sbox[state[2]] ^ Sbox[state[7]];
        tmp[10]  = Sbox[state[8]] ^ Sbox[state[13]] ^ Xtime2Sbox[state[2]] ^ Xtime3Sbox[state[7]];
        tmp[11]  = Xtime3Sbox[state[8]] ^ Sbox[state[13]] ^ Sbox[state[2]] ^ Xtime2Sbox[state[7]];

        /*
            Mixing column 3
        */
        tmp[12] = Xtime2Sbox[state[12]] ^ Xtime3Sbox[state[1]] ^ Sbox[state[6]] ^ Sbox[state[11]];
        tmp[13] = Sbox[state[12]] ^ Xtime2Sbox[state[1]] ^ Xtime3Sbox[state[6]] ^ Sbox[state[11]];
        tmp[14] = Sbox[state[12]] ^ Sbox[state[1]] ^ Xtime2Sbox[state[6]] ^ Xtime3Sbox[state[11]];
        tmp[15] = Xtime3Sbox[state[12]] ^ Sbox[state[1]] ^ Sbox[state[6]] ^ Xtime2Sbox[state[11]];

        state[0]  = tmp[0];
        state[1]  = tmp[1];
        state[2]  = tmp[2];
        state[3]  = tmp[3];
        state[4]  = tmp[4];
        state[5]  = tmp[5];
        state[6]  = tmp[6];
        state[7]  = tmp[7];
        state[8]  = tmp[8];
        state[9]  = tmp[9];
        state[10] = tmp[10];
        state[11] = tmp[11];
        state[12] = tmp[12];
        state[13] = tmp[13];
        state[14] = tmp[14];
        state[15] = tmp[15];

    }

    /**
     *  Performs the ShiftRows operation.
     *  @param state The current state of the algorithm.
     */
    void shiftRows(uint8_t *state){
        uint8_t tmp;

        /*
            Substitute row 0
        */
        state[0] = Sbox[state[0]], state[4] = Sbox[state[4]];
        state[8] = Sbox[state[8]], state[12] = Sbox[state[12]];

        /*
            Rotate row 1
        */
        tmp = Sbox[state[1]], state[1] = Sbox[state[5]];
        state[5] = Sbox[state[9]], state[9] = Sbox[state[13]], state[13] = tmp;

        /*
            Rotate row 2
        */
        tmp = Sbox[state[2]], state[2] = Sbox[state[10]], state[10] = tmp;
        tmp = Sbox[state[6]], state[6] = Sbox[state[14]], state[14] = tmp;

        /*
            Rotate row 3
        */
        tmp = Sbox[state[15]], state[15] = Sbox[state[11]];
        state[11] = Sbox[state[7]], state[7] = Sbox[state[3]], state[3] = tmp;
    }

    /*
        Internal functions for decryption
    */

    /**
     *   Performs the operation: InvShiftRows.
     *   @param state The current state of the algorithm.
     */
    void invShiftRows(uint8_t *state){
        uint8_t tmp;

        /*
            Restore row 0
        */
        state[0] = InvSbox[state[0]], state[4] = InvSbox[state[4]];
        state[8] = InvSbox[state[8]], state[12] = InvSbox[state[12]];

        /*
            Restore row 1
        */
        tmp = InvSbox[state[13]], state[13] = InvSbox[state[9]];
        state[9] = InvSbox[state[5]], state[5] = InvSbox[state[1]], state[1] = tmp;

        /*
            Restore row 2
        */
        tmp = InvSbox[state[2]], state[2] = InvSbox[state[10]], state[10] = tmp;
        tmp = InvSbox[state[6]], state[6] = InvSbox[state[14]], state[14] = tmp;

        /*
            Restore row 3
        */
        tmp = InvSbox[state[3]], state[3] = InvSbox[state[7]];
        state[7] = InvSbox[state[11]], state[11] = InvSbox[state[15]], state[15] = tmp;
    }

    /**
     *  Performs the three operations: InvSubBytes, InvShiftRows and InvsMixColumns.
     *  @param state The current state of the algorithm.
     */
    void invMixSubColumns (uint8_t *state)
    {
        uint8_t tmp[4 * Nb];
        uint8_t i;

        /*
            Restore column 0
        */
        tmp[0] = XtimeE[state[0]] ^ XtimeB[state[1]] ^ XtimeD[state[2]] ^ Xtime9[state[3]];
        tmp[5] = Xtime9[state[0]] ^ XtimeE[state[1]] ^ XtimeB[state[2]] ^ XtimeD[state[3]];
        tmp[10] = XtimeD[state[0]] ^ Xtime9[state[1]] ^ XtimeE[state[2]] ^ XtimeB[state[3]];
        tmp[15] = XtimeB[state[0]] ^ XtimeD[state[1]] ^ Xtime9[state[2]] ^ XtimeE[state[3]];

        /*
            Restore column 1
        */
        tmp[4] = XtimeE[state[4]] ^ XtimeB[state[5]] ^ XtimeD[state[6]] ^ Xtime9[state[7]];
        tmp[9] = Xtime9[state[4]] ^ XtimeE[state[5]] ^ XtimeB[state[6]] ^ XtimeD[state[7]];
        tmp[14] = XtimeD[state[4]] ^ Xtime9[state[5]] ^ XtimeE[state[6]] ^ XtimeB[state[7]];
        tmp[3] = XtimeB[state[4]] ^ XtimeD[state[5]] ^ Xtime9[state[6]] ^ XtimeE[state[7]];

        /*
            Restore column 2
        */
        tmp[8] = XtimeE[state[8]] ^ XtimeB[state[9]] ^ XtimeD[state[10]] ^ Xtime9[state[11]];
        tmp[13] = Xtime9[state[8]] ^ XtimeE[state[9]] ^ XtimeB[state[10]] ^ XtimeD[state[11]];
        tmp[2]  = XtimeD[state[8]] ^ Xtime9[state[9]] ^ XtimeE[state[10]] ^ XtimeB[state[11]];
        tmp[7]  = XtimeB[state[8]] ^ XtimeD[state[9]] ^ Xtime9[state[10]] ^ XtimeE[state[11]];

        /*
            Restore column 3
        */
        tmp[12] = XtimeE[state[12]] ^ XtimeB[state[13]] ^ XtimeD[state[14]] ^ Xtime9[state[15]];
        tmp[1] = Xtime9[state[12]] ^ XtimeE[state[13]] ^ XtimeB[state[14]] ^ XtimeD[state[15]];
        tmp[6] = XtimeD[state[12]] ^ Xtime9[state[13]] ^ XtimeE[state[14]] ^ XtimeB[state[15]];
        tmp[11] = XtimeB[state[12]] ^ XtimeD[state[13]] ^ Xtime9[state[14]] ^ XtimeE[state[15]];

        for( i=0; i < 4 * Nb; i++ )
        {
            state[i] = InvSbox[tmp[i]];
        }
    }

    /*
        AES module commands.
    */
	command void AES.keyExpansion(uint8_t *expkey, uint8_t *key){

        uint8_t i;
        uint8_t tmp0,tmp1,tmp2,tmp3,tmp4;

        /*
            The first bytes of the expanded key is the key itself.
        */
        for(i=0;i< KEY_SIZE ;i++)
        {
            expkey[i] = key[i];
        }

        /*
            Key schedule.
        */
        for( i = Nk; i < Nb * (NB_ROUNDS + 1); i++ )
        {
            tmp0 = expkey[4*i - 4];
            tmp1 = expkey[4*i - 3];
            tmp2 = expkey[4*i - 2];
            tmp3 = expkey[4*i - 1];

            if( !(i % Nk) ) {
                tmp4 = tmp3;
                tmp3 = Sbox[tmp0];
                tmp0 = Sbox[tmp1] ^ Rcon[i/Nk];
                tmp1 = Sbox[tmp2];
                tmp2 = Sbox[tmp4];
            }
            else if( Nk > 6 && i % Nk == 4 ) {
                tmp0 = Sbox[tmp0];
                tmp1 = Sbox[tmp1];
                tmp2 = Sbox[tmp2];
                tmp3 = Sbox[tmp3];
            }

            expkey[4*i+0] = expkey[4*i - 4*Nk + 0] ^ tmp0;
            expkey[4*i+1] = expkey[4*i - 4*Nk + 1] ^ tmp1;
            expkey[4*i+2] = expkey[4*i - 4*Nk + 2] ^ tmp2;
            expkey[4*i+3] = expkey[4*i - 4*Nk + 3] ^ tmp3;
        }
	}

    command void AES.encrypt(uint8_t *in_block, uint8_t *expkey, uint8_t *out_block){
        uint8_t state[Nb * 4];
        uint8_t i;


        /*
            State initialisation with the plaintext block.
        */
        for(i=0;i<16;i++)
        {
            state[i] = in_block[i];
        }

        addRoundKey(state,expkey);

        for(i=1;i<NB_ROUNDS+1;i++)
        {
            if( i < NB_ROUNDS )
            {
                mixSubColumns(state);
            }
            else
            {
                shiftRows(state);
            }
            addRoundKey(state,expkey+16*i);
        }

        for(i=0;i<16;i++)
        {
            out_block[i] = state[i];
        }

    }

    command void AES.decrypt(uint8_t *in_block, uint8_t *expkey, uint8_t *out_block){
        uint8_t state[Nb * 4];
        uint8_t i;

        for(i=0;i<16;i++)
        {
            state[i] = in_block[i];
        }

        addRoundKey(state,expkey + 16*NB_ROUNDS);
        invShiftRows(state);

        for( i = NB_ROUNDS; i--;)
        {
            addRoundKey (state,expkey + i * 16);
            if( i ){
                invMixSubColumns (state);
            }
        }

        for(i=0;i<16;i++)
        {
            out_block[i] = state[i];
        }
    }
}
