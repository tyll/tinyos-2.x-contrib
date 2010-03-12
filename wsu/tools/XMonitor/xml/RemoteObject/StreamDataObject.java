package xml.RemoteObject;

import java.io.Serializable;
import java.util.Vector;

public class StreamDataObject implements Serializable{
	
	public String name;
	public Vector data;
	
	public StreamDataObject(String name, Vector data){
		this.name = name;
		this.data = data;
	}
	
}
