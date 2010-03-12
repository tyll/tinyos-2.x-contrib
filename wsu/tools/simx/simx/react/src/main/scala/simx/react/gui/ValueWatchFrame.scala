package simx.react.gui

//import java.awt._
import java.awt.event._
import javax.swing.{DefaultComboBoxModel, JInternalFrame, DefaultListModel}
import javax.swing.event.{ListSelectionEvent}
import javax.swing.tree.{DefaultMutableTreeNode => JTreeNode, DefaultTreeModel}
import javax.swing._;
import javax.swing.tree._;
import javax.swing.event._;
import javax.swing.text.Position;

import java.util.Enumeration;
import scala.collection.immutable.{HashMap, Map}

import scala.collection.mutable

import net.tinyos.message.MoteIF
import org.json.JSONObject

import simx.mig._
import simx.react.message._
import simx.react.actor._
import simx.react.util._
import simx.react.bridge._
import simx.react.util.JavaHelper.toOption

class ValueWatchFrame(probe: ProbeBridge,watch: WatchBridge)
extends JInternalFrame with EventHandler with EnsureExposed {
  class Panel extends react.guibase.ValueWatch {
    object EmptyDefinition extends Def.ProbeDef {
      override def toString = "[no definition]"
    }
    type Categories = Map[String, Definitions]
    type Definitions = Map[String, Def.ProbeDef]
    val EmptyDefinitionListing = Map() ++ List(("[none]", EmptyDefinition))


    //updateStructuralView("[none]", EmptyDefinition)
    updateDefinitionListing(EmptyDefinitionListing)
    //updateCategoryListing()

    def updateStructuralView(name: String, structure: Def.ProbeDef) {
      //println("updateStructuralView"+structure);
      /*
       val root = buildTreeModel(structure, None)
       structuralTree.setModel(new DefaultTreeModel(root))
       lblStructureName.setText(name)
       */
    }
    object Structures {
      private var _categories: Categories = new HashMap()
      def categories = _categories
      def update(_categories: Categories) = this._categories = _categories

      def getDefinitions(catname: String) = {
        _categories.get(catname) getOrElse EmptyDefinitionListing
      }
      def getDefinition(catname: String, defname: String) = {
        (for {
            category <- categories.get(catname)
            definition <- category.get(defname)
          } yield {
            definition
          }) getOrElse EmptyDefinition
      }
    }
    /*
     def updateCategoryListing() {
     val category_items = Structures.categories.keys.toList match {
     case Nil => List("[not loaded]")
     case x => x.sort((a, b) => a < b)
     // case x => List("list")
     }
     categoryList.setModel(
     new DefaultComboBoxModel(category_items.toArray[Object]))
     categoryList.setSelectedIndex(0)
     updateDefinitionListing(Structures.getDefinitions(category_items(0)))
     }*/
    
    def updateDefinitionListing(defns: Definitions) {
      /*
       val definition_items = defns.keys.toList.sort((a, b) => a < b)
       // val definition_items="[nnn]";
       val model = new DefaultListModel()
       for (item <- definition_items)
       model.addElement(item)
       definitionList.setModel(model)
       */

      var root:DefaultMutableTreeNode = new DefaultMutableTreeNode("Root");
      val definition_items = defns.keys.toList.sort((a, b) => a < b)
      for(item <- definition_items){
        //println(item)
        //root.add( new DefaultMutableTreeNode(item));
        val tokens  = item.split('$');       // Single blank is the separator.
        var pre=root
        jTree1.setModel(new DefaultTreeModel(root));
        var i:Int=0;
        for(s<-tokens){
          //println(s)
          //var path:TreePath = jTree1.getNextMatch(s, 0, Position.Bias.Forward);
          //println(path)

          //e=root.depthFirstEnumeration;

          // while(e.hasMoreElements())
          // println(e.nextElement());
          
          var temp= new DefaultMutableTreeNode(s)
          var existnode:DefaultMutableTreeNode = isexist(root,temp)
          //println(existnode)
          //val j = root.getIndex(temp)
          //val j = temp.getRoot()
          //println("j "+j)
          if(existnode==null){
            pre.add(temp)
            pre=temp;
          }
          else{
            pre=existnode;
            
          }
        }

      }
      
      // val definition_iterms=defns.keys.toList.sort((a, b) => a < b)
      // jTree1.
      
      // for (item <- definition_items)
      ///  root.add( new DefaultMutableTreeNode(item));
      //  item
      
    }
    // Convert raw JSON-object defintion to proper Categories
    def toDefinition(raw: Any): Categories = try {
      val raw_casted = raw.asInstanceOf[Categories]
      new HashMap() ++ {
        for ((cat_name, cat_data) <- raw_casted) yield {
          (cat_name, new HashMap() ++ {
              for ((def_name, def_data) <- cat_data)
                yield (def_name, Def.reconstructDef(def_data))
            })
        }
      }
    } catch {
      case _:ClassCastException =>
        Map() ++ List(("[error loading]", Map[String, Def.ProbeDef]()))
    }
    def updateStructure(r: Any) {
      //println(toDefinition(r));
      Structures.update(toDefinition(r))
      //updateCategoryListing()
      updateDefinitionListing(Structures.getDefinitions("variables"))
    }
    def fetchStructure() {
      println("fetchStructure")
      probe.queryStructure((msg, maybe_r) => EDT.run {
          //println("queryStructure")

          if (msg.isSuccess) {
            println("fetchStructure SUCCESS")
            for (r <- maybe_r)
              updateStructure(r)
          } else {
            println("fetchStructure Fail")
            StatusDisplay.showReply(msg)
          }
        })

    }
        override def DeleteActionPerformed(ae: ActionEvent) {
    // TODO add your handling code here:
    watch_model.clearData()
    watch delAll
  }
/*
  override def ClearActionPerformed(ae: ActionEvent) {
    // TODO add your handling code here:
    watch_model clearData
  }
  */
    override def ListValueChanged(evt:TreeSelectionEvent) {
      // TODO add your handling code here:
      // System.out.println("Current Selection: " + jTree1.getLastSelectedPathComponent().toString());


      //System.out.println(new DefaultMutableTreeNode(jTree1.getLastSelectedPathComponent()).getPath().toString() );
      var  node:TreeNode=(jTree1.getLastSelectedPathComponent()).asInstanceOf[ TreeNode];
      var name:String =""+node;
      while(node.getParent()!=null){
        //if(!name.equalsIgnoreCase(""))
        if(!node.getParent().toString().equalsIgnoreCase("Root"))
          name=node.getParent()+"$"+name;
        node=(node.getParent());
      }
      //println("aa"+name);
      var nodes:String=nodesList.getText
      val tokens  = nodes.split(',');       // Single blank is the separator.

      for(s<-tokens){
        try{
          val nodeSel=s
          val watchValue = ""
          watch watchVariable(nodeSel,name,watchValue)

        }catch{
          case _:NumberFormatException =>()

        }
      }



    }             
      

  }
  type VarId = Int
  type Row = Int

  import javax.swing.table._
  class WatchTableModel extends AbstractTableModel {
    var binding = new mutable.HashMap[VarId,WatchData]()
    case class WatchData(id: Int, mote_id: Int, name: String,
                         var watch_expr: String, var value: AnyRef)
    var rows: scala.List[WatchData] = Nil

    type AnyClass = java.lang.Class[_]
    // val names = Array("Bind#", "Mote", "Name", "Expr", "Value")
    val names = Array("NodeID", "Name",  "Value")
    val classes: Array[AnyClass] = {
      val _int = classOf[java.lang.Integer]
      val _str = classOf[java.lang.String]
      //Array(_int, _int, _str, _str, _str)
      Array(_int, _str, _str)
    }
    override def getValueAt(r: Int, c: Int) = {
      val row = rows(r)
      c match {
        /*
         case 0 => row.id.asInstanceOf[Object]
         case 1 => row.mote_id.asInstanceOf[Object]
         case 2 => row.name
         case 3 => row.watch_expr
         case 4 => row.value
         case 5 => "?"
         */
        case 0 => row.mote_id.asInstanceOf[Object]
        case 1 =>row.name
        case 2 => row.value

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

  // def respond(event: TriggerEvent) {}
  /*
   override def btnAddUpdateActionPerformed(ae: ActionEvent) {
   try{
   val nodeSel=fldNodes.getText
   val name = fldVarname.getText
   val watchValue = fldWatch.getText
   watch watchVariable(nodeSel,name,watchValue)

   }catch{
   case _:NumberFormatException =>()

   }


   }
   */
  
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
  // Form setup

  setTitle("Value Watch")
  setResizable(true)
  setIconifiable(true)

  val panel = new Panel()
  
  val watch_model = new WatchTableModel
  panel.jTable1 setModel watch_model

  getContentPane.add(panel)
  panel.fetchStructure()
  pack()


}

