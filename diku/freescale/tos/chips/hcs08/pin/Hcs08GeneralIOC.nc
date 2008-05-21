
/* "Copyright (c) 2000-2003 The Regents of the University of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement
 * is hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
 * OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 * HPL for the general-purpose I/O on the Hcs08.
 * Adapted from the Msp430 implementation
 *
 * @author Joe Polastre
 * @author Tor Petterson <motor@diku.dk>
 */

configuration Hcs08GeneralIOC
{
	
  provides interface HplHcs08GeneralIO as PortA0;
  provides interface HplHcs08GeneralIO as PortA1;
  provides interface HplHcs08GeneralIO as PortA2;
  provides interface HplHcs08GeneralIO as PortA3;
  provides interface HplHcs08GeneralIO as PortA4;
  provides interface HplHcs08GeneralIO as PortA5;
  provides interface HplHcs08GeneralIO as PortA6;
  provides interface HplHcs08GeneralIO as PortA7;
  
  provides interface HplHcs08GeneralIO as PortB0;
  provides interface HplHcs08GeneralIO as PortB1;
  provides interface HplHcs08GeneralIO as PortB2;
  provides interface HplHcs08GeneralIO as PortB3;
  provides interface HplHcs08GeneralIO as PortB4;
  provides interface HplHcs08GeneralIO as PortB5;
  provides interface HplHcs08GeneralIO as PortB6;
  provides interface HplHcs08GeneralIO as PortB7;
  
  provides interface HplHcs08GeneralIO as PortC0;
  provides interface HplHcs08GeneralIO as PortC1;
  provides interface HplHcs08GeneralIO as PortC2;
  provides interface HplHcs08GeneralIO as PortC3;
  provides interface HplHcs08GeneralIO as PortC4;
  provides interface HplHcs08GeneralIO as PortC5;
  provides interface HplHcs08GeneralIO as PortC6;
  provides interface HplHcs08GeneralIO as PortC7;
  
  provides interface HplHcs08GeneralIO as PortD0;
  provides interface HplHcs08GeneralIO as PortD1;
  provides interface HplHcs08GeneralIO as PortD2;
  provides interface HplHcs08GeneralIO as PortD3;
  provides interface HplHcs08GeneralIO as PortD4;
  provides interface HplHcs08GeneralIO as PortD5;
  provides interface HplHcs08GeneralIO as PortD6;
  provides interface HplHcs08GeneralIO as PortD7;
  
  provides interface HplHcs08GeneralIO as PortE0;
  provides interface HplHcs08GeneralIO as PortE1;
  provides interface HplHcs08GeneralIO as PortE2;
  provides interface HplHcs08GeneralIO as PortE3;
  provides interface HplHcs08GeneralIO as PortE4;
  provides interface HplHcs08GeneralIO as PortE5;
  provides interface HplHcs08GeneralIO as PortE6;
  provides interface HplHcs08GeneralIO as PortE7;
 
  provides interface HplHcs08GeneralIO as PortF0;
  provides interface HplHcs08GeneralIO as PortF1;
  provides interface HplHcs08GeneralIO as PortF2;
  provides interface HplHcs08GeneralIO as PortF3;
  provides interface HplHcs08GeneralIO as PortF4;
  provides interface HplHcs08GeneralIO as PortF5;
  provides interface HplHcs08GeneralIO as PortF6;
  provides interface HplHcs08GeneralIO as PortF7;
  
  provides interface HplHcs08GeneralIO as PortG0;
  provides interface HplHcs08GeneralIO as PortG1;
  provides interface HplHcs08GeneralIO as PortG2;
  provides interface HplHcs08GeneralIO as PortG3;
  provides interface HplHcs08GeneralIO as PortG4;
  provides interface HplHcs08GeneralIO as PortG5;
  provides interface HplHcs08GeneralIO as PortG6;
  provides interface HplHcs08GeneralIO as PortG7;

}
implementation
{
  components 
  new HplHcs08GeneralIOP(PTAD_Addr, PTADD_Addr, PTAPE_Addr, PTASE_Addr, 0) as PA0,
  new HplHcs08GeneralIOP(PTAD_Addr, PTADD_Addr, PTAPE_Addr, PTASE_Addr, 1) as PA1,
  new HplHcs08GeneralIOP(PTAD_Addr, PTADD_Addr, PTAPE_Addr, PTASE_Addr, 2) as PA2,
  new HplHcs08GeneralIOP(PTAD_Addr, PTADD_Addr, PTAPE_Addr, PTASE_Addr, 3) as PA3,
  new HplHcs08GeneralIOP(PTAD_Addr, PTADD_Addr, PTAPE_Addr, PTASE_Addr, 4) as PA4,
  new HplHcs08GeneralIOP(PTAD_Addr, PTADD_Addr, PTAPE_Addr, PTASE_Addr, 5) as PA5,
  new HplHcs08GeneralIOP(PTAD_Addr, PTADD_Addr, PTAPE_Addr, PTASE_Addr, 6) as PA6,
  new HplHcs08GeneralIOP(PTAD_Addr, PTADD_Addr, PTAPE_Addr, PTASE_Addr, 7) as PA7,
  
  new HplHcs08GeneralIOP(PTBD_Addr, PTBDD_Addr, PTBPE_Addr, PTBSE_Addr, 0) as PB0,
  new HplHcs08GeneralIOP(PTBD_Addr, PTBDD_Addr, PTBPE_Addr, PTBSE_Addr, 1) as PB1,
  new HplHcs08GeneralIOP(PTBD_Addr, PTBDD_Addr, PTBPE_Addr, PTBSE_Addr, 2) as PB2,
  new HplHcs08GeneralIOP(PTBD_Addr, PTBDD_Addr, PTBPE_Addr, PTBSE_Addr, 3) as PB3,
  new HplHcs08GeneralIOP(PTBD_Addr, PTBDD_Addr, PTBPE_Addr, PTBSE_Addr, 4) as PB4,
  new HplHcs08GeneralIOP(PTBD_Addr, PTBDD_Addr, PTBPE_Addr, PTBSE_Addr, 5) as PB5,
  new HplHcs08GeneralIOP(PTBD_Addr, PTBDD_Addr, PTBPE_Addr, PTBSE_Addr, 6) as PB6,
  new HplHcs08GeneralIOP(PTBD_Addr, PTBDD_Addr, PTBPE_Addr, PTBSE_Addr, 7) as PB7,
  
  new HplHcs08GeneralIOP(PTCD_Addr, PTCDD_Addr, PTCPE_Addr, PTCSE_Addr, 0) as PC0,
  new HplHcs08GeneralIOP(PTCD_Addr, PTCDD_Addr, PTCPE_Addr, PTCSE_Addr, 1) as PC1,
  new HplHcs08GeneralIOP(PTCD_Addr, PTCDD_Addr, PTCPE_Addr, PTCSE_Addr, 2) as PC2,
  new HplHcs08GeneralIOP(PTCD_Addr, PTCDD_Addr, PTCPE_Addr, PTCSE_Addr, 3) as PC3,
  new HplHcs08GeneralIOP(PTCD_Addr, PTCDD_Addr, PTCPE_Addr, PTCSE_Addr, 4) as PC4,
  new HplHcs08GeneralIOP(PTCD_Addr, PTCDD_Addr, PTCPE_Addr, PTCSE_Addr, 5) as PC5,
  new HplHcs08GeneralIOP(PTCD_Addr, PTCDD_Addr, PTCPE_Addr, PTCSE_Addr, 6) as PC6,
  new HplHcs08GeneralIOP(PTCD_Addr, PTCDD_Addr, PTCPE_Addr, PTCSE_Addr, 7) as PC7,

  new HplHcs08GeneralIOP(PTDD_Addr, PTDDD_Addr, PTDPE_Addr, PTDSE_Addr, 0) as PD0,
  new HplHcs08GeneralIOP(PTDD_Addr, PTDDD_Addr, PTDPE_Addr, PTDSE_Addr, 1) as PD1,
  new HplHcs08GeneralIOP(PTDD_Addr, PTDDD_Addr, PTDPE_Addr, PTDSE_Addr, 2) as PD2,
  new HplHcs08GeneralIOP(PTDD_Addr, PTDDD_Addr, PTDPE_Addr, PTDSE_Addr, 3) as PD3,
  new HplHcs08GeneralIOP(PTDD_Addr, PTDDD_Addr, PTDPE_Addr, PTDSE_Addr, 4) as PD4,
  new HplHcs08GeneralIOP(PTDD_Addr, PTDDD_Addr, PTDPE_Addr, PTDSE_Addr, 5) as PD5,
  new HplHcs08GeneralIOP(PTDD_Addr, PTDDD_Addr, PTDPE_Addr, PTDSE_Addr, 6) as PD6,
  new HplHcs08GeneralIOP(PTDD_Addr, PTDDD_Addr, PTDPE_Addr, PTDSE_Addr, 7) as PD7,
 
  new HplHcs08GeneralIOP(PTED_Addr, PTEDD_Addr, PTEPE_Addr, PTESE_Addr, 0) as PE0,
  new HplHcs08GeneralIOP(PTED_Addr, PTEDD_Addr, PTEPE_Addr, PTESE_Addr, 1) as PE1,
  new HplHcs08GeneralIOP(PTED_Addr, PTEDD_Addr, PTEPE_Addr, PTESE_Addr, 2) as PE2,
  new HplHcs08GeneralIOP(PTED_Addr, PTEDD_Addr, PTEPE_Addr, PTESE_Addr, 3) as PE3,
  new HplHcs08GeneralIOP(PTED_Addr, PTEDD_Addr, PTEPE_Addr, PTESE_Addr, 4) as PE4,
  new HplHcs08GeneralIOP(PTED_Addr, PTEDD_Addr, PTEPE_Addr, PTESE_Addr, 5) as PE5,
  new HplHcs08GeneralIOP(PTED_Addr, PTEDD_Addr, PTEPE_Addr, PTESE_Addr, 6) as PE6,
  new HplHcs08GeneralIOP(PTED_Addr, PTEDD_Addr, PTEPE_Addr, PTESE_Addr, 7) as PE7,
    
  new HplHcs08GeneralIOP(PTFD_Addr, PTFDD_Addr, PTFPE_Addr, PTFSE_Addr, 0) as PF0,
  new HplHcs08GeneralIOP(PTFD_Addr, PTFDD_Addr, PTFPE_Addr, PTFSE_Addr, 1) as PF1,
  new HplHcs08GeneralIOP(PTFD_Addr, PTFDD_Addr, PTFPE_Addr, PTFSE_Addr, 2) as PF2,
  new HplHcs08GeneralIOP(PTFD_Addr, PTFDD_Addr, PTFPE_Addr, PTFSE_Addr, 3) as PF3,
  new HplHcs08GeneralIOP(PTFD_Addr, PTFDD_Addr, PTFPE_Addr, PTFSE_Addr, 4) as PF4,
  new HplHcs08GeneralIOP(PTFD_Addr, PTFDD_Addr, PTFPE_Addr, PTFSE_Addr, 5) as PF5,
  new HplHcs08GeneralIOP(PTFD_Addr, PTFDD_Addr, PTFPE_Addr, PTFSE_Addr, 6) as PF6,
  new HplHcs08GeneralIOP(PTFD_Addr, PTFDD_Addr, PTFPE_Addr, PTFSE_Addr, 7) as PF7,
    
  new HplHcs08GeneralIOP(PTGD_Addr, PTGDD_Addr, PTGPE_Addr, PTGSE_Addr, 0) as PG0,
  new HplHcs08GeneralIOP(PTGD_Addr, PTGDD_Addr, PTGPE_Addr, PTGSE_Addr, 1) as PG1,
  new HplHcs08GeneralIOP(PTGD_Addr, PTGDD_Addr, PTGPE_Addr, PTGSE_Addr, 2) as PG2,
  new HplHcs08GeneralIOP(PTGD_Addr, PTGDD_Addr, PTGPE_Addr, PTGSE_Addr, 3) as PG3,
  new HplHcs08GeneralIOP(PTGD_Addr, PTGDD_Addr, PTGPE_Addr, PTGSE_Addr, 4) as PG4,
  new HplHcs08GeneralIOP(PTGD_Addr, PTGDD_Addr, PTGPE_Addr, PTGSE_Addr, 5) as PG5,
  new HplHcs08GeneralIOP(PTGD_Addr, PTGDD_Addr, PTGPE_Addr, PTGSE_Addr, 6) as PG6,
  new HplHcs08GeneralIOP(PTGD_Addr, PTGDD_Addr, PTGPE_Addr, PTGSE_Addr, 7) as PG7;

  PortA0 = PA0;
  PortA1 = PA1;
  PortA2 = PA2;
  PortA3 = PA3;
  PortA4 = PA4;
  PortA5 = PA5;
  PortA6 = PA6;
  PortA7 = PA7;
  
  PortB0 = PB0;
  PortB1 = PB1;
  PortB2 = PB2;
  PortB3 = PB3;
  PortB4 = PB4;
  PortB5 = PB5;
  PortB6 = PB6;
  PortB7 = PB7;
  
  PortC0 = PC0;
  PortC1 = PC1;
  PortC2 = PC2;
  PortC3 = PC3;
  PortC4 = PC4;
  PortC5 = PC5;
  PortC6 = PC6;
  PortC7 = PC7;
  
  PortD0 = PD0;
  PortD1 = PD1;
  PortD2 = PD2;
  PortD3 = PD3;
  PortD4 = PD4;
  PortD5 = PD5;
  PortD6 = PD6;
  PortD7 = PD7;
  
  PortE0 = PE0;
  PortE1 = PE1;
  PortE2 = PE2;
  PortE3 = PE3;
  PortE4 = PE4;
  PortE5 = PE5;
  PortE6 = PE6;
  PortE7 = PE7;
  
  PortF0 = PF0;
  PortF1 = PF1;
  PortF2 = PF2;
  PortF3 = PF3;
  PortF4 = PF4;
  PortF5 = PF5;
  PortF6 = PF6;
  PortF7 = PF7;
  
  PortG0 = PG0;
  PortG1 = PG1;
  PortG2 = PG2;
  PortG3 = PG3;
  PortG4 = PG4;
  PortG5 = PG5;
  PortG6 = PG6;
  PortG7 = PG7;
  
}

