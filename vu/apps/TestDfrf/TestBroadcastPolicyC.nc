module TestBroadcastPolicyC {
  uses {
    interface Boot;
    interface SplitControl as AMControl;
    interface StdControl as DfrfControl;
    interface DfrfSend<counter_packet_t>;
    interface DfrfReceive<counter_packet_t>;
    interface Timer<TMilli>;
    interface AMPacket;
    interface Leds;
  }
} implementation {

  uint8_t cnt = 0;

  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t error_code) {
    if(call DfrfControl.start() == SUCCESS) {
      if(call AMPacket.address() == 1) {
        dbg("TestBroadcastPolicy","Starting send timer\n");
        call Timer.startPeriodic(768);
      }
    } else {
        call Leds.led0On();
        dbg("TestBroadcastPolicy","Error starting Dfrf\n");
    }
  }

  event void AMControl.stopDone(error_t error_code) {}

  task void sendPacket() {
    counter_packet_t packet;
    uint32_t timeStamp = call Timer.getNow();

    packet.cnt = cnt;
    packet.src = call AMPacket.address() & 0xff;
    call DfrfSend.send(&packet, timeStamp);
    dbg("TestBroadcastPolicy","Sent packet %d @ %d\n", cnt, timeStamp);

    cnt++;
    if((cnt % 4) != 0)
      post sendPacket();
  }

  event void Timer.fired() {
    post sendPacket();
  }

  event bool DfrfReceive.receive(counter_packet_t* packet, uint32_t timeStamp) {

    dbg("TestBroadcastPolicy","Received packet %d @ %d\n", packet->cnt, timeStamp);
    call Leds.set(packet->cnt);
    return SUCCESS;
  }

}
