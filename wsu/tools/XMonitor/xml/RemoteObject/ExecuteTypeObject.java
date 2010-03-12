package xml.RemoteObject;

import java.io.Serializable;

public class ExecuteTypeObject implements Serializable{
	
	public String dataName = null;
	public String executeType = null;
	public StructureObject structureObject = null;
	
	public ExecuteTypeObject(String dataName, String executeType){
		this.dataName = dataName;
		this.executeType = executeType;
	}

	public void tostring() {
		System.out.println("dataName: " + dataName + " executeType " + executeType);
	}
	
}
