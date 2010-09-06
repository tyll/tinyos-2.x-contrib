/**
 * Implementation for Bluetooth Application
 * 
 **/
#include "hci.h"
#include "printf.h"
#include "bttester.h"
module BluetoothTesterC
{
  uses {
    interface Bluetooth;
    interface Leds;
    interface Boot;
    interface Flu;
    interface Timer<TMilli> as Timer0;
    interface Timer<TMilli> as Heartbeat;
//    interface Receive;
//    interface Packet;
//    interface AMPacket;
//    interface AMSend;
//    interface SplitControl as AMControl;
//    interface PointerQueue<message_t>;
  }
}
implementation
{
  //gen_pkt btbuffer;
  //Bad implementation. Redo.
  char LocalName[] = "Tracey-0.01";
  uint8_t COD[3] = {0x11,0x05, 0x10};
  uint32_t curtime = IDENT_TIMESTAMP + 30;
  uint8_t reset = 0;

  bool busy = FALSE;
  bool am_error = FALSE;
  flurec_t localaddr;
  //task postrecords();
  event void Boot.booted()
  {
    printf("\r\nInitialising Bluetooth Device\r\n");
    printfflush();
    call Heartbeat.startPeriodic(125);
    call Timer0.startPeriodic(30720);
    //call AMControl.start();
    call Bluetooth.init();
  }

  event void Bluetooth.connPTypeChange(evt_conn_ptype_changed_pkt *pkt){
 
  }

  event void Bluetooth.modeChange(evt_mode_change_pkt *pkt){
 
  }

  event error_t Bluetooth.recvAcl(hci_acl_data_pkt *pkt){
    return SUCCESS;
  }

  event error_t Bluetooth.readBufSizeComplete(read_buf_size_pkt *pkt){
    return SUCCESS;    
  }

  event void Bluetooth.roleChange(evt_role_change_pkt *pkt){
 
  }

  event void Bluetooth.writeLinkPolicyComplete(write_link_policy_complete_pkt *pkt){
 
  }

  async event void Bluetooth.postComplete(gen_pkt *pkt){
 
  }

  event void Bluetooth.error(errcode err, uint16_t param){
    atomic {
      switch(err) {
        case OK: //printf("OK %.2X \r\n", param); 
        break;
        case UNKNOWN_PTYPE: ////printf("UNKNOWN_PTYPE %.2X \r\n", param); 
        break;
        case UNKNOWN_PTYPE_DONE: //printf("UNKNOWN_PTYPE_DONE %.2X \r\n", param); 
        break;
        case EVENT_PKT_TOO_LONG: //printf("EVENT_PKT_TOO_LONG %.2X \r\n", param); 
        break;
        case ACL_PKT_TOO_LONG: //printf("ACL_PKT_TOO_LONG %.2X \r\n", param); 
        break;
        case UNKNOWN_EVENT: //printf("UNKNOWN_EVENT %.2X \r\n", param); 
        break;
        case UNKNOWN_CMD_COMPLETE: //printf("UNKNOWN_CMD_COMPLETE %.2X \r\n", param); 
        break;
        case HW_ERROR: //printf("HW_ERROR %.2X \r\n", param); 
        break;
        case UART_UNABLE_TO_HANDLE_EVENTS: //printf("UART_UNABLE_TO_HANDLE_EVENTS %.2X \r\n", param); 
        break;
        case HCIPACKET_SEND_OVERFLOW: //printf("HCIPACKET_SEND_OVERFLOW %.2X \r\n", param); 
        break;
        case EVENT_HANDLER_TO_SLOW: //printf("EVENT_HANDLER_TO_SLOW %.2X \r\n", param); 
        break;
        case HCI_UNABLE_TO_HANDLE_EVENTS: //printf("HCI_UNABLE_TO_HANDLE_EVENTS %.2X \r\n", param); 
        break;
        case NO_FREE_RECV_PACKET: //printf("NO_FREE_RECV_PACKET %.2X \r\n", param); 
        break;
        case WRONG_ACK: //printf("WRONG_ACK %.2X \r\n", param); 
        break;
      }
      //printfflush();
    }
  }

  event void Bluetooth.ready(){
    printf("Bluetooth.ready() called.\r\n");
    printfflush();
    call Bluetooth.postWriteInquiryMode(INQUIRY_MODE_RSSI);
    call Bluetooth.postReadBDAddr();
    call Bluetooth.writeDefaultLinkPolicy((uint16_t)(HCI_LP_RSWITCH|HCI_LP_SNIFF|HCI_LP_PARK));
    //printf("Sending!\r\n");
    
  }

  event error_t Bluetooth.writeInqActivityComplete(gen_pkt *pkt){
    
    return SUCCESS;
  }
  event error_t Bluetooth.writeDefaultLinkPolicyComplete(status_pkt *pkt){
    call Bluetooth.postWriteScanEnable(SCAN_INQUIRY|SCAN_PAGE);
 
    return SUCCESS;
  }
  event error_t Bluetooth.writeScanEnableComplete(status_pkt *pkt){
    
    call Bluetooth.postWriteInqActivity(0x1000,0x0012);
    return SUCCESS;    
  }

  event error_t Bluetooth.inquiryCancelComplete(status_pkt *pkt){
    return SUCCESS;   
  }

  event error_t Bluetooth.noCompletedPkts(num_comp_pkts_pkt *pkt){
    return SUCCESS;   
  }

  event error_t Bluetooth.readBDAddrComplete(read_bd_addr_pkt *pkt){
//    flurec_t * tmprec;
//    message_t * tmpmsg;
//    tmprec = (flurec_t *) (call Packet.getPayload((tmpmsg = call PointerQueue.enqueue()), NULL));   
//    tmprec->dropped = FALSE;
//    bacpy(&(tmprec->baddr),&(pkt->start->bdaddr));
//    if (!busy && call AMSend.send(AM_FLUREC_T, tmpmsg, sizeof(flurec_t)) == SUCCESS) {
//      busy = TRUE;
//    }
//    
    call Bluetooth.changeLocalName(LocalName);
    call Bluetooth.writeClassOfDevice(COD);
    call Bluetooth.postInquiryDefault();
    
    call Leds.led0On();
    return SUCCESS;    
  }

  event error_t Bluetooth.connComplete(conn_complete_pkt *pkt){
    return SUCCESS;   
  }

  event error_t Bluetooth.disconnComplete(disconn_complete_pkt *pkt){
    return SUCCESS;    
  }

  event error_t Bluetooth.inquiryResult(gen_pkt *pkt,uint8_t evt){
    uint8_t i;
    call Leds.led2On();
    if (evt == EVT_INQUIRY_RESULT) {
        for (i=0; i< ((inq_resp_pkt *) pkt)->devices->numresp; i++) {
      printf("%.2X%.2X%.2X%.2X%.2X%.2X:%.4X%.4X\r\n",
        ((inq_resp_pkt *) pkt)->devices->info[i].bdaddr.b[5],
        ((inq_resp_pkt *) pkt)->devices->info[i].bdaddr.b[4],
        ((inq_resp_pkt *) pkt)->devices->info[i].bdaddr.b[3],
        ((inq_resp_pkt *) pkt)->devices->info[i].bdaddr.b[2],
        ((inq_resp_pkt *) pkt)->devices->info[i].bdaddr.b[1],
        ((inq_resp_pkt *) pkt)->devices->info[i].bdaddr.b[0],
        (uint16_t) (curtime >> 16),
        (uint16_t) curtime
    );
//   call Flu.add(&(((inq_resp_pkt *) pkt)->devices->info[i].bdaddr));
    }
    }
    else if (evt == EVT_INQUIRY_RSSI_RESULT) {
      for (i=0; i< ((inq_resp_rssi_pkt *) pkt)->devices->numresp; i++) {
      printf("%.2X%.2X%.2X%.2X%.2X%.2X:%.4X%.4X,R%.2X\r\n",
        ((inq_resp_rssi_pkt *) pkt)->devices->info[i].bdaddr.b[5],
        ((inq_resp_rssi_pkt *) pkt)->devices->info[i].bdaddr.b[4],
        ((inq_resp_rssi_pkt *) pkt)->devices->info[i].bdaddr.b[3],
        ((inq_resp_rssi_pkt *) pkt)->devices->info[i].bdaddr.b[2],
        ((inq_resp_rssi_pkt *) pkt)->devices->info[i].bdaddr.b[1],
        ((inq_resp_rssi_pkt *) pkt)->devices->info[i].bdaddr.b[0],
        (uint16_t) (curtime >> 16),
        (uint16_t) curtime,
        ((inq_resp_rssi_pkt *) pkt)->devices->info[i].rssi
    );
//    call Flu.add(&(((inq_resp_pkt *) pkt)->devices->info[i].bdaddr));
    }
    }
    else
    return FAIL;
    
    printfflush();
    return SUCCESS;    
  }

  event void Bluetooth.inquiryComplete(){
//    flurec_t * tmprec, * indexrec;
//    message_t * tmpmsg;
//    uint8_t i;
//    call Flu.sync(curtime);
    call Leds.led2Off();
//    for (i=0;i < FLUREC_SIZE;i++) {
//      if (call PointerQueue.available() && call Flu.marked_to_send(i)) {
//        tmprec = (flurec_t *) (call Packet.getPayload((tmpmsg = call PointerQueue.enqueue()), NULL));
//        indexrec = call Flu.index_get(i);
//        bacpy(&(tmprec->baddr),&(indexrec->baddr));
//        tmprec->start = indexrec->start;
//        tmprec->end = indexrec->end;
//        tmprec->dropped = indexrec->dropped;
//        tmprec->occupied = indexrec->occupied;
//        if (!busy && call AMSend.send(AM_FLUREC_T, tmpmsg, sizeof(flurec_t)) == SUCCESS) {
//          busy = TRUE;
//          //call Leds.led1On();
//          call Flu.remove(i);
//        }
//      }
//      //atomic curtime = (uint32_t) IDENT_TIMESTAMP + call Timestamp.get();
//      printf("We're Done!");
//      printfflush();
//    }
    }
    event error_t Bluetooth.connRequest(conn_request_pkt *pkt) {
      return SUCCESS;   
    }

    event void Timer0.fired(){
      atomic curtime += 30;
      
      atomic if (++reset == 5 ) call Bluetooth.powerOff();
      else if (reset == 6) call Bluetooth.init();
      else call Bluetooth.postInquiryDefault();
    }

//    event message_t * Receive.receive(message_t *msg, void *payload, uint8_t len){
// 
//    }
//
//    event void AMSend.sendDone(message_t *msg, error_t error){
//      if (msg == call PointerQueue.head()) {
//        call Leds.led1Off();
//        call PointerQueue.dequeue();
//        if (call PointerQueue.size() && call AMSend.send(AM_BROADCAST_ADDR, (call PointerQueue.head()), sizeof(flurec_t)) == SUCCESS) {
//          busy = TRUE;
//          call Leds.led1On();
//        }
//        else {
//          busy = FALSE;
//        }
//      }
//    }
//
//    event void AMControl.startDone(error_t error){
//     am_error = FALSE;
//      if (error != SUCCESS)
//     am_error = TRUE;
//    }
//
//    event void AMControl.stopDone(error_t error){
// 
//    }
//  
//    async event void PointerQueue.bufferFull(message_t *bin){
//      
//    }
//
//    async event void PointerQueue.bufferLow(){
//      
//    }

  event void Heartbeat.fired(){
     call Leds.led3Toggle();
  }
}

