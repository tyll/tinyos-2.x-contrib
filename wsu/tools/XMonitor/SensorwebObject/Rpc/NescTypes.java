package SensorwebObject.Rpc;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Serializable;
import java.util.Enumeration;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import SensorwebObject.Rpc.NescApp.PlatformType;
import SensorwebObject.Rpc.NescApp._Struct;
import SensorwebObject.Rpc.NescApp._Type;

public class NescTypes implements Serializable
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


	/**
	 * figure out the sizes of all the types 
	 * (by scanning the xml file)
	 */
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
		/*System.out.println("\n Infos stored in _platformTypes: ");
		for (e = platformTypes.elements(); e.hasMoreElements(); )
		{
			PlatformType t = (PlatformType)e.nextElement();
			System.out.println("name="+t.name+", size="+t.size);
		}*/

        
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

		//YFHDebug-Print-All:
		/*System.out.println("\n Infos stored in _types before: ");
		for (e = _types.elements(); e.hasMoreElements(); ) {
			_Type t = (_Type)e.nextElement();
			System.out.println(t.key+", "+t.value.nesctype+ ", "+t.value.size);
		}*/

		//Create compound types (struct, typedef...) from xml file
		createTypesFromXml(xmlFileName);
	}


   /**
	* Store new types in _types, _typeNames
	* _types: (nescTypeName/ctypeName, NescType)
	* _typeNames: (nescTypeName/ctypeName)
	*
	*/
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


   /**
	* Store structs in _structs, _typeNames
	* _structs: (structName, nescStruct)
	* _typeNames: (.../structName)
	*
	*/
	void addStruct(NescDecls.nescStruct value)
	{
		if (value.nesctype == null) {
			return;
		}

		Enumeration e;
		boolean found = false;
		for (e = _typeNames.elements(); e.hasMoreElements();) {
			String name = (String)e.nextElement();
				/*
				//String tempname = typeDef.getAttribute("name");
				try{
				if (name.substring(0,4).equals("tTes"))
						System.out.println(name);
					}
				catch(Exception ex){}
				*/
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


	/**
	 * Abstract typedef/struct from nescDcls.xml and save them in _types/_structs, _typeNames
	 */
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
		Document dom= NescApp.getDomFromXml(xmlFileName);

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

		/*
			Enumeration ee;
		int count = 0;
	
		for (ee = _structs.elements(); ee.hasMoreElements(); ){
					_Struct ss = (_Struct)ee.nextElement();
					System.out.println(count++);
		}
		*/
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
		while (NescApp.skippedStruct.size() != 0){
			numSkipped++;
			Element typeDef = (Element)NescApp.skippedStruct.get(0);
			NescApp.skippedStruct.remove(0);
			addStruct(new NescDecls.nescStruct(typeDef));
			if (numSkipped > 0 && numSkipped > NescApp.skippedStruct.size() * NescApp.skippedStruct.size() ){
				break;
			}
		}	
		

		//YFHDebug-Print-All:
		/*System.out.println("\n Infos stored in _types: ");
		for (e = _types.elements(); e.hasMoreElements(); ) {
			t = (_Type)e.nextElement();
			System.out.println(t.key+", "+t.value.nesctype+", "+t.value.ctype+", "+t.value.size);
		}*/
		//YFHDebug-Print-All:
		/*System.out.println("\n Infos stored in _structs: ");
		for (e = _structs.elements(); e.hasMoreElements(); ) {
			s = (_Struct)e.nextElement();
			System.out.println(s.key+", "+s.value.size);
		}*/
	}


   /**
	*  A generally called function: to get type from xml file
	*  Find the type name value given in xml file;
	*  If it is an array or pointer, define the new type here.
	*/
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

