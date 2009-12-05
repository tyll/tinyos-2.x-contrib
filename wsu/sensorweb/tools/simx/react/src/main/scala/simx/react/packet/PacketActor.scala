package simx.react.packet

import scala.actors._
import net.tinyos.message.{MoteIF, Message}

// Someone told the actor to wakeup
case class Wakeup(p: Int)

abstract class PacketActor extends Actor {
}
