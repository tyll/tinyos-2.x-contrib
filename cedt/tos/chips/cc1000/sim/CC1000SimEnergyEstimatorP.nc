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

#include <sim_energy_estimate.h>
#include <CC1000Current.h>
 
module CC1000SimEnergyEstimatorP {
  provides interface CC1000SimEnergyEstimator;
}

implementation {
  
  async command void CC1000SimEnergyEstimator.crysOscEnergy(sim_time_t diff) {
    
    sim_update_cyrsOscEnergy(VOLTAGE * CC1K_CRYSTAL_OSC_CURRENT *(float) diff/sim_ticks_per_sec());

  }

  async command void CC1000SimEnergyEstimator.crysOscBiasEnergy(sim_time_t diff) {
  
    sim_update_cyrsOscBiasEnergy(VOLTAGE * CC1K_CrystalBias_CURRENT *(float) diff/sim_ticks_per_sec());
  
  }

  async command void CC1000SimEnergyEstimator.crysOscBiasSynEnergy(sim_time_t diff) {
  
    sim_update_cyrsOscBiasSynEnergy(VOLTAGE * CC1K_CrystalBiasSyn_CURRENT *(float) diff/sim_ticks_per_sec());
  
  }

  async command void CC1000SimEnergyEstimator.txEnergy(uint8_t bytes, float current, uint32_t baudrate) {
    double txTime = (double)((1/(double)baudrate)*8.0*bytes);
    sim_update_radioTxEnergy(VOLTAGE * current * txTime);
  }
  
  async command void CC1000SimEnergyEstimator.rxEnergy(sim_time_t diff) {
    uint8_t mode;
    mode = (CC1K_REG_ACCESS(CC1K_FRONT_END) >> CC1K_LNA_CURRENT) & 0x3;  
    sim_update_radioRxEnergy(VOLTAGE*CC1K_RX_CURRENT[mode]*(float)diff/sim_ticks_per_sec());
  }
  
  async command void CC1000SimEnergyEstimator.rxPacketEnergy(uint8_t bytes, float current, uint32_t baudrate) {
    double rxTime = (double)((1/(double)baudrate)*8.0*bytes);
    sim_update_radioRxPacketEnergy(VOLTAGE*current*rxTime);
  
  }
  
}
