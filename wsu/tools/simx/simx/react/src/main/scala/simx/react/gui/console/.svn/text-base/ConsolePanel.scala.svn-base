package simx.react.gui.console

import javax.swing._
import java.awt.event._
import javax.swing.text._

import simx.react.message._
import simx.react.util._


class ConsolePanel(
  manager: CommandManager,
  // TODO: Make more specific, less general/open
  console_commands: ConsoleFrame
) extends react.guibase.ConsolePanel {

  import console_commands.{autoscroll, showTemplates, sendInteractiveCommand}
  
  val output_doc = new ConsoleStyledDocument
  
  // alt+enter to send
  btnSend.setMnemonic(KeyEvent.VK_ENTER)
  
  txtInput.setTabSize(2)      
  txtPaneOutput.setStyledDocument(output_doc)
  
  def processReply(reply: ReactReply.Msg) {
    if (reply.refinements.size == 0) {
      appendOutput(Warning("ReactReply with no refinements"))
    } else {
      for ((ref_type, msg) <- reply.refinements) {
        if (ref_type == ReactReply.NORMAL) {
          //println("ConsolePanel: "+Result(msg))
          appendOutput(Result(msg))
        } else {
          appendOutput(Error(msg))
        }
      }
    }	
  }
    
  /*
   * Append some output and honor auto-scroll
   */
  def appendOutput(output: Output) {
    val old_caret = txtPaneOutput.getCaretPosition
    val str = Output.normalizeStr(output.text)
    output_doc.append(str, output.style)
    output_doc.append("\n", "div")
    txtPaneOutput.setCaretPosition {
      if (autoscroll) output_doc.getLength else old_caret
    }
  }
  
  /*
   * Insert some text into the output text area
   */
  def insertText(text: String) {
    txtInput.insert(text, txtInput.getCaretPosition)    
  }	
  
  // Bindings
  
  BindEdt(txtInput.setText) <<| manager.current
  BindEdt(btnPrev.setEnabled) <<| manager.hasPrev
  BindEdt(btnNext.setEnabled) <<| manager.hasNext
  
  // Events
  
  override def formComponentShown(ce: ComponentEvent) {
    txtInput.requestFocus(true)
  }
  
  override def btnTemplatesActionPerformed(ae: ActionEvent) {
    showTemplates()
  }
  
  override def btnSendActionPerformed(ae: ActionEvent) {
    val cmd_str = txtInput.getText
    sendInteractiveCommand(cmd_str)
    // Focus back for easy editing
    txtInput.requestFocus(true)
  }
  
  override def btnPrevActionPerformed(ae: ActionEvent) {
    manager.prev()
  }
  
  override def btnNextActionPerformed(ae: ActionEvent) {
    manager.next()
  }
  
}
