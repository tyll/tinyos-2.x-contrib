package simx.react.util

import java.awt.Container

object LayoutGap {
  import javax.swing.{LayoutStyle, JComponent}
  
  /*
   * Make "gaps" smaller by reducing the preferred and container
   * gaps for the current layout. This change is global.
   */
  def useThinGaps(mul: Float) {
    val ls = LayoutStyle.getInstance()
    LayoutStyle.setInstance(new LayoutStyle {
      type C = JComponent
      type CP = LayoutStyle.ComponentPlacement
      
      def getPreferredGap(c1: C, c2: C, t: CP, i: Int, p: Container) =
        (ls.getPreferredGap(c1, c2, t, i, p) * mul).toInt	
      
      def getContainerGap(c1: C, i: Int, p: Container) =
        (ls.getContainerGap(c1, i, p) * mul).toInt + 1
    })
  }
  
}
