package simx.react.util

import java.awt._
import javax.swing._

import scala.xml._
import scala.collection.immutable

class Layout(layout: Layout.RestoreMap) {
  
  /*
   * Apply a particular layout to a component. The component must act like
   * a frame and must have an associated layout (by title).
   */
  def applyLayout(component: Component) {
    for (f <- Layout.asFrame(component)) {
      layout.get(f.getTitle) match {
        case Some((iconified, bounds)) => {
          f setBounds bounds
          try {
            f setIcon iconified
          } catch {
            case _:NoSuchMethodException => ()
          }
        }
        case None => {
          Log.info("No layout for frame titled: '" + f.getTitle + "'")
        }
      }
    }
  }
  
}

/*
 * Record and restore layouts for things that act like frames.
 */
object Layout {
  import scala.collection.{mutable, Map}
  type Iconified = Boolean
  type RestoreMap = Map[String, (Iconified, Rectangle)]
  
  type ActsLikeFrame = {
    def getTitle(): String
    def getBounds(): Rectangle
    def setBounds(b: Rectangle)
    def isIcon(): Boolean
    def setIcon(b: Boolean)
  }
  
  def saveFile(filename: String, components: Seq[Component]) {
    XML.save(filename, store(components))
  }

  def loadFile(filename: String) = {
    val layout = XML.loadFile(filename)
    new Layout(retrieve(layout))
  }
  
  /*
   * Given a list of components, choose those which act like frames.
   */
  def frameComponents(components: Seq[Component]): Seq[ActsLikeFrame] = for {
    c <- components if (c.isInstanceOf[JFrame] || c.isInstanceOf[JInternalFrame])
  } yield c.asInstanceOf[ActsLikeFrame]
  
  def asFrame(c: Component): Option[ActsLikeFrame] = {
    if (c.isInstanceOf[JFrame] || c.isInstanceOf[JInternalFrame])
      Some(c.asInstanceOf[ActsLikeFrame])
    else None
  }
  
  /*
   * Save the components which act like frames.
   */
  def store(components: Seq[Component]): Node = {
    implicit def int2string(i: Int) = i.toString
    implicit def bool2string(b: Boolean) = b.toString
    
    val info: NodeSeq = for {
      f <- frameComponents(components)
      title = f.getTitle
      b = f.getBounds()
    } yield {
      val iconified = try {
        f.isIcon
      } catch {
        case _:NoSuchMethodException => false
      }
      <frame name={title} iconified={iconified}
      x={b.x} y={b.y} w={b.width} h={b.height}/>
    }
    <layout>{info}</layout>
  }
      
  def retrieve(layout: Node): RestoreMap = {
    val map = new mutable.HashMap[String, (Iconified, Rectangle)]()
    for {
      f <- layout \\ "frame"
    } {
      val name = (f \\ "@name").text
      val iconified = (f \\ "@iconified").text.toLowerCase match {
        case "true" => true
        case _ => false
      }
      val x = (f \\ "@x").text.toInt
      val y = (f \\ "@y").text.toInt
      val w = (f \\ "@w").text.toInt
      val h = (f \\ "@h").text.toInt
      map(name) = (iconified, new Rectangle(x, y, w, h))
    }
    map
  }

}
