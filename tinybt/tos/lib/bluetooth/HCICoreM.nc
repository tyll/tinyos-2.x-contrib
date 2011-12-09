/**
 *
 * $Rev:: 129         $:  Revision of last commit
 * $Author$:  Author of last commit
 * $Date$:  Date of last commit
 *
 **/
/*
 * Copyright (C) 2002-2003 Martin Leopold <leopold@diku.dk>
 * Copyright (C) 2003 Mads Bondo Dydensborg <madsdyd@diku.dk>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
#include "btpackets.h"
#include "printf.h"
/** 
 * HCICore0M module.
 * 
 * <p>Provides an implementation of the Bluetooth interface.</p> */
module HCICoreM {
  provides {
    interface Bluetooth;
  }
  uses {
    interface HCIPacket;
    interface BluetoothVendor;
    interface Leds;
    //interface Timer<TMilli> as Timer0;
    interface PointerQueue<gen_pkt> as SendQueue;
    interface PointerQueue<gen_pkt> as RecvQueue;
  }
}

implementation{

  uint16_t vendor_uart_opcode;
  uint8_t init_state; 
  uint8_t bt_avail_acl_data; // Counts free buffers in the bt device
 
  uint16_t acl_mtu;
  uint16_t acl_max_pkt;
  uint16_t last_sent_opcode;
  uint8_t bigLAP[4];
  bool esr_uart_rate_switch;

  typedef struct {
    int	ocf:10;
    int	ogf:6; // High order bits
  } __attribute__ ((packed)) opcode_t;
  //task void process_event();
  //task void process_init_events();
  task void initialize_bt_device();
  task void sendNext();
  command error_t Bluetooth.init() 
  {
    return call Bluetooth.powerOn();
  }

  command error_t Bluetooth.powerOn()
  {
    bt_avail_acl_data = 1;
    atomic esr_uart_rate_switch = FALSE;
    return ecombine(call HCIPacket.powerOn(), call HCIPacket.init_BT());
  }

  command error_t Bluetooth.powerOff() 
  {
    error_t res = call HCIPacket.powerOff();
    return res;
  }

  void init_hdr(uint8_t *hdr, uint8_t ogf, uint8_t ocf, uint8_t plen)
  {
    hci_command_hdr *cmd_hdr;
    cmd_hdr = (hci_command_hdr *) hdr;
 
    cmd_hdr->opcode = cmd_opcode_pack(ogf, ocf);
    cmd_hdr->plen = plen;
    return;
  }

  // Builds a complete esr_set_baud_rate with the parameter
  // from the Ericsson vendor specific commands p. 12
  // pkt must be setup correctly in advance!!

  /* Do serialisation of communication over the serial line */
  error_t send_packet(gen_pkt *send, hci_data_t type) 
  {
    if (send && send->start && send->end) {
      //      uint16_t tmp_opcode = ((hci_command_hdr *)send->start)->opcode;
      call HCIPacket.addTransport((gen_pkt*) send, type);
      if (send == call SendQueue.head())
        return call HCIPacket.putRawPacket(send);
    }
    return EBUSY;
  }

  command error_t Bluetooth.postAcl(hci_acl_data_pkt* send)
  {
    if (bt_avail_acl_data > 0) {
      bt_avail_acl_data--;
      if (send_packet((gen_pkt*)send, HCI_ACLDATA) == SUCCESS) {
        return SUCCESS;
      } else {
        // Undo changes so packet appears unchanged and can be resubmitted
        // to HCICore without errors
        bt_avail_acl_data++;

        // Notice: Fallthrough
      }
    } 
    return FAIL;
  }
 
  command error_t Bluetooth.postCmd(gen_pkt *send)
  {
    return send_packet(send, HCI_COMMAND);
  }

  error_t send_hci_cmd(gen_pkt* pkt, uint8_t ogf, uint8_t ocf,
      uint8_t plen) 
  {
    error_t res;
    // Put some cmd headers on - in reverse order
    pkt->start = pkt->start - HCI_COMMAND_HDR_SIZE;
    init_hdr(pkt->start, ogf, ocf, plen);
    res = call Bluetooth.postCmd(pkt);

    if(res) {
      return SUCCESS;
    } else {
      pkt->start = pkt->start + HCI_COMMAND_HDR_SIZE;
      return FAIL;
    }
  }
  command error_t Bluetooth.postInquiryDefault()
  {
    uint8_t LAP[] = { 0x9E,0x8B,0x33 };
    // lap[0], Lap[1], Lap[2], length, numrsp
    /* Note: If these are changed, they must be changed in the pc platform too */
    return call Bluetooth.postInquiry(LAP , 0x10 , 0x00);
  }
  command error_t Bluetooth.postInquiry(uint8_t LAP[3],
      uint8_t inquiry_length,
      uint8_t num_responses) 
  { 

    inq_req_pkt * tmp = (inq_req_pkt *) call SendQueue.enqueue();
    rst_send_pkt((gen_pkt*)tmp);
    tmp->start--;
    (tmp->start)->num_rsp = num_responses;
    (tmp->start)->length = inquiry_length;
    (tmp->start)->lap[0] = LAP[2];
    (tmp->start)->lap[1] = LAP[1];
    (tmp->start)->lap[2] = LAP[0];

    return send_hci_cmd((gen_pkt*) tmp,
        OGF_LINK_CTL,
        OCF_INQUIRY,
        INQUIRY_CP_SIZE);
  }
  command error_t Bluetooth.postPeriodicInquiryModeDefault(
      uint16_t 	min_period_len) {
    uint8_t LAP[] = { 0x9E,0x8B,0x33 };
    // lap[0], Lap[1], Lap[2], length, numrsp
    /* Note: If these are changed, they must be changed in the pc platform too */
    return call Bluetooth.postPeriodicInquiryMode(0x0030,
        0x020,
        LAP, 0x10 , 0x00);
  }
  command error_t Bluetooth.postPeriodicInquiryMode(	uint16_t 	max_period_len,
      uint16_t 	min_period_len,
      uint8_t     lap[3],
      uint8_t     inq_len,
      uint8_t     num_responses) {
    periodic_inq_mode_pkt * tmp = (periodic_inq_mode_pkt *) call SendQueue.enqueue();
    rst_send_pkt((gen_pkt*)tmp);
    tmp->start--;
    (tmp->start)->num_responses = num_responses;
    (tmp->start)->inq_len = inq_len;
    (tmp->start)->lap[0] = lap[2];
    (tmp->start)->lap[1] = lap[1];
    (tmp->start)->lap[2] = lap[0];
    (tmp->start)->max_period_len = htobs(max_period_len);
    (tmp->start)->min_period_len = htobs(min_period_len);
    return send_hci_cmd((gen_pkt*) tmp,
        OGF_LINK_CTL,
        OCF_PERIODIC_INQ_MODE,
        PERIODIC_INQ_MODE_CP_SIZE);
  }
  command error_t Bluetooth.postInquiryCancel() 
  {
    gen_pkt * pkt = call SendQueue.enqueue(); 
    rst_send_pkt(pkt);
    return send_hci_cmd((gen_pkt*) pkt,
        OGF_LINK_CTL,
        OCF_INQUIRY_CANCEL,
        0); //plen
  }

  command error_t Bluetooth.postCreateConn(	bdaddr_t	bdaddr,
      uint16_t 	pkt_type,
      uint8_t 	pscan_rep_mode,
      uint8_t 	pscan_mode,
      uint16_t 	clock_offset,
      uint8_t 	role_switch) 
  { 
    create_conn_pkt * tmp = (create_conn_pkt *) call SendQueue.enqueue();
    rst_send_pkt((gen_pkt*)tmp);
    tmp->start--;
    (tmp->start)->bdaddr = bdaddr;
    (tmp->start)->pkt_type = htobs(pkt_type);
    (tmp->start)->pscan_rep_mode = pscan_rep_mode;
    (tmp->start)->pscan_mode = pscan_mode;
    (tmp->start)->clock_offset = htobs(clock_offset);
    (tmp->start)->role_switch = role_switch;
    return send_hci_cmd((gen_pkt*) tmp,
        OGF_LINK_CTL,
        OCF_CREATE_CONN,
        CREATE_CONN_CP_SIZE);
  }

  command error_t Bluetooth.postAcceptConnReq(bdaddr_t	bdaddr,
      uint8_t 	role) 
  {
    accept_conn_req_pkt * tmp = (accept_conn_req_pkt *) call SendQueue.enqueue();
    rst_send_pkt((gen_pkt*)tmp);
    tmp->start--;
    (tmp->start)->bdaddr = bdaddr;
    (tmp->start)->role = role;
    return send_hci_cmd((gen_pkt*) tmp,
        OGF_LINK_CTL,
        OCF_ACCEPT_CONN_REQ,
        ACCEPT_CONN_REQ_CP_SIZE);
  }

  command error_t Bluetooth.postWriteInqActivity(uint16_t inquiry_scan_interval, uint16_t inquiry_scan_window)
  {
    write_inq_activity_pkt * tmp = (write_inq_activity_pkt *) call SendQueue.enqueue();
    rst_send_pkt((gen_pkt*)tmp);
    tmp->start--;
    (tmp->start)->interval = htobs(inquiry_scan_interval);
    (tmp->start)->window = htobs(inquiry_scan_window);
    return send_hci_cmd((gen_pkt*) tmp,
        OGF_HOST_CTL,
        OCF_WRITE_INQ_ACTIVITY,
        WRITE_INQ_ACTIVITY_CP_SIZE);
  }

  command error_t Bluetooth.postWriteScanEnable(uint8_t scan_enable) 
  {
    gen_pkt * tmp = call SendQueue.enqueue(); 
    rst_send_pkt(tmp);
    * (--(tmp->start)) = scan_enable;
    return send_hci_cmd((gen_pkt*) tmp,
        OGF_HOST_CTL,
        OCF_WRITE_SCAN_ENABLE,
        1);
  }
  command error_t Bluetooth.postWriteInquiryMode(uint8_t inquiry_mode) 
  {
    gen_pkt * tmp = call SendQueue.enqueue(); 
    rst_send_pkt(tmp);
    * (--(tmp->start)) = inquiry_mode;
    return send_hci_cmd((gen_pkt*) tmp,
        OGF_HOST_CTL,
        OCF_WRITE_INQUIRY_MODE,
        1);
  }
  command error_t Bluetooth.postReadBDAddr() 
  {
    gen_pkt * pkt = call SendQueue.enqueue();
    rst_send_pkt(pkt);
    return send_hci_cmd((gen_pkt*) pkt,
        OGF_INFO_PARAM,
        OCF_READ_BD_ADDR,
        0); //plen
  }

  command error_t Bluetooth.postReadBufSize() 
  {
    gen_pkt * pkt = call SendQueue.enqueue();
    rst_send_pkt(pkt);
    return send_hci_cmd((gen_pkt*) pkt,
        OGF_INFO_PARAM,
        OCF_READ_BUFFER_SIZE,
        0); //plen
  }

  command error_t Bluetooth.postDisconnect(	uint16_t 	handle,
      uint8_t 	reason)
  {
    disconnect_pkt * tmp = (disconnect_pkt *) call SendQueue.enqueue();
    rst_send_pkt((gen_pkt*)tmp);
    tmp->start--;
    (tmp->start)->handle = htobs(handle);
    (tmp->start)->reason = reason;
    return send_hci_cmd((gen_pkt*) tmp,
        OGF_LINK_CTL,
        OCF_DISCONNECT,
        DISCONNECT_CP_SIZE); //plen
  }
 
  command error_t Bluetooth.postSniffMode( uint16_t   handle,
      uint16_t   max_interval,
      uint16_t   min_interval,
      uint16_t   attempt,
      uint16_t   timeout)
  {
    sniff_mode_pkt * tmp = (sniff_mode_pkt *) call SendQueue.enqueue();
    rst_send_pkt((gen_pkt*)tmp);
    tmp->start--;
    (tmp->start)->handle = htobs(handle);
    (tmp->start)->max_interval = htobs(max_interval);
    (tmp->start)->min_interval = htobs(min_interval);
    (tmp->start)->attempt = htobs(attempt);     
    (tmp->start)->timeout = htobs(timeout);
    return send_hci_cmd((gen_pkt*) tmp,
        OGF_LINK_POLICY,
        OCF_SNIFF_MODE,
        SNIFF_MODE_CP_SIZE); //plen
  }
 
  command error_t Bluetooth.postWriteLinkPolicy(uint8_t handle, uint16_t policy)
  {
    write_link_policy_pkt * tmp = (write_link_policy_pkt *) call SendQueue.enqueue();
    rst_send_pkt((gen_pkt*)tmp);
    tmp->start--;
    (tmp->start)->policy = htobs(policy);
    (tmp->start)->handle = handle;
 
    return send_hci_cmd((gen_pkt*) tmp,
        OGF_LINK_POLICY,
        OCF_WRITE_LINK_POLICY,
        WRITE_LINK_POLICY_CP_SIZE); //plen
  }
  command error_t Bluetooth.writeDefaultLinkPolicy(uint16_t policy)
  {
    write_default_link_policy_pkt * tmp = (write_default_link_policy_pkt *) call SendQueue.enqueue();
    rst_send_pkt((gen_pkt*)tmp);
    tmp->start--;
    (tmp->start)->policy = htobs(policy);

    return send_hci_cmd((gen_pkt*) tmp,
        OGF_LINK_POLICY,
        OCF_WRITE_DEFAULT_LINK_POLICY,
        WRITE_DEFAULT_LINK_POLICY_CP_SIZE); //plen
	
  }
  command error_t Bluetooth.postSwitchRole(	bdaddr_t	bdaddr,
      uint8_t 	role) 
  {
    switch_role_pkt * tmp = (switch_role_pkt *) call SendQueue.enqueue();
    rst_send_pkt((gen_pkt*)tmp);
    tmp->start--;
    (tmp->start)->bdaddr = bdaddr;
    (tmp->start)->role = role;
    return send_hci_cmd((gen_pkt*) tmp,
        OGF_LINK_POLICY,
        OCF_SWITCH_ROLE,
        SWITCH_ROLE_CP_SIZE); //plen
  }

  command error_t Bluetooth.postChgConnPType(	uint16_t	 handle,
      uint16_t	 pkt_type)
  {
    set_conn_ptype_pkt * tmp = (set_conn_ptype_pkt *) call SendQueue.enqueue();
    rst_send_pkt((gen_pkt*)tmp);
    tmp->start--;
    (tmp->start)->handle = htobs(handle);
    (tmp->start)->pkt_type = htobs(pkt_type);
    return send_hci_cmd((gen_pkt*) tmp,
        OGF_LINK_CTL,
        OCF_SET_CONN_PTYPE,
        SET_CONN_PTYPE_CP_SIZE); //plen
  }
  command error_t Bluetooth.changeLocalName(char s[CHANGE_LOCAL_NAME_CP_SIZE])
  {
    gen_pkt * pkt = call SendQueue.enqueue(); 
    rst_send_pkt(pkt);
    pkt->start = pkt->start - CHANGE_LOCAL_NAME_CP_SIZE;
    memcpy(((change_local_name_cp *) pkt->start)->name,s,sizeof(change_local_name_cp));
 
    return send_hci_cmd((gen_pkt*) pkt,
        OGF_HOST_CTL,
        OCF_CHANGE_LOCAL_NAME,
        CHANGE_LOCAL_NAME_CP_SIZE); //plen
  }
  command error_t Bluetooth.readLocalName()
  {
    gen_pkt * pkt = call SendQueue.enqueue();
    rst_send_pkt(pkt);
    return send_hci_cmd((gen_pkt*) pkt,
        OGF_HOST_CTL,
        OCF_READ_LOCAL_NAME,
        0); //plen
  }
  command error_t Bluetooth.writeClassOfDevice(uint8_t cod[3])
  {
    uint8_t i;
    gen_pkt * pkt = call SendQueue.enqueue(); 
    rst_send_pkt(pkt);
    for (i=0; i<3; i++) {
      * (--(pkt->start)) = cod[i];
    }
    return send_hci_cmd((gen_pkt*) pkt,
        OGF_HOST_CTL,
        OCF_WRITE_CLASS_OF_DEV,
        WRITE_CLASS_OF_DEV_CP_SIZE); //plen
  }

  event gen_pkt* HCIPacket.getPacket()
  {
    return call RecvQueue.enqueue();
  }
  event void HCIPacket.error(errcode e, uint16_t param) {
    signal Bluetooth.error(e, param);
  }

  // Just forward the gotAclData event to recvAcl.
  event error_t HCIPacket.gotAclData(gen_pkt* data) 
  {
    error_t res = signal Bluetooth.recvAcl((hci_acl_data_pkt*) data);
    call RecvQueue.dequeue();
    return res;
  }

  event error_t HCIPacket.gotEvent(gen_pkt* event_buffer) {
    uint16_t opcode1;
    uint16_t *wordArr;
    uint8_t evt, tmp;
    // Short circuit vendor specific events - we get a lot of these =]
    if (((hci_event_hdr*) event_buffer->start)->evt == 0xFF) {
      signal Bluetooth.postComplete(event_buffer);
      return SUCCESS;
    }

    evt = ((hci_event_hdr*) event_buffer->start)->evt;       
    // Skip the event header - we need what's after
    event_buffer->start += sizeof(hci_event_hdr);
    //printf("ev: %.2X\r\n", evt);
    switch (evt) {
      case (EVT_CMD_COMPLETE): //0x0E
 
      // Bluez core/hci_event.c l. 799 handles it acording to the 
      // type of ack'ed command:
      opcode1 = ((evt_cmd_complete*) event_buffer->start)->opcode;
      //printf("cc: %.4X\r\n", opcode1);
      // Move to the return parameters of the command
      event_buffer->start = event_buffer->start + EVT_CMD_COMPLETE_SIZE;
      // Signal the appropriate events that the command is finished
      atomic if (opcode1 == vendor_uart_opcode && init_state){
        init_state = 3;
        post initialize_bt_device();
        signal Bluetooth.postComplete(event_buffer);
      }
      else switch(opcode1) {
        case cmd_opcode_pack(OGF_HOST_CTL, OCF_RESET):
        atomic {
          if (init_state) {
            init_state = 3;
            
            post initialize_bt_device();
          }
        }
        signal Bluetooth.postComplete(event_buffer);
        break;
        case cmd_opcode_pack(OGF_HOST_CTL, OCF_WRITE_INQ_ACTIVITY):
        signal Bluetooth.writeInqActivityComplete(event_buffer);
        break;

        case cmd_opcode_pack(OGF_HOST_CTL, OCF_WRITE_SCAN_ENABLE):
        signal Bluetooth.writeScanEnableComplete((status_pkt*)event_buffer);
        break;
        case cmd_opcode_pack(OGF_INFO_PARAM, OCF_READ_BD_ADDR):
        signal Bluetooth.readBDAddrComplete((read_bd_addr_pkt*)event_buffer);
        break;
        case cmd_opcode_pack(OGF_HOST_CTL, OCF_WRITE_INQUIRY_MODE):
        //printf("rssi: %.4X\r\n", ((status_pkt *) event_buffer)->start->status);
        break;
        case cmd_opcode_pack(OGF_INFO_PARAM, OCF_READ_BUFFER_SIZE):
        {
          uint8_t tmp_state;
 
          atomic tmp_state = init_state;

          if (tmp_state) {
            acl_mtu = ((read_buf_size_pkt*) 
                event_buffer)->start->acl_mtu;
            acl_max_pkt = ((read_buf_size_pkt*)
                event_buffer)->start->acl_max_pkt;
            bt_avail_acl_data = acl_max_pkt;
            atomic init_state = 4;
            signal Bluetooth.postComplete(event_buffer);
            post initialize_bt_device();
          } else {
            signal Bluetooth.readBufSizeComplete((read_buf_size_pkt*)event_buffer);
          }
        }
        break;
        case cmd_opcode_pack(OGF_LINK_CTL, OCF_INQUIRY_CANCEL):
        signal Bluetooth.inquiryCancelComplete((status_pkt*)event_buffer);
        break;
        case cmd_opcode_pack(OGF_LINK_POLICY, OCF_WRITE_DEFAULT_LINK_POLICY):
        signal Bluetooth.writeDefaultLinkPolicyComplete((status_pkt *) event_buffer);
        break;
        case cmd_opcode_pack(OGF_LINK_POLICY, OCF_WRITE_LINK_POLICY):
        signal Bluetooth.writeLinkPolicyComplete((write_link_policy_complete_pkt *)
            event_buffer);
        break;
        case (uint16_t) 0x0000:
        break;
        case cmd_opcode_pack(OGF_LINK_CTL, OCF_PERIODIC_INQ_MODE):
        break;
        case cmd_opcode_pack(OGF_HOST_CTL, OCF_DISCONNECT):
        case cmd_opcode_pack(OGF_HOST_CTL, OCF_CHANGE_LOCAL_NAME):
        case cmd_opcode_pack(OGF_HOST_CTL, OCF_WRITE_CLASS_OF_DEV):
        case cmd_opcode_pack(OGF_LINK_CTL,OCF_SET_CONN_PTYPE):
        case cmd_opcode_pack(OGF_LINK_POLICY, OCF_SWITCH_ROLE):
        // There are seperate event for these!
        signal Bluetooth.postComplete(event_buffer);
        break;
        
        default:
        signal Bluetooth.postComplete(event_buffer);
        signal Bluetooth.error(UNKNOWN_CMD_COMPLETE, opcode1);
      }
      call SendQueue.dequeue();
      if (call SendQueue.size())
        post sendNext();
      break;
      case EVT_CMD_STATUS:
 
      // spec p. 745 opcode=0 means that the device is ready and
      // the no packet buffers is now xxx
 
      // status for a command is also an ack that it was received ok..
      opcode1 = ((evt_cmd_status*) event_buffer->start)->opcode;
      //printf("cs %.2X\r\n", opcode1);
      if (opcode1 != 0x0000) { 
        if (opcode1 != ((hci_command_hdr *) (call SendQueue.head())->start)->opcode) {
          //printf("Command status opcode mismatch");
          signal Bluetooth.error(WRONG_ACK, opcode1);
        }
        else {
          call SendQueue.dequeue();
          if (call SendQueue.size())
            post sendNext();
        }
      } 
      // Return the event_buffer.
      signal Bluetooth.postComplete(event_buffer);
 
      break;
      case EVT_INQUIRY_COMPLETE:
      signal Bluetooth.postComplete(event_buffer);
      signal Bluetooth.inquiryComplete();
 
      break;
      case EVT_INQUIRY_RESULT:
      case EVT_INQUIRY_RSSI_RESULT:
      signal Bluetooth.inquiryResult(event_buffer,evt);
      break;
      case EVT_CONN_COMPLETE:
      signal Bluetooth.connComplete((conn_complete_pkt*) event_buffer);
      break;
      case EVT_CONN_REQUEST:
      signal Bluetooth.connRequest((conn_request_pkt*) event_buffer);
      break;
      case EVT_DISCONN_COMPLETE:
      signal Bluetooth.disconnComplete((disconn_complete_pkt*) event_buffer);
      break;
      case EVT_MAX_SLOTS_CHANGE:
      // This signal is sometimes received when the packet type is
      // changed. Just ignore it for now.
      signal Bluetooth.postComplete(event_buffer);
      break;
      case EVT_HW_ERROR:
      // "Ericsson ASIC Specific HCI Commands and Events for Baeband C
      signal Bluetooth.error(HW_ERROR, 
          ((evt_hw_error*)event_buffer->start)->code);
      signal Bluetooth.postComplete(event_buffer);
      break;
      case EVT_NUM_COMP_PKTS:
      // Record the number of empty buffers
 
      // There is no requirement to have one-to-one relation between
      // the number of completed events and the event complete
 
      tmp = ((num_comp_pkts_pkt*) event_buffer)->start->num_hndl;
      wordArr = (uint16_t*) (((uint8_t*) (event_buffer->start))+1);

      // Returns an array of completed packets
      //
      // Since we are in a task, and all other accesses to
      // bt_avail_acl_data is out of async context, it is safe to use
      // this variable.

      // We need the noCompletedPkts of all connection handles
      for (; tmp > 0 ; tmp--)
        bt_avail_acl_data += wordArr[(tmp<<1) - 1]; 
 
      signal Bluetooth.noCompletedPkts((num_comp_pkts_pkt*) event_buffer);
      break;
      case EVT_VENDOR_SPECIFIC:
      // We don't care if you have an error in your lm implentation =]
      signal Bluetooth.postComplete(event_buffer);
      break;
      case EVT_MODE_CHANGE:
      signal Bluetooth.modeChange((evt_mode_change_pkt*) event_buffer);
      break;
      case EVT_ROLE_CHANGE:
      signal Bluetooth.roleChange((evt_role_change_pkt*) event_buffer);
      break;
      case EVT_CONN_PTYPE_CHANGED:
      signal Bluetooth.connPTypeChange((evt_conn_ptype_changed_pkt*) event_buffer);
      break;
      default: //Uknown event type
      signal Bluetooth.postComplete(event_buffer);
      signal Bluetooth.error(UNKNOWN_EVENT, evt);
      break; 
    }
    call RecvQueue.dequeue();
    //printfflush();
    return SUCCESS;
  }
  task void sendNext() {
    call HCIPacket.putRawPacket(call SendQueue.head());
  }
  async event error_t HCIPacket.putPacketDone(gen_pkt *data) {
    bool need_to_set_rate = FALSE;
    //uint8_t tmp_rate = 0x03; // To keep gcc from warning
    //The data parm is the buffer that we "get back"
    signal Bluetooth.postComplete(data);

    // When esr_uart_rate and init_state is set, we have to change the
    // uart speed between the command and the commmand_complete
    // event. For this we have approx 0.5s
    //
    // This was previously done in a task, but since we're in a hurry,
    // it is better just to do it right away.
//    atomic {
//      if (esr_uart_rate_switch == TRUE && init_state != 0) {
//        need_to_set_rate = TRUE;
//        esr_uart_rate_switch = FALSE;
//        //tmp_rate = esr_uart_rate;
//      }
//    }

    /*if (need_to_set_rate) {
    long j;
    for (j = 0; j <= 1356; j++) { //app 10 ms at 7 Mhz
    asm volatile ("nop"::);
    }
    call HCIPacket.setRate(tmp_rate);
    } */

    return SUCCESS;
  }

  // This means that the BT device is up and ready to receive commands
  event error_t HCIPacket.BT_ready(error_t s) {
    atomic init_state = 1;
    printf("Starting BT Initialisation\r\n");
    post initialize_bt_device();
    printfflush();
    return s;
  }
  //event void Timer0.fired(){
    //	gen_pkt *pkt = call SendQueue.enqueue();
    //	rst_send_pkt(pkt);
    //	send_hci_cmd(pkt, OGF_HOST_CTL, OCF_RESET, 0);
    //call Leds.led3Toggle();
 
  //}

  // We need to negociate a few things before we are ready
  // Run a few commands init_stat=0 means done.
  task void initialize_bt_device() {
    uint8_t tmp_state;
    atomic tmp_state = init_state;

    switch (tmp_state) {
      case 1:
      {
        // Reset the bugger
        gen_pkt *pkt = call SendQueue.enqueue();
        rst_send_pkt(pkt);	
        send_hci_cmd(pkt, OGF_HOST_CTL, OCF_RESET,0);  
        //call Timer0.startPeriodic(5000);
        break;
      }
      case 2: 
      {
        // We're now running 57.6 kBps - let's beef that up a bit!
        // 0x00 ~ 460.8 kbps ~ 57.6 kB/s
        // 0x01 ~ 230.4 kbps ~ 28.8 kB/s
        // 0x02 ~ 115.2 kbps ~ 14.4 kB/s
        // 0x03 ~  57.6 kbps ~  7.2kB/s
        //	uint8_t uart_rate = 0x01;
        gen_pkt* pkt = call SendQueue.enqueue();
        atomic {
          esr_uart_rate_switch = TRUE;
        }
	
        rst_send_pkt(pkt);
        //call BluetoothVendorSpecs.setPacket(pkt);
        //atomic vendor_uart_opcode = call BluetoothVendorSpecs.setPacket(pkt);
        //call HCIPacket.addTransport(pkt, HCI_COMMAND);
      }
      break;
      case 3: 
      {
        // CMD_COMPLETE esr_set_baud_rate

        call Bluetooth.postReadBufSize();
      }
      break;
      case 4: // readBufSizeComplete
      atomic init_state = 0;
      printf("Bluetooth.ready()\r\n");
      signal Bluetooth.ready();
      break;
    }
  }

  async event void RecvQueue.bufferLow(){
 
  }

  async event void SendQueue.bufferLow() {
  }
  async event void RecvQueue.bufferBlown(){
    //DIE EARLY
  }
  async event void SendQueue.bufferBlown(){
    //DIE EARLY
  }
  async event void SendQueue.bufferFull(gen_pkt* bin) {
  }
  async event void RecvQueue.bufferFull(gen_pkt *bin){
 
  }
}
