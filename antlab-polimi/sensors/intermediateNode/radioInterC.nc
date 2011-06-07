/*
 * Author: Stefano Paniga
 * contact: stefano.paniga@mail.polimi.it
 */
#include "config.h"


configuration radioInterC {}
implementation {

  components MainC, radioInterM as App, LedsC, CC2420ActiveMessageC;
  components ActiveMessageC as RadioAMC;
  components new AMReceiverC(AM_RADIO_IMGSTAT_R) as ImgstatRcv;  
  components new AMReceiverC(AM_RADIO_PHOTO_R) as PhotoRcv;
  components new AMReceiverC(AM_RADIO_VIDEO_R) as VideoRcv;  
  components new AMReceiverC(AM_RADIO_CMD_R) as CmdRcv;  
  components new AMSenderC(AM_RADIO_IMGSTAT_S) as ImgstatSend;
  components new AMSenderC(AM_RADIO_PHOTO_S) as PhotoSend;
  components new AMSenderC(AM_RADIO_VIDEO_S) as VideoSend;
  components new AMSenderC(AM_RADIO_CMD_S) as CmdSend;
//test
#ifdef TEST_ENV
  components new AMReceiverC(AM_RADIO_PKT_TEST_R) as TestPktRcv;
  components new AMSenderC(AM_RADIO_PKT_TEST_S) as TestPktSend;
  components new AMReceiverC(AM_RADIO_TIME_TEST_R) as TestTimeRcv;
  components new AMSenderC(AM_RADIO_TIME_TEST_S) as TestTimeSend;
  components new AMSenderC(AM_RADIO_QUEUE_TEST) as TestQueueSend;
  components new AMReceiverC(AM_RADIO_QUEUE_TEST) as TestQueueRcv;
#endif

  components new QueueC(message_t*,250) as Queue;
  components new PoolC(message_t,250) as Pool;

  //boot
  App.Boot -> MainC.Boot;
  App.Leds -> LedsC;
  //Radio
  App.SendImgstat -> ImgstatSend;
  App.SendPhoto -> PhotoSend;
  App.SendVideo -> VideoSend;
  App.SendCommand -> CmdSend;
  App.ReceiveImgstat -> ImgstatRcv;
  App.ReceivePhoto -> PhotoRcv;
  App.ReceiveVideo -> VideoRcv;
  App.ReceiveCmd -> CmdRcv;
  App.AMControl -> RadioAMC;
  App.RadioPacket -> RadioAMC;
  //test
#ifdef TEST_ENV
  App.SendTimeTest->TestTimeSend;
  App.ReceiveTimeTest->TestTimeRcv;
  App.SendPktTest->TestPktSend;
  App.SendQueueTest->TestQueueSend;
  App.ReceiveQueueTest->TestQueueRcv;
  App.ReceivePktTest->TestPktRcv;
  components new TimerMilliC() as TimerTestTime;
  components new TimerMilliC() as TimerTestPkt;
 App.TimerTestTime->TimerTestTime;
 App.TimerTestPkt->TimerTestPkt; 
  components new TimerMilliC() as TimerQueue;
  App.TimerQueue->TimerQueue;
#endif

  App.Ack -> RadioAMC;
  //queues
 App.Queue->Queue;
 App.Pool->Pool;
 

// timer

  components new TimerMilliC() as TimerCmd;
  components new TimerMilliC() as TimerImgstat;
  components new TimerMilliC() as TimerTxPause;
 App.TimerTxPause->TimerTxPause;
 App.TimerImgstat->TimerImgstat; 
 App.TimerCmd->TimerCmd;

  
}
