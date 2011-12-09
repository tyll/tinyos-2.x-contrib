/**
 * Implementation for Bluetooth Application
 * 
 **/
#include "l2cap.h"
#include "printf.h"
module L2CAPM
{
  uses {
    interface Bluetooth;
    interface Leds;
    interface Boot;
  }
}
implementation
{
  //gen_pkt btbuffer;
  //Bad implementation. Redo.
  char LocalName[] = "Tracey-0.01";
  uint8_t COD[3] = {0x11,0x05, 0x10};
  event void Boot.booted()
  { 
    printf("Initialising Bluetooth Device\r\n");

    printfflush();
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
     case OK: printf("OK %.2X \r\n", param); break;
     case UNKNOWN_PTYPE: printf("UNKNOWN_PTYPE %.2X \r\n", param); break;
     case UNKNOWN_PTYPE_DONE: printf("UNKNOWN_PTYPE_DONE %.2X \r\n", param); break;
     case EVENT_PKT_TOO_LONG: printf("EVENT_PKT_TOO_LONG %.2X \r\n", param); break;
     case ACL_PKT_TOO_LONG: printf("ACL_PKT_TOO_LONG %.2X \r\n", param); break;
     case UNKNOWN_EVENT: printf("UNKNOWN_EVENT %.2X \r\n", param); break;
     case UNKNOWN_CMD_COMPLETE: printf("UNKNOWN_CMD_COMPLETE %.2X \r\n", param); break;
     case HW_ERROR: printf("HW_ERROR %.2X \r\n", param); break;
     case UART_UNABLE_TO_HANDLE_EVENTS: printf("UART_UNABLE_TO_HANDLE_EVENTS %.2X \r\n", param); break;
     case HCIPACKET_SEND_OVERFLOW: printf("HCIPACKET_SEND_OVERFLOW %.2X \r\n", param); break;
     case EVENT_HANDLER_TO_SLOW: printf("EVENT_HANDLER_TO_SLOW %.2X \r\n", param); break;
     case HCI_UNABLE_TO_HANDLE_EVENTS: printf("HCI_UNABLE_TO_HANDLE_EVENTS %.2X \r\n", param); break;
     case NO_FREE_RECV_PACKET: printf("NO_FREE_RECV_PACKET %.2X \r\n", param); break;
     case WRONG_ACK: printf("WRONG_ACK %.2X \r\n", param); break;
    }
    printfflush();
    }
  }

  event void Bluetooth.ready(){
    call Leds.led0On();
    printf("Bluetooth.ready() called.\r\n");
    printfflush();
    //
    call Bluetooth.changeLocalName(LocalName);
    call Bluetooth.writeClassOfDevice(COD);
    call Bluetooth.writeDefaultLinkPolicy((uint16_t)(HCI_LP_RSWITCH|HCI_LP_SNIFF|HCI_LP_PARK));
    //
    //
  }

  event error_t Bluetooth.writeInqActivityComplete(gen_pkt *pkt){
    call Bluetooth.postInquiryDefault();
    return SUCCESS;
  }
  event error_t Bluetooth.writeDefaultLinkPolicyComplete(status_pkt *pkt){
    call Bluetooth.postWriteScanEnable(SCAN_INQUIRY|SCAN_PAGE);
    
    return SUCCESS;
  }
  event error_t Bluetooth.writeScanEnableComplete(status_pkt *pkt){
    
    //call Bluetooth.postWriteInqActivity(0x1000,0x0012);
    
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
    return SUCCESS;    
  }

  event error_t Bluetooth.connComplete(conn_complete_pkt *pkt){
     return SUCCESS;   
  }

  event error_t Bluetooth.disconnComplete(disconn_complete_pkt *pkt){
    return SUCCESS;    
  }

  event error_t Bluetooth.inquiryResult(inq_resp_pkt *pkt){
    uint8_t i;
    for (i=0; i< pkt->start->numresp; i++)
    printf("%.2X:%.2X:%.2X:%.2X:%.2X:%.2X \r\n",
                  pkt->start->infos[i].bdaddr.b[5],
                  pkt->start->infos[i].bdaddr.b[4],
                  pkt->start->infos[i].bdaddr.b[3],
                  pkt->start->infos[i].bdaddr.b[2],
                  pkt->start->infos[i].bdaddr.b[1],
                  pkt->start->infos[i].bdaddr.b[0]);
    return SUCCESS;    
  }

  event void Bluetooth.inquiryComplete(){
  }

  event error_t Bluetooth.connRequest(conn_request_pkt *pkt){
     return SUCCESS;   
  }
}

