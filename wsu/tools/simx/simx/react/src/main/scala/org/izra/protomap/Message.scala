package org.izra.protomap

import _root_.com.google.protobuf

/**
 * A raw decoded (or unencoded) message.
 */
case class Message(trackId: Option[Short],
                   ident: ProtoIdent,
                   protomsg: protobuf.Message) {
  
  /**
   * Create a new message, from this one, with a given tracking ID.
   */
  def withTracking(new_track_id: Short) = {
    Message(Some(new_track_id), ident, protomsg)
  }
  
  /**
   * Create a new message, from this one, with a given proto.
   */
  def withProto(new_proto: ProtoIdent) = {
    Message(trackId, new_proto, protomsg)
  }
}

object Message {
  def apply(protomsg: protobuf.Message): Message = {
    Message(None, AnyProto(), protomsg)
  }
}