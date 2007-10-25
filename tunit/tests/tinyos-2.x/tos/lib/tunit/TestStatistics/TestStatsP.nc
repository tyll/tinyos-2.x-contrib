
/** 
 * @author David Moss
 */
 
#include "TestCase.h"
#include "Statistics.h"

module TestStatsP {
  
  provides {
    interface AMSend as SerialAMSend[am_id_t amId];
  }
  
  uses {
    interface TestControl as SetUpOneTime;
    
    interface TestCase as LogStats;
    interface TestCase as MakeSureAllStatsWereLogged;
    
    interface Statistics as Stats1;
    interface Statistics as Stats2;
    interface Statistics as Stats3;
    interface Statistics as Stats4;
    interface Statistics as Stats5;
    interface Statistics as Stats6;
    interface Statistics as Stats7;
    
    interface Random;
    interface Timer<TMilli>;
    
    interface AMSend as SerialAMSubSend[am_id_t amId];
  }

}

implementation {

  uint8_t stats1;
  uint16_t stats2;
  uint32_t stats3;
  int8_t stats4;
  int16_t stats5;
  int32_t stats6;
  uint8_t stats7;
  
  uint8_t stats1Logged;
  uint8_t stats2Logged;
  uint8_t stats3Logged;
  uint8_t stats4Logged;
  uint8_t stats5Logged;
  uint8_t stats6Logged;
  uint8_t stats7Logged;

  
  
  /**
   * Runs once before the first test can begin.
   */
  event void SetUpOneTime.run() {
    stats1 = 255;
    stats2 = call Random.rand16();
    stats3 = 0x7FFFFFFF;  // Maximum positive value we can log
    stats4 = -5;
    stats5 = -2048;
    stats6 = 0x80000000;  // Maximum negative value we can log
    stats7 = 200;
    
    stats1Logged = 0;
    stats2Logged = 0;
    stats3Logged = 0;
    stats4Logged = 0;
    stats5Logged = 0;
    stats6Logged = 0;
    stats7Logged = 0;
    
    // BE SURE TO CALL BACK AND NOTIFY SetUpOneTime IS DONE!
    call Timer.startOneShot(2048);
  }
  
  event void Timer.fired() {
    call SetUpOneTime.done();
  }
    
  /**
   * Log each statistic in a single-phase manner (even though stats are
   * really split-phase, tunit takes care of that automatically).
   * 
   * All stats logged in this manner should be done logging
   * automatically before the next test is allowed to run.
   */
  event void LogStats.run() {
    assertSuccess();
    call Stats1.log("255", stats1);
    call Stats2.log("Random-16", stats2);
    call Stats3.log("int32=uint32(0x7FFFFFFF)", stats3);
    call Stats4.log("-5", stats4);
    call Stats5.log("-2048", stats5);
    call Stats6.log("int32=int32(0x80000000)", stats6);
    call Stats7.log("200", stats7);
    call LogStats.done();
  }
  
  event void MakeSureAllStatsWereLogged.run() {
    assertEquals("Stats1 logs", 1, stats1Logged);
    assertEquals("Stats2 logs", 1, stats2Logged);
    assertEquals("Stats3 logs", 1, stats3Logged);
    assertEquals("Stats4 logs", 1, stats4Logged);
    assertEquals("Stats5 logs", 1, stats5Logged);
    assertEquals("Stats6 logs", 1, stats6Logged);
    assertEquals("Stats7 logs", 1, stats7Logged);
    
    call MakeSureAllStatsWereLogged.done();
  }
  
  
  /***************** SerialAMSend Commands ****************/
    command error_t SerialAMSend.send[am_id_t id](am_addr_t dest,
					  message_t* msg,
					  uint8_t len) {

    StatisticsMsg *outboundStats;
    if(id == AM_STATISTICSMSG) {
      // Intercepted an outbound statistics message
      outboundStats = (StatisticsMsg *) call SerialAMSubSend.getPayload[id](msg, TOSH_DATA_LENGTH);
      
      switch(outboundStats->statsId) {
        case 0:
          stats1Logged++;
          break;
          
        case 1:
          stats2Logged++;
          break;
          
        case 2: 
          stats3Logged++;
          break;
          
        case 3: 
          stats4Logged++;
          break;
        
        case 4: 
          stats5Logged++;
          break;
          
        case 5:
          stats6Logged++;
          break;
          
        case 6:
          stats7Logged++;
          break;
          
        default:
          assertResultIsBelow("OOB Stats Index", 7, outboundStats->statsId);
          break;
      }
    }

    return call SerialAMSubSend.send[id](dest, msg, len);
  }

  command error_t SerialAMSend.cancel[am_id_t id](message_t* msg) {
    return call SerialAMSubSend.cancel[id](msg);
  }

  command uint8_t SerialAMSend.maxPayloadLength[am_id_t id]() {
    return call SerialAMSubSend.maxPayloadLength[id]();
  }

  command void* SerialAMSend.getPayload[am_id_t id](message_t* m, uint8_t len) {
    return call SerialAMSubSend.getPayload[id](m, len);
  }
  
  /***************** SerialAMSubSend Events ****************/
  event void SerialAMSubSend.sendDone[am_id_t id](message_t* msg, error_t result) {
    signal SerialAMSend.sendDone[id](msg, result);
  }
  
}
