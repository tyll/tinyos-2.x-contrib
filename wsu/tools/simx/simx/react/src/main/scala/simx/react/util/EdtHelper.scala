package simx.react.util

import java.awt.event._
import java.awt._

object Swing {
  object Implicits {
    implicit def listener(fn: ActionEvent => Unit): ActionListener = {
      new ActionListener() {
        override def actionPerformed(ae: ActionEvent) = fn(ae)
      }
    }
  }
}

object EDT {
  
  /*
   * Turn a thunk into a Runnable.
   */
  def asRunnable(x: => Unit) = new Runnable() {def run() = x}
  
  /*
   * Execute the specified function in the EDT.
   * If already in the EDT, run right away.
   * Returns true if execution is immediate, false if it is deferred.
   */
  def run(x: => Unit) {
    if (EventQueue.isDispatchThread) {
      x
      true
    } else {
      EventQueue.invokeLater(asRunnable(x))
      false
    }
  }
}
