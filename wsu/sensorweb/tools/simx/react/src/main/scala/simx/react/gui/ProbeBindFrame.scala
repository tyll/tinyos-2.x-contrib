package simx.react.gui

//import java.awt._
import java.awt.event._
import javax.swing.{DefaultComboBoxModel, JInternalFrame, DefaultListModel}
import javax.swing.event.{ListSelectionEvent}
import javax.swing.tree.{DefaultMutableTreeNode => JTreeNode, DefaultTreeModel}

import scala.collection.immutable.{HashMap, Map}

import net.tinyos.message.MoteIF
import org.json.JSONObject

import simx.mig._
import simx.react.message._
import simx.react.actor._
import simx.react.util._
import simx.react.bridge._
import simx.react.util.JavaHelper.toOption

class ProbeBindFrame(probe: ProbeBridge)
extends JInternalFrame with EventHandler with EnsureExposed {
  
  class Panel extends react.guibase.ProbeBindPanel {
    object EmptyDefinition extends Def.ProbeDef {
      override def toString = "[no definition]"
    }
    type Categories = Map[String, Definitions]
    type Definitions = Map[String, Def.ProbeDef]
    val EmptyDefinitionListing = Map() ++ List(("[none]", EmptyDefinition))    
    
    updateStructuralView("[none]", EmptyDefinition)
    updateDefinitionListing(EmptyDefinitionListing)
    updateCategoryListing()
        
    object Structures {
      private var _categories: Categories = new HashMap()
      def categories = _categories
      def update(_categories: Categories) = this._categories = _categories
      
      def getDefinitions(catname: String) = {
        //println("catname: "+catname);
        _categories.get(catname) getOrElse EmptyDefinitionListing
      }
      def getDefinition(catname: String, defname: String) = {
        //println("cat&def: "+catname+" "+defname);
        (for {
          category <- categories.get(catname)
          definition <- category.get(defname)
        } yield {
          definition
        }) getOrElse EmptyDefinition
      }
    }
        
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
    }

    def updateDefinitionListing(defns: Definitions) {
      val definition_items = defns.keys.toList.sort((a, b) => a < b)
      // val definition_items="[nnn]";
      val model = new DefaultListModel()
      for (item <- definition_items)
        model.addElement(item)
      definitionList.setModel(model)
    }
    
    def buildTreeModel(structure: Def.ProbeDef, name: Option[String]): JTreeNode = {
      def combine_name(new_name: String) = name match {
        case Some(old_name) => old_name + ": " + new_name
        case None => new_name
      }
      //println("\nstructure: "+structure.toString())
      structure match {
        case h:Def.DefStruct => {//println("h");
          val n = new JTreeNode(combine_name("struct"))
          val children = for ((name, sdef) <- h.members) yield { 
            buildTreeModel(sdef, Some(name))
          }
          for (c <- children)
            n.add(c)
          n
        }
        case a:Def.DefArray => {//println("a");
          buildTreeModel(a.of, Some(combine_name(a.toString))) 
        }
        case p:Def.DefBasic => {//println("p"+p.value);
          new JTreeNode(combine_name(p.value))
        }	
        case x => {//println("x");
              new JTreeNode(combine_name(x.toString))}
      }
    }
    
    def updateStructuralView(name: String, structure: Def.ProbeDef) {
      //println("updateStructuralView"+structure);
      val root = buildTreeModel(structure, None)
      structuralTree.setModel(new DefaultTreeModel(root))
      lblStructureName.setText(name)
    }
    
    def updateStructure(r: Any) {
      Structures.update(toDefinition(r))
      updateCategoryListing()
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
        
    def selectedCategory(categories: Categories): Option[(String, Definitions)] = {
      //println("selectedCategory")
      for (a <- toOption(categoryList.getSelectedValue)) yield
        (a.toString, Structures.getDefinitions(a.toString))
    }
    
    def selectedDefinition(category: Definitions): Option[(String, Def.ProbeDef)] = {
      //println("selectedDefinition")
      for (a <- toOption(definitionList.getSelectedValue)) yield
        (a.toString, category.get(a.toString) getOrElse EmptyDefinition)
    }
    
    def selectedStructure: Option[(String, String, Def.ProbeDef)] = {
      //println("selectedStructure")
      
      for {
        (cname, cdef) <- selectedCategory(Structures.categories)
        (dname, ddef) <- selectedDefinition(cdef)
      } yield {
        (cname, dname, ddef)
       // ("c", "a", ddef)
      }
      
    }
    
    def fetchStructure() {
         //println("fetchStructure")
         
      probe.queryStructure((msg, maybe_r) => EDT.run {
              ////println("queryStructure")

            if (msg.isSuccess) {
             //println("fetchStructure SUCCESS")
          for (r <- maybe_r){
            //println("maybe_r "+r);
            updateStructure(r)
            }
        } else {
            //println("fetchStructure Fail")
          StatusDisplay.showReply(msg)
        }
        
      })
  
    }
    
    def viewRebind(variable: String, rebind: String) {
      probe.viewRebind(variable, rebind, (msg, data) => EDT.run {
        if (msg.isSuccess) {
            //println("viewRebind: "+ variable)

          data match {
            case Some(x) => updateStructuralView(variable + "(rebounnd)",
                                                 Def.reconstructDef(x))
            case _ => updateStructuralView(variable + "(error)",
                                           Def.reconstructDef("error"))
          }
        } else {
          StatusDisplay.showReply(msg)
        }
      })
    }
    
    def declareProbe(variable: String, rebind: String) {
      probe.declareProbe(variable, rebind, data => EDT.run {})
      
    }

    // Update listing    
    override def categoryListValueChanged(evt: ListSelectionEvent) {
      if (!evt.getValueIsAdjusting) {
        //println("ACTION")
        categoryList.getSelectedValue match {
          case s:String => updateDefinitionListing(Structures.getDefinitions(s))
          case _ => updateDefinitionListing(EmptyDefinitionListing)
        }
      }
    }
    
    override def definitionListValueChanged(evt: ListSelectionEvent) {
      if (!evt.getValueIsAdjusting) {
        selectedStructure match {
          case Some((cname, dname, defn)) =>  updateStructuralView(dname, defn)
          case _ => updateStructuralView("", EmptyDefinition)
        }
      }
    }
 
    // Other UI actions
    
    override def btnBindActionPerformed(ae: ActionEvent) {
      //println("btnBindActionPerformed")
      declareProbe(fldTarget.getText, fldRebind.getText)
    }

    override def btnViewStructureActionPerformed(ae: ActionEvent) {
        //println("btnViewStructureActionPerformed")
      viewRebind(fldTarget.getText, fldRebind.getText)
    }

    override def btnUpdateCategoriesActionPerformed(ae: ActionEvent) {
      //println("btnUpdateCategoriesActionPerformed")
      fetchStructure()
    }

    override def definitionListMouseClicked(me: MouseEvent) {
      if (me.getClickCount >= 2) {
        val txt = {
          (toOption(definitionList.getSelectedValue) getOrElse "").toString
        }
        categoryList.getSelectedValue match {
          case "structures" => fldRebind.setText(fldRebind.getText + txt)
          case "typedefs" => fldRebind.setText(fldRebind.getText + txt)
          case _ => fldTarget.setText(txt)
          //case _ => fldTarget.setText("nihao")
        }
      }
    }
    
  }
    
  def respond(event: TriggerEvent) {}

  // Form setup
  
  setTitle("Probe Bind")
  setResizable(true)
  setIconifiable(true)
  
  val panel = new Panel()
  getContentPane.add(panel)
  panel.fetchStructure()
  pack()
}
