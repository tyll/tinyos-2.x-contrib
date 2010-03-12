package simx.react.message

import simx.mig.{ReactBindWatchBaseMsg => MsgBase}

object ReactBindWatch extends DecodableMsg {
  
  def decodeMsg(a: Array[Byte], id: Int) = new Msg(a) with Tracker {
    val track_id = id
  }
  
  object Msg extends ObjectEncoder {
    val fixedLength = MsgBase.offset_ve_start_byte()
    val AM_TYPE = MsgBase.AM_TYPE
  }
  
  class Msg(val data: Array[Byte], variable: Array[Byte])
  extends MsgBase(data)
  with Encoder {

    def this(data: Array[Byte]) =
      this(Msg.fixed(data), Msg.variable(data))

    var (var_name, watch_expr) = decode(variable)
  
    def decode(ve: Array[Byte]) = {
      val str = decodeStr(ve)
      val parts = str.split("\0", 2)
      (parts(0), parts(1))
    }
  
    def encoded = 
      encodeStr(var_name) ++ Array(0.toByte) ++ encodeStr(watch_expr)
  }
  
}
