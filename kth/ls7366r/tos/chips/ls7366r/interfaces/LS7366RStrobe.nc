/**
 * Interface that provides the LS7366RStrobe component.
 * 
 * </br> KTH | Royal Institute of Technology
 * </br> Automatic Control
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version $Revision$ $Date$
 * 
 */

#include "LS7366R.h"

interface LS7366RStrobe {

	/**
	 * Send a strobe. It sends an instruction to the chip.
	 * Depending on the strobe we shall enable the reception or not
	 * 
	 * 
	 * @return SUCCESS if the read was done, FAIL otherwise.
	 */
	async command error_t strobe();

}
