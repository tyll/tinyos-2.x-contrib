package simx.react.util

/*
 * Simple "declarative-style" bindings.
 * Closures and implicit callbacks.
 * This isn't designed to be fast and expensive operations can
 * be cascaded. However, for forms and such...
 * 
 * val a = new Bind("Here?")
 * val b = new Bind("Who?")
 * 
 * a.value // "Here?"
 * a << b <= {"Hello " + b}
 * a.value // "Hello Who?"
 * 
 * b.value = "Bob"
 * a.value // "Hello Bob"
 * 
 * val c = new Bind("Unknown!")
 * a << b << c <= {"Hello " + b + " and " + c}
 * 
 * a.value // "Hello Bob and Unknown!"
 * c.value = "Charlie"
 * a.value // "Hello Bob and Charlie"
 * 
 */
import scala.collection.mutable

object Bind {
  def apply(): Bind[Any] = {
    new Bind(null)
  }
  
  def apply[T](fn: Function[T, Any]): Bind[T] = {
    val b = new Bind[T](null.asInstanceOf[T])
    Bind() << b <= fn(~b)
    b
  }
}
 
object BindEdt {
  import react.util.EDT
  
  def apply[T](fn: Function[T, Any]): Bind[T] = {
    val b = new Bind[T](null.asInstanceOf[T])
    Bind() << b <= EDT.run(fn(~b))
    b
  }
}

class Bind[A](var _value: A) {
  // Targets are things that need to know about the change
  val targets = new mutable.HashSet[Bind[Any]]()

  // What to do on a change
  var fn: () => A = () => _value
    
  // Update all targets (object changed)
  def force {
    for (t <- targets)
      t.cascade()
  }
    
  // Set the value (and cause changes to propogate)
  def set(_v: A) {
    _value = _v;
    this.force
  }
    
  def value = _value
  def value_=(_v: A) = set(_v)

  // Means a value changes, re-calc.
  def cascade() = set(fn())

  // Returns the value. I wish Scala had more unary operators.
  def unary_~ = _value
    
  // Set the action
  def <= (_fn: => A) {
    fn = () => _fn
    // Value "forced" at start
    set(fn())
  }

  // Add a source
  def << (s: Bind[_]) = {
    s.targets += this.asInstanceOf[Bind[Any]]
    this
  }
  
  // Add a single self-representing source
  def <<| (s: Bind[A]) {
    s.targets += this.asInstanceOf[Bind[Any]]
    this <= ~s
  }
  
}

/*
object SwingBind {
  type HasEnabled = {
    def setEnabled(x: Boolean);
    def isEnabled: Boolean
  }
  
  implict def bindEnable(s: HasEnabled) = new {
    def bindEnabled() {
      new Bind(s.isEnabled) {
        def <= (f: => Bind.A) {
          s.setEnabled()
        }
      }
    }
  }
}
*/