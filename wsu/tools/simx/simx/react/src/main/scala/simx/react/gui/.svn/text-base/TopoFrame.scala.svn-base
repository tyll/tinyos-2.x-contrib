package simx.react.gui

import java.awt._
import java.awt.event._
import javax.swing._
import javax.swing.event._

import scala.collection.mutable

import net.tinyos.message.MoteIF

import simx.mig.ReactConst
import simx.react.message._
import simx.react.actor._
import simx.react.util._
import simx.react.bridge._

import nodes._


/*
 * A LinkIdent uniquely identifies a link between two nodes.
 */
case class LinkIdent(a: NodeNum, b: NodeNum)
object LinkIdent {
  
  /*
   * Automatically sorts the linked nodes; This ensures that
   * a->b and b->a resolve to the same link. This is almost always the correct
   * way to create a LinkIdent.
   */
  def make(a: NodeNum, b: NodeNum): LinkIdent = {
    if (a.n > b.n) LinkIdent(a, b)
    else LinkIdent(b, a)
  }
}

class TopoFrame(topo: TopoBridge)
extends JInternalFrame with EventHandler with EnsureExposed {
  
  val display = new NodeDisplay()
  val panel = new TopoPanel()
  panel.topoPanel.setLayout(new GridLayout())
  panel.topoPanel.add(display)

  display.setSize(400, 300)
  display.fitAll()

  setTitle("Topology")
  setResizable(true)
  setIconifiable(true)
  setContentPane(panel)
  pack()
  
  // Handlers
  
  topo.addHandler(this)
  display.moved_hook += {(id, x, y) => topo.moveNode(id, x, y)}
    
  def respond(event: TriggerEvent) = event match {
    case TopoInfoIn(msg) => infoHandler(msg)
    case LinkIn(msg) => display.updateLink(msg)
  }
  
  // Display context menu
  
  display.popup.addItem("Turn off", {(ae: ActionEvent) =>
    topo.turnOff(display.selectedNodeIds)
  })
  
  display.popup.addItem("Turn on", {(ae: ActionEvent) =>
    topo.turnOn(display.selectedNodeIds)
  })

  display.popup.addItem("Reset nodes", {(ae: ActionEvent) =>
    topo.resetNodes(display.selectedNodeIds)
  })
  
  // Support
    
  def rebuildNodes() {
    topo.rebuild()
  }  
  
  def infoHandler(info: ReactNodeInfo.Msg) {
    // PST: signal to clear all nodes; this needs fixing
    if (info.get_id == 0xFFFF) {
      display.clearNodes()
    } else {
      display.updateNode(info)
    }
  }
  
  class TopoPanel extends react.guibase.TopoPanel {
    override def btnClearActionPerformed(ae: ActionEvent) {
      //clearNodes
      topo.queryTopo()
    }
    override def btnRebuildActionPerformed(ae: ActionEvent) {
      rebuildNodes()
    }
    override def btnFitActionPerformed(ae: ActionEvent) {
      display.fitAll()
    }
    override def btnFitSelectedActionPerformed(ae: ActionEvent) {
      display.fitSelected()
    }
  }
  
  // Final init
  
  topo.queryTopo()
    
}
