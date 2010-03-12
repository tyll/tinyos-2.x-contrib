package org.izra.protomap

import _root_.scala.collection.mutable.HashMap
import _root_.com.google.protobuf

/**
 */
class LocalMap {
  private val lookup_name = new HashMap[String, Short]()
  private var next_id = 1
  
  def nextId() = synchronized {
    val current = next_id.toShort
    next_id += 1
    current
  }
   
  def add(protomsg: protobuf.Message): Short = {
    addByName(protomsg, ProtoHelper.fullname(protomsg))
  }
  
  def addWithSubname(protomsg: protobuf.Message, subname: String): Short = {
    addByName(protomsg, ProtoHelper.fullname(protomsg, subname))
  }
  
  def addByName(protomsg: protobuf.Message, name: String): Short = synchronized {
    lookup_name.get(name) match {
      case Some(id) => id
      case None => {
        val id = nextId()
        lookup_name(name) = id
        id
      }
    }
  }
  
  /**
   * Resolve a name.
   * None is returned if the particular lookup fails.
   */
  def resolveId(name: String): Option[Short] = {
    lookup_name.get(name)
  }
  
}

class RemoteMap {
  val lookup = new HashMap[String, Short]()
  
  /**
   * And a mapping from a name to id.
   */
  def add(name: String, id: Short) {
    lookup(name) = id
  }
  
  def resolveId(name: String): Option[Short] = lookup.get(name)
  
  /**
   * Resolve the sent protocol for a particular message.
   * 
   * The resultant protocol honors the existing protocol such that the
   * name will only be resolved if it is not specified and the mapping ID
   * will only be resolved if it is not specified.
   */
  def resolveProto(msg: Message): ResolvedProtoIdent = {
    //def fullname = msg.protomsg.getDescriptorForType.getFullName
    msg.ident match {
      case i:InternedProto => i
      case _ => {
        val name = msg.ident match {
          case _:AnyProto =>
            ProtoHelper.fullname(msg.protomsg)
          case NamedProto(name) =>
            name
          case SubnamedProto(subname) =>
            ProtoHelper.fullname(msg.protomsg, subname)
          case _ => "" // okay: InternedProto handled above
        }
        resolveId(name) match {
          case Some(id) => InternedProto(id)
          case _ => NamedProto(name)
        }
      }
    }
  }
  
}
