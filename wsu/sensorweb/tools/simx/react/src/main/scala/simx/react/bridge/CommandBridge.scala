package simx.react.bridge

import scala.collection.mutable
import scala.actors._

import net.tinyos.message.{MoteIF, Message}

import react.message._
import react.packet._ 
import react.actor._
import react.util._

import mig._

case class CommandOut(command: String) extends TriggerEvent
case class CommandIn(sg: ReactReply.Msg) extends TriggerEvent

/*
 * Send/receive ReactDoMsg commands.
 */ 
class CommandBridge(ma: MoteActor) extends EventTrigger {

  var DEBUG=false;

  ma.bind {
    case (msg:ReactReply.Msg, 0) => trigger(CommandIn(msg))
    case (msg:ReactReply.Msg, _) if {
      msg.get_status != ReactReply.NORMAL
    } => trigger(CommandIn(msg))
  }
  
  def send(s: String) = {
       
    val cmdMsg = new ReactCmd.Msg() withCmd s
   if(DEBUG)println(cmdMsg)
    ma ! MoteActor.Send(cmdMsg)
  }
    
}
