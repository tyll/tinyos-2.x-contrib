package simx.react.bridge

import scala.actors._
import scala.collection.mutable

import net.tinyos.message.{MoteIF, Message}

import message._
import packet._
import actor._
import util._

case class TopoInfoIn(msg: ReactNodeInfo.Msg) extends TriggerEvent
case class LinkIn(msg: ReactLink.Msg) extends TriggerEvent

/*
 * Send/receive ReactDoMsg commands.
 */
class TopoBridge(ma: MoteActor) extends EventTrigger {
  import Py.Implicit._
  type CmdMsg = ReactCmd.Msg
  
  ma.bind {
    case (msg:ReactNodeInfo.Msg, _) => trigger(TopoInfoIn(msg))
    case (msg:ReactLink.Msg, _) => trigger(LinkIn(msg))
  }
  
  def sendCmd(cmd: CmdMsg) = ma ! MoteActor.Send(cmd)
    
  def queryTopo() {
    sendCmd(new CmdMsg() withCmd Py.Fn("TOPO.QUERY"))
  }
  
  def moveNode(id: Int, x: Float, y: Float) {
    sendCmd(new CmdMsg() withCmd Py.Fn("TOPO.MOVE", id, x, y))
  }
  
  def rebuild() {
    sendCmd(new CmdMsg() withCmd Py.Fn("TOPO.REBUILD")) 
  }
  
  def turnOff(ids: List[Int]) {
    sendCmd(new CmdMsg() withCmd 
              "for n in T[" + Py.PyList(ids) + "]:\n\tn.turnOff()")
  }
  
  def turnOn(ids: List[Int]) {
    sendCmd(new CmdMsg() withCmd 
              "for n in T[" + Py.PyList(ids) + "]:\n\tn.turnOn()")
  }
  
  def resetNodes(ids: List[Int]) {
    turnOff(ids)
    turnOn(ids)
  }
    
}
