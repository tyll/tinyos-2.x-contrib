package xml.RemoteObject;

import java.io.Serializable;

public class StructureField implements Serializable{
	
	public String message = null;
	public String messageField = null;
	public String encode = null;
	public String value = null;
	
	public StructureField(String message, String messageField, String encode, String value){
		this.message = message;
		this.messageField = messageField;
		this.encode = encode;
		this.value = value;	
	}
	
	public void tostring(){
		System.out.println("message: " + message + " messageField: " + messageField + " encode: " +
				encode + " value " + value);
	}
	
}