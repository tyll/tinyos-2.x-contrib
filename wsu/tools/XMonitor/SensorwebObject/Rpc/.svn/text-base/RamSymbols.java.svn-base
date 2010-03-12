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
 * A container class from which to find all ram symbols
 *
 * @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */


package SensorwebObject.Rpc;

import java.io.*;
import java.util.Vector;
import java.util.Enumeration;

import java.util.regex.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;



/**
 * A container class from which to find all ram symbols
 */
public class RamSymbols implements Serializable
{
	public Vector ramSymbols;
	NescDecls decls;
	NescApp app;
	
	/**
	 * Abstract all ramSymbols from nescDecls.xml
	 */
	public RamSymbols(String buildDir, NescTypes types, NescApp app)
	{	
		this.app = app;
		this.decls = new NescDecls(app);
		int i;
		RamArgs ramArgs;
		ramSymbols = new Vector();
		
		//get ram symbols from xml file
		String xmlFileName = buildDir + "/nescDecls.xml";
		Document dom= NescApp.getDomFromXml(xmlFileName);
			
		//get list of nodes in dom
		Element docEle = dom.getDocumentElement();
		NodeList schema = docEle.getElementsByTagName("ramSymbols");
		NodeList symbols = schema.item(0).getChildNodes();
		if(symbols != null && symbols.getLength() > 0) {
			for(i = 0 ; i < symbols.getLength();i++) {	
				Node symDef = symbols.item(i);
				if ( symDef.getNodeType()== 1){ // //ELEMENT_NODE
					ramArgs = RamSymbol((Element)symDef, types);
					if (ramArgs.name != null){
		
						ramSymbols.addElement(ramArgs);
					//	if (ramArgs.name.substring(0,4).equals("Test"))
					//		System.out.println(ramArgs.name);
					}
				}
			}
		}
		else{
			System.out.println("Warning: No ramSymbols in this Application.");
		}
		
	}


    /**
	 * Get info for each ram symbol from XML file 
	 */
	public RamArgs RamSymbol(Element xmlDef, NescTypes types)
	{
    		NodeList typeDef;
		int i, numElements=0;
		
		RamArgs ramArgs = new RamArgs();
		NescDecls.nescType nesctype = new NescDecls.nescType();
		NescDecls.nescStruct nescstruct = new NescDecls.nescStruct();
		NescApp._Struct newstruct = null;

		//Get general info for the ramSymbol
		ramArgs.name = xmlDef.getAttribute("name");  //e.g DrainM.sendPackets
		ramArgs.memAddress = Integer.valueOf(xmlDef.getAttribute("address")).intValue();
		ramArgs.length = Integer.valueOf(xmlDef.getAttribute("length")).intValue();
		ramArgs.isArray = xmlDef.hasAttribute("array");
	
		typeDef = xmlDef.getElementsByTagName("type"); //get node
		ramArgs.isPointer = ((Element)typeDef.item(0)).getAttribute("typeClass").equals("pointer");
		ramArgs.isStruct = false;  //init value
		ramArgs.typename = ((Element)typeDef.item(0)).getAttribute("typeName"); 

		//Get nescType of typename
		app.getType(ramArgs.typename, nesctype);
		if (nesctype.nesctype != null) {
				
			//it is a simple type
			Vector paramTuple = new Vector();
			//9/2/2007
			NescDecls._FieldType baseType = new NescDecls._FieldType();
			baseType.typename =ramArgs.typename;
			if (ramArgs.isArray){
				NescDecls._FieldType type = new NescDecls._FieldType();
				type.fieldtype = baseType;
				type.isArray = true;
				type.arraySize = ramArgs.length/nesctype.size;
				type.isStruct = false;
				type.isPointer = false;
				paramTuple.addElement(new NescDecls._ParamTuple("value", type));
			}else{
				paramTuple.addElement(new NescDecls._ParamTuple("value", baseType));
			}
			newstruct = new NescApp._Struct(ramArgs.name, new NescDecls.nescStruct(ramArgs.name, paramTuple, app));
		}
		else{
	
			app.getStruct(ramArgs.typename, nescstruct);
			if (nescstruct.nesctype != null) {

				//if (ramArgs.name.substring(0,4).equals("Test"))
				//	System.out.println("Ramsymbol-152 : " + ramArgs.name);
				
				Vector paramTuple = new Vector();
				//it is a struct
				ramArgs.isStruct = true;

				NescDecls._FieldType baseType = new NescDecls._FieldType();
				baseType.typename =ramArgs.typename;
				NescDecls._FieldType btype = new NescDecls._FieldType();
				btype.fieldtype = baseType;
				btype.isArray = false;
				btype.isStruct = true;
				btype.isPointer = false;

				if (ramArgs.isArray){
					NescDecls._FieldType type = new NescDecls._FieldType();
					type.fieldtype = btype;
					type.isArray = true;
					type.arraySize = ramArgs.length/nescstruct.size;
					type.isStruct = false;
					type.isPointer = false;
					paramTuple.addElement(new NescDecls._ParamTuple("value", type));
				}else{
					paramTuple.addElement(new NescDecls._ParamTuple("value", btype));
				}
				newstruct = new NescApp._Struct(ramArgs.name, new NescDecls.nescStruct(ramArgs.name, paramTuple, app));

				//Create new _Struct by copying existing struct
				//newstruct = new NescApp._Struct(ramArgs.name, new NescDecls.nescStruct(nescstruct));
			}
			else{
			
				ramArgs.name = null;
				//System.exit(0);
			}
		}

		//add to _structs to store info of this ramSymbol
		if (newstruct != null){
			types._structs.addElement(newstruct);
		}

		
		return ramArgs;
	}

	
    public Vector getRamList()
	{
    	//YFHDebug-Print-All:
		/*System.out.println("\n ramSymbols: ");
		Enumeration e;
		for (e = ramSymbols.elements(); e.hasMoreElements(); )
		{
			RamArgs ram = (RamArgs)e.nextElement();
			System.out.println("name="+ram.name+", memAddr="+ram.memAddress+", len="+ram.length+", type="+ram.typename);
		}*/

		return ramSymbols;
	}


	public RamArgs findRamSymbol(String name)
	{
		boolean found = false;
		RamArgs symbol = null;
		for (Enumeration e = ramSymbols.elements(); e.hasMoreElements(); ) {
			symbol = (RamArgs)e.nextElement();
				//System.out.println(symbol.name);
				//System.out.println(symbol.length);
			if (symbol.name.equals(name)){
				found = true;
				break;
			}
			
		}
		if (!found){
			System.out.println("In RamSymbols.findRamSymbol(): Error: Can not find parameter list for "+name+" !");			
		}
		return symbol;
	}


	public RamArgs findRamSymbol(int addr)
	{
		boolean found = false;
		RamArgs symbol = null;
		for (Enumeration e = ramSymbols.elements(); e.hasMoreElements(); ) {
			symbol = (RamArgs)e.nextElement();
			if (symbol.memAddress == addr){
				found = true;
				break;
			}
		}
		if (!found){
			System.out.println("In RamSymbols.findRamSymbol(): Error: Can not find parameter list for memAddress="+addr+" !");			
		}
		return symbol;
	}



	/* =================== =================================================*/
	static public void setHeadParams(RamArgs symbol, Vector srvalues)
	{
		srvalues.addElement(new Integer(symbol.memAddress));  
		srvalues.addElement(new Integer(symbol.length));  
		srvalues.addElement(new Integer(0));  //dereference = false, 
		                                      //cause Pointer type is not allowed
	}




/* ===================== Basic Data Structure Definition =========================*/
	static public class RamArgs implements Serializable
	{
		public String name;
		public int memAddress;
		public int length;
		public boolean isPointer;
		public boolean isArray;
		public boolean isStruct;
		public String typename;
		
		public RamArgs() {}
	};


	static public class ramSymbol_t implements Serializable
	{
		static public final int MAX_RAM_SYMBOL_SIZE = 100;
			
			/*rpc.com.message.ramSymbol_t.DEFAULT_MESSAGE_SIZE 
									- rpc.com.message.ramSymbol_t.size_dereference() 
									- rpc.com.message.ramSymbol_t.size_memAddress() 
									- rpc.com.message.ramSymbol_t.size_length(); */

		int memAddress;
		int length;
        	int dereference;
      		short [] data = new short[MAX_RAM_SYMBOL_SIZE];

		public ramSymbol_t() {}
		
	};

}
