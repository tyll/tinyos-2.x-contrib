/* Interface for the ADE chip.
* So far we have set and get register, this should allows us to do everything we
* want on the chip. 
* The events are implemented in the powernetTest application
*
* @author Maria Kazandjieva, <mariakaz@cs.stanford.edu> 
* @date Nov 18, 2008
*/

interface ADE7753 {
    command error_t setReg(uint8_t regArrd, uint8_t txLen, uint32_t value);
    command error_t getReg(uint8_t regAddr, uint8_t rxLen);
    async event void getRegDone(error_t error, uint32_t value);
    async event void setRegDone(error_t, uint32_t value);
    
    // relay commands
    command bool getRelayState();
    command bool toggleRelay();
}
