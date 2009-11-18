/*
* Copyright (c) 2009 GTI/TC-1 Research Group.  Universidade de Vigo.
*                    Gradiant (www.gradiant.org)
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
* - Neither the name of Universidade de Vigo nor the names of its
*   contributors may be used to endorse or promote products derived
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
* - Revision -------------------------------------------------------------
* $Revision$
* $Date$
* @author Daniel F. Piñeiro-Santos <danips@enigma.det.uvigo.es>
* @author Felipe Gil-Castiñeira <xil@det.uvigo.es>
* @author David Chaves-Diéguez <dchaves@gradiant.org>
* ========================================================================
*/


/**
 * Implementation of the ZigBee Tree Routing. Simple procedure based on a
 * distributed address assignment.
 * The packet goes up the tree till it finds a common parent, then it goes down
 * till reaching its destination.
 */

module NwkTreeRoutingP {
  provides {
    interface NWK_ROUTING;
  } uses {
    // NMLE-SAP
    interface NLME_GET;
    interface NIB_SET_GET;
  }
}

implementation {

  bool isDescendant(uint16_t Addr) {
    if ((Addr > call NLME_GET.nwkNetworkAddress())
	&& (Addr < (call NLME_GET.nwkNetworkAddress() + call NIB_SET_GET.getCskip(call NIB_SET_GET.getDepth() - 1))))
      return TRUE;
    else return FALSE;
  }

  command uint16_t NWK_ROUTING.nextHop(uint16_t DstAddr) {
    if (DstAddr >= 0xFFF8) {//Do not change address in broadcasted messages
      return DstAddr;
    }

    if ((isDescendant(DstAddr) == TRUE)
	|| (call NLME_GET.nwkNetworkAddress() == 0x0000)) {
      //We have to route down the tree
      uint8_t depth = call NIB_SET_GET.getDepth();
      uint16_t cskip = call NIB_SET_GET.getCskip(depth);
      uint16_t myAddr = call NLME_GET.nwkNetworkAddress();
      return (myAddr + 1 + (((DstAddr - myAddr - 1)/cskip) * cskip));
    }
    else{ //We have to give it to our parent
      return call NIB_SET_GET.searchParentNwkAddress();
    }
  }
}