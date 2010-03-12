package simx.react.bridge

import scala.collection.mutable

import net.tinyos.message.{MoteIF, Message}

import react.message._
import react.packet._
import react.actor._
import react.util._

case class TimeInfoIn(msg: TimeEvent.Msg) extends TriggerEvent

class TimeControlBridge(ma: MoteActor) extends EventTrigger {
  
  ma.bind {
    case (msg:TimeEvent.Msg, _) => trigger(TimeInfoIn(msg))
  }

  import Py.Implicit._
  
  def run() {
    val cmd = new ReactCmd.Msg() withCmd Py.Fn("TIME.RUN")
    ma ! MoteActor.Send(cmd)
  }
  
  def runUntil(time: String) {
    val cmd = new ReactCmd.Msg() withCmd Py.Fn("TIME.RUN_UNTIL", time)
    ma ! MoteActor.Send(cmd)    
  }
  
  def stop() {
    val cmd = new ReactCmd.Msg() withCmd Py.Fn("TIME.STOP")
    ma ! MoteActor.Send(cmd)
  }
  
  def queryTime() {
    val cmd = new ReactCmd.Msg() withCmd Py.Fn("TIME.QUERY")
    ma ! MoteActor.Send(cmd)
  }
  def setScale(clock_mul:String) {
    val cmd = new ReactCmd.Msg() withCmd Py.Fn("TIME.SET_CLOCK_MUL",clock_mul)
    ma ! MoteActor.Send(cmd)
  }
    
}
