package simx.react.message

import simx.mig.{ReactReplyMsg => MsgBase}
import simx.mig.ReactConst

object ReactReply extends DecodableMsg {
  import ReactConst._
  
  val SUCCESS = RESULT_SUCCESS
  val FAILURE = RESULT_FAILURE
  val PARTIAL = RESULT_PARTIAL
  val UNSOLICITED = RESULT_UNSOLICITED
  
  val NORMAL = REFINE_NORMAL
  val INFO = REFINE_INFO
  val WARN = REFINE_WARN
  val ERROR = REFINE_ERROR
  val FATAL = REFINE_FATAL
  val DEBUG = REFINE_DEBUG
  
  def decodeMsg(a: Array[Byte], id: Int) = new Msg(a) with Tracker {
    val track_id = id
  }
  
  object Msg extends ObjectEncoder {
    val fixedLength = MsgBase.offset_ve_start_byte()
    val AM_TYPE = MsgBase.AM_TYPE
  }
  
  object ReplyDecoder {	
    def decode(ve: Array[Byte]): Seq[(Int, String)] = {
      val str = Encoder.decodeStr(ve)
      if (str.length > 0) { // may not have any refinements
        val pieces = str.split("\0")
        for (piece <- pieces) yield {
          val reftype = piece(0).toInt
          val data = piece.substring(1)
          (reftype, data)
        }
      } else {
        Nil
      }
    }
  }
  
  class Msg(val data: Array[Byte], val refinements: Seq[(Int, String)])
  extends MsgBase(data)
  with Encoder {
    
    def this(data: Array[Byte]) =
      this(Msg.fixed(data), ReplyDecoder.decode(Msg.variable(data)))
    
    def isSuccess = get_status == SUCCESS
    
    def encoded = encodeStr("")
  }
  
}
