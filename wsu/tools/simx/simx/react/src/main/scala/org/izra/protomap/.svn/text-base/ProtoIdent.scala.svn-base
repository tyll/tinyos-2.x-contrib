package org.izra.protomap

sealed case class ProtoIdent()

case class ResolvedProtoIdent() extends ProtoIdent
case class NamedProto(name: String) extends ResolvedProtoIdent
case class InternedProto(id: Short) extends ResolvedProtoIdent

case class UnresolvedProtoIdent() extends ProtoIdent
/**
 * Use any method to find the correct name of a protocol buffer object.
 */
case class AnyProto() extends UnresolvedProtoIdent
/**
 * A variant of AnyProto that applies a sub-name to the result.
 */
case class SubnamedProto(subname: String) extends UnresolvedProtoIdent 
