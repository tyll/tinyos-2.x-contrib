

/**
 * @author Jared Hill
 */

/**
 * This module assumes it already has full access to the Spi Bus
 */
 
 #include "Blaze.h"
 
module BlazeReceiveP {

  provides {
    interface Receive[ radio_id_t id ];
    interface ReceiveController[ radio_id_t id ];
    interface AckReceive;
        
    interface Init;
  }
  
  uses {
    interface AsyncSend as AckSend[ radio_id_t id ];
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

  uint8_t m_id;
  
  message_t* m_msg;
  
  blaze_ack_t acknowledgement;
  
  message_t myMsg;

  
  enum receive_states{
    S_IDLE,
    S_RX_LENGTH,
    S_REC_HEADER,
    S_REC_PKT,
    S_TX_ACK,
    S_REC_ACK,  
  };
  
  enum {
    BLAZE_RXFIFO_LENGTH = 64,
    MAC_PACKET_SIZE = MAC_HEADER_SIZE + TOSH_DATA_LENGTH + MAC_FOOTER_SIZE,
    SACK_HEADER_LENGTH = 5,
  };
  
  
  /***************** Prototypes ****************/
  void receive();
  void initReceive();
  uint8_t getStatus();
  void failReceive();
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    m_msg = &myMsg;
    acknowledgement.length = ACK_FRAME_LENGTH;
    acknowledgement.fcf = IEEE154_TYPE_ACK;
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
    uint8_t* buf = (uint8_t*)(call BlazePacketBody.getHeader( m ));
    return buf[0];
  }
  
  /*************** ReceiveController Commands ***********************/
  async command error_t ReceiveController.beginReceive[ radio_id_t id ](){
    
    uint8_t status;
    if(call State.requestState(S_RX_LENGTH) != SUCCESS) {
      return EBUSY;
    }
    
    call Csn.clr[ id ]();
    atomic{
      m_id = id;
      m_msg = &myMsg;
    }
    
    //crc check on the packet that was just received
    if((call PktStatus.read(&status)) >> 7) {
      // return SUCCESS because failReceive signals an event
      call State.toIdle();
      failReceive();
      return SUCCESS;
    }
    
    // Anything after receive() returns an event, so signal SUCCESS
    receive();
    
    return SUCCESS;
  }
  
  
  /***************** AckSend Events ****************/
  async event void AckSend.sendDone[ radio_id_t id ](void *msg, error_t error) {
  }
  
  /***************** RXFIFO Events ****************/
  async event void RXFIFO.readDone( uint8_t* rx_buf, uint8_t rx_len,
                                    error_t error ) {

    uint8_t id;
    blaze_header_t* header;
    uint8_t* msg;
    atomic{ 
      id = m_id; 
      msg = (uint8_t*)m_msg;
    }
    
    call Csn.set[ id ]();  //toggle csn to show done reading
    call Csn.clr[ id ]();
    
    if(call State.isState(S_RX_LENGTH)) {
      call State.forceState(S_REC_HEADER);
    
      if((msg[0] > sizeof(message_t)) || (msg[0] == 0)) {
        call State.toIdle();
        failReceive();
        return;
      }
      
      call RXFIFO.beginRead((msg + 1), msg[0]);
    
    } else if(call State.isState(S_REC_PKT)){
      initReceive(); //put the radio back in receive mode
      call Csn.set[ id ]();  //unselect the radio
      call State.toIdle();
      signal Receive.receive[ id ]((message_t*) msg, rx_buf, msg[0]);
    
    } else if(call State.getState() == S_REC_HEADER) {
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
        acknowledgement.length = sizeof(blaze_ack_t) - 1;
        acknowledgement.fcf = ( ( IEEE154_TYPE_ACK << IEEE154_FCF_FRAME_TYPE ) |
		     ( 1 << IEEE154_FCF_INTRAPAN ) |
		     ( IEEE154_ADDR_SHORT << IEEE154_FCF_DEST_ADDR_MODE ) |
		     ( IEEE154_ADDR_SHORT << IEEE154_FCF_SRC_ADDR_MODE ) );
        acknowledgement.dsn = header -> dsn;
        acknowledgement.dest = header -> src;
        acknowledgement.src = header -> dest; 
        call STX.strobe();
        while(call RadioStatus.getRadioStatus() != BLAZE_S_TX);
        call TXFIFO.write(((uint8_t*)&acknowledgement), acknowledgement.length);  
      }
      else{
        //finish reading the RXFIFO
        //call State.forceState(S_REC_PKT);
        //call RXFIFO.beginRead((uint8_t*)(msg + sizeof(blaze_header_t)), ((uint8_t*)msg)[0] - (sizeof(blaze_header_t) - 1)); 
        initReceive(); //put the radio back in receive mode
        
        call Csn.set[ id ]();  //unselect the radio
        call State.toIdle();
        signal Receive.receive[ id ]((message_t*)msg, m_msg->data, msg[0]);  
      }
      
    }else if(call State.getState() == S_REC_ACK){
      initReceive(); //put the radio back in receive mode
      call Csn.set[ id ]();  //unselect the radio
      call State.toIdle();
      //if the packet isn't meant for me, don't pass it up
      if(acknowledgement.dest != TOS_NODE_ID){
        return;    
      }   
      //increment the length of the packet back to the proper size;
      (uint8_t)(acknowledgement.length)++;
      signal Receive.receive[ id ]((message_t*)(&acknowledgement), ((message_t*)(&acknowledgement)), rx_len);
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
  
  void receive() {
    uint8_t* msg; 
    uint8_t status = call RadioStatus.getRadioStatus();
    
    if(status == BLAZE_S_TXFIFO_UNDERFLOW){
      // SFTX puts us back into IDLE.  Take us out of IDLE and back into Rx
      call SFTX.strobe();
      initReceive();
    }
      
    if(status == BLAZE_S_RXFIFO_OVERFLOW){
      // RXFIFO is corrupted, don't try and read it in.
      // need to service the interrupt or future ones won't fire
      call State.toIdle();
      failReceive();
      return; 
    }
      
    call RXFIFO.beginRead((uint8_t *) m_msg, 1);
  }
 
  void initReceive(){
    while (call RadioStatus.getRadioStatus() != BLAZE_S_RX){
      call SRX.strobe();
    }
  } 
  
  void failReceive(){
    uint8_t id;
    call SFRX.strobe();
    initReceive();
    atomic id = m_id;
    call Csn.set[ id ]();
    
    signal ReceiveController.receiveFailed[m_id]();
    return; 
  }
  
  /*************** Defaults ********************/
  default event message_t *Receive.receive[ radio_id_t id ](message_t* msg, void* payload, uint8_t len){
    return msg;
  }
  
  default async event void ReceiveController.receiveFailed[ radio_id_t id ]() {
  }
  
  default async command error_t AckSend.send[ radio_id_t id ](void *msg) {
    return FAIL;
  }
  
  default async event void AckReceive.receive( blaze_ack_t *ack ) {
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

