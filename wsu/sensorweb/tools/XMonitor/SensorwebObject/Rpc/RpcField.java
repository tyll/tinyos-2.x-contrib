package SensorwebObject.Rpc;

import java.io.Serializable;

public class RpcField implements Serializable{
	
	public int bitoffset;
	public String name;
	public int size;
	public String value;
	public String encode;
	
	public RpcField(int bitoffset, String name, int size){
		this.bitoffset = bitoffset;
		this.name = name;
		this.size = size;
	}
	
}
