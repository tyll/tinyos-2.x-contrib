#include "Timer.h"
#include "TestPacketTimestamp.h"

module TestPacketTimestampC {
  uses {
    interface Leds;
    interface Boot;
    interface Receive as PingReceive;
    interface AMSend as PingAMSend;
    interface AMSend as PongAMSend;
    interface AMPacket;
    interface Timer<TMilli> as MilliTimer;
#if defined(TIMESYNC_T32KHZ)    
    interface PacketTimeStamp<T32khz,uint32_t>;
#elif  defined(TIMESYNC_TMICRO)
    interface PacketTimeStamp<TMicro,uint32_t>;
#else
    interface PacketTimeStamp<TMilli,uint32_t>;
#endif        
    interface SplitControl as AMControl;
    interface Packet;

  }
}
implementation {

  message_t ping_packet;
  message_t pong_packet;

  bool locked;
  uint32_t counter = 0;

  event void Boot.booted() {
    call Leds.led0On();
    memset(&ping_packet, 0, sizeof(ping_packet));
    memset(&pong_packet, 0, sizeof(pong_packet));
    call AMControl.start();
  }

  task void nullTask() {
    // just to prevent the MCU from sleeping
    post nullTask();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
    if(call AMPacket.address() == 1) {
          call MilliTimer.startPeriodic(512);
    }
#if defined(PINGER)
    else {
      call MilliTimer.startPeriodic(100);
    }
#endif

#if !defined(TOSSIM)
      post nullTask();
#endif
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
    // do nothing
  }

  event void MilliTimer.fired() {
    call Leds.led1Toggle();
    if (locked) {
      return;
    } else {
      ping_msg_t* ping = (ping_msg_t*)call Packet.getPayload(&ping_packet, sizeof(ping_msg_t));
      if (ping == NULL) {
        return;
      }
      ping->pinger = TOS_NODE_ID;
      ping->ping_counter = counter++;
      if (call PingAMSend.send(AM_BROADCAST_ADDR, &ping_packet, sizeof(ping_msg_t)) == SUCCESS) {
        dbg("TestPacketTimestamp", "%d: TestPacketTimestamp: Sending ping #%d at localtime %d\n", call MilliTimer.getNow(), ping->ping_counter, call MilliTimer.getNow());
        call Leds.led0On();
	      locked = TRUE;
      }
    }
  }

  event message_t* PingReceive.receive(message_t* bufPtr,
				   void* payload, uint8_t len) {
    call Leds.led2Toggle();
    if (locked || len != sizeof(ping_msg_t)) {
      return bufPtr;
    } else {
      ping_msg_t* ping = (ping_msg_t*)payload;
      pong_msg_t* pong = (pong_msg_t*)call Packet.getPayload(&pong_packet, sizeof(pong_msg_t));
      pong->ponger = TOS_NODE_ID;
      pong->pinger = ping->pinger;
      pong->ping_counter = ping->ping_counter;
      pong->ping_rx_timestamp_is_valid = call PacketTimeStamp.isValid(bufPtr);
      if(pong->ping_rx_timestamp_is_valid > 0) pong->ping_rx_timestamp_is_valid = 1;
      pong->ping_rx_timestamp = call PacketTimeStamp.timestamp(bufPtr);

      dbg("TestPacketTimestamp", "%d: TestPacketTimestamp: Received ping #%d at localtime %d\n", call MilliTimer.getNow(), ping->ping_counter, call PacketTimeStamp.timestamp(bufPtr));


      if (call PongAMSend.send(AM_BROADCAST_ADDR, &pong_packet, sizeof(pong_msg_t)) == SUCCESS) {
//        dbg("TestPacketTimestamp", "TestPacketTimestamp: Sending pong #%d\n", pong->ping_counter);
        call Leds.led0On();
      	locked = TRUE;
      }

      return bufPtr;
    }
  }

  event void PingAMSend.sendDone(message_t* bufPtr, error_t error) {
    if (&ping_packet == bufPtr) {
      ping_msg_t* ping = (ping_msg_t*)call Packet.getPayload(&ping_packet, sizeof(ping_msg_t));
      ping->prev_ping_counter = ping->ping_counter;
      ping->prev_ping_tx_timestamp_is_valid = call PacketTimeStamp.isValid(bufPtr);
      if(ping->prev_ping_tx_timestamp_is_valid > 0) ping->prev_ping_tx_timestamp_is_valid = 1;
      ping->prev_ping_tx_timestamp = call PacketTimeStamp.timestamp(bufPtr);

      dbg("TestPacketTimestamp", "%d: TestPacketTimestamp: Done sending ping #%d at localtime %d\n", call MilliTimer.getNow(), ping->ping_counter, call PacketTimeStamp.timestamp(bufPtr));

      call Leds.led0Off();
      locked = FALSE;
    }
  }

  event void PongAMSend.sendDone(message_t* bufPtr, error_t error) {
    if (&pong_packet == bufPtr) {
      call Leds.led0Off();
      locked = FALSE;
    }
  }
}
