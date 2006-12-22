
/**
 * Manage storing and retrieving configuration settings 
 * for various components, mainly to non-volatile internal microcontroller memory.
 *
 * Always connect your components to the parameterized interface 
 * unique("Configuration")
 * 
 * On install, the internal flash should be erased automatically on
 * both the avr and msp430 platforms, so you shouldn't have to worry
 * about loading incorrect config data left over from a different
 * version of the application.
 *
 * On boot, each unique parameterized Configuration interface will
 * be called with an event to requestRegistration().  The component
 * using the Configuration interface must call the command registrate(..)
 * at that point to register its global buffers that store configuration data.
 * After all components have registered, the ready() event will be signaled.
 * At that point, it is safe to load and store settings.  It is recommended
 * that all loading and storing of settings be put in a repetitive task
 * loop to ensure a proper flash transaction:
 *
 *   task void loadSettings() {
 *     if(!call Configuration.load()) {
 *       post loadSettings();
 *     }
 *   }
 *
 *
 *   task void storeSettings() {
 *     if(!call Configuration.store()) {
 *       post storeSettings();
 *     }
 *   }
 *
 * Storing data will first calcute and store the CRC of the data to flash,
 * then store the actual data to flash.  Each client will take up the
 * size they register with plus 2 bytes extra for the CRC.
 *
 * Loading data will first load the CRC from flash, then load the
 * data from flash into the registered client's pointer.  If
 * the CRC's don't match, then the loaded() event will signal with
 * valid == FALSE and result == SUCCESS.  You can then fill
 * in the registered buffer with default data and call store().
 *
 * @author David Moss
 */
 
