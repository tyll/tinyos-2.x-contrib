package simx.react.gui

import java.awt._
import java.awt.event._
import javax.swing._
import javax.swing.event._

import net.tinyos.message.MoteIF

import simx.mig.ReactNodeInfoMsg
import simx.react.message._
import simx.react.actor._
import simx.react.util._
import simx.react.bridge._

class TimeControlFrame(time_bridge: TimeControlBridge)
extends JInternalFrame with EnsureExposed with EventHandler {
  
  this setTitle "Time Control"
  this setIconifiable true
 
  class TimePanel extends react.guibase.TimeControlPanel {
    override def btnStopActionPerformed(ae: ActionEvent) {
      time_bridge.stop
    }
    override def btnRunActionPerformed(ae: ActionEvent) {
      time_bridge.run
    }
    override def btnRunUntilActionPerformed(ae: ActionEvent) {
      time_bridge.runUntil(time_panel.fldRunUntil.getText)
    }
    override def btnSetScaleActionPerformed(ae: ActionEvent) {//GEN-FIRST:event_btnSetScaleActionPerformed
        // TODO add your handling code here:
      time_bridge.setScale(time_panel.fldScale.getText)
        return;
    }//GEN-LAST:event_btnSetScaleActionPerformed
  }
   
  object TimeQuery {
    var update_time = 1000 // in MS 
    val timer = new java.util.Timer
    var task: Option[java.util.TimerTask] = None
  
    def createTask = new java.util.TimerTask {
      override def run() {
        time_bridge.queryTime
        cancel()
      }
    }
  
    def reset() {
      for (t <- task)
        t.cancel()
      task = Some(createTask) 
      timer.schedule(task.get, update_time)
    }
  }
    
  import react.util.SimTime
  
  def respond(event: TriggerEvent) = event match {
    case TimeInfoIn(msg) => {
      val time = SimTime(msg.get_time)
      time_panel.fldSimTime.setText(time.toString(3))
      TimeQuery.reset
    }
  }
  
  val time_panel = new TimePanel()
  getContentPane.add(time_panel)
  setSize(400, 300)
  
  time_bridge.addHandler(this)
  TimeQuery.reset()
  time_bridge.queryTime()
  
  pack
}
