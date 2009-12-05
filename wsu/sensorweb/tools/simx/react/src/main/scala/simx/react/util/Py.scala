package simx.react.util

object Py {
  object Implicit {
    implicit def pyfn2str(py: Fn): String = py.toString
    implicit def int2pyint(i: Int): Val = PyInt(i)
    implicit def str2pystr(s: String): Val = Str(s)
    implicit def float2pyfloat(s: Float): Val = PyFloat(s)
  }
  case class Val()
  case class PyInt(int: Int) extends Val {
    override def toString = int.toString
  }
  case class PyFloat(float: Float) extends Val {
    override def toString = float.toString
  }
  case object Range {
    def apply(str: String): Range = {
      if (str contains "-") {
        val split = str.split("-").map(_.toInt)
        Range(split(0), split(1), 1)
      } else {
        val start = str.toInt
        Range(start, start + 1, 1)
      }
    }
  }
  case class Range(start: Int, stop: Int, step: Int) extends Val {
    import Implicit._
    override def toString = Fn("range", start, stop, step).toString
  }
  case class PyList(items: List[Any]) extends Val {
    override def toString = "[" + items.mkString(",") + "]"
  }
  case class Str(str: String) extends Val {
    override def toString = "'''" + str + "'''"
  }
  case class Fn(fn: String, params: Val*) extends Val {
    override def toString = fn + "(" + params.mkString(",") + ")"
  }
}
