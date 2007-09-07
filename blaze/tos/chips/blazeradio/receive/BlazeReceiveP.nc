

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
  
  enum receive_states{
    S_IDLE = 0,
    S_REC_HEADER = 1,
    S_REC_PKT = 2,
    S_TX_ACK = 3,
    S_REC_ACK,  
  };
  
  uint8_t m_id;
  message_t* m_msg; // TODO fix this
  blaze_ack_t ack;
  message_t myMsg; // TODO fix this
  
  /***************** Prototypes ****************/
  void receive();
  void initReceive();
  uint8_t getStatus();
  void failReceive();
  
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
  async command void ReceiveController.beginReceive[ radio_id_t id ](){
    
    uint8_t status;
    call State.forceState(S_REC_HEADER);
    call Csn.clr[ id ]();
    atomic{
      m_id = id;
      m_msg = &myMsg;
    }
    
    //crc check on the packet that was just received
    if((call PktStatus.read(&status)) >> 7){
      call State.toIdle();
      failReceive();
      return;
    }
    receive();
    
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
    if(call State.isState(S_REC_PKT)){
      initReceive(); //put the radio back in receive mode
      call Csn.set[ id ]();  //unselect the radio
      //increment the length of the packet back to the proper size;
      msg[0] ++;
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
        ack.length = sizeof(blaze_ack_t) - 1;
        ack.fcf = ( ( IEEE154_TYPE_ACK << IEEE154_FCF_FRAME_TYPE ) |
		     ( 1 << IEEE154_FCF_INTRAPAN ) |
		     ( IEEE154_ADDR_SHORT << IEEE154_FCF_DEST_ADDR_MODE ) |
		     ( IEEE154_ADDR_SHORT << IEEE154_FCF_SRC_ADDR_MODE ) );
        ack.dsn = header -> dsn;
        ack.dest = header -> src;
        ack.src = header -> dest; 
        call STX.strobe();
        while(call RadioStatus.getRadioStatus() != BLAZE_S_TX);
        call TXFIFO.write(((uint8_t*)&ack), ack.length);  
      }
      else{
        //finish reading the RXFIFO
        //call State.forceState(S_REC_PKT);
        //call RXFIFO.beginRead((uint8_t*)(msg + sizeof(blaze_header_t)), ((uint8_t*)msg)[0] - (sizeof(blaze_header_t) - 1)); 
        initReceive(); //put the radio back in receive mode
        
        call Csn.set[ id ]();  //unselect the radio
        //increment the length of the packet back to the proper size;
        msg[0] ++;
        call State.toIdle();
        signal Receive.receive[ id ]((message_t*)msg, (uint8_t*)m_msg->data, msg[0]);  
      }
    }else if(call State.getState() == S_REC_ACK){
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
    uint8_t status;
    
    call SIDLE.strobe(); 
    while ((status = call RadioStatus.getRadioStatus()) != BLAZE_S_IDLE){
      if(status == BLAZE_S_TXFIFO_UNDERFLOW){
        call SFTX.strobe();
      }else if(status == BLAZE_S_RXFIFO_OVERFLOW){
        call State.toIdle();
        failReceive();
        return; // RXFIFO is corrupted, don't try and read it in.
                 // need to service the interrupt or future ones won't fire
      }
    }
    /*** receive the data */
    atomic msg = (uint8_t*) m_msg; 
    call RxReg.read(msg);
    //check and make sure we are not reading in a message that is larger than the buffer
    //we provided
    if((msg[0] > sizeof(message_t)) || (msg[0] == 0)){
      call State.toIdle();
      failReceive();
      return;
    }
    
    //this is an ack
    if(msg[0] == (sizeof(blaze_ack_t) - 1)){
      call State.forceState(S_REC_ACK);
      call RXFIFO.beginRead((uint8_t*)((&ack) + 1), (sizeof(blaze_ack_t) - 1));
    }else if(msg[0] >= sizeof(blaze_header_t)){ //this is a message_t frame
    //the first byte of message_t (length) is not transmitted as part of the message_t struct, 
    //but it is transmitted as part of the radio's message and therefore is easy to rebuild;
    //set a read header state, size = sizeof(blaze_header_t) - 1
    //call RXFIFO.beginRead((msg + 1), (sizeof(blaze_header_t) - 1));
    call RXFIFO.beginRead((msg + 1), msg[0]);
    }
  }
 
  void initReceive(){
     
   uint8_t status;
   //call Leds.led2On();
   //prev = call Leds.get();     
   while ((status = call RadioStatus.getRadioStatus()) != BLAZE_S_IDLE){
     //call Leds.set(status + 8);
   }
   //call Leds.set(prev);
        
   //call SFRX.strobe();
   /*** switch to rx mode */
   //prev = call Leds.get();
   while ((status = call RadioStatus.getRadioStatus()) != BLAZE_S_RX){
     call SRX.strobe();
     //call Leds.set(status + 8);
   }
   //call Leds.set(prev);
   
  } 
  
  void failReceive(){
    uint8_t id;
    //call Leds.led0On();
    call SFRX.strobe();
    call SIDLE.strobe();
    initReceive();
    atomic{ id = m_id; }
    call Csn.set[ id ]();
    m_msg = signal Receive.receive[ id ](NULL, NULL, 0);
    if(m_msg == NULL) {
      m_msg = &myMsg;
    }
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

