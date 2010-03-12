package simx.react.message

import net.tinyos.message.Message

object Encoder {
  val ENCODING = "US-ASCII"  
  def decodeStr(data: Array[Byte]) = new String(data, "US-ASCII")
}

abstract trait Encoder extends Message {
  def encoded: Array[Byte]
  val data: Array[Byte]

  override def dataGet(): Array[Byte] = data ++ encoded
  def encodeStr(s: String) = s.getBytes(Encoder.ENCODING)
  def decodeStr(data: Array[Byte]) = new String(data, Encoder.ENCODING)
}
