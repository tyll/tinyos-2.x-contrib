/** based upon CC2420ReceiveP, CC2420ControlP */

#include <message.h>
#include <AM.h>
    
module CC2420SniffP {

  provides interface Init;
  provides interface SplitControl;
      
  provides command error_t setChannel(uint8_t channel);
	provides command am_addr_t amAddress();
  
  uses interface AsyncStdControl as SubControl;
  uses interface Resource;
	
  // upcall to HIL
  uses async command void* rawReceive(void*);
  
  // HAL inetrfaces of the radio
	uses interface CC2420Power;
    
  // HPL (low level) interfaces of the radio
  uses interface CC2420Fifo as RXFIFO;
  uses interface CC2420Ram as PANID;
  uses interface GpioInterrupt as InterruptCCA;
  uses interface GpioInterrupt as InterruptFIFOP;
  uses interface GpioCapture as CaptureSFD;
  uses interface CC2420Register as IOCFG0;
  uses interface CC2420Register as IOCFG1;
  uses interface CC2420Register as FSCTRL;
  uses interface CC2420Register as MDMCTRL0;
  uses interface CC2420Register as RXCTRL1;
  uses interface CC2420Strobe as SRXON;
  uses interface CC2420Strobe as SRFOFF;
  uses interface CC2420Strobe as SXOSCON;
  uses interface CC2420Strobe as SACK;
  uses interface CC2420Strobe as SFLUSHRX;
  uses interface GeneralIO as CSN;
  uses interface GeneralIO as FIFO;
  uses interface GeneralIO as FIFOP;

}

implementation {

  typedef enum {
    S_PREINIT,
    S_STOPPED,
    S_STARTING,
    S_STARTED,
    S_STOPPING,
    S_SETUP_CHANNEL,
    S_RX_HEADER,
    S_RX_PAYLOAD,
  } cc2420_sniff_state_t;
  
  enum {
    RXFIFO_SIZE = 128,
  };

  norace uint8_t m_state = S_PREINIT;
  uint16_t m_pan = 0xffff;
  uint16_t m_short_addr = 0xffff;
  uint8_t m_channel = CC2420_DEF_CHANNEL;
  uint8_t m_missed_packets;
  norace uint8_t m_bytes_left;
  norace message_t* m_p_rx_buf;
  message_t m_rx_buf;
  
  task void startDone_task();
  task void stopDone_task();
  void setConfig();
  void resetReceiveState();
  void beginReceive();
  void receive();
  void waitForNextPacket();

  
  command am_addr_t amAddress() {
   	return m_short_addr;
  }
  
  command error_t Init.init() {
    if ( m_state != S_PREINIT )
      return FAIL;

    m_p_rx_buf = &m_rx_buf;
    m_state = S_STOPPED;

    return SUCCESS;
  }

  command error_t SplitControl.start() {
    if ( m_state != S_STOPPED ) 
      return FAIL;
    call CC2420Power.startVReg();
    return SUCCESS;
  }

  async event void CC2420Power.startVRegDone() {
    atomic m_state = S_STARTING;
    call Resource.request();
  }

  // configure radio (accept all frametypes, accept all addresses, turn off automatic acks)
  void setConfig() {
    atomic {
      call IOCFG1.write( CC2420_SFDMUX_XOSC16M_STABLE << 
          CC2420_IOCFG1_CCAMUX );
      call InterruptCCA.enableRisingEdge();
      call SXOSCON.strobe();
      call IOCFG0.write( ( 1 << CC2420_IOCFG0_FIFOP_POLARITY ) |
          ( 127 << CC2420_IOCFG0_FIFOP_THR ) );
      call FSCTRL.write( ( 1 << CC2420_FSCTRL_LOCK_THR ) |
          ( ( (m_channel - 11)*5+357 ) 
          << CC2420_FSCTRL_FREQ ) );
      call MDMCTRL0.write( ( 1 << CC2420_MDMCTRL0_RESERVED_FRAME_MODE ) |
          ( 0 << CC2420_MDMCTRL0_ADR_DECODE ) |
          ( 2 << CC2420_MDMCTRL0_CCA_HYST ) |
          ( 3 << CC2420_MDMCTRL0_CCA_MOD ) |
          ( 1 << CC2420_MDMCTRL0_AUTOCRC ) |
          ( 0 << CC2420_MDMCTRL0_AUTOACK ) |
          ( 2 << CC2420_MDMCTRL0_PREAMBLE_LENGTH ) );
      call RXCTRL1.write( ( 1 << CC2420_RXCTRL1_RXBPF_LOCUR ) |
          ( 1 << CC2420_RXCTRL1_LOW_LOWGAIN ) |
          ( 1 << CC2420_RXCTRL1_HIGH_HGM ) |
          ( 1 << CC2420_RXCTRL1_LNA_CAP_ARRAY ) |
          ( 1 << CC2420_RXCTRL1_RXMIX_TAIL ) |
          ( 1 << CC2420_RXCTRL1_RXMIX_VCM ) |
          ( 2 << CC2420_RXCTRL1_RXMIX_CURRENT ) );
    }
  }
  
  event void Resource.granted() {
    if (m_state == S_STARTING) {
			setConfig();
    } else if (m_state == S_RX_HEADER) {
      receive();
    }
	}
  
  async event void InterruptCCA.fired() {
    nxle_uint16_t id[ 2 ];
    id[ 0 ] = m_pan;
    id[ 1 ] = m_short_addr;
    call InterruptCCA.disable();
    call IOCFG1.write( 0 );
    call PANID.write( 0, (uint8_t*)&id, 4 );
    call CSN.set();
    call CSN.clr();
		resetReceiveState();
    m_state = S_STARTED;
    call InterruptFIFOP.enableFallingEdge();;
    call CC2420Power.rxOn();
    call Resource.release();
    post startDone_task();
  }
  
  task void startDone_task() {
    m_state = S_STARTED;
    signal SplitControl.startDone( SUCCESS );
  }

  command error_t SplitControl.stop() {
    if ( m_state != S_STARTED )
      return FAIL;
    m_state = S_STOPPING;
    call InterruptFIFOP.disable();
    call CC2420Power.stopVReg();
    post stopDone_task();
    return SUCCESS;
  }

  task void stopDone_task() {
    m_state = S_STOPPED;
    signal SplitControl.stopDone( SUCCESS );
  }
  
  // set channel
  error_t command setChannel(uint8_t channel) {
    nxle_uint16_t id[ 2 ];
    
    if (call Resource.immediateRequest() != SUCCESS) 
	    return FAIL;
    else 
      m_state = S_SETUP_CHANNEL;
       
    atomic {
      m_channel = channel;
      id[ 0 ] = m_pan;
      id[ 1 ] = m_short_addr;
    }
    call CSN.clr();
    call SRFOFF.strobe();
    call FSCTRL.write( ( 1 << CC2420_FSCTRL_LOCK_THR ) | ( ( (m_channel - 11)*5+357 ) << CC2420_FSCTRL_FREQ ) );
    call PANID.write( 0, (uint8_t*)id, sizeof( id ) );
    call CSN.set();
    call CSN.clr();
    call SRXON.strobe();
    
    m_state = S_STARTED;
    call Resource.release();
    return SUCCESS;
  }
  

  void resetReceiveState() {
    m_bytes_left = RXFIFO_SIZE;
    m_missed_packets = 0;
  }
  
  void beginReceive() { 
    m_state = S_RX_HEADER;
    if ( call Resource.immediateRequest() == SUCCESS )
      receive();
    else
      call Resource.request();
  }
    
  void receive() {
    call CSN.clr();
    call RXFIFO.beginRead( (uint8_t*)m_p_rx_buf->data , 1 );
  }
  
  void waitForNextPacket() {
    atomic {
      if ( m_state == S_STOPPED )
        return;
      if ( ( m_missed_packets && call FIFO.get() ) || !call FIFOP.get() ) {
        if ( m_missed_packets )
          m_missed_packets--;
        beginReceive();
      }
      else {
        m_state = S_STARTED;
        m_missed_packets = 0;
      }
    }      
  }     
  
  async event void InterruptFIFOP.fired() {
    if ( m_state == S_STARTED )
      beginReceive();
    else
      m_missed_packets++;
  }

  async event void RXFIFO.readDone( uint8_t* rx_buf, uint8_t rx_len, error_t error ) {

    uint8_t* buf = (uint8_t*)m_p_rx_buf->data;
    uint8_t length = buf[ 0 ];

    switch( m_state ) {
    case S_RX_HEADER:
      m_state = S_RX_PAYLOAD;
      if ( length + 1 > m_bytes_left ) {
				resetReceiveState();
	      call CSN.set();
        call CSN.clr();
        call SFLUSHRX.strobe();
        call SFLUSHRX.strobe();
        call CSN.set();
        call Resource.release();
        waitForNextPacket();
      }
      else {
				if ( !call FIFO.get() && !call FIFOP.get() )
	 				m_bytes_left -= length + 1;
				call RXFIFO.continueRead( (length <= MAC_PACKET_SIZE) ? buf + 1 : NULL, length );
      }
      break;
    case S_RX_PAYLOAD:
      call CSN.set();
      call Resource.release();
      // pass packet if correct crc and do the swap
      if ( ( buf[ length ] >> 7 ) && rx_buf ) {
    		m_p_rx_buf = call rawReceive( m_p_rx_buf);
      }
      waitForNextPacket();
      break;
    default:
      call CSN.set();
      call Resource.release();
      break;
    }
  }
  
  
  // unused and/or ignored events
  async event void CC2420Power.startOscillatorDone() {}
  async event void CaptureSFD.captured( uint16_t time ) {}
  async event void RXFIFO.writeDone( uint8_t* tx_buf, uint8_t tx_len, error_t error ) {}  
}
