package simx.react.gui

import java.awt.{Component, Dimension}
import java.awt.event._
import javax.swing._
import javax.swing.event._

import scala.actors._

import net.tinyos.message.MoteIF

import simx.react.message._
import simx.react.actor._
import simx.react.util._
import simx.react.bridge._

/*
 * MainFrame - Parent MDI Frame
 * 
 * Closes itself upon "exit".
 */
class MainFrame(
  config: Configuration
) extends react.guibase.MainFrame with EventTrigger {
  
  // Setup  
  
  val desktop = desktopPane
  
  desktop.setDragMode(JDesktopPane.OUTLINE_DRAG_MODE)
  
  setSize(new Dimension(1024, 1000))
  setMinimumSize(new Dimension(480, 320))
  
  def layoutComponents: Seq[Component] =
    this :: desktop.getAllFrames.toList
    
  // Support

  def storeLayout() = try {
    Layout.saveFile("layout.xml", layoutComponents)
  } catch {	
    case e => Log.warn("Could not store layout: " + e.getMessage)
  }
  
  val layoutInfo: Option[Layout] = try {
    Some(Layout.loadFile("layout.xml"))
  } catch {
    case e => Log.warn("Could not retrieve layout: " + e.getMessage)
    None
  }
  
  // Guard used to keep from re-applying layout information.
  // The same JInternalFrame is re-added to the DesktopPane when it's
  // de-iconified (and made visible?)
  // FIXME: In a larger setup this should have a way of purging..
  val layoutApplied = new scala.collection.mutable.HashSet[Component]()
  
  /*
   * Dispose of the frame, possible saving layout first. 
   */
  def closeFrame() {
    if (config.Layout.autoSave.value) {
      Log.info("Auto-Saving layout")
      storeLayout
    }
    dispose()
  }
    
  // Bindings
  
  BindEdt(layoutAutoSave.setSelected) <<| config.Layout.autoSave
  BindEdt(consoleAutoScroll.setSelected) <<| config.Console.autoScroll
  BindEdt(consoleAutoResult.setSelected) <<| config.Console.autoResult
  
  // Events
      
  override def formWindowClosing(ev: WindowEvent) {
    closeFrame()
  }
  
  override def desktopPaneComponentAdded(ev: ContainerEvent) {
    val component = ev.getChild
    
    if (!layoutApplied.contains(component)) 
      for (layout <- layoutInfo) {
        layout.applyLayout(component)
        layoutApplied += component
      }
  }
  
  override def exitProgramActionPerformed(ae: ActionEvent) {
    closeFrame()
  }
  
  // Layout/options
  
  override def saveLayoutActionPerformed(ae: ActionEvent) {
    storeLayout
  }
  
  override def loadLayoutActionPerformed(ae: ActionEvent) {
    // FIXME: Do something
    //retrieveLayout
  }

  override def layoutAutoSaveActionPerformed(ae: ActionEvent) {
    config.Layout.autoSave.value = layoutAutoSave.isSelected
  }
  
  // Console/options
      
  override def consoleAutoScrollActionPerformed(ae: ActionEvent) {
    config.Console.autoScroll.value = consoleAutoScroll.isSelected
  }
  
  override def consoleAutoResultActionPerformed(ae: ActionEvent) {
    config.Console.autoResult.value = consoleAutoResult.isSelected
  }
      
  // Show forms
  
  override def btnTimeControlActionPerformed(ae: ActionEvent) {
    trigger(RestoreFrame('time))
  }
  
  override def btnConsoleActionPerformed(ae: ActionEvent) {
    trigger(RestoreFrame('console))
  }
    
  override def btnTopoActionPerformed(ae: ActionEvent) {
    trigger(RestoreFrame('topo))
  }
      
  override def btnTemplateActionPerformed(ae: ActionEvent) {
    trigger(RestoreFrame('template))
  }
        
  override def btnWatchActionPerformed(ae: ActionEvent) {
    trigger(RestoreFrame('watch))
  }
  
  override def btnProbeBindActionPerformed(ae: ActionEvent) {
    trigger(RestoreFrame('probeBind))
  }
  
  override def btnProbeWatchActionPerformed(ae: ActionEvent) {
    //trigger(RestoreFrame('probeWatch))
    trigger(RestoreFrame('probeWatch))
  }
  override def btnValueWatchActionPerformed(ae: ActionEvent) {
    //trigger(RestoreFrame('probeWatch))
    trigger(RestoreFrame('valueWatch))
  }
  
}
