package simx.react.bridge

import scala.collection.mutable
import scala.actors._

import net.tinyos.message.{MoteIF, Message}
import mig._

import simx.react.message._
import simx.react.packet._
import simx.react.actor._
import simx.react.util._

case class VarBind(msg: ReactBindWatch.Msg) extends TriggerEvent
case class VarWatch(msg: ReactWatch.Msg) extends TriggerEvent

/*
 * Send/receive ReactDoMsg commands.
 */
class WatchBridge(ma: MoteActor) extends EventTrigger {
  
  ma.bind {
    case (msg:ReactBindWatch.Msg, _) => trigger(VarBind(msg))
    case (msg:ReactWatch.Msg, _) => trigger(VarWatch(msg))
  }
  
  import Py.Implicit._
  def watchVariable(nodeSel: String, name: String, watchValue: String) = {
    val cmd = new ReactCmd.Msg()
    //cmd.cmd = Py.Fn("WATCH.ADD", Py.Range(nodeSel), name, expr)
    cmd.cmd = Py.Fn("PROBE.BIND", nodeSel.toInt, name, watchValue)
    

    ma ! MoteActor.Send(cmd)
  }
  
  def delAll() {
    val cmd = new ReactCmd.Msg() withCmd Py.Fn("PROBE.DEL_ALL")
    ma ! MoteActor.Send(cmd)
  }
  
  def addBreak(var_id: Int, expr: String) {
    val cmd = new ReactCmd.Msg() withCmd Py.Fn("PROBE.BRK", var_id, expr)
    ma ! MoteActor.Send(cmd)
  }
  
  def resume() {
    val cmd = new ReactCmd.Msg() withCmd Py.Fn("PROBE.RESUME")
    ma ! MoteActor.Send(cmd)
  }
  
  def queryWatch(var_id: Int) = {
    val cmd = new ReactCmd.Msg() withCmd Py.Fn("PROBE.QUERY", var_id)
    ma ! MoteActor.Send(cmd)
  }
  
  def trackNodes() = {}
  def untrackNodes() = {}
  
}
