package simx.react.gui

import java.awt._
import java.awt.event._
import javax.swing._
import javax.swing.event._
import javax.swing.tree._

import scala.collection.mutable

import net.tinyos.message.MoteIF

import simx.mig._
import simx.react.message._
import simx.react.actor._
import simx.react.util._
import simx.react.bridge._

class ProbeWatchFrame(probe: ProbeBridge)
extends JInternalFrame with EventHandler with EnsureExposed {
  
  type VarId = Int
  type Row = Int

  import javax.swing.table._
  class BindTreeModel(top: TreeNode) extends DefaultTreeModel(top) {
    def this() = this(new DefaultMutableTreeNode())
  }
  
  class ProbeWatchPanel extends react.guibase.ProbeWatchPanel {
    
    def bindingModel_=(t: TreeModel) = bindingTree.setModel(t)
    def bindingModel = bindingTree.getModel
    
    // TODO: Wire correct
    override def addBindingActionPerformed(ae: ActionEvent) {
      
    }
  }
   
  // PST- need to be replaced with proper type information
  def looksLikeData(str: String): Boolean = {
    val decoded = str getBytes "US-ASCII"
    for (i <- 0 until decoded.size)
      if (decoded(i) < 32 || decoded(i) > 127)
        return true
    false
  }
  
  def bindWatch(msg: ReactBindWatch.Msg) {
    //val d = probe_model.WatchData(msg.get_var_id, msg.get_node,
    //                              msg.var_name, msg.probe_expr, "")
    //println("Watch for " + d.id + " mote " + d.mote_id)
    //probe_model updateWatch d
  }
  
  def valueWatch(msg: ReactWatch.Msg) {
    val var_id = msg.get_var_id
    var value = msg.value
    //if (!probe_model.updateValue(var_id, value)) {
//      println("No binding for " + var_id + ": Sending query")
      //probe queryWatch var_id
    //}
    ()
  }
  
  
  def respond(event: TriggerEvent) = event match {
    case VarBind(msg) => bindWatch(msg)
    case VarWatch(msg) => valueWatch(msg)
  }
  
  probe.addHandler(this)

  // Form setup
  
  setTitle("Watcher")
  setResizable(true)
  setIconifiable(true)
  
  val probe_panel = new ProbeWatchPanel
  probe_panel.bindingModel = new BindTreeModel
  getContentPane.add(probe_panel)

  pack()
}
