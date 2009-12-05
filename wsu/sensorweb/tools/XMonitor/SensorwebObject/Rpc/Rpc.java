//$Id$

/**
 * Copyright (C) 2006 WSU All Rights Reserved
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE WASHINGTON STATE UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE WASHINGTON 
 * STATE UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE WASHINGTON STATE UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE WASHINGTON STATE UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */


/**
 * Function Description:
 * A container class from which to call all rpc functions
 *
 * @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */


package SensorwebObject.Rpc;



import java.io.*;
import java.util.Vector;
import java.util.Enumeration;


import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;


/**
 * A container class from which to call all rpc functions
 */
public class Rpc implements Serializable
{
	//List of Rpc Functions
	public Vector rpcFunctions;
	NescApp app;

	//Abstract all rpc functions from rpcSchema.xml
	public Rpc(String buildDir, NescTypes types, NescApp app)
	{
		this.app = app;
		rpcFunctions = new Vector();
		int i;
		
		//get rpc functions from xml file
		String xmlFileName = buildDir + "/rpcSchema.xml";
		Document dom= NescApp.getDomFromXml(xmlFileName);

		//get list of nodes in dom
		Element docEle = dom.getDocumentElement();
		NodeList funcs = docEle.getElementsByTagName("rpcFunctions");
		NodeList functions = funcs.item(0).getChildNodes();
		if(functions != null && functions.getLength() > 0) {
			for(i = 0 ; i < functions.getLength();i++) {	
				//get name of each rpc function
				Node el = functions.item(i);
				if ( el.getNodeType()== 1){ // //ELEMENT_NODE
					//get info of each rpc Function, 
					//and create new struct for its params into types._structs
					StructArgs args = RpcFunction((Element)el, types);
					if (args != null){
						rpcFunctions.addElement(args);
					}
				}
			}
		}
	}


    /**
	 * Save rpc functions into nescStruct struct
	 */
	public StructArgs RpcFunction(Element xmlDef, NescTypes types)
	{
		Enumeration e;
		NodeList param;
		int i;

		StructArgs structArgs; 
		String name;
		Vector params = new Vector();
		String paramName, paramType;
		NescDecls._ParamTuple rpcparam;
		NescDecls._FieldType type;
		String responseType;
		int commandID;
		int dataLength = 0;
		int size;

		NescDecls.nescType nesctype = new NescDecls.nescType();
		NescDecls.nescStruct nescstruct = new NescDecls.nescStruct();

		name = ((Node)xmlDef).getNodeName();
		int numParam = Integer.valueOf(xmlDef.getAttribute("numParams")).intValue();
		for (i=0; i<numParam; i++) {
			param = xmlDef.getElementsByTagName("param"+i);
			paramName = ((Element)param.item(0)).getAttribute("name");
			paramType = ((Element)(((Element)param.item(0)).getElementsByTagName("type")).item(0)).getAttribute("typeName");

			//param might be simple type or struct, 
			//(not consider array here: pointer is not applicable for rpc)
			type = new NescDecls._FieldType();
			app.getType(paramType, nesctype);
			if (nesctype.nesctype == null) {
				app.getStruct(paramType, nescstruct);
				if (nescstruct.nesctype == null) {
					System.out.println("Error: In Rpc.java: undefined type: "+ paramType);
					//System.exit(0);
				}
				else{
					NescDecls._FieldType ttype = new NescDecls._FieldType();
					ttype.typename = paramType;
					type.fieldtype = ttype;
					type.typename = null;	
					type.isStruct = true;
				}
			}
			else{
				type.fieldtype = null;
				type.typename = paramType;	
			}
			
			rpcparam = new NescDecls._ParamTuple(paramName, type);
			params.addElement(rpcparam);
		}
	
		commandID = Integer.valueOf(xmlDef.getAttribute("commandID")).intValue();
		responseType = ((Element)(xmlDef.getElementsByTagName("returnType").item(0))).getAttribute("typeName");
		
		structArgs = new StructArgs(name, params, responseType, commandID, dataLength);

		NescApp._Struct newstruct = new NescApp._Struct(name, new NescDecls.nescStruct(name, params,app));
		types._structs.addElement(newstruct);
		dataLength = app.getsize(name);
		structArgs.dataLength = dataLength;

		return structArgs;
	}

	
	public Vector getRpcList()
	{
		//YFHDebug: Print All
		/*for (Enumeration e = rpcFunctions.elements(); e.hasMoreElements(); )
		{
			StructArgs r = (StructArgs)e.nextElement();
			System.out.println(r.name);
		}*/

		return rpcFunctions;
	}


	public StructArgs findRpcFunc(String name)
	{
		boolean found = false;
		StructArgs cmd = null;
		for (Enumeration e = rpcFunctions.elements(); e.hasMoreElements(); )
		{
			cmd = (StructArgs)e.nextElement();
			if (cmd.name.equals(name)){
				found = true;
				break;
			}
		}
		if (!found){
			System.out.println("In Rpc.findRpcFunc(): Error: Can not find parameter list for "+name+" !");			
		}
		return cmd;
	}


	public StructArgs findRpcFunc(int Id)
	{
		boolean found = false;
		StructArgs cmd = null;
		for (Enumeration e = rpcFunctions.elements(); e.hasMoreElements(); )
		{
			cmd = (StructArgs)e.nextElement();
			if (cmd.commandID == Id){
				found = true;
				break;
			}
		}
		if (!found){
			System.out.println("In Rpc.findRpcFunc(): Error: Can not find parameter list for commandID= "+Id+" !");			
		}
		return cmd;
	}



	static public class StructArgs implements Serializable
	{
		public String name;
		public Vector params;
		public String responseType;
		public int commandID;
		public int dataLength;

		public StructArgs()
		{
			name = "";
			params = null;
			responseType = "";
			commandID = -1;
			dataLength = 0;
		}

		public StructArgs(String name, Vector params, String responseType, int commandID, int dataLength)
		{
			this.name = name;
			this.params = params;
			this.responseType = responseType;
			this.commandID = commandID;
			this.dataLength = dataLength;
		}
	};

}
