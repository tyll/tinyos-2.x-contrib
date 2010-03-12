package simx.react.message

import simx.mig.{TimeEventMsg => MsgBase}

object TimeEvent extends DecodableMsg {
  
  def decodeMsg(a: Array[Byte], id: Int) = new Msg(a) with Tracker {
    val track_id = id
  }
  
  object Msg extends ObjectEncoder {
    val fixedLength = 0
    val AM_TYPE = MsgBase.AM_TYPE
  }

  class Msg(data: Array[Byte])
  extends MsgBase(data) {
    def get_time = (get_timeH << 32) | get_timeL
  }
  
}
