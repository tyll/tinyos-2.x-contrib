package simx.react.gui.nodes

import java.awt._
import java.awt.geom._

import edu.umd.cs.piccolo._
import edu.umd.cs.piccolo.activities._
import edu.umd.cs.piccolo.nodes._
import edu.umd.cs.piccolo.event._
import edu.umd.cs.piccolox.nodes._

case class NodeNum(n: Int)

object Node {
  val GOOD_COLOR = Color.BLUE
  val INVALID_COLOR = Color.RED
  val STALE_COLOR = Color.GREEN
  val OFF_COLOR = Color.GRAY
}

class Node(var nn: NodeNum) extends PComposite {
  import mig.ReactConst.{NODE_ON, NODE_INVALID, NODE_STALE}
  import Node._
  val R = 5f // radius of "node circle"
  val A = 1.1f
  scale(0.05f) // TODO: Remove hard-code?
  
  addInputEventListener(new PBasicInputEventHandler() {
    override def mousePressed(event: PInputEvent) {
      if (event.isShiftDown) {
        selected = !selected
      }
    }
  })
  
  val select_ring = PPath.createEllipse(-A*R, -A*R, 2*A*R, 2*A*R)
  select_ring.setPaint(Color.GREEN)
  select_ring.setStrokePaint(Color.GREEN)
  addChild(select_ring)
  
  val node = PPath.createEllipse(-R, -R, 2*R, 2*R)
  node.setPaint(STALE_COLOR)
  addChild(node)
  
  {	 
    val number = new PText(nn.n.toString)
    number.setTextPaint(Color.BLACK)
    number.scale(0.6f)
    number.offset(0, -number.getHeight)
    addChild(number)
  }
  
  // Selection information
  
  var selected_@ = false
  def selected_=(selected: Boolean) {
    selected_@ = selected
    select_ring.setVisible(selected_@)
  }
  def selected = selected_@
  
  selected = false
  
  /**
   * Returns color associated with a given status.
   */
  def statusColor(level: Int) = {
    if ((level & NODE_ON) == 0) {
      OFF_COLOR
    } else {
      if ((level & NODE_INVALID) != 0) INVALID_COLOR
      else if ((level & NODE_STALE) != 0) STALE_COLOR
      else GOOD_COLOR
    }
  }
  
  /**
   * Update the status level of a node.
   */
  def setStatus(level: Int) {
    node.setPaint(statusColor(level))
  }
  
  // Returns the center of the node circle in global coordinates}
  def nodeCenter: Point2D = node.localToGlobal(node.getBounds.getCenter2D)
  
  def globalFullBounds = node.localToGlobal(node.getFullBounds)
    
}
