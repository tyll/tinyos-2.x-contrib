
#include "TestCase.h"

/**
 * @author David Moss
 */
module TestRadioP {
  uses {
    interface TestControl as SetUpOneTime;
    interface TestControl as TearDownOneTime;
    interface Statistics as AveragePktStats;
    interface Statistics as DetectRateStats;
    
    interface TestCase as TestPeriodicDelivery;
    interface LowPowerListening;
    interface SplitControl;
    interface PacketAcknowledgements;
    interface ActiveMessageAddress;
    interface AMSend;
    interface AMPacket;
    interface Receive;
    interface Timer<TMilli>;
    interface Timer<TMilli> as WaitTimer;
    interface SplitControl as RadioPowerControl;
    interface State;
    interface Leds;
  }
}

implementation {

  enum {
    MAX_NODES = 20,
    RUN_TIME = 92160, // 1.5 minutes
    SLEEP_INTERVAL = 512,
  };
  
  
  /** The message transmitter nodes send */
  message_t myMsg;
  
  /** True if this is the transmitter, any node above the driving node */
  bool transmitter;
  
  /** A count of how many times each other node has gotten a message through */
  uint32_t received[MAX_NODES];
  
  /** Total number of other nodes in the area we've seen */
  uint8_t totalSources;
  
  /** Total number of times the radio was physically flipped on */
  uint16_t attempts;
  
  /** Total number of times a packet was detected/received after turning on */
  uint16_t detects;
  
  /** True if the radio physically just turned on and we're waiting for rx */
  bool attempting;
  
  enum {
    S_IDLE,
    S_SETUPONETIME,
    S_RUNNING,
  };

  

  /***************** Prototypes ****************/
  task void send();
  
  /***************** TestControl Events ****************/
  event void SetUpOneTime.run() {
    totalSources = 0;

    transmitter = (call ActiveMessageAddress.amAddress() > 0);
    call LowPowerListening.setRxSleepInterval(&myMsg, SLEEP_INTERVAL);
    call State.forceState(S_SETUPONETIME);
    call LowPowerListening.setLocalSleepInterval(SLEEP_INTERVAL);
    call SplitControl.start();
  }
  
  event void TearDownOneTime.run() {
    call State.toIdle();
    call AMSend.cancel(&myMsg);
    call SplitControl.stop();
  }
  
  /***************** SplitControl Events ****************/
  event void SplitControl.startDone(error_t error) {
    if(transmitter) { 
      call Leds.led1On();
      call State.forceState(S_RUNNING);
      post send();
    }
    call SetUpOneTime.done();
  }
  
  event void SplitControl.stopDone(error_t error) {
    call TearDownOneTime.done();
  }
  
  /***************** Tests ****************/
  event void TestPeriodicDelivery.run() {
    int i;
    for(i = 0; i < MAX_NODES; i++) {
      received[i] = 0;
    }
    attempting = FALSE;
    detects = 0;
    attempts = 0;
    call State.forceState(S_RUNNING);
    call Timer.startOneShot(RUN_TIME);
  }
    
  /***************** AMSend Events ****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    call Leds.led2Off();
    if(call State.isState(S_RUNNING)) {
      // Send another
      call WaitTimer.startOneShot(256);
    }
  }
  
  /***************** RadioPowerControl Events *****************/
  event void RadioPowerControl.startDone(error_t error) {
    if(call State.isState(S_RUNNING)) {
      attempting = TRUE;
      attempts++;
    }
  }
  
  event void RadioPowerControl.stopDone(error_t error) {
  }
  
  /***************** Receive Events ****************/
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    int sourceAddr = call AMPacket.source(msg);
    call Leds.led0Toggle();
    if(call State.isState(S_RUNNING)) {
      if(attempting) {
        // First packet received after the radio turned on.
        attempting = FALSE;
        detects++;
      }
    
      if(received[sourceAddr-1] == 0) {
        totalSources++;
      }
    
      received[sourceAddr-1]++;
    }
    return msg;
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
    float average = 0;
    int i;
    bool pass;
    call State.toIdle();
    
    assertResultIsAbove("No sources detected", 0, totalSources);
    assertResultIsAbove("Unreliable detections", (float) attempts - ((float) 0.05 * (float) attempts), (float) detects);

    for(i = 0; i < totalSources; i++) {
      average += (float) received[i];
    }
    average /= (float) totalSources;
    
    for(i = 0; i < totalSources; i++) {
      pass = TRUE;
      if(average + ((float) 0.1 * average) < received[i]) {
        pass = FALSE;
        assertResultIsBelow("Source is 10% over avg", average + ((float) 0.1 * average), received[i]);
        assertEquals("Previous source was ...", 0, i+1);
      }
      
      if(average - ((float) 0.1 * average) > received[i]) {
        pass = FALSE;
        assertResultIsAbove("Source is 10% below avg", average - ((float) 0.1 * average), received[i]);
        assertEquals("Previous source was ...", 0, i+1);
      }
      
      if(pass) {
        assertSuccess();
      }
    }
    
    call AveragePktStats.log("[Avg # Pkt Rx]", average);
    call DetectRateStats.log("[Detects/Attempts %]", (float) (((float) (detects * 100)) / (float) attempts));
    call TestPeriodicDelivery.done();
  }
  
  event void WaitTimer.fired() {
    post send();
  }
  
  
  /***************** Other Events ****************/
  async event void ActiveMessageAddress.changed() {
  }
  
  /***************** Tasks ****************/
  task void send() {
    call Leds.led2On();
    if(call AMSend.send(0, &myMsg, TOSH_DATA_LENGTH) != SUCCESS) {
      post send();
    }
  }
  
}
