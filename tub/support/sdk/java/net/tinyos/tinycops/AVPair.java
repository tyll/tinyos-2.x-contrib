/**
 * @author mig and Jan Hauer
 */


package net.tinyos.tinycops;
public class AVPair extends net.tinyos.message.Message {

    public static final int DEFAULT_SIZE = 2;
    protected int value_length;
    
    /** Create a new AVPair of the given value_length in byte. */
    public AVPair(int value_length) {
      super(value_length + DEFAULT_SIZE);
      set_control((short) (value_length + DEFAULT_SIZE + 0x80));
      this.value_length = value_length;
    }
    
    public int getSize() {
      return value_length + DEFAULT_SIZE;
    }
    /**
    /* Return a String representation of this message. Includes the
     * message type name and the non-indexed field values.
     */
    public String toString() {
      String s = "Message <AVPair> \n";
      try {
        s += "  [control=0x"+Long.toHexString(get_control())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [attributeID=0x"+Long.toHexString(get_attributeID())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [value=0x"+Long.toHexString(get_value())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      return s;
    }

    // Message-type-specific access methods appear below.

    /////////////////////////////////////////////////////////
    // Accessor methods for field: control
    //   Field type: short, signed
    //   Offset (bits): 0
    //   Size (bits): 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'control' is signed (true).
     */
    public static boolean isSigned_control() {
        return true;
    }

    /**
     * Return whether the field 'control' is an array (false).
     */
    public static boolean isArray_control() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'control'
     */
    public static int offset_control() {
        return (0 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'control'
     */
    public static int offsetBits_control() {
        return 0;
    }

    /**
     * Return the value (as a short) of the field 'control'
     */
    public short get_control() {
        return (short)getUIntBEElement(offsetBits_control(), 8);
    }

    /**
     * Set the value of the field 'control'
     */
    protected void set_control(short value) {
        setUIntBEElement(offsetBits_control(), 8, value);
    }

    /**
     * Return the size, in bytes, of the field 'control'
     */
    public static int size_control() {
        return (8 / 8);
    }

    /**
     * Return the size, in bits, of the field 'control'
     */
    public static int sizeBits_control() {
        return 8;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: attributeID
    //   Field type: short, signed
    //   Offset (bits): 8
    //   Size (bits): 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'attributeID' is signed (true).
     */
    public static boolean isSigned_attributeID() {
        return true;
    }

    /**
     * Return whether the field 'attributeID' is an array (false).
     */
    public static boolean isArray_attributeID() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'attributeID'
     */
    public static int offset_attributeID() {
        return (8 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'attributeID'
     */
    public static int offsetBits_attributeID() {
        return 8;
    }

    /**
     * Return the value (as a short) of the field 'attributeID'
     */
    public short get_attributeID() {
        return (short)getUIntBEElement(offsetBits_attributeID(), 8);
    }

    /**
     * Set the value of the field 'attributeID'
     */
    public void set_attributeID(short value) {
        setUIntBEElement(offsetBits_attributeID(), 8, value);
    }

    /**
     * Return the size, in bytes, of the field 'attributeID'
     */
    public static int size_attributeID() {
        return (8 / 8);
    }

    /**
     * Return the size, in bits, of the field 'attributeID'
     */
    public static int sizeBits_attributeID() {
        return 8;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: value
    //   Field type: byte[], signed
    //   Offset (bits): 16
    //   Size of each element (bits): 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'value' is signed (true).
     */
    public static boolean isSigned_value() {
        return true;
    }

    /**
     * Return whether the field 'value' is an array (true).
     */
    public static boolean isArray_value() {
        return true;
    }

    /**
     * Return the offset (in bytes) of the field 'value'
     */
    public static int offset_value() {
        return (16 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'value'
     */
    public static int offsetBits_value() {
        return 16;
    }

    /**
     * Return the value (as a int) of the field 'value'
     */
    public int get_value() {
        return (int)getUIntBEElement(offsetBits_value(), this.value_length * 8);
    }
    
    /**
     * Return the value (as a 16 bit int[]) of the field 'value'
     */
    public int[] get_value16bitArray (){
      int entries = value_length / 2;
      int result[] = new int[entries];
      for (int i=0; i<entries; i++){
        result[i] = (int)getUIntBEElement(offsetBits_value() + (16 * i), 2 * 8);
      }
      return result;
    }

    /**
     * Set the value of the field 'value'
     */
    public void set_value(long value) {
        setUIntBEElement(offsetBits_value(), this.value_length * 8, value);
            }

    /**
     * Set the value of the field 'value'
     */
    public void set_value(byte[] data) {
        for (int k = 0; k<data.length; k++)
          setUIntBEElement(offsetBits_value() + (k*8), 8, data[k]);
    }
}
