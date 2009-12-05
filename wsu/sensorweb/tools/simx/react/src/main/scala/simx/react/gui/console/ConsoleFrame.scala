package simx.react.gui.console

import javax.swing._
import java.awt.event._
import javax.swing.text._

import scala.actors._
import scala.collection.mutable

import simx.react.message._
import simx.react.actor._
import simx.react.util._
import simx.react.bridge._

/*
 * Main UI interaction interface with Act server.
 * 
 * Provides an input area and result window.
 */
class ConsoleFrame(
  cmd_bridge: CommandBridge,
  template_frame: TemplateFrame,
  config: Configuration
) extends JInternalFrame with EventHandler with EnsureExposed {
  var DEBUG=false
  setTitle("Console")
  setIconifiable(true)
  setResizable(true)

  def autoscroll = config.Console.autoScroll.value

  val manager = new CommandManager()
  val console_panel = new ConsolePanel(manager, this) 
    
  add(console_panel)
  pack()
  
  // Forward changes to console panels
  cmd_bridge.addHandler(this)

  /*
   * Display templates.
   */
  def showTemplates() {
    // If not restoring from an icon, doesn't seem to take focus
    template_frame.setIcon(true)
    template_frame.setIcon(false)
    template_frame.moveToFront
    template_frame.requestFocusInWindow
  }
  
  /*
   * Send an interactive command.
   * 
   * Clears the output area.
   */
  def sendInteractiveCommand(cmd: String) {
    cmd_bridge.send(cmd)
    manager.commitCurrent(cmd)    
  }
    
  // Events
  
  def respond(event: TriggerEvent) = event match {
    // Just insert template
    case UseTemplate(t, false) => {
             if(DEBUG)println("sendInteractiveCommandfalse")
      console_panel.insertText(t.text)
    }
    // Send right away
    case UseTemplate(t, true) => {
       if(DEBUG)println("sendInteractiveCommand")
      sendInteractiveCommand(t.text)
    }
    case CommandOut(str) => {
             if(DEBUG)println("command out")
      console_panel.appendOutput(Result(str))
    }
    case CommandIn(msg) => {
             if(DEBUG)println("commandin")
      console_panel.processReply(msg)
    }
  }

}
