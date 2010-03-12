package simx.react.actor

import net.tinyos.message.{Message, MoteIF}
import scala.collection.mutable
import scala.collection.immutable
import scala.actors._

import message.{ReactMsg, Tracker}
import packet.MessageIn

// Send a message
object MoteActor {
  type MsgCriteria = (Message with Tracker, Int)
  type MsgSelector = PartialFunction[MsgCriteria, Unit]
  
  /*
   * Send an untracked message.
   */
  case class Send(m: Message)
  
  /*
   * Send a tracked message. Replies will be routed to the callback.
   * If uniq is not None, the tracker will overwrite any previous trackers
   * that have an equals uniq (and log a message indicating loss).
   */
  case class SendTracked(m: Message, uniq: Option[Any], callback: MsgCriteria => Unit)
}

class MoteActor(mote: MoteIF) extends Actor {
  import MoteActor.{MsgCriteria, MsgSelector}
  var DEBUG=true
  val DEST_ADDR = 0xFFFE
  
  val selectors = new mutable.ListBuffer[MsgSelector]
  val trackers = new mutable.HashMap[Int, MsgCriteria => Unit]()

  object Tracking {
    val MIN_ID = 1
    val MAX_ID = 250
    val used_ids = new mutable.ListBuffer[Int]()
    val free_ids = (new mutable.ListBuffer[Int]()) ++ (MIN_ID until MAX_ID)
    
    /*
     * Returns (id, reclaimed)
     * 
     * If reclaimed is true the id MUST be removed from use before
     * being used.
     */
    def acquire(): (Int, Boolean) = {
      val (source, reclaimed) = if (free_ids.length == 0)
        (used_ids, true) else (free_ids, false)
      val id = source.first
      source.trimStart(1)
      used_ids += id
      return (id, reclaimed)
    }
    
    def release(id: Int) = if (used_ids.contains(id)) {
      used_ids -= id
      free_ids += id
    }
  }
  
  /*
   * Add a binding.
   */
  def bind(sel: MsgSelector) = selectors += sel
  
  def act() = react {
     
    case MoteActor.SendTracked(m, uniq, using) => {

      //println("MoteActor SendT")
      val (id, reclaimed) = Tracking.acquire()
      //println("MoteActor SendT"+ "Reclaiming tracking ID: " + id + " Stolen? " + (trackers.get(id) ne None))
      if (reclaimed) {
        //println("Reclaiming tracking ID: " + id + " Stolen? " + (trackers.get(id) ne None))
        Log.error("Reclaiming tracking ID: " + id + " Stolen? " + (trackers.get(id) ne None))
      }
      // possibly replace existing
      trackers(id) = using
      for (part <- ReactMsg.encodeTracked(m, id))
        mote.send(DEST_ADDR, part)
      act
    }
    
    case MoteActor.Send(m) => {
      for (part <- ReactMsg.encode(m))
        mote.send(DEST_ADDR, part)
      act
    }
    
    case MessageIn(msg, mote) => {
      if(DEBUG && msg.track_id != 0){
          //println("Have mesg: " + msg.getClass.getName + " track: " + msg.track_id)
          //println(msg.dataGet+" "+ msg.dataLength +" "+ msg.toString)
      }
      import msg.{track_id => id}
      val matcher = (msg, id)
      

      for (t <- trackers.get(id)) {
        trackers -= id
        Tracking.release(id)
        t(matcher)
      }
      for (sel <- selectors if sel.isDefinedAt(matcher)){
        //println("sel"+sel)
                sel(matcher)
      }
      act
    }
  }
  
}
