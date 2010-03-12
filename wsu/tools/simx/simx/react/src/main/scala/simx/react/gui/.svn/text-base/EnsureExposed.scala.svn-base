package simx.react.gui

import javax.swing.JInternalFrame
import javax.swing.event._ //InternalFrameEvent
import java.awt.event._
import java.beans._ //{PropertyChangeListener, PropertyChangeEvent}

/*
 * Ensure the frame is at least partially exposed within the desktop.
 * 
 * The frame may still be covered, but this helps protect against
 * "lost frames" caused when the DesktopFrame is shrunk.
 */
trait EnsureExposed extends JInternalFrame {

  /*
   * React to changes in parent bounds
   */
  addHierarchyBoundsListener(new HierarchyBoundsAdapter {
    override def ancestorResized(ae: HierarchyEvent) = expose()
  })
  
  /*
   * Ensure exposed on activation or deiconification.
   */
  addInternalFrameListener(new InternalFrameAdapter {
    override def internalFrameActivated(ie: InternalFrameEvent) = expose()
    override def internalFrameDeiconified(ie: InternalFrameEvent) = expose()
  })
      
  def expose() {
    getDesktopPane match {
      case null => ()
      case desktop => {
        val GAP = 80
        def bound(v: Int, low: Int, high: Int) = (high min v) max low 
        val (min_x, max_x) = (-getWidth + GAP, desktop.getWidth - GAP)
        val (min_y, max_y) = (-getHeight + GAP, desktop.getHeight - GAP)
        setLocation(bound(getX, min_x, max_x),
                    bound(getY, min_y, max_y))      
      }
    }
  }
  
}
