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
 *
 * A class that holds all types, enums, msgs, rpc commands 
 * and ram symbol definitions as defined for a specific nesc 
 * application.
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


public class NescApp implements Serializable
{
	static public int INIT_SEQNO = 1; 
	//public MoteIF moteif;

	static public int seqNo = INIT_SEQNO;
	static public NescTypes types;
	static public NescEnums enums;
	public Rpc rpcs;
	public RamSymbols ramsymbols;
	//static public RoutingMessages comm;
	public long unix_time;
	public long user_hash;
	static public Vector skippedStruct = new Vector();
	
	public String xmlfile = null;


	public NescApp(String buildDir)
	{
		this.xmlfile = buildDir+"/nescDecls.xml";
		//this.moteif = moteif;
		
		//Get app identification info
		getIdentInfo(buildDir+"/ident_flags.txt");
			
		//Import enums
		enums = new NescEnums(xmlfile);
		
		//Import types (including basic types and structs)
		types = new NescTypes(xmlfile);

		//Setup network
		//comm = new RoutingMessages(moteif);

		//Import the rpc commands
		rpcs = new Rpc(buildDir, types, this);
	
		//Import the ram symbols
		ramsymbols = new RamSymbols(buildDir, types, this);


	}

//8/2/2007 YFH: add management for seqno
	static public void setSeqNo(int newNo)
	{
		seqNo = newNo;
	}

	static public int getSeqNo()
	{
		return seqNo;
	}

	static public void clearSeqNo()
	{
		seqNo = INIT_SEQNO;
	}


// In ident_flag.txt:
// substring[3] = -DIDENT_USER_HASH=0x......L
// substring[4] = -DIDENT_UNIX_TIME=0x......L
	public void getIdentInfo(String identFile)
	{
		BufferedReader reader = null;

		File file = new File(identFile);
		if (!file.exists()) {
		  throw new IllegalArgumentException( "no such file " + identFile);
		}
		try {
			String readline = null;
			String patternStr = "\\s|\\t|\\n";
			reader = new BufferedReader(new FileReader(file));
			readline = reader.readLine();
			String [] result = readline.split(patternStr);
			String uhStr = result[3];
			user_hash = Long.parseLong(uhStr.substring(uhStr.indexOf('=')+3,uhStr.indexOf('L')),16);
			String utStr = result[4];
			unix_time = Long.parseLong(utStr.substring(utStr.indexOf('=')+3,utStr.indexOf('L')),16);
			//System.out.println("uhStr="+uhStr.substring(uhStr.indexOf('=')+3,uhStr.indexOf('L'))
			//	                +", utStr="+utStr.substring(utStr.indexOf('=')+3,utStr.indexOf('L')));
		} catch (Exception e) {
		  e.printStackTrace();
		}

		try {
			reader.close();
		}
		catch (Exception e) {}
		file = null;
	}

	/*public void getIdentInfo(String tosXml)
	{
		String name;     

		File file = new File(tosXml);
		if (!file.exists()) {
		  throw new IllegalArgumentException( "no such file " + tosXml);
		}
		try {
		  DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		  DocumentBuilder parser = factory.newDocumentBuilder();
		  Document doc = parser.parse(tosXml);
		  String tmp;

		  NodeList nlist=doc.getElementsByTagName("program_name");
		  name = nlist.item(0).getFirstChild().getNodeValue();

		  nlist=doc.getElementsByTagName("unix_time");
		  tmp = nlist.item(0).getFirstChild().getNodeValue();
		  unix_time = Long.parseLong(tmp.substring(0,tmp.indexOf('L')),16);

		  nlist=doc.getElementsByTagName("user_hash");
		  tmp = nlist.item(0).getFirstChild().getNodeValue();
		  user_hash = Long.parseLong(tmp.substring(0,tmp.indexOf('L')),16);
		} catch (Exception e) {
		  e.printStackTrace();
		}
	}*/



	/* 
	* Get type size, which is registered in types
	*/
	public int getsize(String type)
	{
		int size = -1;
		boolean found;
		Enumeration e;

		//Search in _types: 
		_Type t = null;
		found = false;
		for (e = (types._types).elements(); e.hasMoreElements(); )
		{
			t = (_Type)e.nextElement();
			if (t.key.equals(type)) 
			{
				found = true;
				break;
			}							
		}
		if (found)
			size = t.value.size;
		else
		{
			_Struct s = null;
			found = false;
			for (e = (types._structs).elements(); e.hasMoreElements(); )
			{
				s = (_Struct)e.nextElement();
				if (s.key.equals(type)) 
				{
					found = true;
					break;
				}							
			}
			if (found)
				size = s.value.size;
			else
			{
				size = 2;   // specific for "Ptr"
			}			
		}

		return size;
		
	}


	/** 
	 * Get nescType of type
	 */
	public void getType(String type, NescDecls.nescType nesctype)
	{
		_Type t = null;
		boolean found = false;
		for (Enumeration e = (types._types).elements(); e.hasMoreElements(); ) {
			t = (_Type)e.nextElement();
			if (t.key.equals(type))	{
				found = true;
				break;	
			}							
		}
		if (found){
			NescDecls.nescType.copyType(nesctype, t.value);
		}
		else {
			nesctype = null;
		}
	}



	/** 
	 * Get nescStruct of type
	 */
	 public void getStruct(String type, NescDecls.nescStruct nescstruct)
	{
		_Struct s = null;
		boolean found = false;
		System.out.println(types._structs);
		for (Enumeration e = (types._structs).elements(); e.hasMoreElements(); ) {
			s = (_Struct)e.nextElement();
			if (s.key.equals(type)) {
				found = true;
				break;
			}							
		}
		if (found){
				NescDecls.nescStruct.copyStruct(nescstruct, s.value);
		}
		else {
			nescstruct = null;
		}
	}


    
   /**  
	* A class that holds all types defined in a specific nesc application.  
    *//*
    static public class NescTypes implements Serializable
	{
		//Type arrays
		static public Vector _typeNames;      //(nescTypeName/cname/structName): complete list of type names
        static public Vector _types;          //(nescTypeName/cname, nescType) : complete infos of basic types
		static public Vector _structs;        //(structName, nescStruct): complete infos of structs

		Vector platformTypes;          //temp vector to hold platform types (cname,size): in xml file
		Vector typeDefs;               //temp vector to hold all structs and typedefs

        //Some arrays for error reporting
		Vector unknownStructs;
		Vector anonymousStructs;
		Vector anonymousRefStructs;
		Vector undefinedTypes;

		//For regular expression
		static Pattern compiledRegex;
		int Options = 0;
		// Matcher object that will search the subject string using compiledRegex 
		static Matcher regexMatcher;

		public NescTypes(String xmlFileName){
			_typeNames = new Vector();
			_types = new Vector();
			_structs = new Vector();
			platformTypes = new Vector();  
			typeDefs = new Vector();  

			Initialize(xmlFileName);
		}



		void Initialize(String xmlFileName){
			String inline;
			Enumeration e;
			boolean found = false;

			//Abstract PlatformType (ctype:size) from xml file
			try	{
			    //Open xml file
				FileReader xmlreader = new FileReader(xmlFileName);
				BufferedReader xmlbuffer = new BufferedReader(xmlreader); 
				inline = xmlbuffer.readLine();

				Options |= Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE;
				compiledRegex = Pattern.compile("cname=\"([\\w\\s]+?)\" size=\"I:(\\d+?)\"", Options);
				while (inline != null) {
					regexMatcher = compiledRegex.matcher(inline);
					if (regexMatcher.find()) {
						String name = regexMatcher.group(1);
						int size = Integer.valueOf(regexMatcher.group(2)).intValue();
						found = false;
						for (e = platformTypes.elements(); e.hasMoreElements(); ) {
							PlatformType t = (PlatformType)e.nextElement();
							if (t.name.equals(name)) {
								found = true;
								break;
							}							
						}
						if (!found){
							platformTypes.addElement(new PlatformType(name, size));
						}
					}
					inline = xmlbuffer.readLine();
				}
				xmlbuffer.close();
			}
			catch (FileNotFoundException filenotfound) {
				System.out.println(xmlFileName + "doesn't exist!");
			}
			catch (IOException ioexception)	{
				ioexception.printStackTrace();
			}

    		//YFHDebug-Print-All:


            
	        //Add basic types
	        addType(new NescDecls.nescType("uint8_t", "unsigned char", "char", "type-int", 'B',1,0));
			addType(new NescDecls.nescType("int8_t", "signed char", "char", "type-int", 'b', 1, 0));
			
			//YFH: added when debug 
			addType(new NescDecls.nescType("result_t", "unsigned char", "char", "type-int", 'B', 1, 0));
			addType(new NescDecls.nescType("unsigned long int", "unsigned long int", "long", "type-int", 'L',4,0));
			addType(new NescDecls.nescType("long int", "long int", "int", "type-int", 'l', 4, 0));
			addType(new NescDecls.nescType("TOS_MsgPtr", "TOS_MsgPtr", "TOS_MsgPtr", "TOS_MsgPtr", 'H', 2, 0));

			
			//Define all the basic types based on platformTypes
			found = false;
			for (e = platformTypes.elements(); e.hasMoreElements(); ){
				PlatformType t = (PlatformType)e.nextElement();
				if ((t.name.equals("int") && t.size==4) || 
					(t.name.equals("unsigned int") && t.size==4)){
					found = true;
					break;
				}							
			}
			if (found) {
				//int is 4 bytes long 
				addType(new NescDecls.nescType("uint16_t", "unsigned short", "int", "type-int", 'H', 2, 0));
				addType(new NescDecls.nescType("int16_t", "short", "short", "type-int", 'h', 2, 0));
				addType(new NescDecls.nescType("uint32_t", "unsigned int", "long", "type-int", 'L',4,0));
				addType(new NescDecls.nescType("int32_t", "int", "int", "type-int", 'L', 4, 0));
				addType(new NescDecls.nescType("unsigned long", "unsigned long", "long", "type-int", 'L',4,0));
				addType(new NescDecls.nescType("long", "long", "int", "type-int", 'l', 4, 0));
			}
			else {
				//int is 2 bytes long (the default)
				addType(new NescDecls.nescType("unsigned short", "unsigned short", "int", "type-int", 'H', 2, 0));
				addType(new NescDecls.nescType("short", "short", "short", "type-int", 'h', 2, 0));
				addType(new NescDecls.nescType("uint16_t", "unsigned int", "int", "type-int", 'H', 2, 0));
				addType(new NescDecls.nescType("int16_t", "int", "short", "type-int", 'h', 2, 0));
				addType(new NescDecls.nescType("uint32_t", "unsigned long", "long", "type-int", 'L',4,0));
				addType(new NescDecls.nescType("int32_t", "long", "long", "type-int", 'l', 4, 0));
				addType(new NescDecls.nescType("int64_t", "long long", "long", "type-int", 'q', 8, 0));
				addType(new NescDecls.nescType("uint64_t", "unsigned long long", "long long", "type-int", 'Q', 8, 0));
				addType(new NescDecls.nescType("float", "float", "float", "type-float", 'f', 4, 0));
			}


			found = false;
			for (e = platformTypes.elements(); e.hasMoreElements(); ) {
				PlatformType t = (PlatformType)e.nextElement();
				if (t.name.equals("double") && t.size==8) {
					found = true;
					break;
				}							
			}
			if (found) {
				addType(new NescDecls.nescType("double", "double", "double", "type-float", 'd', 8, 0));
			}
			else {
				//double is 4 bytes (the default)
				addType(new NescDecls.nescType("double", "double", "float", "type-float", 'f', 4, 0));
				addType(new NescDecls.nescType("char", "char", "char", "type-int", 'c', 1, 0));  //default: \x00?
				addType(new NescDecls.nescType("void", "void", "void", "type-void", 'v', 0, 0));
			}

   

			//Create compound types (struct, typedef...) from xml file
			createTypesFromXml(xmlFileName);
		}



		void addType(NescDecls.nescType value)
		{
			Enumeration e;
			boolean found;
			
			//check for value.nesctype
			found = false;
			for (e = _typeNames.elements(); e.hasMoreElements(); ) {
				String name = (String)e.nextElement();
				if (name.equals(value.nesctype)) {
					found = true;
					break;
				}							
			}
			if (!found){
				_typeNames.addElement(value.nesctype);
				_types.addElement(new _Type(value.nesctype, value));
			}

			//check for value.ctype
			found = false;
			for (e = _types.elements(); e.hasMoreElements(); ) {
				_Type nt = (_Type)e.nextElement();
				if (nt.key.equals(value.ctype)) {
					found = true;
					break;
				}							
			}
			if (!found){
				_typeNames.addElement(value.ctype);
				_types.addElement(new _Type(value.ctype, value));
			}	
		}



		void addStruct(NescDecls.nescStruct value)
		{
			if (value.nesctype == null) {
				return;
			}

			Enumeration e;
			boolean found = false;
			for (e = _typeNames.elements(); e.hasMoreElements();) {
				String name = (String)e.nextElement();

				if (name.equals(value.nesctype)) {
					found = true;
					break;
				}							
			}
			if (!found){
				_typeNames.addElement(value.nesctype);
				_structs.addElement(new _Struct(value.nesctype, value));
			}
		}



		void createTypesFromXml(String xmlFileName)
		{
			Enumeration e;
			boolean found = false;
			int numSkipped = 0;
			int i;
			_Type t = null;
			_Struct s = null;
   		    NescDecls.nescType newType = null;
			NescDecls.nescStruct newStruct = null;


			//get structs and typedefs from xml file
			Document dom= getDomFromXml(xmlFileName);

			//get the root elememt
			Element docEle = dom.getDocumentElement();
			
			//get list of structs, and put into typeDefs
			NodeList structs = docEle.getElementsByTagName("struct");
			if(structs != null && structs.getLength() > 0) {
				for(i = 0 ; i < structs.getLength();i++) {					
					//get each element
					Element el = (Element)structs.item(i);
					typeDefs.addElement(el);
				}
			}
			
			//get list of typedefs, and put into typeDefs
			NodeList defs = docEle.getElementsByTagName("typedef");
			if(defs != null && defs.getLength() > 0) {
				for(i = 0 ; i < defs.getLength();i++) {					
					//get each element
					Element el = (Element)defs.item(i);
					typeDefs.addElement(el);
				}
			}

			//keep going through the queue until it is empty
			numSkipped = 0;
	

			while (!typeDefs.isEmpty())	{
				Element typeDef = (Element)typeDefs.remove(0);

				//if this is a "typedef", see if the value is there
				if (typeDef.getTagName() == "typedef") {
					String value = typeDef.getAttribute("value");
					String name = typeDef.getAttribute("name");
					
						

                  		  //check in _types
					t=null;
					found = false;
					for (e = _types.elements(); e.hasMoreElements(); ) {
						t = (_Type)e.nextElement();
						if (t.key.equals(value)) {
							found = true;
							break;
						}							
					}
					if (found) {
						newType = new NescDecls.nescType(t.value);
						newType.nesctype = name;
						addType(newType);
						numSkipped = 0;
					}
					else{

					//check in _structs
						s = null;
						found = false;
						for (e = _structs.elements(); e.hasMoreElements(); ) {
							s = (_Struct)e.nextElement();
							if (s.key.equals(value)) {
								found = true;
								break;
							}							
						}
						if (found) {
							newStruct = new NescDecls.nescStruct(s.value);
							newStruct.nesctype = name;
							addStruct(newStruct);
							numSkipped = 0;
						}					
						else {
							//try again later
							typeDefs.addElement(typeDef);
							numSkipped +=1;
						}
					}
				}
				//if this is a "struct"
				else {
					addStruct(new NescDecls.nescStruct(typeDef));
				}

				//make sure we are not cycling endlessly
				if (numSkipped >0 && numSkipped >= typeDefs.size()) {
					break;
				}
			}
			
			numSkipped = 0;
			while (skippedStruct.size() != 0){
				numSkipped++;
				Element typeDef = (Element)skippedStruct.get(0);
				skippedStruct.remove(0);
				addStruct(new NescDecls.nescStruct(typeDef));
				if (numSkipped > 0 && numSkipped > skippedStruct.size() * skippedStruct.size() ){
					break;
				}
			}	
			

			//YFHDebug-Print-All:
			/*System.out.println("\n Infos stored in _types: ");
			for (e = _types.elements(); e.hasMoreElements(); ) {
				t = (_Type)e.nextElement();
				System.out.println(t.key+", "+t.value.nesctype+", "+t.value.ctype+", "+t.value.size);

		}



		static public void getTypeFromXML(Element xmlDef,  NescDecls._FieldType type)
		{
			int i;
			int foundType = 0;
			Element typeTag = null;
			
			//First, see if the tag is type or if child is type
			if ((xmlDef.getTagName()).indexOf("type-") < 0 ||
				 (xmlDef.getTagName()).indexOf("type-qualified") >= 0){
				foundType = 0;
				NodeList nodes = xmlDef.getChildNodes();
				if(nodes != null && nodes.getLength() > 0) {
					for(i = 0 ; i < nodes.getLength();i++) {	
						Node tag = nodes.item(i);
						if (tag.getNodeType() == 1){  //ELEMENT_NODE
							if ((((Element)tag).getTagName()).indexOf("type-") >= 0){
								foundType += 1;
								typeTag = (Element)tag;
							}
						}
					}
					if (foundType < 1) {
						System.out.println("Error: In NescApp.java: No type tag found!");
						System.exit(0);
					}
					if (foundType > 1) {
						System.out.println("Error: In NescApp.java: Too many type tag found!");
						System.exit(0);
					}
					else{
						getTypeFromXML(typeTag, type);						
					}
		        }
			}
			else{
				Enumeration e;
				boolean found = false;
				//if it is a simple type
				for (e = _types.elements(); e.hasMoreElements(); ){
					_Type t = (_Type)e.nextElement();
					found = t.value.isType(xmlDef);
					if (found){
						type.typename = t.value.nesctype;
						type.isArray = false;
						type.isStruct = false;
						type.isPointer = false;
						break;
					}							
				}
				if(!found){
					//if it is a struct
					for (e = _structs.elements(); e.hasMoreElements(); ){
						_Struct s = (_Struct)e.nextElement();
						found = s.value.isType(xmlDef);
						if (found){
							NescDecls._FieldType childType0 = new NescDecls._FieldType();
							childType0.typename = s.value.nesctype;
							type.fieldtype = childType0;
							type.isArray = false;
							type.isStruct = true;
							type.isPointer = false;
							break;
						}							
					}
				}
				
				if (!found){
					//if the type doesn't already exist, try creating a new one
					//(this is for array or pointer)  

					//get first childNode
					NodeList subnodes = xmlDef.getChildNodes();
					Node firstnode = subnodes.item(1);
					NescDecls._FieldType childType = new NescDecls._FieldType();

					//if it is array
					if (xmlDef.getTagName() == "type-array") { 
						//get filedtype of childNode
						getTypeFromXML((Element)firstnode, childType);
						type.fieldtype = childType;
						type.isArray = true;
						type.isStruct = false;
						type.isPointer = false;
						type.arraySize = Integer.valueOf(xmlDef.getAttribute("elements").substring(2)).intValue();
					}
					else {
						//if it is pointer
						if (xmlDef.getTagName() == "type-pointer") {
							//get fieldtype of childNode
							getTypeFromXML((Element)firstnode, childType);
							type.fieldtype = childType;
							type.isArray = false;
							type.isStruct = false;
							type.isPointer = true;
						}
						else {
							//it must be a yet undefined struct
							//System.out.println("Error: in NescApp.java: Unknown type with tag="+ xmlDef.getTagName());
							type.fieldtype = null;
							type.typename = null;
							type.isArray = false;
							type.isStruct = false;
							type.isPointer = false;
						}
					}					
				}
			}
		}
	}
*/


   /**
	* A class that holds all enums defined in a specific nesc application  [6/7/2007 OK]
	*/
    static public class NescEnums implements Serializable
	{
		Vector _enums;
		Vector _enumDict;
		Vector _namedenumDict;

		//For regular expression
		static Pattern regexInteger, regexHexidecimal;
		int Options = 0;
		// Matcher object that will search the subject string using compiledRegex 
		static Matcher regexMatcher;

		public NescEnums(String xmlFileName)
		{
			_enums = new Vector();
			_enumDict = new Vector();
			_namedenumDict = new Vector();

			Initialize(xmlFileName);
		}

		public NescEnums(Element domEle)
		{
			_enums = new Vector();
			_enumDict = new Vector();
			_namedenumDict = new Vector();

			createEnumsFromXml(domEle);
		}

		void Initialize(String xmlFileName)
		{
			Document dom = getDomFromXml(xmlFileName);
			//get the root elememt
			Element docEle = dom.getDocumentElement();

			createEnumsFromXml(docEle);
		}

		void createEnumsFromXml(Element docEle)
		{
			int i;
			String name, value;
			boolean found = false;
			Enumeration e;
			String en = null;
			
			//get list of enums
			NodeList enumDefs = docEle.getElementsByTagName("enum");
			if(enumDefs != null && enumDefs.getLength() > 0) {
				Options |= Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE;
				regexInteger = Pattern.compile("^I:(\\d+)$", Options);
				regexHexidecimal = Pattern.compile("^(0x[\\dabcdefABCDEF]+)$", Options);

				for(i = 0 ; i < enumDefs.getLength();i++) {					
					//get each element
					Element enumDef = (Element)enumDefs.item(i);
					name = enumDef.getAttribute("name");

					found = false;
					for (e = _enums.elements(); e.hasMoreElements(); )
					{
						en = (String)e.nextElement();
						if (en.equals(name)) 
						{
							found = true;
							break;
						}							
					}
					if (!found)
					{
						_EnumDict edict;
						value = enumDef.getAttribute("value");
						regexMatcher = regexInteger.matcher(value);
						if (regexMatcher.find()) 
							edict = new _EnumDict(name, regexMatcher.group(1));
						else
						{
							regexMatcher = regexHexidecimal.matcher(value);
							if (regexMatcher.find())
								edict = new _EnumDict(name, 
								            // Integer.toString(Integer.valueOf(regexMatcher.group(1).substring(2), 16).intValue()));
								             Long.toString(Long.valueOf(regexMatcher.group(1).substring(2), 16).longValue()));  //change for tmote platform
								//edict = new _EnumDict(name, regexMatcher.group(1));
							else
								edict = new _EnumDict(name, value);
						}
						_enumDict.addElement(edict);
						_enums.addElement(name);
					}
				}//end of for
			}//end of if

			//get list of namedenums
			NodeList namedEnums = docEle.getElementsByTagName("namedEnum");
			if(namedEnums != null && namedEnums.getLength() > 0) {
				for(i = 0 ; i < namedEnums.getLength();i++) {					
					//get each element
					Element namedEnum = (Element)namedEnums.item(i);
					name = namedEnum.getAttribute("name");

					found = false;
					for (e = _enums.elements(); e.hasMoreElements(); )
					{
						en = (String)e.nextElement();
						if (en.equals(name)) 
						{
							found = true;
							break;
						}							
					}
					if (!found)
					{
						NescEnums enums = new NescEnums(namedEnum);//, applicationName);
						_NamedEnumDict nEnum = new _NamedEnumDict(name, enums);
						_namedenumDict.addElement(nEnum);
						_enums.addElement(name);
					}				
				}
			}

    		//YFHDebug-Print-All:
			/*System.out.println("\n Infos stored in _enums: ");
			for (e = _enums.elements(); e.hasMoreElements(); )
			{
				en = (String)e.nextElement();
				System.out.println(en);
			}	


			System.out.println("\n Infos stored in _enumDict: ");
			for (e = _enumDict.elements(); e.hasMoreElements(); )
			{
				_EnumDict edic = (_EnumDict)e.nextElement();
				System.out.println("name="+edic.name+", value="+edic.value);
			}*/				

		}

	}



	/*================= General Functions ==================[6/7/2007 OK]====*/
	
	/*
	* Get Document from xml file
	*/
	static Document getDomFromXml(String xmlFileName)
	{
		Document dom = null;
		int i;
		//get the factory
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();			
		try {				
			//Using factory get an instance of document builder
			DocumentBuilder db = dbf.newDocumentBuilder();
			
			//parse using builder to get DOM representation of the XML file
			dom = db.parse(xmlFileName);

		}catch(ParserConfigurationException pce) {
			pce.printStackTrace();
		}catch(SAXException se) {
			se.printStackTrace();
		}catch(IOException ioe) {
			ioe.printStackTrace();
		}

		return dom;
	}
  

    /*=================== Basic Data Structures ==================[6/7/2007 OK]=====*/
	static public class PlatformType implements Serializable
	{
		public String name;
		public int size;

		public PlatformType(String name, int size)
		{
			this.name = name;
			this.size = size;
		}
			
	};

	static public class _Type implements Serializable
	{
		public String key;
		public NescDecls.nescType value;

		public _Type(String key, NescDecls.nescType value)
		{
			this.value = new NescDecls.nescType(value);
			this.key = key;
		}
	};

	static public class _Struct implements Serializable
	{
		public String key;
		public NescDecls.nescStruct value;

		public _Struct(String key, NescDecls.nescStruct value)
		{
			this.key = key;
			this.value = value;
		}
	};

	static public class _EnumDict implements Serializable
	{
		public String name;
		public String value;

		public _EnumDict(String name, String value)
		{
			this.name = name;
			this.value = value;
		}
	};

	static public class _NamedEnumDict implements Serializable
	{
		public String name;
		public NescEnums value;

		public _NamedEnumDict(String name, NescEnums value)
		{
			this.name = name;
			this.value = value;
		}
	};


}


