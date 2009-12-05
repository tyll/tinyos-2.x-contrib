package simx.react.util

object Logger {
  
  sealed case class Event(text: String)
  case class Debug(override val text: String) extends Event(text)
  case class Info(override val text: String) extends Event(text)
  case class Warn(override val text: String) extends Event(text)
  case class Error(override val text: String) extends Event(text)
  
  trait Target {
    def log(level: Event): Unit
  }
  
  abstract trait Source {
    val log: Logger
  }
  
  /*
   * A simple logger wrapper
   * 
   * Example:
   * new Logger.Direct(System.stdout.println _)
   */
  class Direct(fn: String => Unit) extends Target {
    def log(level: Event) {
      val msg = level match {
        case Debug(s) => "Debug: " + s 
        case Info(s) => "Info: " + s
        case Warn(s) => "Warn: " + s
        case Error(s) => "Error: " + s
      }
      fn(msg)
    }
  }
  
}


/*
 * Simple logger that uses WeakReferences to accomodate for log targets that
 * may dissapear. (I just wanted to play with weak refs; I don't think there
 * is a really good case when this should happen.)
 */
class Logger {
  import Logger._
  import scala.collection.immutable
  import scala.ref.{WeakReference, ReferenceQueue}
  
  var targets: List[WeakReference[Target]] = Nil
  val ref_queue = new ReferenceQueue[Target]()
  
  /*
   * Add a logging target.
   * 
   * Since the target is treated as a weak reference, the caller is responsible
   * to hold onto a strong reference (otherwise the logging "may just stop".)
   * Also, even though weak-refs are used, loggers should explicitly remove
   * themselves when done to guarentee they stop receiving logging messages.
   */
  def add(target: Target) {
    targets ::= new WeakReference(target)
  }
  
  def remove(target: Target) {
    // Filters reclaimed weak-refs through
    targets = targets.filter(t => t.get != target) 
  }
 
  def dispatch(l: Event) {
    // Side-effects, but non-lazy seq
    // TODO: Make more efficient
    targets = for {
      weak_target <- targets
      t = weak_target.get
      if t.isDefined
    } yield {
      t.get.log(l)
      weak_target
    }
  }
  
  def debug(s: String) = dispatch(Debug(s))
  def info(s: String) = dispatch(Info(s))
  def warn(s: String) = dispatch(Warn(s))
  def error(s: String) = dispatch(Error(s))
}
