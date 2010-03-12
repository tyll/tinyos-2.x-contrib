package simx.react.bridge

import javax.swing.JOptionPane

import scala.collection.mutable
import scala.actors._

import net.tinyos.message.{MoteIF, Message}
import mig._

import react.message.{ReactReply, ReactCmd}
import react.packet._
import react.actor._
import react.util._

//case class VarBind(msg: ReactBindWatch.Msg) extends TriggerEvent
//case class VarWatch(msg: ReactWatch.Msg) extends TriggerEvent

class ProbeBridge(ma: MoteActor) extends EventTrigger {
  import Py.Implicit._
  
  def viewRebind(variable: String, rebind: String,
                 cb: (ReactReply.Msg, Option[AnyRef]) => Unit) {
    
    val cmd = new ReactCmd.Msg() withCmd
      Py.Fn("PROBE.VIEW_REBIND", variable, rebind)
    
    def handle(criteria: MoteActor.MsgCriteria) = criteria match {
      case (re:ReactReply.Msg, _) => {
        if (re.get_status == ReactReply.SUCCESS) {
          val (_, source) = re.refinements.first
          cb(re, JSON.optionFromString(source))
        } else {
          cb(re, None)
        }
      }
    }
    
    ma ! MoteActor.SendTracked(cmd, Some('rebind), handle _)
  }
  
  def declareProbe(variable: String, rebind: String, cb: AnyRef => Unit) {
        //val cmd = new ReactCmd.Msg() withCmd
      //Py.Fn("PROBE.DECLARE_PROBE", variable, rebind)
     val nodes = 0
        val cmd = new ReactCmd.Msg() withCmd
      Py.Fn("PROBE.DECLARE_PROBE", nodes,variable, rebind)
       //println("cmd"+cmd+Py.Fn("PROBE.DECLARE_PROBE", nodes,variable, rebind))
    def handle(criteria: MoteActor.MsgCriteria) = criteria match {
      case (re:ReactReply.Msg, _) => {
        if (re.get_status != ReactReply.SUCCESS) {
          //showReply(re)
        }
      }
    }
    
    ma ! MoteActor.SendTracked(cmd, Some('declareProbe), handle _)
  }
  
  def queryStructure(cb: (ReactReply.Msg, Option[AnyRef]) => Unit) {
    val cmd = new ReactCmd.Msg() withCmd Py.Fn("PROBE.GET_LISTING")
    //println("REQUESTING LISTING! "+cmd+" "+Py.Fn("PROBE.GET_LISTING"))
    
    def handle(criteria: MoteActor.MsgCriteria) = criteria match {
      case (re:ReactReply.Msg, _) => {
              //println("re:ReactReply.Msg")
        if (re.get_status == ReactReply.SUCCESS) {
            //println("re:ReactReply.Msg***************************")
          val (_, source) = re.refinements.first
          cb(re, JSON.optionFromString(source))
        } else {
          cb(re, None)
        }
      }
    }
    
    ma ! MoteActor.SendTracked(cmd, Some('query), handle _)
  }
    
}
