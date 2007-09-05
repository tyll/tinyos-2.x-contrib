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

#include <stdio.h>
#include <tos.h>
#include <sim_energy_estimate.h>

sim_energy_t node_energy[TOSSIM_MAX_NODES];

void sim_energy_estimator_init()
{
  int i;

  //printf("Initializing node_power variables to zero\n");

  for (i=0; i< TOSSIM_MAX_NODES; i++) {
    node_energy[i].MCUEnergy.idle = 0.0;
    node_energy[i].MCUEnergy.adc = 0.0;
    node_energy[i].MCUEnergy.extStandby = 0.0;
    node_energy[i].MCUEnergy.save = 0.0;
    node_energy[i].MCUEnergy.standby = 0.0;
    node_energy[i].MCUEnergy.down = 0.0;
    node_energy[i].MCUEnergy.on = 0.0;
    node_energy[i].MCUEnergy.total = 0.0;
    node_energy[i].LedEnergy.led0 = 0.0;
    node_energy[i].LedEnergy.led1 = 0.0;
    node_energy[i].LedEnergy.led2 = 0.0;
    node_energy[i].LedEnergy.total = 0.0;
    node_energy[i].RadioEnergy.core = 0.0;
    node_energy[i].RadioEnergy.coreBias = 0.0;
    node_energy[i].RadioEnergy.coreBiasSyn = 0.0;
    node_energy[i].RadioEnergy.tx = 0.0;
    node_energy[i].RadioEnergy.rx = 0.0;
    node_energy[i].RadioEnergy.rxPacket = 0.0;
    node_energy[i].RadioEnergy.total = 0.0;
    node_energy[i].MemEnergy.write = 0.0;
    node_energy[i].MemEnergy.read = 0.0;
    node_energy[i].MemEnergy.total = 0.0;
    node_energy[i].total = 0.0;
  }
}

void sim_update_cpuIdleEnergy(double val) {
  node_energy[sim_node()].MCUEnergy.idle += val;
  node_energy[sim_node()].MCUEnergy.total += val;
  node_energy[sim_node()].total += val;
}

void sim_update_cpuAdcEnergy(double val) {
  node_energy[sim_node()].MCUEnergy.adc += val;
  node_energy[sim_node()].MCUEnergy.total += val;
  node_energy[sim_node()].total += val;
}

void sim_update_cpuExtStandbyEnergy(double val) {
  node_energy[sim_node()].MCUEnergy.extStandby += val;
  node_energy[sim_node()].MCUEnergy.total += val;
  node_energy[sim_node()].total += val;
}

void sim_update_cpuSaveEnergy(double val) {
  node_energy[sim_node()].MCUEnergy.save  += val;
  node_energy[sim_node()].MCUEnergy.total += val;
  node_energy[sim_node()].total += val;
}

void sim_update_cpuStandbyEnergy(double val) {
  node_energy[sim_node()].MCUEnergy.standby += val;
  node_energy[sim_node()].MCUEnergy.total += val;
  node_energy[sim_node()].total += val;
}

void sim_update_cpuPowerDownEnergy(double val) {
  node_energy[sim_node()].MCUEnergy.down += val;
  node_energy[sim_node()].MCUEnergy.total += val;
  node_energy[sim_node()].total += val;
}

void sim_update_cpuOnEnergy(double val) {
   node_energy[sim_node()].MCUEnergy.on +=  val;
}

void sim_update_led0Energy(double val) {
  node_energy[sim_node()].LedEnergy.led0 += val;
  node_energy[sim_node()].LedEnergy.total += val;
  node_energy[sim_node()].total += val;
}

void sim_update_led1Energy(double val) {
  node_energy[sim_node()].LedEnergy.led1 += val;
  node_energy[sim_node()].LedEnergy.total += val;
  node_energy[sim_node()].total += val;
}

void sim_update_led2Energy(double val) {
  node_energy[sim_node()].LedEnergy.led2 += val;
  node_energy[sim_node()].LedEnergy.total += val;
  node_energy[sim_node()].total += val;
}

void sim_update_cyrsOscEnergy(double val) {
  node_energy[sim_node()].RadioEnergy.core += val;
  node_energy[sim_node()].RadioEnergy.total += val;
  node_energy[sim_node()].total += val;
}

void sim_update_cyrsOscBiasEnergy(double val) {  
  node_energy[sim_node()].RadioEnergy.coreBias += val;
  node_energy[sim_node()].RadioEnergy.total += val;
  node_energy[sim_node()].total += val;
}

void sim_update_cyrsOscBiasSynEnergy(double val) {
  node_energy[sim_node()].RadioEnergy.coreBiasSyn += val;
  node_energy[sim_node()].RadioEnergy.total += val;
  node_energy[sim_node()].total += val;
}

void sim_update_radioTxEnergy(double val) {
  node_energy[sim_node()].RadioEnergy.tx += val;
  node_energy[sim_node()].RadioEnergy.total += val;
  node_energy[sim_node()].total += val;
}

void sim_update_radioRxEnergy(double val) {
  node_energy[sim_node()].RadioEnergy.rx +=  val;
  node_energy[sim_node()].RadioEnergy.total += val;
  node_energy[sim_node()].total += val;
}

void sim_update_radioRxPacketEnergy(double val) {
  node_energy[sim_node()].RadioEnergy.rxPacket += val;
}


void sim_update_memWriteEnergy(double val) {
  node_energy[sim_node()].MemEnergy.write += val;
  node_energy[sim_node()].MemEnergy.total += val;
  node_energy[sim_node()].total += val;
}

void sim_update_memReadEnergy(double val) {
  node_energy[sim_node()].MemEnergy.read += val;
  node_energy[sim_node()].MemEnergy.total += val;
  node_energy[sim_node()].total += val;
}

void sim_node_energy(int node) {
  char str[20];
  FILE *fp;
  sprintf(str,"Node_%d_Energy",node);
  fp = fopen(str,"w");
  if(fp == NULL) {
    fprintf(fp,"ERROR in writing the Energy to a file\n");
    return;
  }
  
  fprintf(fp,"Node %d Energy Status\n",node);
  fprintf(fp,"***************************************\n");
  fprintf(fp,"Total Node  Energy = %4.8f J\n",node_energy[node].total);
  fprintf(fp,"Total MCU   Energy = %4.8f J\n",node_energy[node].MCUEnergy.total);
  fprintf(fp,"Total Leds  Energy = %4.8f J\n",node_energy[node].LedEnergy.total);
  fprintf(fp,"Total Radio Energy = %4.8f J\n",node_energy[node].RadioEnergy.total);
  fprintf(fp,"Total Flash Energy = %4.8f J\n",node_energy[node].MemEnergy.total);
  fprintf(fp,"****************************************\n");
  fprintf(fp,"Energy spent in Detail \n");
  fprintf(fp,"------ AT128 MCU Energy-----------\n");
//  fprintf(fp,"MCUPower.Active = %4.8f J\n",node_energy[node].MCUEnergy.on);
  fprintf(fp,"Idle \t\t= %4.8f J\n",node_energy[node].MCUEnergy.idle);
  fprintf(fp,"ADC_NR \t\t= %4.8f J\n",node_energy[node].MCUEnergy.adc);
  fprintf(fp,"ExtStandby \t= %4.8f J\n",node_energy[node].MCUEnergy.extStandby);
  fprintf(fp,"Save \t\t= %4.8f J\n",node_energy[node].MCUEnergy.save);
  fprintf(fp,"Standby \t= %4.8f J\n",node_energy[node].MCUEnergy.standby);
  fprintf(fp,"Down \t\t= %4.8f J\n",node_energy[node].MCUEnergy.down);
  fprintf(fp,"-----------Leds Energy-----------\n");
  fprintf(fp,"led0 \t\t= %4.8f J\n",node_energy[node].LedEnergy.led0);
  fprintf(fp,"led1 \t\t= %4.8f J\n",node_energy[node].LedEnergy.led1);
  fprintf(fp,"led2 \t\t= %4.8f J\n",node_energy[node].LedEnergy.led2);
  fprintf(fp,"--------CC1000 Radio Energy--------\n");
  fprintf(fp,"Core \t\t= %4.8f J\n",node_energy[node].RadioEnergy.core);
  fprintf(fp,"CoreBias \t= %4.8f J\n",node_energy[node].RadioEnergy.coreBias); 
  fprintf(fp,"CoreBiasSyn \t= %4.8f J\n",node_energy[node].RadioEnergy.coreBiasSyn);
  fprintf(fp,"Tx \t\t= %4.8f J\n",node_energy[node].RadioEnergy.tx);
  fprintf(fp,"Rx(Total) \t= %4.8f J\n",node_energy[node].RadioEnergy.rx);
  fprintf(fp,"Rx(Packet Only) = %4.8f J\n",node_energy[node].RadioEnergy.rxPacket);
  fprintf(fp,"--------- AT45DB Flash -------------\n");
  fprintf(fp,"Read \t\t= %4.8f J\n",node_energy[node].MemEnergy.read);
  fprintf(fp,"Write \t\t= %4.8f J\n",node_energy[node].MemEnergy.write);
  fprintf(fp,"****************************************\n");
  fclose(fp);
}
