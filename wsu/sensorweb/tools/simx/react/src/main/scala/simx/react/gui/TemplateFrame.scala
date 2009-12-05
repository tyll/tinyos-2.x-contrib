package simx.react.gui

import java.awt.event._
import javax.swing._
import javax.swing.event._

import scala.collection.mutable

import simx.react.util._

class TemplateFrame(manager: TemplateManager)
extends JInternalFrame with EventTrigger with EnsureExposed {
  
  setTitle("Templates")
  setIconifiable(true)
  setResizable(true)
  
  val template_panel = new TemplatePanel
  updateModel()
  getContentPane.add(template_panel)
  pack()
  
  manager.change_hook += (() => {
    template_panel.listing_model.change(manager.templates)
  })
  
  // Support
  
  def updateModel() {
    template_panel.listing_model.change(manager.templates)
  }
  
  def spawnFrame(frame: JInternalFrame) {
    getParent.add(frame)
    frame.setVisible(true)
  }
 
  // GUI
  
  class TemplatePanel extends react.guibase.TemplatePanel {
    
    val listing_model = new TemplateListingModel
    var selectedTemplate: Option[Template] = None
    
    selectTemplate(None)
    
    tblListing setModel listing_model
    tblListing setSelectionMode ListSelectionModel.SINGLE_SELECTION
    
    txtSource setTabSize 2
    
    // Set the currently selected template
    def selectTemplate(template: Option[Template]) {
      selectedTemplate = 
        template match {
          case Some(t) => {
            fldTemplateIdent setText (t.category + ": " + t.short)
            txtSource setText t.text
            txtSource setEditable true
            txtSource setEnabled true
            template
          }
          case None => {
            fldTemplateIdent setText "(no template selected)"
            txtSource setText ""
            txtSource setEditable false
            txtSource setEnabled false
            Some(new Template("uncategorized", "none"))
          }
      }
    }
        
    {
      // Show template selected from table
      val sm = tblListing.getSelectionModel
      sm.addListSelectionListener(new ListSelectionListener {
        override def valueChanged(e: ListSelectionEvent) {
          def select(idx: Int) {
            val model_idx = tblListing.convertRowIndexToModel(idx)
            selectTemplate(listing_model.get(model_idx))            
          }
          e.getSource match {
            case lsm:ListSelectionModel if !e.getValueIsAdjusting =>
              select(lsm.getMinSelectionIndex)
            case _ => ()
          }
        }
      })
    }
    
    import javax.swing.table._
    class TemplateListingModel extends AbstractTableModel {
      
      var templates: Array[Template] = Array()
      
      def get(index: Int): Option[Template] = {
        if (index >= 0 && index < templates.size) Some(templates(index))
        else None
      }
      
      def change(_templates: Seq[Template]) {
        templates = _templates.toArray
        this fireTableDataChanged ()
      }
      
      type AnyClass = java.lang.Class[_]
      val names = Array("Category", "Description")
      val classes: Array[AnyClass] = {
        Array(classOf[java.lang.String], classOf[java.lang.String])
      }
    
      override def getValueAt(r: Int, c: Int) = {
        c match {
          case 0 => templates(r).category
          case 1 => templates(r).short
          case _ => "?"
        }
      }
                
      override def getRowCount = templates.length
      override def getColumnName(col: Int) = names(col)
      override def getColumnCount = names.size
      override def getColumnClass(col: Int): AnyClass = classes(col)
    }

    override def showActionsActionPerformed(ae: ActionEvent) {
      actionMenu.show(this, showActions.getX, showActions.getY)
    }

    override def addTemplateActionPerformed(ae: ActionEvent) {
      val template = selectedTemplate.get
      val t = new Template(template.category, template.short, txtSource.getText)
      val new_template = new NewTemplateFrame(manager, t)
      spawnFrame(new_template)
    }
    
    override def deleteTemplateActionPerformed(ae: ActionEvent) {
      val template = selectedTemplate.get
      manager.remove(template)
      template.delete
      txtSource.grabFocus
    }
    
    /* 
     * Retrieve the template as it currently is, in its entirety.
     * (Takes into account current modifications.)
     * 
     * If there is no currently selected template a DummyTemplate
     * will be returned (why?)
     */
    def fullTemplate = selectedTemplate match {
      case Some(t) => {
        t.text = txtSource.getText
        t
      }
      case None => new DummyTemplate()
    }
    
    /*
     * Returns a template encompassing only the selected lines, if any.
     * The full template is returned if there is no selection 
     */
    def appliedTemplate = {
      val full = fullTemplate
      def is_selected = (txtSource.getSelectedText ne null) &&
        txtSource.getSelectedText.length > 0
      
      if (!is_selected) {
        full
      } else {
        val partial = new DummyTemplate()
        //val text = txtSource.getText
        partial.text = txtSource.getSelectedText
        partial
      }
    }
    
    override def updateTemplateActionPerformed(ae: ActionEvent) {
      fullTemplate.save
      txtSource.grabFocus
    }
    
    override def btnUseActionPerformed(ae: ActionEvent) {
      trigger(UseTemplate(appliedTemplate, false))
      txtSource.grabFocus
    }
    
    override def btnSendNowActionPerformed(ae: ActionEvent) {
      trigger(UseTemplate(appliedTemplate, true))
      txtSource.grabFocus
    }
  }
  
}
