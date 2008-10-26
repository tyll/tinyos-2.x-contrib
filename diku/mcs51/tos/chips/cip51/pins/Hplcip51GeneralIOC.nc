/*
 * Copyright (c) 2008 Polaric
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
 * - Neither the name of Polaric nor the names of its contributors may
 *   be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL POLARIC OR ITS CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * 
 * @author Martin Leopold <leopold@polaric.dk>
 *
 */

configuration Hplcip51GeneralIOC {
  provides interface GeneralIO as P00;
  provides interface GeneralIO as P01;
  provides interface GeneralIO as P02;
  provides interface GeneralIO as P03;
  provides interface GeneralIO as P04;
  provides interface GeneralIO as P05;
  provides interface GeneralIO as P06;
  provides interface GeneralIO as P07;

  provides interface GeneralIO as P10;
  provides interface GeneralIO as P11;
  provides interface GeneralIO as P12;
  provides interface GeneralIO as P13;
  provides interface GeneralIO as P14;
  provides interface GeneralIO as P15;
  provides interface GeneralIO as P16;
  provides interface GeneralIO as P17;

  provides interface GeneralIO as P20;
  provides interface GeneralIO as P21;
  provides interface GeneralIO as P22;
  provides interface GeneralIO as P23;
  provides interface GeneralIO as P24;
  provides interface GeneralIO as P25;
  provides interface GeneralIO as P26;
  provides interface GeneralIO as P27;

  provides interface GeneralIO as P30;
  provides interface GeneralIO as P31;
  provides interface GeneralIO as P32;
  provides interface GeneralIO as P33;
  provides interface GeneralIO as P34;
  provides interface GeneralIO as P35;
  provides interface GeneralIO as P36;
  provides interface GeneralIO as P37;

#ifdef __cip51_has_port4
  provides interface GeneralIO as P40;
  provides interface GeneralIO as P41;
  provides interface GeneralIO as P42;
  provides interface GeneralIO as P43;
  provides interface GeneralIO as P44;
  provides interface GeneralIO as P45;
  provides interface GeneralIO as P46;
  provides interface GeneralIO as P47;
#endif

   provides interface Init;
}
implementation {
  components Hplcip51IOC,
    new Hplcip51GeneralIOP() as P00_w,
    new Hplcip51GeneralIOP() as P01_w,
    new Hplcip51GeneralIOP() as P02_w,
    new Hplcip51GeneralIOP() as P03_w,
    new Hplcip51GeneralIOP() as P04_w,
    new Hplcip51GeneralIOP() as P05_w,
    new Hplcip51GeneralIOP() as P06_w,
    new Hplcip51GeneralIOP() as P07_w,

    new Hplcip51GeneralIOP() as P10_w,
    new Hplcip51GeneralIOP() as P11_w,
    new Hplcip51GeneralIOP() as P12_w,
    new Hplcip51GeneralIOP() as P13_w,
    new Hplcip51GeneralIOP() as P14_w,
    new Hplcip51GeneralIOP() as P15_w,
    new Hplcip51GeneralIOP() as P16_w,
    new Hplcip51GeneralIOP() as P17_w,

    new Hplcip51GeneralIOP() as P20_w,
    new Hplcip51GeneralIOP() as P21_w,
    new Hplcip51GeneralIOP() as P22_w,
    new Hplcip51GeneralIOP() as P23_w,
    new Hplcip51GeneralIOP() as P24_w,
    new Hplcip51GeneralIOP() as P25_w,
    new Hplcip51GeneralIOP() as P26_w,
    new Hplcip51GeneralIOP() as P27_w,

    new Hplcip51GeneralIOP() as P30_w,
    new Hplcip51GeneralIOP() as P31_w,
    new Hplcip51GeneralIOP() as P32_w,
    new Hplcip51GeneralIOP() as P33_w,
    new Hplcip51GeneralIOP() as P34_w,
    new Hplcip51GeneralIOP() as P35_w,
    new Hplcip51GeneralIOP() as P36_w,
    new Hplcip51GeneralIOP() as P37_w;
  
  P00_w.in -> Hplcip51IOC.P00; P00=P00_w.out;
  P01_w.in -> Hplcip51IOC.P01; P01=P01_w.out;
  P02_w.in -> Hplcip51IOC.P02; P02=P02_w.out;
  P03_w.in -> Hplcip51IOC.P03; P03=P03_w.out;
  P04_w.in -> Hplcip51IOC.P04; P04=P04_w.out;
  P05_w.in -> Hplcip51IOC.P05; P05=P05_w.out;
  P06_w.in -> Hplcip51IOC.P06; P06=P06_w.out;
  P07_w.in -> Hplcip51IOC.P07; P07=P07_w.out;

  P10_w.in -> Hplcip51IOC.P10; P10=P10_w.out;
  P11_w.in -> Hplcip51IOC.P11; P11=P11_w.out;
  P12_w.in -> Hplcip51IOC.P12; P12=P12_w.out;
  P13_w.in -> Hplcip51IOC.P13; P13=P13_w.out;
  P14_w.in -> Hplcip51IOC.P14; P14=P14_w.out;
  P15_w.in -> Hplcip51IOC.P15; P15=P15_w.out;
  P16_w.in -> Hplcip51IOC.P16; P16=P16_w.out;
  P17_w.in -> Hplcip51IOC.P17; P17=P17_w.out;

  P20_w.in -> Hplcip51IOC.P20; P20=P20_w.out;
  P21_w.in -> Hplcip51IOC.P21; P21=P21_w.out;
  P22_w.in -> Hplcip51IOC.P22; P22=P22_w.out;
  P23_w.in -> Hplcip51IOC.P23; P23=P23_w.out;
  P24_w.in -> Hplcip51IOC.P24; P24=P24_w.out;
  P25_w.in -> Hplcip51IOC.P25; P25=P25_w.out;
  P26_w.in -> Hplcip51IOC.P26; P26=P26_w.out;
  P27_w.in -> Hplcip51IOC.P27; P27=P27_w.out;

  P30_w.in -> Hplcip51IOC.P30; P30=P30_w.out;
  P31_w.in -> Hplcip51IOC.P31; P31=P31_w.out;
  P32_w.in -> Hplcip51IOC.P32; P32=P32_w.out;
  P33_w.in -> Hplcip51IOC.P33; P33=P33_w.out;
  P34_w.in -> Hplcip51IOC.P34; P34=P34_w.out;
  P35_w.in -> Hplcip51IOC.P35; P35=P35_w.out;
  P36_w.in -> Hplcip51IOC.P36; P36=P36_w.out;
  P37_w.in -> Hplcip51IOC.P37; P37=P37_w.out;

  Init = Hplcip51IOC.Init;
}
