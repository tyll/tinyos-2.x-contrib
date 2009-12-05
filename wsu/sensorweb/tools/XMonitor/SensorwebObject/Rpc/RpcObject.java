package SensorwebObject.Rpc;

import java.io.Serializable;
import java.util.Vector;

public class RpcObject implements Serializable{
	
	public String name;
	public Vector<RpcField> rpcCommandFieldList;
	
	
	public RpcObject(String name){
		this.name = name;
		rpcCommandFieldList = new Vector();
	}
	
	public void addCommandField(RpcField field){
		rpcCommandFieldList.add(field);
	}
	
	public void tostring(){
		System.out.println("Name: " + name);
		for (int i = 0 ; i < rpcCommandFieldList.size(); i++){
			RpcField currentField = rpcCommandFieldList.get(i);
			System.out.println("   Offset: "   + currentField.bitoffset 
					+ " Name: " + currentField.name 
					+ " Size: " + currentField.size); 
		}
		
	}
	
}
