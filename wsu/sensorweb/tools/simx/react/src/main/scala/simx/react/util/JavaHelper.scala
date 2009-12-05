package simx.react.util

object JavaHelper {
  /**
   * Returns an option representing a nullable type.
   */
  def toOption[T](a: T) = a match {case null => None; case _ => Some(a)}
}
