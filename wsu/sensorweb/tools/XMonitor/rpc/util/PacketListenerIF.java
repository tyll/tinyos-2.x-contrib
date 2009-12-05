// $Id$

/* 
 * Author: Mike Chen <mikechen@cs.berkeley.edu>
 * Inception Date: October 22th, 2000
 *
 * This software is copyrighted by Mike Chen and the Regents of
 * the University of California.  The following terms apply to all
 * files associated with the software unless explicitly disclaimed in
 * individual files.
 * 
 * The authors hereby grant permission to use this software without
 * fee or royalty for any non-commercial purpose.  The authors also
 * grant permission to redistribute this software, provided this
 * copyright and a copy of this license (for reference) are retained
 * in all distributed copies.
 *
 * For commercial use of this software, contact the authors.
 * 
 * IN NO EVENT SHALL THE AUTHORS OR DISTRIBUTORS BE LIABLE TO ANY PARTY
 * FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE, ITS DOCUMENTATION, OR ANY
 * DERIVATIVES THEREOF, EVEN IF THE AUTHORS HAVE BEEN ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * THE AUTHORS AND DISTRIBUTORS SPECIFICALLY DISCLAIM ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.  THIS SOFTWARE
 * IS PROVIDED ON AN "AS IS" BASIS, AND THE AUTHORS AND DISTRIBUTORS HAVE
 * NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS.
 */

//==============================================================================
//===   PacketListenerIF.java   ==============================================


/**
 * @author Mike Chen <mikechen@cs.berkeley.edu>
 */

package rpc.util;

/**
 * 
 * The listener interface receives incoming packets.
 *
 * @author  <A HREF="http://www.cs.berkeley.edu/~mikechen/">Mike Chen</A> 
 *		(<A HREF="mailto:mikechen@cs.berkeley.edu">mikechen@cs.berkeley.edu</A>)
 * @since   1.1.6
 * @deprecated Use rpc.packet.PacketListenerIF instead
 */


public interface PacketListenerIF extends java.util.EventListener {

  //===========================================================================
  //===   CONSTANTS   =========================================================
  
  //===   CONSTANTS   =========================================================
  //===========================================================================
  

  //===========================================================================
  

  /**
   *  .
   */

public void packetReceived(byte[] packet);

}


// of Class PacketListenerIF

//===   PacketListenerIF.java   =============================================
//=============================================================================



//////////////////////////////////////////////////
// Fix the emacs editing mode
// Local Variables: ***
// c-basic-offset:2 ***
// End: ***
//////////////////////////////////////////////////
