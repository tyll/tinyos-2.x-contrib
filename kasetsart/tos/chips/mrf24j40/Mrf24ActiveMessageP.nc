#include "mrf24.h"
#include "IEEE802154.h"

/**
 * Active message implementation on top of the MRF24J40 radio.
 *
 * @todo
 * Make a better HPL for interacting with MRF24J40 radio
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

#define RECEIVE_HISTORY_SIZE  4

module Mrf24ActiveMessageP
{
  provides
  {
    interface Init;
    interface SplitControl;
    interface AMSend[am_id_t id];
    interface Receive[am_id_t id];
    interface Receive as Snoop[am_id_t id];
    interface AMPacket;
    interface Packet;
    interface PacketAcknowledgements as Acks;
    interface SendNotifier[am_id_t id];
  }

  uses
  {
    interface Random;
    interface Mrf24Register as Reg;
    interface Resource;
    interface ActiveMessageAddress;
    interface Mrf24PacketBody as PacketBody;
    interface GpioInterrupt as Interrupt;
    //interface Leds;
  }
}
implementation
{
  typedef enum send_state_enum {
    S_IDLE,
    S_SENDING
  } send_state_t;

  /**
   * @typedef
   * Keeps information of received messages for detecting duplicate frames
   */
  typedef struct
  {
    am_addr_t source;  ///< Message's source
    uint8_t frameId;   ///< Message's frame ID
  } ReceiveInfo;

  uint8_t m_frame_id;
  bool m_sending;
  message_t* m_p_txmsg;
  message_t  m_rxbuf;
  message_t* m_p_rxbuf;
  ReceiveInfo m_recvHistory[RECEIVE_HISTORY_SIZE];
  uint8_t m_prevHistIndex;
  uint8_t m_histIndex;

  //////////////////////////////////////
  // Utility functions
  //////////////////////////////////////
  /**
   * Write bytes to MRF24J40's RAM.
   * @param startRamAddr Starting address to write to
   * @param data Pointer to buffer storing data to write
   * @param len Number of bytes to read
   */
  void writeToMrf24Ram(uint16_t startRamAddr, uint8_t* data, uint8_t len)
  {
    uint8_t i;
    for (i = 0; i < len; i++)
      call Reg.writeLongAddr(startRamAddr+i, data[i]);
  }

  /**
   * Read bytes from MRF24J40's RAM into uC's RAM.
   * @param startRamAddr Starting address to read from
   * @param data Pointer to buffer for storing data
   * @param len Number of bytes to read
   */
  void readFromMrf24Ram(uint16_t startRamAddr, uint8_t* data, uint8_t len)
  {
    uint8_t i;
    for (i = 0; i < len; i++)
      data[i] = call Reg.readLongAddr(startRamAddr+i);
  }

  /**
   * Initialize data structures and variables that keep history of received
   * frames for duplicate checking
   */
  void initReceiveHistory()
  {
    uint8_t i;
    for (i = 0; i < RECEIVE_HISTORY_SIZE; i++)
    {
      m_recvHistory[i].source = AM_BROADCAST_ADDR;
      m_recvHistory[i].frameId = 0;
    }
    m_prevHistIndex = 0xFF;
    m_histIndex = 0;
  }


  /**
   * Records frame information and checks for duplicates.
   * @param src Address of the sender of this frame
   * @param frameId Frame ID (i.e., sequence number) of this frame
   * @retval 0 This frame is a duplicate
   * @retval 1 This frame is new
   */
  uint8_t recordAndCheckDuplicate(am_addr_t src, uint8_t frameId)
  {
    uint8_t newSource = 0, newFrame = 0;

    // Check if a frame with the same source and ID has been previously seen
    if (m_prevHistIndex == 0xFF) // history is empty
      newSource = 1;
    else
    {
      // See if this frame comes from the same source as previous
      if (m_recvHistory[m_prevHistIndex].source != src)
      {
        // If not, scan the history to see if this source has been seen
        newSource = 1;
        for (m_prevHistIndex = 0;
            m_prevHistIndex < RECEIVE_HISTORY_SIZE;
            m_prevHistIndex++)
        {
          if (m_recvHistory[m_prevHistIndex].source == src)
          {
            // Seen this source before
            newSource = 0;
            break;
          }
        }
      }
      else
        newSource = 0;

      // At this point if the source has been seen, m_prevHistIndex must
      // already point to the corresponding history slot, so check that slot
      // to see if the frame is new
      if (!newSource)
        newFrame = (m_recvHistory[m_prevHistIndex].frameId != frameId);
    }

    if (newSource)
    {
      m_recvHistory[m_histIndex].source = src;
      m_prevHistIndex = m_histIndex;
      m_histIndex = (m_histIndex+1) % RECEIVE_HISTORY_SIZE;
    }
    m_recvHistory[m_prevHistIndex].frameId = frameId;

    return (newSource || newFrame);
  }

  //////////////////////////////////////
  // Init
  //////////////////////////////////////
  command error_t Init.init()
  {
    m_frame_id = call Random.rand16();
    m_sending  = FALSE;
    m_p_rxbuf  = &m_rxbuf;
    return SUCCESS;
  }

  //////////////////////////////////////
  // SplitControl
  //////////////////////////////////////
  command error_t SplitControl.start()
  {
    call Resource.request();
    return SUCCESS;
  }

  command error_t SplitControl.stop() { }

  //////////////////////////////////////
  // Resource
  //////////////////////////////////////
  event void Resource.granted()
  {
    // Initialize the MRF24J40 chip once SPI resource is granted
    uint16_t addr = call ActiveMessageAddress.amAddress();
    uint16_t panId = call ActiveMessageAddress.amGroup();

    call Reg.writeShortAddr(SOFTRST,0x07); //Perform software reset
    call Reg.writeShortAddr(PACON2,0x98);  //FIFOEN = 1, TXONTS = 0x6
    call Reg.writeShortAddr(TXSTBL,0x95);  //RFSTBL = 0x9
    call Reg.writeLongAddr(RFCON1,0x01);   //VCOOPT = 0x1
    call Reg.writeLongAddr(RFCON2,0x80);   //PLLEN = 1
    call Reg.writeLongAddr(RFCON6,0x90);   //TXFIL = 1,20MRECVR = 1
    call Reg.writeLongAddr(RFCON7,0x80);   //SLPCLKSEL = 0x2
    call Reg.writeLongAddr(RFCON8,0x10);   //RFVCO = 1
    call Reg.writeLongAddr(SLPCON1,0x21);  //CLKOUTEN = 1,SLPCLKDIV = 0x1
    call Reg.writeShortAddr(ORDER,0xFF);   //BO and SO = 15
    call Reg.writeShortAddr(RXMCR,0x00);   //Configure as device
    call Reg.writeShortAddr(BBREG2,0x80);  //Set CCA mode to ED
    call Reg.writeShortAddr(CCAEDTH,0x60); //Set CCA ED threshold
    call Reg.writeShortAddr(BBREG6,0x40);  //Set appended RSSI value to FIFO
    call Reg.writeShortAddr(INTCON,0xF6);  //Enable RX and TX interrupt

    //Set default channel, PAN-ID, and address
    call Reg.writeLongAddr(RFCON0,CHANNEL(MRF24_DEF_CHANNEL));
    call Reg.writeShortAddr(PANIDL,LOW_BYTE(panId));
    call Reg.writeShortAddr(PANIDH,HIGH_BYTE(panId));
    call Reg.writeShortAddr(SADRL,LOW_BYTE(addr));
    call Reg.writeShortAddr(SADRH,HIGH_BYTE(addr));

    call Reg.writeShortAddr(RFCTL,0x04);          //Reset state machine
    call Reg.writeShortAddr(RFCTL,0x00);                    

    // Enable interrupt pin
    call Interrupt.enableFallingEdge();

    signal SplitControl.startDone(SUCCESS);
  }

  //////////////////////////////////////
  // AMSend
  //////////////////////////////////////
  command error_t AMSend.send[am_id_t id](
      am_addr_t addr,
      message_t* msg,
      uint8_t len) 
  {
    uint8_t header_len, frame_len;
    mrf24_header_t* header;
    mrf24_metadata_t* metadata;

    if (m_sending) return EBUSY;

    m_sending = TRUE;
    header   = call PacketBody.getHeader(msg);
    metadata = call PacketBody.getMetadata(msg);
    header->type = id;
    header->dst  = addr;
    //header->dstpan = call AMPacket.group(msg);
    header->dstpan = call AMPacket.localGroup();
    header->src = call AMPacket.address();

    // prepare the rest of the header
#ifdef MRF24_IFRAME_TYPE
    header_len = sizeof(mrf24_header_t) - 2; // exclude network & type fields
    frame_len  = header_len + 2 + len;
    header->network = TINYOS_6LOWPAN_NETWORK_ID;
#else
    header_len = sizeof(mrf24_header_t) - 1; // exclude type field
    frame_len  = header_len + 1 + len;
#endif
    header->frame_ctrl |=
      ( IEEE154_TYPE_DATA << IEEE154_FCF_FRAME_TYPE ) |
      ( 1 << IEEE154_FCF_INTRAPAN ) |
      ( IEEE154_ADDR_SHORT << IEEE154_FCF_DEST_ADDR_MODE ) |
      ( IEEE154_ADDR_SHORT << IEEE154_FCF_SRC_ADDR_MODE );
    header->frame_id = m_frame_id++;

    // prepare meta data
    metadata->lqi         = 0;
    metadata->rssi        = 0;
    metadata->num_retries = 0;
    metadata->cca_fail    = 0;

    // inform other interested modules
    signal SendNotifier.aboutToSend[id](addr, msg);

    // Load header's and frame's lengths into TX Normal FIFO
    call Reg.writeLongAddr(MRF24_TX_NORMAL_FIFO,   header_len);
    call Reg.writeLongAddr(MRF24_TX_NORMAL_FIFO+1, frame_len);

    // Load IEEE802.15.4 header into TX Normal FIFO
    writeToMrf24Ram(
        MRF24_TX_NORMAL_FIFO+2, (uint8_t*)header, sizeof(mrf24_header_t));

    // Load data into TX Normal FIFO
    writeToMrf24Ram(MRF24_TX_NORMAL_FIFO+2+sizeof(mrf24_header_t),
        (uint8_t*)msg->data, len);

    // Tell MRF24J40 to start transmitting
    if ( (addr != AM_BROADCAST_ADDR)
        && (header->frame_ctrl & (1 << IEEE154_FCF_ACK_REQ)) )
    {
      // Not a broadcast and ACK is requested
      call Reg.writeShortAddr(TXNCON, 0x05);
    }
    else
    {
      // Broadcast or ACK is not requested
      call Reg.writeShortAddr(TXNCON, 0x01);
    }

    // keep the message pointer for later inspection
    atomic m_p_txmsg = msg;

    return SUCCESS;
  }

  command error_t AMSend.cancel[am_id_t id](message_t* msg)
  {
    return FAIL;  // currently not supported
  }

  command uint8_t AMSend.maxPayloadLength[am_id_t id]()
  {
    return call Packet.maxPayloadLength();
  }

  command void* AMSend.getPayload[am_id_t id](message_t* msg, uint8_t len)
  {
    return call Packet.getPayload(msg, len);
  }

  default event void AMSend.sendDone[uint8_t id](message_t* msg, error_t error) { }

  //////////////////////////////////////
  // AMPacket
  //////////////////////////////////////
  command am_addr_t AMPacket.address()
  {
    return call ActiveMessageAddress.amAddress();
  }

  command am_addr_t AMPacket.destination(message_t* amsg)
  {
    return (call PacketBody.getHeader(amsg))->dst;
  }

  command am_addr_t AMPacket.source(message_t* amsg)
  {
    return (call PacketBody.getHeader(amsg))->src;
  }

  command void AMPacket.setDestination(message_t* amsg, am_addr_t addr)
  {
    (call PacketBody.getHeader(amsg))->dst = addr;
  }

  command void AMPacket.setSource(message_t* amsg, am_addr_t addr)
  {
    (call PacketBody.getHeader(amsg))->src = addr;
  }

  command bool AMPacket.isForMe(message_t* amsg)
  {
    return (call AMPacket.destination(amsg) == call AMPacket.address() ||
      call AMPacket.destination(amsg) == AM_BROADCAST_ADDR);
  }

  command am_id_t AMPacket.type(message_t* amsg)
  {
    return (call PacketBody.getHeader(amsg))->type;
  }

  command void AMPacket.setType(message_t* amsg, am_id_t t)
  {
    (call PacketBody.getHeader(amsg))->type = t;
  }

  command am_group_t AMPacket.group(message_t* amsg)
  {
    return (call PacketBody.getHeader(amsg))->dstpan;
  }

  command void AMPacket.setGroup(message_t* amsg, am_group_t grp)
  {
    (call PacketBody.getHeader(amsg))->dstpan = grp;
  }

  command am_group_t AMPacket.localGroup()
  {
    return call ActiveMessageAddress.amGroup();
  }

  //////////////////////////////////////
  // Packet
  //////////////////////////////////////
  command void Packet.clear(message_t* msg)
  {
    memset(call PacketBody.getHeader(msg), 0x0, sizeof(mrf24_header_t));
    memset(call PacketBody.getMetadata(msg), 0x0, sizeof(mrf24_metadata_t));
  }

  command uint8_t Packet.payloadLength(message_t* msg)
  {
    return (call PacketBody.getMetadata(msg))->payload_len;
  }

  command void Packet.setPayloadLength(message_t* msg, uint8_t len)
  {
    (call PacketBody.getMetadata(msg))->payload_len = len;
  }

  command uint8_t Packet.maxPayloadLength()
  {
    return TOSH_DATA_LENGTH;
  }

  command void* Packet.getPayload(message_t* msg, uint8_t len)
  {
    if (len <= call Packet.maxPayloadLength())
      return (void* COUNT_NOK(len))msg->data;
    else
      return NULL;
  }
  
  //////////////////////////////////////
  // Acks
  //////////////////////////////////////
  async command error_t Acks.requestAck( message_t* msg )
  {
    (call PacketBody.getHeader(msg))->frame_ctrl |= (1 << IEEE154_FCF_ACK_REQ);
    return SUCCESS;
  }

  async command error_t Acks.noAck( message_t* msg )
  {
    (call PacketBody.getHeader(msg))->frame_ctrl &= ~(1 << IEEE154_FCF_ACK_REQ);
    return SUCCESS;
  }

  async command bool Acks.wasAcked(message_t* msg)
  {
    return (call PacketBody.getMetadata(msg))->acked;
  }

  //////////////////////////////////////
  // ActiveMessageAddress
  //////////////////////////////////////
  async event void ActiveMessageAddress.changed()
  { 
    // TODO
    // to be implemented after support for MRF24J40's run-time settings is
    // done
  }


  //////////////////////////////////////
  // SendNotifier
  //////////////////////////////////////
  default event void SendNotifier.aboutToSend[am_id_t amId](
      am_addr_t addr, message_t *msg) { } 

  //////////////////////////////////////
  // Receive
  //////////////////////////////////////
  default event message_t* Receive.receive[am_id_t amId](
      message_t* msg, void* payload, uint8_t len) 
  {
    return msg;
  }

  //////////////////////////////////////
  // Interrupt
  //////////////////////////////////////
  task void sendDone()
  {
    // Read and put tx status info in the metadata part of the message
    mrf24_header_t* hdr;
    mrf24_metadata_t* meta;
    Mrf24_TXSTAT_t txstat;

    txstat.flat = call Reg.readShortAddr(TXSTAT);

    hdr  = call PacketBody.getHeader(m_p_txmsg);
    meta = call PacketBody.getMetadata(m_p_txmsg);

    // fill metadata with tx status
    meta->num_retries = txstat.bits.txnretry;
    meta->cca_fail    = txstat.bits.ccafail;
    if ( (hdr->frame_ctrl & (1 << IEEE154_FCF_ACK_REQ))
        && txstat.bits.txnstat == 0)
      meta->acked = TRUE;

    m_sending = FALSE;

    if (txstat.bits.txnstat) // failed
      signal AMSend.sendDone[hdr->type](m_p_txmsg, FAIL);
    else
      signal AMSend.sendDone[hdr->type](m_p_txmsg, SUCCESS);
  }

  task void readRxFifo()
  {
    uint8_t frameLen, payloadLen;
    uint16_t fifoAddr;
    mrf24_header_t* header;
    mrf24_metadata_t* metadata;

    header   = call PacketBody.getHeader(m_p_rxbuf);
    metadata = call PacketBody.getMetadata(m_p_rxbuf);

    // read the entire RX frame's length
    frameLen = call Reg.readLongAddr(MRF24_RX_NORMAL_FIFO);

    // read the header up until the destination address field
    readFromMrf24Ram(
        MRF24_RX_NORMAL_FIFO+1,
        (uint8_t*)header, 
        offsetof(mrf24_header_t, dst) + sizeof(uint16_t));

    // TODO: make sure we check for duplicates and ignore them

    // calculate the length of payload
    //   payloadLen = frameLen - headerLen - 2 (LQI/RSSI)
    payloadLen = frameLen - sizeof(mrf24_header_t) - 2;

    // determine FIFO address for src addr field,
    fifoAddr = MRF24_RX_NORMAL_FIFO + offsetof(mrf24_header_t, src) + 1;
    if (!(header->frame_ctrl & (1 << IEEE154_FCF_INTRAPAN)))
      fifoAddr += 2; // src PAN is included when intrapan flag is not set

    // read the source address
    readFromMrf24Ram(fifoAddr, (uint8_t*)&header->src, sizeof(header->src));
    fifoAddr += sizeof(header->src);

    // check for duplicates and ignore them
    if (!recordAndCheckDuplicate(header->src, header->frame_id))
    {
      // reenable MRF24J40's interrupt and packet reception
      call Reg.writeShortAddr(INTCON,0xF6);  
      call Reg.writeShortAddr(BBREG1,0x00);
      return;
    }

#ifdef MRF24_IFRAME_TYPE
    // TODO:
    // for interoperability, we should adaptively determine the existence of
    // this field by matching the field's value against TinyOS's 6LOWPAN
    // Network Id
 
    // read 6LOWPAN network ID
    header->network = call Reg.readLongAddr(fifoAddr++);
#endif

    // read AM type
    header->type = call Reg.readLongAddr(fifoAddr++);

    // read payload
    readFromMrf24Ram(fifoAddr, (uint8_t*)m_p_rxbuf->data, payloadLen);
    fifoAddr += payloadLen;

    // store RSSI and LQI in metadata
    fifoAddr += 2;  // skip FCS
    metadata->lqi  = call Reg.readLongAddr(fifoAddr++);
    metadata->rssi = call Reg.readLongAddr(fifoAddr++);

    // reenable MRF24J40's interrupt and packet reception
    call Reg.writeShortAddr(INTCON,0xF6);  
    call Reg.writeShortAddr(BBREG1,0x00);

    // inform the client module(s)
    m_p_rxbuf = signal Receive.receive[header->type](
        m_p_rxbuf, m_p_rxbuf->data, payloadLen);
  }

  async event void Interrupt.fired()
  {
    Mrf24_INTSTAT_t intstat;
    
    intstat.flat = call Reg.readShortAddr(INTSTAT);

    // TX Normal FIFO interrupt
    if (intstat.bits.txnif)
    {
      post sendDone();
    }

    // RX FIFO interrupt
    if (intstat.bits.rxif)
    {
      call Reg.writeShortAddr(INTCON,0xFF); //Disable RX and TX interrupt of MRF24J40
      call Reg.writeShortAddr(BBREG1,0x04); //Disable receiving packets off the air

      post readRxFifo(); // start reading data
    }
  }
}

