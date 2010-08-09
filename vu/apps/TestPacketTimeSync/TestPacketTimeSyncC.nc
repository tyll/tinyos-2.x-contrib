#include "Timer.h"
#include "TestPacketTimeSync.h"

module TestPacketTimeSyncC {
  uses {
    interface Leds;
    interface Boot;
    interface Receive as PingReceive;
    interface AMSend as PongAMSend;
    interface AMPacket;
    interface Timer<TMilli> as MilliTimer;
    interface SplitControl as AMControl;
    interface Packet;

#if defined(TIMESYNC_T32KHZ)    
    interface PacketTimeStamp<T32khz,uint32_t>;
    interface TimeSyncPacket<T32khz,uint32_t>;
    interface TimeSyncAMSend<T32khz,uint32_t> as PingAMSend;
    interface LocalTime<T32khz>;
#elif  defined(TIMESYNC_TMICRO)
    interface PacketTimeStamp<TMicro,uint32_t>;
    interface TimeSyncPacket<TMicro,uint32_t>;
    interface TimeSyncAMSend<TMicro,uint32_t> as PingAMSend;
    interface LocalTime<TMicro>;    
#else
    interface PacketTimeStamp<TMilli,uint32_t>;
    interface TimeSyncPacket<TMilli,uint32_t>;
    interface TimeSyncAMSend<TMilli,uint32_t> as PingAMSend;
    interface LocalTime<TMilli>;    
#endif        

  }
}
implementation {

  message_t ping_packet;
  message_t pong_packet;

  bool locked;
  uint32_t counter = 0;

  event void Boot.booted() {
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
          call MilliTimer.startPeriodic(1024/4);
    }
#if defined(PINGER)
    else {
      call MilliTimer.startPeriodic(1024/4);
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
      uint32_t eventTime = call LocalTime.get();
      if (ping == NULL) {
        return;
      }
      ping->pinger = TOS_NODE_ID;
      ping->ping_counter = counter++;
      ping->ping_event_time = eventTime;
      if (call PingAMSend.send(AM_BROADCAST_ADDR, &ping_packet, sizeof(ping_msg_t), eventTime) == SUCCESS) {
        dbg("TestPacketTimeSync", "%d: TestPacketTimeSync: Sending ping #%d with event time %d\n", call LocalTime.get(), ping->ping_counter, eventTime);
        call Leds.led0On();
	      locked = TRUE;
      }
    }
  }

  event message_t* PingReceive.receive(message_t* bufPtr,
				   void* payload, uint8_t len) {
    call Leds.led2Toggle();

    dbg("TestPacketTimeSync", "%d: TestPacketTimeSync: Received ping of size %d (%d expected)\n", call LocalTime.get(), len, sizeof(ping_msg_t)+4);

    if (locked /*|| len != sizeof(ping_msg_t)*/) {
      return bufPtr;
    } else {
      ping_msg_t* ping = (ping_msg_t*)payload;
      pong_msg_t* pong = (pong_msg_t*)call Packet.getPayload(&pong_packet, sizeof(pong_msg_t));
      pong->ponger = TOS_NODE_ID;
      pong->pinger = ping->pinger;
      pong->ping_counter = ping->ping_counter;
      pong->ping_event_time = call TimeSyncPacket.eventTime(bufPtr);
      pong->ping_rx_timestamp_is_valid = call PacketTimeStamp.isValid(bufPtr);
      pong->ping_event_time_is_valid = call TimeSyncPacket.isValid(bufPtr);
      if(pong->ping_rx_timestamp_is_valid > 0) pong->ping_rx_timestamp_is_valid = 1;
      pong->ping_rx_timestamp = call PacketTimeStamp.timestamp(bufPtr);

      dbg("TestPacketTimeSync", "%d: TestPacketTimeSync: Received ping #%d with event time %d\n", call LocalTime.get(), ping->ping_counter, pong->ping_event_time);


      if (call PongAMSend.send(AM_BROADCAST_ADDR, &pong_packet, sizeof(pong_msg_t)) == SUCCESS) {
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
