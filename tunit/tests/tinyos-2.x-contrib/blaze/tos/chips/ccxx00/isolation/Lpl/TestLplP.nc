
/**
 * @author David Moss
 */
 
#include "TestCase.h"

module TestLplP {
  provides {
    interface Wor[radio_id_t radioId];
    interface Send as SubSend[radio_id_t radioId];
    interface Receive as SubReceive[radio_id_t radioId];
    interface SplitControlManager[radio_id_t radioId];
    interface RxNotify[radio_id_t radioId];
  }
  
  uses {
    interface LowPowerListening[radio_id_t radioId];
    interface Send[radio_id_t radioId];
    interface SplitControl[radio_id_t radioId];
    interface State;
    interface Leds;
    
    interface TestControl as SetUp;
    interface TestCase as ToggleLplBeforeStart;
    interface TestCase as ToggleLplAfterStart;
    interface TestCase as NoLplSplitControl;
  }
}

implementation {

  uint8_t radioOn;
  uint8_t worEnabled;
  uint16_t event0;
  
  enum {
    S_IDLE,
    S_TOGGLELPLBEFORESTART,
    S_TOGGLELPLAFTERSTART,
    S_NOLPLSPLITCONTROL,
  };
  
  enum {
    CRYSTAL_KHZ = 26000,
  };
  
  /***************** TestControls ****************/
  event void SetUp.run() {
    worEnabled = FALSE;
    radioOn = 0;
    event0 = 0x876B;
    call LowPowerListening.setLocalSleepInterval[0](0);
    call SetUp.done();
  }
  
  
  /***************** TestCases ****************/
  /**
   * Turn on LPL. Start the radio. Stop the radio.
   */
  event void ToggleLplBeforeStart.run() {
    call State.forceState(S_TOGGLELPLBEFORESTART);
    assertEquals("RxInt isn't 0", 0, call LowPowerListening.getLocalSleepInterval[0]());
    call LowPowerListening.setLocalSleepInterval[0](500);
    assertResultIsAbove("RxInt isn't above 495", 495, call LowPowerListening.getLocalSleepInterval[0]());
    assertResultIsBelow("RxInt isn't below 505", 505, call LowPowerListening.getLocalSleepInterval[0]());
    call SplitControl.start[0]();
  }
  
  /**
   * Start the radio. Turn on LPL. Turn off LPL. Stop the radio
   */
  event void ToggleLplAfterStart.run() {
    call State.forceState(S_TOGGLELPLAFTERSTART);
    assertEquals("RxInt isn't 0", 0, call LowPowerListening.getLocalSleepInterval[0]());
    call SplitControl.start[0]();
  }

  event void NoLplSplitControl.run() {
    call State.forceState(S_NOLPLSPLITCONTROL);
    call SplitControl.start[0]();
  }
  
  /***************** SplitControl Events ****************/
  event void SplitControl.startDone[radio_id_t radioId](error_t error) {
    radioOn++;
    switch(call State.getState()) {
    case S_TOGGLELPLBEFORESTART:
      assertTrue("WoR off!", worEnabled);
      call SplitControl.stop[0]();
      break;
      
    case S_TOGGLELPLAFTERSTART:
      assertEquals("WoR on!", 0, worEnabled);
      
      call LowPowerListening.setLocalSleepInterval[0](500);
      assertEquals("Wor off!", 1, worEnabled);

      call LowPowerListening.setLocalSleepInterval[0](0);
      assertEquals("WoR not off!", 0, worEnabled);
      call LowPowerListening.setLocalSleepInterval[0](0);
      assertEquals("WoR not off!", 0, worEnabled);
      
      call SplitControl.stop[0]();

      break;
      
    case S_NOLPLSPLITCONTROL:
      assertEquals("WoR on!", 0, worEnabled);
      call SplitControl.stop[0]();
      break;
      
    default:
      assertFail("Default startDone");
      break;
    
    }
  }
  
  event void SplitControl.stopDone[radio_id_t radioId](error_t error) {
    radioOn--;
    switch(call State.getState()) {
    case S_TOGGLELPLBEFORESTART:
      assertFalse("WoR still on!", worEnabled);
      call ToggleLplBeforeStart.done();
      break;
      
    case S_TOGGLELPLAFTERSTART:
      assertEquals("WoR still on", 0, worEnabled);
      call ToggleLplAfterStart.done();
      break;
      
    case S_NOLPLSPLITCONTROL:
      assertEquals("WoR on", 0, worEnabled);
      call NoLplSplitControl.done();
      break;
      
    default:
      assertFail("Default stopDone");
    }
  }
  
  /***************** Send Events ******************/
  event void Send.sendDone[radio_id_t radioId](message_t *msg, error_t error) {
  }
  
  
  /***************** SubSend Commands ****************/
  command error_t SubSend.send[radio_id_t id](message_t* msg, uint8_t len) {
    signal SubSend.sendDone[id](msg, SUCCESS);
    return SUCCESS;
  }

  command error_t SubSend.cancel[radio_id_t id](message_t* msg) {
    return FAIL;
  }

  command uint8_t SubSend.maxPayloadLength[radio_id_t id]() { 
    return TOSH_DATA_LENGTH;
  }

  command void *SubSend.getPayload[radio_id_t id](message_t* msg, uint8_t len) {
    if(len <= TOSH_DATA_LENGTH) {
      return msg->data;
    } else {
      return NULL;
    }
  }
  
  
  /***************** SplitControlManager Commands ****************/
  command bool SplitControlManager.isOn[radio_id_t radioId]() {
    return radioOn > 0;
  }

  command radio_state_t SplitControlManager.getState[radio_id_t radioId]() {
    return 0;
  }
  
  
  /***************** Wor Commands ****************/

  
  command void Wor.enableWor[radio_id_t radioId](bool on) {
    if(on) {
      worEnabled++;
    } else {
      if(worEnabled == 0) {
        assertFail("Too many WoR disables");
      } else {
        worEnabled--;
      }
    }
    
    signal Wor.stateChange[radioId](on);
  }
  
  command bool Wor.isEnabled[radio_id_t radioId]() {
    return worEnabled > 0;
  }

  command void Wor.synchronizeSettings[radio_id_t radioId]() {
    call Wor.enableWor[radioId](TRUE);
  }
  
  command void Wor.calculateAndSetEvent0[radio_id_t radioId](uint16_t evt0_ms) {
    event0 = ((uint32_t) evt0_ms * (uint32_t) CRYSTAL_KHZ) / 750;
  }

  command uint16_t Wor.getEvent0Ms[radio_id_t radioId]() {
    return (((uint32_t) 750) * ((uint32_t) event0)) / CRYSTAL_KHZ;
  }

  command void Wor.setEvent0[radio_id_t radioId](uint16_t evt0) {
    return;
  }
  
  command void Wor.setRxTime[radio_id_t radioId](uint8_t rxTime) {
    return;
  }

  command void Wor.setRxTimeRssi[radio_id_t radioId](bool sleepOnNoCarrier) {
    return;
  }

  command void Wor.setRxTimeQual[radio_id_t radioId](bool enablePqi) {
    return;
  }

  command void Wor.setEvent1[radio_id_t radioId](uint8_t evt1) {
    return;
  }

  
  /***************** Defaults *****************/
  default event void Wor.stateChange[radio_id_t radioId](bool enabled) {}
  default event void SplitControlManager.stateChange[radio_id_t radioId]() {}
  default event void SubSend.sendDone[radio_id_t radioId](message_t *msg, error_t error) {}
  
}

