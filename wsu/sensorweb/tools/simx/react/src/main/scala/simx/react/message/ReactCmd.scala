package simx.react.message

import simx.mig.{ReactCmdBaseMsg => MsgBase}

object ReactCmd extends DecodableMsg {

  def decodeMsg(a: Array[Byte], id: Int) = new Msg(a) with Tracker {
    val track_id = id
  }
  
  object Msg extends ObjectEncoder {
    val fixedLength = MsgBase.offset_ve_start_byte()
    val AM_TYPE = MsgBase.AM_TYPE
  }

  class Msg(val data: Array[Byte], var cmd: String)
  extends MsgBase(data)
  with Encoder {
    
    def this(data: Array[Byte]) =
      this(Msg.fixed(data), Encoder.decodeStr(Msg.variable(data)))
    def this() = this(Msg.emptyFixed)  
    
    def encoded = encodeStr(cmd)
    
    def withCmd(_cmd: String) = {
      cmd = _cmd
      this
    }
  
  }

}
