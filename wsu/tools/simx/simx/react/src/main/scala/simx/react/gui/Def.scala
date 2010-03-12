package simx.react.gui

import scala.collection.mutable._

object Def {
  class ProbeDef
  case class DefStruct(members: List[(String, ProbeDef)]) extends ProbeDef
  case class DefArray(size: Int, of: ProbeDef) extends ProbeDef {
    override def toString() = "array (" + size + ")"
  }
  case class DefBasic(value: String) extends ProbeDef
  case class DefInvalid(value: String) extends ProbeDef
  
  def reconstructStruct(h: HashMap[String, Any]): Option[ProbeDef] = try {
    for (dtype <- h.get("$type") if (dtype == "struct")) yield {
      val casted = (h.get("$members") getOrElse Nil).asInstanceOf[List[_]] 
      val members = for (member <- casted) yield {
        member match {
          case List(name:String, data) => (name, reconstructDef(data))
          case _ => ("<invalid>", DefInvalid(member.toString))
        }
      }
      DefStruct(members)
    }
  } catch {
    case _:ClassCastException => Some(DefInvalid("CCE: " + h.toString))
  }
  
  def reconstructArray(h: HashMap[String, Any]): Option[ProbeDef] = try {
    for (dtype <- h.get("$type") if (dtype == "array")) yield {
      val count = (h.get("$count") getOrElse 0).asInstanceOf[Int]
      val elm_type = {
        for (t <- h.get("$of")) yield 
          reconstructDef(t)
      } getOrElse DefInvalid("<unknown type>")
      DefArray(count, elm_type)
    }
  } catch {
    case _:ClassCastException => Some(DefInvalid("CCE: " + h.toString))
  }
      
  /*
   * Reconstruct a definition based on format from probe.py
   */
  def reconstructDef(structure: Any): ProbeDef = try {
    structure match {
      case h:HashMap[_, _] => {
        val casted = h.asInstanceOf[HashMap[String, Any]]
        reconstructStruct(casted) getOrElse {
          reconstructArray(casted) getOrElse
            DefInvalid(h.toString)
        }
      }
      case l:List[_] => DefInvalid(l.toString)
      case o => DefBasic(o.toString)
    }
  } catch {
    case _:ClassCastException => DefInvalid("CCE: " + structure.toString)
  }
}
