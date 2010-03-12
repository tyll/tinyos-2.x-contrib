package simx.react.gui

import java.awt._
import java.awt.event._
import javax.swing._
import javax.swing.event._

import scala.collection.mutable

import net.tinyos.message.MoteIF

import simx.mig._
import simx.react.message._
import simx.react.actor._
import simx.react.util._
import simx.react.bridge._
import react.guibase.WatchPanel

class WatchFrame(watch: WatchBridge)
extends JInternalFrame with EventHandler with EnsureExposed {
  
    type VarId = Int
    type Row = Int

    import javax.swing.table._
    class WatchTableModel extends AbstractTableModel {
        var binding = new mutable.HashMap[VarId,WatchData]()
    
        case class WatchData(id: Int, mote_id: Int, name: String,
                             var watch_expr: String, var value: AnyRef)
    
        var rows: scala.List[WatchData] = Nil
        
        type AnyClass = java.lang.Class[_]
        val names = Array("Bind#", "Mote", "Name", "Expr", "Value")
        val classes: Array[AnyClass] = {
            val _int = classOf[java.lang.Integer]
            val _str = classOf[java.lang.String]
            Array(_int, _int, _str, _str, _str)
        }
    
        override def getValueAt(r: Int, c: Int) = {
            val row = rows(r)
            c match {
                case 0 => row.id.asInstanceOf[Object]
                case 1 => row.mote_id.asInstanceOf[Object]
                case 2 => row.name
                case 3 => row.watch_expr
                case 4 => row.value
                case 5 => "?"
            }
        }
    
        def updateValue(var_id: VarId, value: String): Boolean = {
            binding.get(var_id) match {
                case Some(f) => {
                        if (looksLikeData(value)) {
                            val bytes = value.getBytes("US-ASCII")
                            f.value = (for (b <- bytes) yield {
                                    String.format("%h", b.asInstanceOf[Object])
                                }).mkString(" ")
                        } else {
                            f.value = value
                        }
                        this fireTableDataChanged ()
                        true
                    }
                case _ => false
            }
        }
    
        def updateWatch(data: WatchData) {
            binding.get(data.id) match {
                case Some(f) => {
                        f.watch_expr = data.watch_expr
                    }
                case _ => {
                        rows = data :: rows
                        binding(data.id) = data
                    }
            }
            this fireTableDataChanged
        }
        
        def clearData() = {
            binding = new mutable.HashMap[VarId,WatchData]()
            rows = Nil
            this fireTableDataChanged
        }
    
        override def getRowCount = rows length
        override def getColumnName(col: Int) = names(col)
        override def getColumnCount = names.size
        override def getColumnClass(col: Int): AnyClass = classes(col)
    }
  
    class WatchPanel extends react.guibase.WatchPanel {
   
                                                    
        override def btnClearActionPerformed(ae: ActionEvent) {
            watch_model clearData
        }
        override def btnDeleteAllActionPerformed(ae: ActionEvent) {
            watch_model.clearData()
            watch delAll
        }
        override def btnAddUpdateActionPerformed(ae: ActionEvent) {
//            try {
//                // PST-- swtich to verified fields
//                val nodeSel = fldNodes.getText
//                val name = fldVarname.getText
//                val expr = fldWatch.getText
//                watch watchVariable (nodeSel, name, expr)
//                //watch_model updateWatch ()
//            } catch {
//                case _:NumberFormatException => ()
//            }
//
          

           try{
               val nodeSel=fldNodes.getText
               val name = fldVarname.getText
               val watchValue = fldWatch.getText
               watch watchVariable(nodeSel,name,watchValue)

           }catch{
                case _:NumberFormatException =>()

           }

            
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
        
        val d = watch_model.WatchData(msg.get_var_id, msg.get_node,
                                      msg.var_name, msg.watch_expr,None)
        //println("Watch for " + d.id + " mote " + d.mote_id)
        watch_model updateWatch d
    }
  
    def valueWatch(msg: ReactWatch.Msg) {
        val var_id = msg.get_var_id
        var value = msg.value
        if (!watch_model.updateValue(var_id, value)) {
            //println("No binding for " + var_id + ": Sending query")
            watch queryWatch var_id
        }
    }
  
  
    def respond(event: TriggerEvent) = event match {
        case VarBind(msg) => bindWatch(msg)
        case VarWatch(msg) => valueWatch(msg)
    }
  
    watch.addHandler(this)
  
    this setTitle "Watcher"
    this setResizable true
    this setIconifiable true
  
    val watch_model = new WatchTableModel
    val watch_panel = new WatchPanel
    watch_panel.tblWatch setModel watch_model
    //watch_panel.btnShowAdd setSelected false
    getContentPane add watch_panel

    pack()
}
