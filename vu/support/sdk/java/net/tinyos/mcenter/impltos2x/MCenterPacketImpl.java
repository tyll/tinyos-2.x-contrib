package net.tinyos.mcenter.impltos2x;

import net.tinyos.mcenter.MCenterPacket;
import net.tinyos.message.Message;
import net.tinyos.message.SerialPacket;

public class MCenterPacketImpl extends SerialPacket implements MCenterPacket{

	public MCenterPacketImpl() {
		super();
	}

	public MCenterPacketImpl(byte[] data, int base_offset, int data_length) {
		super(data, base_offset, data_length);

	}

	public MCenterPacketImpl(byte[] data, int base_offset) {
		super(data, base_offset);

	}

	public MCenterPacketImpl(byte[] data) {
		super(data);
	}

	public MCenterPacketImpl(int data_length, int base_offset) {
		super(data_length, base_offset);
	}

	public MCenterPacketImpl(int data_length) {
		super(data_length);
	}

	public MCenterPacketImpl(Message msg, int base_offset, int data_length) {
		super(msg, base_offset, data_length);
	}

	public MCenterPacketImpl(Message msg, int base_offset) {
		super(msg, base_offset);
	}

	public byte[] getRaw_bytes() {
		return super.dataGet();
	}

	public short[] getRaw_data() {
		short[] data = new short[data_length];
		for(int i=0; i<data_length; i++){
			data[i] = super.getElement_data(i);
		}
		return data;
	}

	public int getOffset_data(int index1) {
		return SerialPacket.offset_data(index1);
	}

}
