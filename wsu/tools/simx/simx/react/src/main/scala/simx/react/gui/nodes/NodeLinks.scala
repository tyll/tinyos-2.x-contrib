package simx.react.gui.nodes

import java.awt._
import java.awt.geom._

import edu.umd.cs.piccolo._
import edu.umd.cs.piccolo.activities._
import edu.umd.cs.piccolo.nodes._
import edu.umd.cs.piccolo.event._
import edu.umd.cs.piccolox.nodes._

import simx.mig.ReactConst

object Link {
  object Color {
    import java.awt.{Color => AwtColor}
    val OK_LINK = AwtColor.GRAY
    val LINK_ERROR = AwtColor.RED 
    val LINK_WARNING = AwtColor.YELLOW 
  }
}

class Link(var source: Node, var dest: Node) extends PPath {
  import mig.ReactConst.{NODE_ON, NODE_INVALID, NODE_STALE}
  import java.beans.{PropertyChangeListener, PropertyChangeEvent}
  
  // Links/labels can't be moved
  setPickable(false)
  setChildrenPickable(false)
    
  var gain_srcDest: Option[Int] = None
  var gain_destSrc: Option[Int] = None
  
  // TODO: Remove hard-code?
  scale(0.05f)
    
  val gain = new PText("?")
  gain.scale(1f)
  addChild(gain)
 
  updateLink()
  
  def ping() {
    setPaint(Color.GREEN)
    animateToColor(Color.BLACK, 250)
  }
  
  private def updateListener = new PropertyChangeListener() {
    def propertyChange(e: PropertyChangeEvent) = updateLink()
  } 
  source.addPropertyChangeListener(PNode.PROPERTY_FULL_BOUNDS, updateListener)
  dest.addPropertyChangeListener(PNode.PROPERTY_FULL_BOUNDS, updateListener)
  
  /**
   * Determine a color for a link.
   */
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
  
  def updateLink() {
    val p1 = globalToLocal(source.nodeCenter)
    val p2 = globalToLocal(dest.nodeCenter)
    
    val line = new Line2D.Double(p1.getX, p1.getY, p2.getX, p2.getY)
    setPathTo(line)
    
    def gainToString(gain: Option[Int]) = gain match {
      case Some(i) => i.toInt.toString
      case _ => "-"
    }
    
    val p1p2 = gainToString(gain_srcDest)
    val p2p1 = gainToString(gain_destSrc)
    
    val txt = if (p1p2 == p2p1) {
      // Is both directions have same gain, report as one
      p1p2
    } else {
      // Generate correct text depending on positions
      if (source.nodeCenter.getX <= dest.nodeCenter.getX) {
        p1p2 + "/" + p2p1
      } else { 
        p2p1 + "/" + p1p2
      }
    }
    
    // This should be elsewhere
    if (gain_srcDest.isEmpty && gain_destSrc.isEmpty) {
      setVisible(false)
    }
    gain.setText(txt)
    gain.scale(0.6f)

    val (w, h) = (p2.getX - p1.getX, p2.getY - p1.getY)
    gain.setOffset(p1.getX + w/2, p1.getY + h/2)
  }
  
}
