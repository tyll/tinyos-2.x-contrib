/*
* Copyright (c) 2007 #### RWTH Aachen Universtiy ####.
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
* - Neither the name of #### RWTH Aachen University ####  nor the names of
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
*
* @author Muhammad Hamad Alizai <hamad.alizai@rwth-aachen.de>
*/


public class SourceLine{

public String lineNum;
public String inFunction;
public double numOfCycles;
public SourceLine nextLine;



public static double[] cc = new double[115];
public static String[] op = new String[115];


static{

op[0] = "add";
cc[0]	= 1;

op[1] = "adc";
cc[1] = 1;

op[2] = "adiw";
cc[2] = 2;

op[3] = "sub";
cc[3] = 1;


op[4] = "subi";
cc[4] = 1;

op[5] = "sbc";
cc[5] = 1;


op[6] = "sbci";
cc[6] = 1;

op[7] = "sbiw";
cc[7] = 2;

op[8] = "and";
cc[8] = 1;

op[9] = "andi";
cc[9] = 1;

op[10] = "or";
cc[10] = 1;

op[11] = "ori";
cc[11] = 1;

op[12] = "eor";
cc[12] = 1;

op[13] = "com";
cc[13] = 1;

op[14] = "neg";
cc[14] = 1;

op[15] = "sbr";
cc[15] = 1;

op[16] = "cbr";
cc[16] = 1;

op[17] = "inc";
cc[17] = 1;

op[18] = "dec";
cc[18] = 1;

op[19] = "tst";
cc[19] = 1;

op[20] = "clr";
cc[20] = 1;

op[21] = "ser";
cc[21] = 1;

op[22] = "mul";
cc[22] = 2;

op[23] = "muls";
cc[23] = 2;

op[24] = "mulsu";
cc[24] = 2;

op[25] = "fmul";
cc[25] = 2;


op[26] = "fmuls";
cc[26] = 2;

op[27] = "fmulsu";
cc[27] = 2;

op[28] = "rjmp";
cc[28] = 2;

op[29] = "ijmp";
cc[29] = 2;

op[30] = "eijmp";
cc[30] = 2;

op[31] = "jmp";
cc[31] = 3;

op[32] = "rcall";
cc[32] = 3;

op[33] = "icall";
cc[33] = 3;

op[34] = "eicall";
cc[34] = 4;

op[35] = "call";
cc[35] = 4;

op[36] = "ret";
cc[36] = 4;

op[37] = "reti";
cc[37] = 4;

op[38] = "cpse";
cc[38] = 1;

op[39] = "cp";
cc[39] = 1;

op[40] = "cpc";
cc[40] = 1;

op[41] = "cpi";
cc[41] = 1;

op[42] = "sbrc";
cc[42] = 1;

op[43] = "sbrs";
cc[43] = 1;

op[44] = "sbic";
cc[44] = 1;

op[45] = "sbis";
cc[45] = 1;

op[46] = "brbs";
cc[46] = 1;

op[47] = "brbc";
cc[47] = 1;

op[48] = "breq";
cc[48] = 1;

op[49] = "brne";
cc[49] = 1;

op[50] = "brcs";
cc[50] = 1;

op[51] = "brcc";
cc[51] = 1;

op[52] = "brsh";
cc[52] = 1;

op[53] = "brlo";
cc[53] = 1;

op[54] = "brmi";
cc[54] = 1;

op[55] = "brmi";
cc[55] = 1.5;

op[56] = "brpl";
cc[56] = 1;

op[57] = "brge";
cc[57] = 1;


op[58] = "brlt";
cc[58] = 1;

op[59] = "brhs";
cc[59] = 1;

op[60] = "brhc";
cc[60] = 1;

op[61] = "brts";
cc[61] = 1;


op[62] = "brtc";
cc[62] = 1;

op[63] = "brvs";
cc[63] = 1;

op[64] = "brvc";
cc[64] = 1;

op[65] = "brie";
cc[65] = 1;

op[66] = "brid";
cc[66] = 1;

op[67] = "mov";
cc[67] = 1;

op[68] = "mov";
cc[68] = 1;

op[69] = "movw";
cc[69] = 1;

op[70] = "ldi";
cc[70] = 1;

op[71] = "lds";
cc[71] = 2;

op[72] = "ld";
cc[72] = 2;

op[73] = "ldd";
cc[73] = 2;

op[74] = "sts";
cc[74] = 2;

op[75] = "st";
cc[75] = 2;

op[76] = "std";
cc[76] = 2;


op[77] = "lpm";
cc[77] = 3;

op[78] = "elpm";
cc[78] = 3;

op[79] = "spm";
cc[79] = 0;

op[80] = "in";
cc[80] = 1;

op[81] = "out";
cc[81] = 1;

op[82] = "push";
cc[82] = 2;

op[83] = "pop";
cc[83] = 2;

op[84] = "lsl";
cc[84] = 1;

op[85] = "lsr";
cc[85] = 1;

op[86] = "rol";
cc[86] = 1;

op[87] = "asr";
cc[87] = 1;

op[88] = "swap";
cc[88] = 1;

op[89] = "bset";
cc[89] = 1;

op[90] = "bclr";
cc[90] = 1;

op[91] = "sbi";
cc[91] = 2;

op[92] = "cbi";
cc[92] = 2;

op[93] = "bst";
cc[93] = 1;

op[94] = "bld";
cc[94] = 1;

op[95] = "sec";
cc[95] = 1;

op[96] = "clc";
cc[96] = 1;

op[97] = "sen";
cc[97] = 1;

op[98] = "cln";
cc[98] = 1;

op[99] = "sez";
cc[99] = 1;

op[100] = "clz";
cc[100] = 1;

op[101] = "sei";
cc[101] = 1;

op[102] = "cli";
cc[102] = 1;

op[103] = "ses";
cc[103] = 1;

op[104] = "cls";
cc[104] = 1;

op[105] = "sev";
cc[105] = 1;

op[106] = "clv";
cc[106] = 1;

op[107] = "set";
cc[107] = 1;

op[108] = "clt";
cc[108] = 1;

op[109] = "seh";
cc[109] = 1;

op[110] = "clh";
cc[110] = 1;

op[111] = "break";
cc[111] = 1;

op[112] = "nop";
cc[112] = 1;

op[113] = "sleep";
cc[113] = 1;

op[114] = "wdr";
cc[114] = 1;
}



}
