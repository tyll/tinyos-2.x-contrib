package simx.react.message

import net.tinyos.message.Message

/*
 * Message that can be encoded/decoded. 
 */
trait DecodableMsg {
	val Msg: ObjectEncoder
	def decodeMsg(a: Array[Byte], track_id: Int): Message with Tracker
}