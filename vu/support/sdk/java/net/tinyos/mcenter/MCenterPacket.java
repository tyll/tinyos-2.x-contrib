package net.tinyos.mcenter;

public interface MCenterPacket {

	/**
	 * Return the value (as a int) of the field 'header.dest'
	 */
	public int get_header_dest();

	/**
	 * Set the value of the field 'header.dest'
	 */
	public void set_header_dest(int value);

	/**
	 * Return the value (as a int) of the field 'header.src'
	 */
	public int get_header_src();

	/**
	 * Set the value of the field 'header.src'
	 */
	public void set_header_src(int value);

	/**
	 * Return the value (as a short) of the field 'header.length'
	 */
	public short get_header_length();

	/**
	 * Set the value of the field 'header.length'
	 */
	public void set_header_length(short value);

	/**
	 * Return the value (as a short) of the field 'header.group'
	 */
	public short get_header_group();

	/**
	 * Set the value of the field 'header.group'
	 */
	public void set_header_group(short value);

	/**
	 * Return the value (as a short) of the field 'header.type'
	 */
	public short get_header_type();

	/**
	 * Set the value of the field 'header.type'
	 */
	public void set_header_type(short value);

	/**
	 * Return the entire array 'data' as a short[]
	 */
	public short[] get_data();

	/**
	 * Set the contents of the array 'data' from the given short[]
	 */
	public void set_data(short[] value);

	/**
	 * Return an element (as a short) of the array 'data'
	 */
	public short getElement_data(int index1);

	/**
	 * Set an element of the array 'data'
	 */
	public void setElement_data(int index1, short value);

	/**
	 * Return the entire message as a short[]
	 */
	public short[] getRaw_data();

	/**
	 * Return the entire message as a byte[]
	 */
	public byte[] getRaw_bytes();
	
	/**
     * Return the offset (in bytes) of the field 'data'
     */
    public int getOffset_data(int index1);
	
}