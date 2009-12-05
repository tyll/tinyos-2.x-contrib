package simx.react.util

import java.nio.ByteBuffer
import java.util.Scanner
import java.util.regex.Pattern

/*
 * Encode/decode of values.
 *
 * Float/double are assumed to be IEEE-754 and all encoded integers are
 * are assumed to be in two's complement.
 * 
 * The byte order is determined by the byte oder of the ByteBuffer.
 * 
 *
 * Format:
 * 
 * The encoding/decoding format is similar to the the format used by
 * struct module in python but it has some differences. In particular,
 * "4b" is NOT the same as "bbbb".
 * 
 * fmt: ({endian}?{count}?{type})*
 *   - white-space is ignored
 * 
 * endian, optional:
 * > - big/network (DEFAULT)
 * < - little
 *
 * count, optional:
 * If present this represents a list of elements of the preceding type.
 * Thus, "b" represents be_int8 while "1b" represents list[be_int8]
 * (Thus, "4b" is NOT the same as "bbbb")
 * 
 * type, required:
 * b/B - int8/uint8
 * s/S - int16/uint16
 * i/I - int32/uint32
 * f   - float754
 * d   - double754
 * 
 */
object Binary {
  type B = ByteBuffer
  type IAE = IllegalArgumentException
  val M8  = 0xFF
  val M16 = 0xFFFF
  val M32 = 0xFFFFFFFF
  
  val BIG_ENDIAN = true
  val LITTLE_ENDIAN = false
  
  sealed case class Type()
  case object Int8 extends Type
  case object UInt8 extends Type
  case object Int16 extends Type
  case object UInt16 extends Type
  case object Int32 extends Type
  case object UInt32 extends Type
  case object Float754 extends Type
  case object Double754 extends Type
  
  object FormatParser {
    val endianPat = Pattern.compile("[<>]")
    val typePat = Pattern.compile("[bBhHiIfd]")
    val restPat = Pattern.compile(".+")
  }
  
  class FormatParser(scanner: Scanner) {
    import FormatParser._
    
    def this(s: String) = this(new Scanner(s))
    
    def foreach(fn: ((Boolean, Type, Int)) => Unit) {
      def _each() {
        val endian = if (scanner.hasNext(endianPat)) {
          scanner.next(endianPat) match {
            case "<" => LITTLE_ENDIAN
            case _ => BIG_ENDIAN
          }
        } else BIG_ENDIAN
        val count = if (scanner.hasNextInt()) scanner.nextInt() else 0
        if (scanner.hasNext(typePat)) {
          val t = scanner.next(typePat) match {
            case "b" => Int8
            case "B" => UInt8
            case "h" => Int16
            case "H" => UInt16
            case "i" => Int32
            case "I" => UInt32
            case "f" => Float754
            case "d" => Double754
          }
          fn((endian, t, count))
          _each()
        } else if (scanner.hasNext(restPat)) {
          throw new IAE("Invalid format: at '" + scanner.next(restPat) + "'")
        }
      }
      _each()
    }
  }
  
  /*
   * Decodes a buffer according to fmt.
   */
  def decode(in: B, fmt: String): List[(Type, Any)] = {
    var res = List[(Type, Any)]()
    val parser = new FormatParser(fmt)
    for (i <- parser) {
      val (a, b, c) = i
      ()
    }
    res
  }
  
  /*
   * Decoding methods.
   * 
   * Notes:
   * - Any method can throw a BufferUnderflowException
   * - The resultant type is widened to accomodate unsigned values
   */
  object Decode {
    def int8(in: B): Byte = in.get
    def uint8(in: B): Short = {
      val b = in.get.toShort
      if (b < 0) (b + M8).toShort else b
    }
    
    def int16(in: B): Short = in.getShort
    def uint16(in: B): Int = {
      val s = in.getShort.toInt
      if (s < 0) s + M16 else s
    }
    
    def int32(in: B): Int = in.getInt
    def uint32(in: B): Long = {
      val i = in.getInt.toLong
      if (i < 0) i + M32 else i
    }
    
    def float754(in: B): Float = in.getFloat
    def double754(in: B): Double = in.getDouble
  }
  
  /*
   * Encoding methods.
   * 
   * Note:
   * - Any method can throw a BufferOverflowException
   * - Input types of signed methods take widened values
   * - An InvalidArgumentException is raised if the widened types exceed
   *   the bounds of the underlying type.
   */
  object Encode {
    def int8(out: B, b: Byte): B = out.put(b)
    def uint8(out: B, b: Short): B = {
      if (b < 0) throw new IAE("Negative unsigned byte")
      if (b > M8) throw new IAE("Widened char exceeds 2^8-1")
      out.put((if (b > M8/2) b - M8 else b.toInt).toByte)
    }
    
    def int16(out: B, s: Short): B = out.putShort(s)
    def uint16(out: B, s: Int): B = {
      if (s < 0) throw new IAE("Negative unsigned short")
      if (s > M16) throw new IAE("Widened short exceeds 2^16-1")
      out.putShort((if (s > M16/2) s - M16 else s).toShort)
    }
    
    def int32(out: B, i: Int): B = out.putInt(i)
    def uint32(out: B, i: Long): B = {
      if (i < 0) throw new IAE("Negative unsigned int")
      if (i > M32) throw new IAE("Widened int exceeds 2^32-1")
      out.putInt((if (i > M32/2) i - M32 else i).toInt) 
    }
    
    def float754(out: B, f: Float): B = out.putFloat(f)
    def double754(out: B, d: Double): B = out.putDouble(d)
  }
    
}
