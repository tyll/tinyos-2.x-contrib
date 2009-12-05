package simx.react.gui

import java.awt.event._
import javax.swing._
import javax.swing.event._


class NewTemplateFrame(manager: TemplateManager, base: Template)
extends JInternalFrame with EnsureExposed {

  this setTitle "New Template"
  this setIconifiable true
  this setResizable true
  
  val template_panel = new NewTemplatePanel
  template_panel.txtSource setTabSize 2
  getContentPane add template_panel
  pack

  // Support
  
  def closeFrame = dispose
  
  def showAddFailure {
    JOptionPane.showMessageDialog(
      this,
        "Ensure that the category and description are valid\n " +
        "and form a unique entity", "Can not add new template. ",
      JOptionPane.ERROR_MESSAGE)
  }
  
  // GUI
  
  class NewTemplatePanel extends react.guibase.NewTemplatePanel {
    
    fldCategory setText base.category
    fldTitle setText base.short
    txtSource setText base.text
    
    override def btnSaveActionPerformed(ae: ActionEvent) {
      val t = new Template(fldCategory.getText, fldTitle.getText, txtSource.getText)
      if (manager.add(t)) {
        t.save
        closeFrame
      } else {
        showAddFailure
      }
    }
    override def btnCancelActionPerformed(ae: ActionEvent) {
      closeFrame
    }
  }

}
