package xml.RemoteObject;

import java.io.Serializable;
import java.util.Vector;

public class StructureObject implements Serializable{
	
	public String name = null;
	public Vector<StructureField> structureFields = null;
	
	public StructureObject(String name){
		this.name = name;
		this.structureFields = new Vector<StructureField>();
	}
	
	
	public void tostring(){
		System.out.println("Name: " + name);
		for (int i = 0 ; i < structureFields.size(); i++){
			StructureField field = structureFields.get(i);
			field.tostring();
		}
	}
	
	
}

