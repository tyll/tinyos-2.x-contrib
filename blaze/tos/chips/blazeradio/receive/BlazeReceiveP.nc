

/**
 * This module assumes it already has full access to the Spi Bus
 *
 * Higher layers must handle the GDO2 interrupt that tells us a packet
 * has been received.  After receiving the interrupt, the SPI bus is
 * acquired and BlazeReceiveP.ReceiveController.beginReceive is called.
 * This will read the bytes out of the Rx FIFO, Ack if necessary, then
 * return the message to higher layers
 *
 * @author Jared Hill
 * @author David Moss
 */
 
 #include "Blaze.h"
 
module BlazeReceiveP {

  provides {
    interface Receive[ radio_id_t id ];
    interface ReceiveController[ radio_id_t id ];
    interface Init;
  }
  
  uses {
    interface GeneralIO as Csn[ radio_id_t id ];
   
    interface BlazeFifo as RXFIFO;
    interface BlazeFifo as TXFIFO;
  
    interface BlazeStrobe as SFRX;
    interface BlazeStrobe as SFTX;
    interface BlazeStrobe as STX;
    interface BlazeStrobe as SNOP;
    interface BlazeStrobe as SRX;
    interface BlazeStrobe as SIDLE;
  
    interface BlazeRegister as RxReg;
    interface BlazeRegister as PktStatus;
  
    interface BlazePacket;
    interface BlazePacketBody;
    
    interface CheckRadio;
    interface RadioStatus;
    
    interface State;
    interface Leds;
  }

}

implementation {
  
  /** ID of the radio we're servicing */
  uint8_t m_id;
  
  /** Pointer to the message buffer to use, so we can double buffer */
  message_t *m_msg; 
  
  /** Default message buffer to use */
  message_t myMsg;
  
  /** Acknowledgement Frame */
  blaze_ack_t ack;

  
  /**
   * Receiver States
   */
  enum {
    S_IDLE,
    S_REC_LENGTH,
    S_REC_HEADER,
    S_REC_PKT,
    S_TX_ACK,
    S_REC_ACK,
  };
  
  /***************** Prototypes ****************/
  void initReceive();
  void failReceive();
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    m_msg = &myMsg;
    return SUCCESS;
  }
  
  /***************** Receive Commands ****************/
  command void* Receive.getPayload[radio_id_t id](message_t* msg, uint8_t* len) {
    if (len != NULL) {
      *len = ((uint8_t*) (call BlazePacketBody.getHeader( msg )))[0];
    }
    return msg->data;
  }

  command uint8_t Receive.payloadLength[radio_id_t id](message_t* m) {
    return (call BlazePacketBody.getHeader( m ))->length;
  }
  
  /*************** ReceiveController Commands ***********************/
  async command error_t ReceiveController.beginReceive[ radio_id_t id ](){
    uint8_t status;
    
    if(call State.requestState(S_REC_LENGTH) != SUCCESS) {
      return EBUSY;
    }
    
    atomic m_id = id;
    
    call Csn.clr[ id ]();
    
    // CRC check the packet before we bother downloading it
    call PktStatus.read(&status);
    if(status >> 7) {
      call State.toIdle();
      failReceive();
      return FAIL;
    }
    
    if(status == BLAZE_S_TXFIFO_UNDERFLOW) {
      // TODO Necessary?
      call SFTX.strobe();
      
    } else if(status == BLAZE_S_RXFIFO_OVERFLOW) {
      // RXFIFO is corrupted, don't try and read it in.
      // need to service the interrupt or future ones won't fire
      call State.toIdle();
      failReceive();
      return FAIL;
    }
    
    initReceive();
    
    // Read 1 byte in. This is the length byte.
    call RXFIFO.beginRead(m_msg, 1);
    return SUCCESS;
    
    
    /*** receive the data *
    // JAREDS FORMER CODE
    atomic msg = (uint8_t*) m_msg; 
    // TODO The RxReg value tells you how many bytes can be unloaded from
    // the RXFIFO, not the length of a single packet in the RXFIFO.  The only
    // way to really know the length of the next packet is to get it.
    call RxReg.read(msg);
    // Make sure we are not reading in a message that is larger 
    // than the buffer we provide
    if((msg[0] > sizeof(message_t)) || (msg[0] == 0)){
      call State.toIdle();
      failReceive();
      return;
    }
    
    //this is an ack
    // TODO this might not be an ack.  The only way to really tell is to read
    // in the packet and check the FCF byte after receiving the packet.
    if(msg[0] == (sizeof(blaze_ack_t) - 1)){
      call State.forceState(S_REC_ACK);
      call RXFIFO.beginRead((uint8_t*)((&ack) + 1), (sizeof(blaze_ack_t) - 1));
      
    } else if(msg[0] >= sizeof(blaze_header_t)){ 
      //this is a message_t frame
      //the first byte of message_t (length) is not transmitted as part of the message_t struct, 
      //but it is transmitted as part of the radio's message and therefore is easy to rebuild;
      //set a read header state, size = sizeof(blaze_header_t) - 1
      //call RXFIFO.beginRead((msg + 1), (sizeof(blaze_header_t) - 1));
      call RXFIFO.beginRead((msg + 1), msg[0]);
    }
    */
  }
  
  /***************** RXFIFO Events ****************/
  async event void RXFIFO.readDone( uint8_t* rx_buf, uint8_t rx_len,
                                    error_t error ) {

    uint8_t id;
    uint8_t rxLength = rx_buf[0];
    blaze_header_t* header;
    
    uint8_t *msg;
    atomic{ 
      id = m_id; 
      msg = (uint8_t*) m_msg;
    }
    
    call Csn.set[ id ]();  //toggle csn to show done reading
    call Csn.clr[ id ]();
    
    switch (call State.getState()) {
      case S_REC_LENGTH:
      
        break;
        
      case S_REC_HEADER:
        header = call BlazePacketBody.getHeader(m_msg);
        //call Leds.led0Toggle();
        //check and see if it is for me or bcast, if not, fail
        /*
        if((header->dest != TOS_NODE_ID) && (header->dest != AM_BROADCAST_ADDR)){
          failReceive();
          return;
        }
        */
      
        if((header->fcf) & (1 << IEEE154_FCF_ACK_REQ)){
          call State.forceState(S_TX_ACK);
          ack.length = sizeof(blaze_ack_t) - 1;
          ack.fcf = ( 
              ( IEEE154_TYPE_ACK << IEEE154_FCF_FRAME_TYPE ) |
              ( 1 << IEEE154_FCF_INTRAPAN ) |
              ( IEEE154_ADDR_SHORT << IEEE154_FCF_DEST_ADDR_MODE ) |
              ( IEEE154_ADDR_SHORT << IEEE154_FCF_SRC_ADDR_MODE ) );
          ack.dsn = header -> dsn;
          ack.dest = header -> src;
          ack.src = header -> dest; 
          call STX.strobe();
          while(call RadioStatus.getRadioStatus() != BLAZE_S_TX);
          call TXFIFO.write(((uint8_t*)&ack), ack.length);  
     
        } else {
          //finish reading the RXFIFO
          //call State.forceState(S_REC_PKT);
          //call RXFIFO.beginRead((uint8_t*)(msg + sizeof(blaze_header_t)), ((uint8_t*)msg)[0] - (sizeof(blaze_header_t) - 1)); 
          initReceive(); //put the radio back in receive mode
        
          call Csn.set[ id ]();  //unselect the radio
          call State.toIdle();
          signal Receive.receive[ id ]((message_t*)msg, (uint8_t*)m_msg->data, msg[0]);  
        }
        break;
        
      case S_REC_PKT:
        initReceive(); //put the radio back in receive mode
        call Csn.set[ id ]();  //unselect the radio
        call State.toIdle();
        signal Receive.receive[ id ]((message_t*) msg, rx_buf, msg[0]);
        break;
        
      case S_REC_ACK:
        initReceive(); //put the radio back in receive mode
        call Csn.set[ id ]();  //unselect the radio
        call State.toIdle();
        //if the packet isn't meant for me, don't pass it up
        if(ack.dest != TOS_NODE_ID){
          return;    
        }   
        //increment the length of the packet back to the proper size;
        (uint8_t)(ack.length)++;
        signal Receive.receive[ id ]((message_t*)(&ack), ((message_t*)(&ack)), rx_len);
        break;
         
      default:
        // TODO
    }   
  }

  async event void RXFIFO.writeDone( uint8_t* tx_buf, uint8_t tx_len, error_t error ) {
  }  
  
  /******************* TXFIFO EVENTS *****************************/
  async event void TXFIFO.readDone(uint8_t* rx_buf, uint8_t rx_len,
                                    error_t error ) {}
                                    
  async event void TXFIFO.writeDone( uint8_t* tx_buf, uint8_t tx_len, error_t error ) {
  
    message_t* msg;
    if(call State.getState() != S_TX_ACK){
      return;
    }
    atomic{
      msg = m_msg;
    }
    // finish reading the RX fifo
    call State.forceState(S_REC_PKT);
    call RXFIFO.beginRead((uint8_t*)(msg + sizeof(blaze_header_t)), ((uint8_t*)(msg))[0] - (sizeof(blaze_header_t) - 1));
  }                                 
  
  /************Local Functions*******************/
  void initReceive(){
    call SRX.strobe();
    while (call RadioStatus.getRadioStatus() != BLAZE_S_RX) { 
      call SRX.strobe();
    }
  } 
  
  void failReceive(){
    uint8_t id;
    call SFRX.strobe();
    initReceive();
    atomic id = m_id;
    call Csn.set[ id ]();
    return; 
  }
  
  /*************** Defaults ********************/
  default event message_t *Receive.receive[ radio_id_t id ](message_t* msg, void* payload, uint8_t len){
    return msg;
  }
  
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command bool Csn.get[ radio_id_t id ](){}
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command bool Csn.isInput[ radio_id_t id ](){}
  default async command void Csn.makeOutput[ radio_id_t id ](){}
  default async command bool Csn.isOutput[ radio_id_t id ](){}
  
}

