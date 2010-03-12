/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package SensorwebObject.Rpc;

import java.io.Serializable;
import java.util.Vector;

/**
 *
 * @author Gavin
 */
public class RpcSender_Object_Client implements Serializable{


     private Vector fieldValues;
     private String functionName;
     private String desIP;
     private static long id;


     public RpcSender_Object_Client(){
    	 id++;
     }

     public long getEventID(){
         return id;          
     }


     public String getDesIP(){
    	 return desIP;
     }


	public void setDesIP(String myIP) {
		this.desIP = myIP;
	}


	public void setFieldValue(Vector fieldValues){
		this.fieldValues = fieldValues;
	}

	public Vector getFieldValue(){
		return this.fieldValues;
	}

	public void setFunctionName(String functionName){
		this.functionName = functionName;
	}

	public String getFunctionName(){
		return this.functionName;
	}
}
