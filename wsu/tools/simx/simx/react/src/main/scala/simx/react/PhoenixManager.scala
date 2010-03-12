package simx.react

import java.io.IOException
import java.util.{Timer, TimerTask}
import net.tinyos.util._
import net.tinyos.packet._
import net.tinyos.message._

import react.util._

/*
 * Events signalled.
 */
case class PhoenixSourceUp() extends TriggerEvent
case class PhoenixSourceDown(error_str: String) extends TriggerEvent

/*
 * Adds "up/down" event processing to a PhoenixSource through some
 * trickery and general mayhem.
 * 
 * Warning: Events triggered run in the Phoenix thread.
 * 
 * Object instantiation will BLOCK until initially connected.
 */
class PhoenixManager(val name: String) extends EventTrigger {
  val DEBUG = true;
  val RETRY_TIMEOUT_MS = 4000
  val ASSUME_OKAY_MS = 5000  // should be > RETRY_TIMEOUT_MS
  
  val timer = new Timer()
  // "Is Okay" timer task, if present
  var timer_task: Option[TimerTask] = None
  
  // Ensure only changes are triggered
  var last_error: Option[String] = None 
  
  def markValid() = if (last_error.isDefined)  {
     println("phoenixManager markValid")
    trigger(PhoenixSourceUp())
    last_error = None

  }
  
  def markInvalid(str: String) = if (last_error.getOrElse("") != str) {
    trigger(PhoenixSourceDown(str))
    last_error = Some(str)
  }
  
  val source = {
    val msg_stream = PrintStreamMessenger.err
    val packet_source = BuildSource.makePacketSource(name)
    BuildSource.makePhoenix(packet_source, msg_stream)
  }
  
  // Listener runs in Phoenix thread.
  source.registerPacketListener(new PacketListenerIF {
    override def packetReceived(packet: Array[Byte]) = markValid()
  })
  
  // Handler is run in Phoenix thread.
  source.setPacketErrorHandler(new PhoenixError {
    def error(io: IOException) {
      Log.error("No connection (" + name + "): " + io.getMessage)
      
      // Cancel old watchdog, if present, start new one
      for (task <- timer_task)
        task.cancel()
      
      timer_task = Some({
        val new_task = new TimerTask {
          override def run = markValid()
        }
        timer.schedule(new_task, ASSUME_OKAY_MS)
        new_task
      })
      
      markInvalid(io.getMessage)
      
      // Perform busy-wait before returning; upon completion of handle
      // the source will try to be accessed (again).
      try {Thread.sleep(RETRY_TIMEOUT_MS)}
      catch {case _ => ()}
    }
  })

  val mote = new MoteIF(source)
}
