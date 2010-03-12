package simx.react.message

import net.tinyos.message.Message

import simx.mig.{ReactConst, ReactBaseMsg => MsgBase}

object ReactMsg extends ObjectEncoder {
  val fixedLength = MsgBase.offset_payload_start_byte()
  val MAX_PAYLOAD = ReactConst.MAX_REACT_PAYLOAD
  val AM_TYPE = MsgBase.AM_TYPE
  
  /*
   * Encode the given message into a sequence of ReactMsg's.
   */
  def encode(msg: Message): Seq[ReactMsg] = encodeTracked(msg, 0) 
  def encodeTracked(msg: Message, track_id: Int) = {
    val am_type = msg.amType.toShort
    val data = msg.dataGet
    val total = data.length
    
    def reactMsg(remaining: Int, partial: Boolean) = {
      val r = new ReactMsg()
      r.set_type(if (partial) 0 else am_type)
      r.set_track_id(track_id)
      r.set_remaining(remaining)
      r
    }
    
    if (total < 1) {
      List(reactMsg(0, false))
    } else {
      for (i <- 0 until total by MAX_PAYLOAD) yield {
        val remaining = total - i
        val size = remaining min MAX_PAYLOAD
        val data_part = data subArray (i, i + size)
        reactMsg(remaining, i > 0) withPayload data_part
      }
    }
  }
  
}

class ReactMsg(data: Array[Byte], var payload: Array[Byte])
extends MsgBase(data) {
  import ReactMsg.MAX_PAYLOAD
  
  /* 
   * The Message class hides direct data-access. We intercept setting the
   * data in the constructor and seive off part of it as the payload.
   * This approach likely breaks setData functionality and only works for
   * the base constructor case.
   */
  def this(data: Array[Byte]) =
    this(ReactMsg.fixed(data), ReactMsg.variable(data))
  def this() = this(ReactMsg.emptyFixed)
  
  override def dataGet(): Array[Byte] = super.dataGet() ++ payload
  
  def withPayload(_payload: Array[Byte]) = {
    payload = _payload
    this
  }
  
  /*
   * Returns true if extract() will be succesfull.
   */
  // only payload is updated when merged; get_remaining always
  // refers to the first packet in a multip-part
  def complete: Boolean = get_remaining == payload.length
  
  /*
   * Returns Some((am_type, track_id, payload)) if the message is fully merged.
   */
  def extract(): Option[(Int, Int, Array[Byte])] = {
    if (complete)
      Some((get_type, get_track_id, payload))
    else None
  }
  
  /*
   * Returns a new message of this message merged with other.
   * If merging fails due to internal structure issues an exception is raised.
   */
  def merge(other: ReactMsg) = {
    if (other.get_type != 0)
      throw new RuntimeException("message not a ``message part''")
    if (other.get_track_id != get_track_id)
      throw new RuntimeException("messages have different tracking ids")
    
    val other_len = other.payload.length
    if (other_len > get_remaining)
      throw new RuntimeException("merge will exceed remaining data")    
    
    new ReactMsg(data ++ payload ++ other.payload)
  }
}
