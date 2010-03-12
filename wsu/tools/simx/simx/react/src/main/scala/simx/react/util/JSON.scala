package simx.react.util

import org.json._

/*
 * Convert a a JSON string to a Map/List/Value and back.
 */
object JSON {
  import scala.collection.immutable.HashMap
  import scala.collection.jcl.MutableIterator.{Wrapper => IterWrap}
  val NULL = JSONObject.NULL
  
  /*
   * Converts JSONObject/JSONArray/etc. into nice Scala objects.
   */
  def unmap(s: AnyRef): AnyRef = s match {
    case o:JSONObject => {
      val iter = new IterWrap(o.keys.asInstanceOf[java.util.Iterator[String]])
      new HashMap[String, AnyRef] ++
        (for (k <- iter; item = o.get(k)) yield (k, unmap(item)))
    }
    case a:JSONArray => {
      (for (i <- 0 until a.length; item = a.get(i)) yield unmap(item)).toList
    }
    case NULL => null
    case x => x
  }
  
  /*
   * Attempt to parse a string of JSON and returns a representative
   * datastructure.
   */
  def fromString(s: String): AnyRef = {
    //println(">>" + s + "<<")
    val decoded = if (s startsWith "{") {
      new JSONObject(s)
    } else if (s startsWith "[") {
      new JSONArray(s)
    } else {
      JSONObject.stringToValue(s)
    }
    unmap(decoded)
  }
  
  /**
   * Ditto, but returns an Option. None on failure.
   */
  def optionFromString(s: String): Option[AnyRef] = try {
    Some(fromString(s))
  } catch {
    case _ => None
  }
  
}
