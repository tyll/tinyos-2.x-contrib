package simx.react.util

object SimTime {
  /*
   * Convert from high-32/low-32 bits to true 64-bit simtime.
   */
  def apply(timeH: Long, timeL: Long): SimTime =
    SimTime((timeH << 32) + timeL)
}

case class SimTime(time: Long) {
  // Values must match TOSSIM
  val TPS = 10000000000L
  val TPS_PER_NANO = 10
  
  /*
   * Return a string representation with the prec representing
   * number of sub-fractional digits. 0 for no fractions of seconds,
   * 2 split seconds, 3 milliseconds, 6 microseconds, 9 nanoseconds.
   */
  def toString(prec: Int) = {
    def _toString(prec: Int) = {
      val full_seconds = time / TPS
      val nanos = (time % TPS) / Math.pow(10, 9 - prec).toInt / TPS_PER_NANO
      val seconds = full_seconds % 60
      val hours = full_seconds / 3600
      val minutes = (full_seconds - hours * 3600) / 60
      val format = if (prec != 0) "%02d:%02d:%02d.%0" + prec + "d"
                   else "%02d:%02d:%02d"

      // Conflicts with predef when using implicit
      def o(i: Long) = i.asInstanceOf[Object]
      String.format(format, o(hours), o(minutes), o(seconds), o(nanos))
    }
    
    _toString(prec.max(0).min(9))
  }
  
  override def toString = toString(9) 
}
