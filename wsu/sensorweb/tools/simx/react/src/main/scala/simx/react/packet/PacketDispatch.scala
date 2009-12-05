package simx.react.packet

import scala.collection.immutable
import scala.actors._

import net.tinyos.message.{Message, MessageListener, MoteIF}

import simx.mig._
import simx.react.message._

// Packet recieved
case class MessageIn(msg: Message with Tracker, mote: MoteIF)

// Shared dispatch context
object PacketDispatch {
  var dispatch: Option[PacketDispatch] = None
  
  def connect(mote: MoteIF, actor: Actor) {
    if (dispatch.isDefined)
      throw new IllegalStateException("Error connecting dispatch more than once")
    dispatch = Some(new PacketDispatch(mote, actor))
  }
}

/*
 * Listens for messages from the MoteIF, decodes them,
 * and passes them to an actor for further processing.
 */
class PacketDispatch(mote: MoteIF, actor: Actor) extends MessageListener {

  mote.registerListener(new mig.ReactBaseMsg(), this)
  
  // Map AM_TYPE to a class (constructor)  
  val am_lookup = new immutable.HashMap() ++ {
    // PST-- this crashes scalac 2.7/2.8pre without the type hint
    val msgs: List[DecodableMsg] =
      ReactCmd :: ReactReply ::
      ReactNodeInfo :: ReactLink ::	
      ReactProbe ::
      ReactWatch :: ReactBindWatch ::
      TimeEvent :: Nil
    for (msg <- msgs) yield (msg.Msg.AM_TYPE, msg)
  }
  
  /*
   * Return a new message from the given information based on
   * the encoded message type.
   */
  def createMsg(pkt: PacketFramer.PacketData): Option[Message with Tracker] = {
    for (decodable <- am_lookup.get(pkt.am_type)) yield
      decodable.decodeMsg(pkt.data, pkt.id)
  }

  /*
   * Decode multiple packets on-the-wire into a single packet that can be
   * decoded.
   * 
   * PST- this entire approach is kind of 'ick'.
   */
  object PacketFramer {
    case object PacketData {
      def apply(d: (Int, Int, Array[Byte])): PacketData = { 
        PacketData(d._1, d._2, d._3)
      }
    }
    case class PacketData(am_type: Int, id: Int, data: Array[Byte])
    
    var partial: Option[ReactMsg] = None
  
    /*
     * Attempt to merge a read packet into an already open packet frame, or start
     * a new packet frame. This assumes that packets arrive un-interrupted and
     * sequentially.
     * 
     * Returns Some when a complete message is in.
     */
    def merge(msg: Message): Option[PacketData] = merge(new ReactMsg(msg.dataGet))
    def merge(r: ReactMsg): Option[PacketData] = {
    
      def _merge(r: ReactMsg, partial: Option[ReactMsg]) = {
        if (r.get_type == 0) { // partial
          partial match {
            case Some(p) => Some(p merge r)
            case None => {
              Log.error("Partial packet received but no partial in progress!")
              None
            }
          }
        } else { // start/complete
          for (p <- partial)
            Log.error("Start received but packet in progress; hijacking")
          Some(r)
        }
      }
    
      val merged = _merge(r, partial)
      var (pkt, new_partial) = merged match {
        case Some(p) if (p complete) => (p extract, None)
        case _ => (None, merged)
      }
      partial = new_partial
      for (p <- pkt) yield PacketData(p)
    }
  }
  
  // Call-back for MoteIF interface
  override def messageReceived(addr: Int, msg: Message) {
    if (ReactMsg.AM_TYPE == msg.amType) {
      for (pkt <- PacketFramer.merge(msg)) {
        createMsg(pkt) match {
          case Some(decoded) => actor ! MessageIn(decoded, mote)
          case _ => Log.error("Error decoding " + pkt)
        }
      }
    } else {
      Log.info("Ignoring packet with AM type: " + msg.amType)
    }
  }
  
}
