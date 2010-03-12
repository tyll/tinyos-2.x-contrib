package simx.react.gui.nodes

import java.awt.EventQueue
import java.awt.geom.Rectangle2D
import edu.umd.cs.piccolo._
import edu.umd.cs.piccolo.event._
import edu.umd.cs.piccolo.util._

import scala.collection.mutable

import simx.mig.ReactConst
import simx.react.packet._
import simx.react.message._

/**
 * Piccolo canvas which displays nodes and links.
 */
class NodeDisplay extends PCanvas {
   //var fitToScreenAutomatically = false
   //var screenIsEmpty = true

   val nodes = new mutable.HashMap[NodeNum, Node]()
   val links = new mutable.HashMap[LinkIdent, Link]()

   def clearNodes() {
     for (node <- nodes.values)
       nodeLayer.removeChild(node)
     nodes.clear()
   }
   
   /*
    * Returns a node for a given node number.
    * If the node does not exist it is created -- but not necessarily displayed!
    */
   def getNode(nn: NodeNum) = nodes.get(nn) getOrElse {
     val node = new Node(nn)
     nodes(nn) = node
     node
   }
  
   /*
    * Returns a link between two nodes.
    * If either the link or the link or the nodes do not exist, they are created.
    * However, they may not be displayed.
    */
   def getLink(a: NodeNum, b: NodeNum) = {
     val ident = LinkIdent.make(a, b)
     links.get(ident) getOrElse {
       val link = new Link(getNode(a), getNode(b))
       links(ident) = link
       link
     }
   }
  
   /**
    * Update link information from a message.
    */
   def updateLink(info: ReactLink.Msg) {
     val (node1, node2) = (NodeNum(info.get_node1), NodeNum(info.get_node2))
     val link = getLink(node1, node2)

     def setGain(nn: NodeNum, gain: Byte) {

       if (gain == ReactConst.INVALID_LINK) {
         link.setGain(nn, None)
 	 link.setVisible(false)
       } else if (gain != ReactConst.IGNORE_LINK) {
         link.setGain(nn, Some(gain))
 	// link.setVisible(false)
       }
       else{
	
		
	 
      }
     }
 linkLayer.addChild(link)
          link.setVisible(true)


/*
def computeColor() {
    val min = (gain_srcDest getOrElse {0}) min (gain_destSrc getOrElse {0})
    val color = if (min <= -90) {
      Link.Color.LINK_ERROR
    } else if (min <= -80) {
      Link.Color.LINK_WARNING
    } else {
      Link.Color.OK_LINK
    }

	
    setStrokePaint(color)
	if(color== Link.Color.LINK_ERROR || color== Link.Color.LINK_WARNING)
		setVisible(false)  
	else
		setVisible(true)

}
  
  def setGain(nn: NodeNum, gain: Option[Int]) {
    if (nn == source.nn) {
      gain_srcDest = gain
    } else if (nn == dest.nn) {
      gain_destSrc = gain
    } else {
      Log.error("Trying to set a gain for a NodeNum not part of a link")
    }
    computeColor()
  }

*/


   
   
    
     setGain(node1, info.get_gain1to2)
     setGain(node2, info.get_gain2to1)
   }
   
   def updateNode(info: ReactNodeInfo.Msg) {
     val x = info.get_x.toFloat / 1000
     val y = info.get_y.toFloat / 1000
     val num = NodeNum(info.get_id)
    
     val c = getNode(num)
     c.setOffset(x, y)
     nodeLayer.addChild(c)
     c.setVisible(true)
     c.setStatus(info.get_status)
   }
   
   val moved_hook = new mutable.ListBuffer[(Int, Float, Float) => Unit]
     
   def nodeMoved(d: Node) {
     val id = d.nn.n
     val offset = d.getOffset
     for (h <- moved_hook)
       h(id, offset.getX.toFloat, offset.getY.toFloat)
   }

   setInteractingRenderQuality(PPaintContext.LOW_QUALITY_RENDERING)
   setAnimatingRenderQuality(PPaintContext.LOW_QUALITY_RENDERING)
   
   import java.awt.event._
   import javax.swing._
   
   class Popup extends JPopupMenu("Actions") {
     
     def addItem(title: String, fn: ActionEvent => Unit) {
       import react.util.Swing.Implicits._       
       val i = new JMenuItem(title)
       i.addActionListener(fn)
       add(i)
     }
     
     addItem("Select None", {(ae: ActionEvent) =>
       selectNone()
     })
     
     addItem("Select All", {(ae: ActionEvent) =>
       selectAll()
     })

     addItem("Select Neighbors", {(ae: ActionEvent) =>
       selectNone()
     })
     
     addItem("Invert Selection", {(ae: ActionEvent) =>
       invertSelection()
     })
     
   }
   
   val popup = new Popup()
     
   addInputEventListener(new PBasicInputEventHandler() {
     override def mousePressed(e: PInputEvent) {
       if (e.isRightMouseButton) {
         val pos = e.getCanvasPosition
         val (x, y) = (pos.getX.toInt, pos.getY.toInt)
         popup.show(NodeDisplay.this, x, y)
       }
     }
   })
   
   /**
    * Pan handler
    * 
    * When the mouse is dragged:
    * If Shift is pressed, do nothing (avoid conflict with zoom)
    * If Control is pressed:
    *    there are selected nodes, drag selected nodes
    *    otherwise, do nothing
    * Otherwise, pan
    */
   class PanEventHandler extends PPanEventHandler {
     import java.awt.event.InputEvent
     // Make sure there are no conflicts with the zoom handler
     //setEventFilter({
     //  new PInputEventFilter(InputEvent.BUTTON1_MASK)
     //})
     override def mousePressed(e: PInputEvent) {
       if (!e.isShiftDown) {
       //  if (e.isControlDown) {
           super.mousePressed(e)
       //  }
       }
     }
   }
   setPanEventHandler(new PanEventHandler())
   
   /**
    * Zoom when mouse is dragged while Shift is pressed.
    */
   class ZoomEventHandler extends PZoomEventHandler {
     import java.awt.event.InputEvent
     setEventFilter({
       new PInputEventFilter(InputEvent.BUTTON1_MASK)
     })
     override def mousePressed(e: PInputEvent) {
       if (e.isShiftDown) {
         super.mousePressed(e)
       }
     }
   }
   setZoomEventHandler(new ZoomEventHandler())
   
   class NodeDragEventHandler extends PDragEventHandler {
     override def startDrag(e: PInputEvent) {
       super.startDrag(e)
       e.setHandled(true)
       e.getPickedNode.moveToFront
     }
     override def endDrag(e: PInputEvent) {
       val picked = e.getPickedNode
       picked match {
         case d:Node => nodeMoved(d)
         case _ => ()
       }
       super.endDrag(e)
     }
   }

   val nodeLayer = new PLayer()
   val linkLayer = new PLayer()
   
   linkLayer.setChildrenPickable(true)
   
   nodeLayer.setChildrenPickable(true)
   nodeLayer.addInputEventListener(new NodeDragEventHandler())

   // Links go below nodes...
   getLayer.addChild(linkLayer)
   getLayer.addChild(nodeLayer)

   getLayer.setChildrenPickable(true)
   
   /**
    * Selected nods
    */
   def selectedNodes = for (n <- nodes.values if n.selected) yield n
   
   /**
    * Ids of selected nodes
    */
   def selectedNodeIds = (for ((nn, n) <- nodes if n.selected) yield nn.n).toList
   
   /**
    * Clear selection
    */
   def selectNone() = for (n <- selectedNodes) n.selected = false
   
   /**
    * Select all nodes.
    */
   def selectAll() = for ((nn, n) <- nodes) n.selected = true
   
   /**
    * Invert current node selection.
    */
   def invertSelection() = for ((nn, n) <- nodes) n.selected = !n.selected
   
   /**
    * Fit all the nodes within the view area.
    */
   def fitAll() {
     val BORDER_RATIO = 0.1f
     val f = getLayer.getFullBounds
     fit(getLayer.localToGlobal(f), Some(BORDER_RATIO), None)
   }

   /**
    * Fit the selected nodes within the view area.
    */
   def fitSelected() = selectedNodes.toList match {
     case Nil => () // no nodes selected, do nothing
     case first :: rest => {
       val border = if (rest eq Nil) 1.5f else 0.1f
       val bounds: Rectangle2D = first.globalFullBounds
       for (n <- rest) {
         bounds.add(n.globalFullBounds)
       }
       fit(bounds, Some(border), None)
     }
   }
   
   /**
    * Fit the region r, with global coordinates, in the view area.
    * An optional border (percentage of width/height of region) can be
    * specified. The delay can also be specified and, if not specified,
    * default to some nice transitional value.
    */
   def fit(r: Rectangle2D, border: Option[Float], delay_ms: Option[Long]) {
     val _r = border match {
       case Some(b) => {
         val bw = r.getWidth * b
         val bh = r.getHeight * b
         new PBounds(r.getMinX - bw / 2, r.getMinY - bh / 2,
                     r.getWidth + bw, r.getHeight + bh)
       }
       case _ => r
     }
     val l = getCamera.globalToLocal(_r)
     getCamera.animateViewToCenterBounds(l, true, delay_ms.getOrElse {500})          
   }
   
}
