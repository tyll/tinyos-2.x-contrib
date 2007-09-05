/**
 * "Copyright (c) 2007 CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc.
 *  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 *
 * IN NO EVENT SHALL CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc BE LIABLE TO
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc HAS BEEN ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc SPECIFICALLY DISCLAIMS
 * ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND CENTRE FOR ELECTRONICS
 * AND DESIGN TECHNOLOGY,IISc HAS NO OBLIGATION TO PROVIDE MAINTENANCE,
 * SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */
 
/**
 *
 * @author Venkatesh S
 * @author Prabhakar T V
 */

#ifndef _SIM_ENERGY_ESTIMATE_H_
#define _SIM_ENERGY_ESTIMATE_H_

#ifdef __cplusplus
extern "C" {
#endif

typedef struct LedsEnergy_t {
  double led0;
  double led1;
  double led2;
  double total;
} LedsEnergy_t;

typedef struct MCUEnergy_t{
  double idle;
  double adc;
  double extStandby;
  double save;
  double standby;
  double down;
  double on;
  double total;
} MCUEnergy_t;

typedef struct RadioEnergy_t {
  double core;
  double coreBias;
  double coreBiasSyn;
  double tx;
  double rx;
  double rxPacket;
  double total;
} RadioEnergy_t;

typedef struct MemEnergy_t {
  double write;
  double read;
  double total;
}MemEnergy_t;

typedef struct sim_energy_t {
  MCUEnergy_t MCUEnergy;
  LedsEnergy_t LedEnergy;
  RadioEnergy_t RadioEnergy;
  MemEnergy_t MemEnergy;
  double total;
} sim_energy_t;

void sim_energy_estimator_init();

void sim_update_cpuIdleEnergy(double val) ;
void sim_update_cpuAdcEnergy(double val) ;
void sim_update_cpuExtStandbyEnergy(double val) ;
void sim_update_cpuSaveEnergy(double val) ;
void sim_update_cpuStandbyEnergy(double val) ;
void sim_update_cpuPowerDownEnergy(double val) ;
void sim_update_cpuOnEnergy(double val) ;

void sim_update_led0Energy(double val) ;
void sim_update_led1Energy(double val) ;
void sim_update_led2Energy(double val) ;

void sim_update_cyrsOscEnergy(double val);
void sim_update_cyrsOscBiasEnergy(double val);
void sim_update_cyrsOscBiasSynEnergy(double val);
void sim_update_radioTxEnergy(double val) ;
void sim_update_radioRxEnergy(double val) ;
void sim_update_radioRxPacketEnergy(double val);

void sim_update_memWriteEnergy(double val);
void sim_update_memReadEnergy(double val);

void sim_node_energy(int nodeId);


#ifdef __cplusplus
}
#endif

#endif
