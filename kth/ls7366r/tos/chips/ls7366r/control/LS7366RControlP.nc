/**
 * General component to control the LS7366R. This components
 * manages the resources to assure a the unicity when using 
 * the SPI communication protocol.
 *  
 * </br> KTH | Royal Institute of Technology
 * </br> Automatic Control
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version $Revision$ $Date$
 * 
 */

#include "Timer.h"

module LS7366RControlP @ safe() {

provides {
	interface Init;
	interface Resource;
	interface LS7366RConfig;
	interface LS7366RReceive;
}

uses {
	interface GeneralIO as SS;

	interface GeneralIO as SOMI;

	interface LS7366RRegister as MDR0;
	interface LS7366RRegister as MDR1;
	interface LS7366RRegister as DTR;
	interface LS7366RRegister as CNTR;
	interface LS7366RRegister as OTR;
	interface LS7366RRegister as STR;

	interface LS7366RStrobe as LDOTR;
	interface LS7366RStrobe as CLRCNTR;

	interface Resource as SpiResource;
	interface Resource as SyncResource;

	interface BusyWait<TMicro,uint16_t> as BusyWait;
}

}

implementation {
	/***************** Configuration vars ****************/
	uint8_t m_size, m_quadMode, m_clkDiv, m_runningMode, m_index, m_indexSync;
	uint32_t m_module;
	bool m_disabled;
	bool m_sync_busy;

	/***************** Prototypes ****************/
	task void sync();
	task void syncDone();
	void generateSSFallingEdge();

	/***************************************************************************************
	 * Init Commands
	 ***************************************************************************************/
	command error_t Init.init() {

		// configure the ports as I/O
		call SS.makeOutput();
		call SOMI.makeInput();

		// set the default configuration
		m_disabled = LS7366R_DEF_DISABLED;
		m_size = LS7366R_DEF_SIZE;
		m_quadMode = LS7366R_DEF_QUAD_MODE;
		m_clkDiv= LS7366R_DEF_CLK_DIV;
		m_runningMode=LS7366R_DEF_RUNNING_MODE;
		m_index=LS7366R_DEF_INDEX;
		m_indexSync=LS7366R_DEF_SYNC_INDEX;

		m_module = LS7366R_DEF_MOD_N_LIMIT;

		// disable the chip enable by default. SS is active with 0
		call SS.set();

		// synchornize the configuration
		post sync();

		return SUCCESS;
	}
	/***************************************************************************************
	 * Resource Commands
	 ***************************************************************************************/
	async command error_t Resource.immediateRequest() {
		error_t error = call SpiResource.immediateRequest();
		if ( error == SUCCESS ) {}
		return error;
	}

	async command error_t Resource.request() {
		return call SpiResource.request();
	}

	async command uint8_t Resource.isOwner() {
		return call SpiResource.isOwner();
	}

	async command error_t Resource.release() {
		atomic {
			return call SpiResource.release();
		}
	}

	default event void Resource.granted() {
		call Resource.release();
	}

	/**
	 * Sync must be called to commit software parameters configured on
	 * the microcontroller (through the LS7366RConfig interface) to the
	 * LS7366R encoder chip.
	 */
	command error_t LS7366RConfig.sync() {
		call SyncResource.request();
		return SUCCESS;
	}

	/***************************************************************************************
	 * SPI Resources Events
	 ***************************************************************************************/
	event void SyncResource.granted() {

		// One WR cycle for MDR0
		call SS.clr();
		// write the default configuration for MDR0
		atomic call MDR0.writeByte(m_quadMode | m_runningMode | m_index | m_clkDiv | m_indexSync);
		generateSSFallingEdge();

		// One WR cycle for MDR1
		// write the default configuration for MDR1
		atomic call MDR1.writeByte(m_disabled << LS7366R_MDR1_ENABLE_COUNTER_SHIFT |
				(m_size & LS7366R_MDR1_COUNTER_BYTES_MASK));
		generateSSFallingEdge();

//		if (m_runningMode == LS7366R_MDR0_MOD_N_MODE) {
//			// One WR cycle for DTR
//			atomic call DTR.writeWord( m_module-1);
//			generateSSFallingEdge();    
//		}
		
		// send the clear counter
		atomic call CLRCNTR.strobe();
		call SS.set();

		call SyncResource.release();
		post syncDone();
	}
	
	event void SpiResource.granted() {
		signal Resource.granted();
	}

	/***************** Tasks ****************/
	/**
	 * Attempt to synchronize our current settings with the LS7366R
	 */
	task void sync() {
		call LS7366RConfig.sync();
	}

	task void syncDone() {
		atomic m_sync_busy = FALSE;
		signal LS7366RConfig.syncDone( SUCCESS );
	}

	/**
	 * Generate a falling edge in the SS line, to enable the chip.
	 */
	void generateSSFallingEdge() {
		//set a high level
		call SS.set();
		//wait 1us
		call BusyWait.wait(1);
		// set a low level
		call SS.clr();
	}

	/***************************************************************************************
	 * LS7366RReceive Commands
	 ***************************************************************************************/
	command error_t LS7366RReceive.receive(uint8_t* data) {

		atomic {
			//enable the chip generating a falling edge
			call SS.clr();
			// send the command to read the counter register
			call CNTR.read(data,call LS7366RConfig.getSize() );
			//disable the chip
			call SS.set();
		}
		call Resource.release();
		signal LS7366RReceive.receiveDone(data);

		return SUCCESS;
	}
	/***************** Defaults ****************/
	default event void LS7366RReceive.receiveDone( uint8_t* data ) {
		call Resource.release();
	}

	/***************************************************************************************
	 * LS7366RConfig Commands
	 ***************************************************************************************/
	/***************** STR configuration ****************/
	command uint8_t LS7366RConfig.getState() {
		uint8_t state;

		call SS.clr(); //enable
		// read the state of the chip from the STR register
		call STR.read(&state, 1);
		call SS.set(); //disable

		return state;
	}

	command void LS7366RConfig.setState( uint8_t state ) {
		call SS.clr(); //enable
		// write the state byte in the STR register
		call STR.writeByte(state);
		call SS.set(); //disable
	}
	/***************** MDR0 configuration ****************/
	command uint8_t LS7366RConfig.getQuadMode() {
		atomic return m_quadMode;
	}

	command void LS7366RConfig.setQuadMode( uint8_t mode ) {
		atomic m_quadMode = mode;
		// synchornize the configuration
		post sync();
	}

	command uint8_t LS7366RConfig.getRunningMode() {
		return m_runningMode;
	}

	command void LS7366RConfig.setRunningMode( uint8_t mode ) {
		atomic m_runningMode = mode;
		// synchornize the configuration
		post sync();
	}

	command uint8_t LS7366RConfig.getIndex() {
		return m_index;
	}

	command void LS7366RConfig.setIndex( uint8_t index ) {
		atomic m_index = index;
		// synchornize the configuration
		post sync();
	}

	command uint8_t LS7366RConfig.getIndexSync() {
		return m_indexSync;
	}

	command void LS7366RConfig.setIndexSync( uint8_t index ) {
		atomic m_indexSync = index;
		// synchornize the configuration
		post sync();
	}

	/***************** MDR1 configuration ****************/

	command uint8_t LS7366RConfig.getSize() {
		return m_size;
	}

	command void LS7366RConfig.setSize( uint8_t size ) {
		atomic m_size = size;
		// synchornize the configuration
		post sync();
	}

	command uint8_t LS7366RConfig.getClkDiv() {
		return m_clkDiv;
	}

	command void LS7366RConfig.setClkDiv( uint8_t clk_div ) {
		atomic m_clkDiv = clk_div;
		// synchornize the configuration
		post sync();
	}

	command bool LS7366RConfig.getDisabled() {
		atomic return m_disabled;
	}
	command void LS7366RConfig.setDisabled( bool disabled ) {
		atomic m_disabled = disabled;
		// synchornize the configuration
		post sync();
	}
	/***************** DTR configuration ****************/
	command uint32_t LS7366RConfig.getModule() {
		return m_module;
	}

	command void LS7366RConfig.setModule(uint32_t module2) {
		atomic m_module = module2;
		// synchornize the configuration
		post sync();
	}

	/***************** Defaults ****************/
	default event void LS7366RConfig.syncDone( error_t error ) {}

}
