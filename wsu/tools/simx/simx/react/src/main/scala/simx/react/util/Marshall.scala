package simx.react.util

import scala.xml.{XML, NodeSeq}

/*
 * Marshall from, or to, XML based on a Schema.
 * 
 * A schema generated using closures is used to "know" how to read in
 * and write each property. This allows type-safety to be kept the entire
 * chain. However, because the schema is generated with closures
 * and, unless it needs to hang about, performed at the last-possible-moment,
 * this approach may be [significantly] slower than approaches which only
 * need to marshall into, or out of, a generic structure, such as a HashMap.
 * It's a good thing configuration settings aren't saved very often!
 * 
 * This is designed to work primarily with Bind although other types
 * should work just fine.
 * 
 * This currently does not support ``non-flat'' XML schemas and the current
 * XML in/out methods are rather limitted.
 */

object Marshall {
  type Schema = List[Rule[_]]
  
  def retrieve(xml: NodeSeq, schema: Schema) = {
    for (config <- xml \\ "config") {
      for (item <- xml \\ "item") {
        // TODO: User pattern-matching
        val name = (item \\ "@name").text
        val value = item.child.text
        // TODO: Make this not O(n)
        for (rule <- schema) {
          if (rule.name == name)
            rule.retrieve(value)
        }
      }
    }
  }
    
  def store(schema: Schema): NodeSeq = {
    for (rule <- schema)
      yield <item name={rule.name}>{rule.store}</item>
  }

  /*
   * Functions to marshall in and out.
   * The schema can use one of these or something else.
   */
  
  abstract class Conv[T] {
    def in(d: String): Option[T]
    def out(d: T): String
  }
  
  object String extends Conv[String] {
    def in(d: String) = Some(d)
    def out(d: String) = d
  }
  
  object Boolean extends Conv[Boolean] {
    def in(d: String) = d.toLowerCase match {
      case "true" => Some(true)
      case "false" => Some(false)
      case _ => None
    } 
    def out(d: Boolean) = d.toString
  }

}

object Rule {
  /*
   * A rule constructor that automatically works with Bind types.
   */
  def apply[T](name: String, bind: Bind[T],
               conv: Marshall.Conv[T], default: T): Rule[T] = {
    Rule(name, conv, default)(bind.value = _, () => bind.value)
  }
}

case class Rule[T](
  name: String,
  conv: Marshall.Conv[T],
  default: T)(in: (T) => Unit, out: () => T) {
  
  def store(): String = conv.out(out())
  def retrieve(d: String) = in(conv.in(d) getOrElse {
    Log.warn("No value found for " + name + " using default: " + default)
    default
  })
}
