package org.izra.protomap

import _root_.java.nio.{ByteOrder, ByteBuffer}

/**
 * A packet is just a container format for data;
 * the data itself belongs to higher-levels.
 */
case class Packet(track_id: Short, ident: ResolvedProtoIdent, data: ByteBuffer) {
  def tracked = track_id != 0
  def encode = Packet.encode(this)
}

object Packet {
  val PROTO_MASK = 0x03
  val NAMED_PROTO = 1
  val TRACKED_MASK = 0x80
  val ASCII = "US-ASCII"
  
  type B = ByteBuffer
  
  /**
   * Try to determine the length of the packet from the blob.
   * This information is stored in the first 4 bytes.
   *
   * An BufferOverflowException will be raised if blob contains less than 4
   * bytes.
   */
  def packetLength(buffer: B): Int = {
    if (buffer.order != ByteOrder.BIG_ENDIAN) {
      throw new RuntimeException("Invalid byte-order")
    }
    val header = buffer.getInt(0)
    header & 0x00FFFFFF
  }
  
  /**
   * Decode a wire-packet.
   * The buffer must be at position 0 before decoding.
   */
  def decode(buffer: B) = {
    val header = buffer.getInt
    val flags: Int = header >> 24
    val tracked = (flags & TRACKED_MASK) != 0
    val prototype = flags & PROTO_MASK
    
    val track_id: Short = if (tracked) buffer.getShort else 0
    
    val proto = if (prototype == NAMED_PROTO) {
      val name_len = buffer.get
      val name = new String({
        val ascii = new Array[Byte](name_len)
        buffer.get(ascii)
        ascii
      }, ASCII)
      NamedProto(name)
    } else {
      InternedProto(buffer.getShort)
    }
    
    Packet(track_id, proto, buffer.slice())
  }
  
  /**
   * Encode a Packet header for wire-transmission.
   * 
   * The packet is encoded as a sequence of byte buffers.
   */
  def encode(packet: Packet): Array[ByteBuffer] = {
    val BASE_LEN = 4
    val TRACK_LEN = 2
    val ID_LEN = 2
    val NAME_LEN = 1
    
    val (flags, headerLength) = {
      val (f0, len0) = if (packet.tracked) {
        (TRACKED_MASK, BASE_LEN + TRACK_LEN)
      } else {
        (0, BASE_LEN)
      }
      packet.ident match {
        // n.name.length valid because ASCII encoding used
        case n:NamedProto => (f0 | NAMED_PROTO, len0 + NAME_LEN + n.name.length)
        case _ => (f0, len0 + ID_LEN)
      }
    }

    val totalLength = headerLength + packet.data.remaining
    val header = ByteBuffer.allocate(headerLength)
    header.order(ByteOrder.BIG_ENDIAN)
    
    header.putInt((flags << 24) | totalLength)
    
    if (packet.tracked) {
      header.putShort(packet.track_id)
    }
    
    packet.ident match {
      case n:NamedProto => {
        val data = n.name.getBytes(ASCII)
        if (data.length > 0xff) {
          throw new IllegalStateException("name is too long: [" + n.name + "]")
        }
        header.put(data.length.toByte).put(data)
      }
      case r:InternedProto => header.putShort(r.id)
    }
    
    header.rewind
    packet.data.rewind
    Array(header, packet.data)
  }
  
}
