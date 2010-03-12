package org.izra.protomap

import _root_.com.google.protobuf

case class ProtoID(pbuf: protobuf.Message, id: String)
object ProtoID {
  def apply(pbuf: protobuf.Message): ProtoID = {
    ProtoID(pbuf, ProtoHelper.fullname(pbuf))
  }
/*  def apply(pbuf: protobuf.Message, subname: String): ProtoID = {
    ProtoID(pbuf, ProtoHelper.fullname(pbuf, subname))
  }*/
}

object ProtoHelper {

  /**
   * Return the fullname of a given Protocol Buffer message.
   */
  def fullname(pbuffer: protobuf.Message): String = {
    pbuffer.getDescriptorForType.getFullName
  }
  
  /**
   * Returns the fullname of a given Protocol Buffer message concatenated
   * with a sub-name.
   */
  def fullname(pbuffer: protobuf.Message, subname: String): String = {
    pbuffer.getDescriptorForType.getFullName + "$" + subname
  }
  
}
