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
 * A description of nesc type, array, pointer, struct
 *
 * @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */


package SensorwebObject.Rpc;


import java.io.Serializable;
import java.util.Vector;
import java.util.Enumeration;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

public class NescDecls implements Serializable
{
	NescApp app;

	public NescDecls(NescApp app){
		this.app = app;
	}


   /**
	*	A description of nesc type
	*/
	static public class nescType implements Serializable
	{
		public String nesctype;
		public String ctype;
		public String javatype; 
		public String _xmltag;
		public char _conversionstring;
		public int size;
		public int value;

		public nescType()
		{
			this.nesctype = null;
			this.ctype = null;
			this.javatype = null;
			this._xmltag = null;
			this._conversionstring = 'v';
			this.size = 0;
			this.value = 0;
		}

		public nescType(nescType newtype)
		{
			this.nesctype = newtype.nesctype;
			this.ctype = newtype.ctype;
			this.javatype = newtype.javatype;
			this._xmltag = newtype._xmltag;
			this._conversionstring = newtype._conversionstring;
			this.size = newtype.size;
			this.value = newtype.value;
		}

		public nescType(String nesctype, String ctype, String javatype, String _xmltag, 
			            char _conversionstring, int size, int defaultvalue)
		{
			this.nesctype = nesctype;
			this.ctype = ctype;
			this.javatype = javatype;
		    this._xmltag = _xmltag;
			this._conversionstring = _conversionstring;
			this.size = size;
			this.value = defaultvalue;
		}

		/**
		 * called to decide the parameter type of struct defined in XML format
		 */
		public boolean isType(Element xmlDef)
		{
			//returns 1 if the xml definition describes this type
			//returns 0 o.w.
			if (xmlDef != null && xmlDef.getTagName() == _xmltag 
				&& xmlDef.hasAttribute("cname") && xmlDef.getAttribute("cname").equals(ctype)){
				return true;
			}
			else if (nesctype.equals("void") && xmlDef.getTagName().equals(_xmltag)){
				return true;
			}
			else
				return false;
		}

		static public void copyType(nescType t1, nescType t2)
		{
			t1.nesctype = t2.nesctype;
			t1.ctype = t2.ctype;
			t1.javatype = t2.javatype;
			t1._xmltag = t2._xmltag;
			t1._conversionstring = t2._conversionstring;
			t1.size = t2.size;
			t1.value = t2.value;
		}
	}


 	/*
	* A description of nesc struct  
	*/
    static public class nescStruct implements Serializable
	{
		public String nesctype = null;
		public String ctype = null;
		public boolean _initialized = false;
		public Vector fields;  //Field
		public Vector values;  //(name, type)
		public int size = 0;
		public NescApp app;

		/** 
		 * Initialize data structure
		 */
		public void init(NescApp app)
		{
			this.fields = new Vector();
			this.values = new Vector();
			this.app = app;
		}

		static public void copyStruct(nescStruct s1, nescStruct s2)
		{
			s1.nesctype = s2.nesctype;
			s1.ctype = s2.ctype;
			s1._initialized = s2._initialized;
			s1.fields = (Vector)((s2.fields).clone());
			s1.values = (Vector)((s2.values).clone());
			s1.size = s2.size;
		}

		
		/**
		 * called to decide the parameter type of struct defined in XML format
		 */
		public boolean isType(Element xmlDef)
		{
			boolean ret = false;
			if (xmlDef.getTagName() == "type-tag"){
				NodeList subnodes = xmlDef.getChildNodes();
				if (subnodes != null){
					Node firstnode = subnodes.item(1);
					Element el = (Element)firstnode;
					if (el.getTagName() == "struct-ref"){
						if (el.hasAttribute("name")){ 
							if (el.getAttribute("name").equals(nesctype)){
								ret = true;
							}
							return ret;
						}
					}
				}
			}
			return false;
		}


		/** 
		 * Create an empty struct
		 */
		public nescStruct()
		{
			init(app);
		}
		

		/** 
		 * Create an copy of existing struct
		 */
		public nescStruct(nescStruct struct)
		{
			init(app);
			this.nesctype = struct.nesctype;
			this.ctype = struct.ctype;
			this._initialized = struct._initialized;
			this.fields = (Vector)((struct.fields).clone());
			this.values = (Vector)((struct.values).clone());
			this.size = struct.size;

		}


		/** 
		 * Parse the struct def from xml  
		 */
		 
		public  nescStruct(Element typeDef)
		{
		
			if (typeDef.getTagName() != "struct"){
				System.out.println("Error: In NescDecls.java: Not struct definition");
				System.exit(0);
			}
			if (!typeDef.hasAttribute("name")){
				System.out.println("Error: In NescDecls.java: Anonymous struct");
				System.exit(0);
			}
			/*
			try{
			if (typeDef.getAttribute("name").substring(0,4).equals("tTes"))
					System.out.println(typeDef.getAttribute("name"));
			}
			catch(Exception ex){}
			*/
			
			init(app);

			//get parameters
			_parseXMLFields(typeDef);
		
			if (!values.isEmpty()) {

			/*
			try{
			if (typeDef.getAttribute("name").substring(0,4).equals("tTes"))
					System.out.println(typeDef.getAttribute("name"));
			}
			catch(Exception ex){}
			*/

				
				nesctype = typeDef.getAttribute("name");
				size = Integer.valueOf(typeDef.getAttribute("size").substring(2)).intValue();

				ctype = nesctype;
				_initialized = true;
			}
		}


		public  nescStruct(Element typeDef, boolean skipped)
		{
		
			if (typeDef.getTagName() != "struct"){
				System.out.println("Error: In NescDecls.java: Not struct definition");
				System.exit(0);
			}
			if (!typeDef.hasAttribute("name")){
				System.out.println("Error: In NescDecls.java: Anonymous struct");
				System.exit(0);
			}
			/*
			try{
			if (typeDef.getAttribute("name").substring(0,4).equals("tTes"))
					System.out.println(typeDef.getAttribute("name"));
			}
			catch(Exception ex){}
			*/
			
			init(app);

			//get parameters
			_parseXMLFieldsForSkippedStruct(typeDef);
		
			if (!values.isEmpty()) {

			/*
			try{
			if (typeDef.getAttribute("name").substring(0,4).equals("tTes"))
					System.out.println(typeDef.getAttribute("name"));
			}
			catch(Exception ex){}
			*/

				
				nesctype = typeDef.getAttribute("name");
				size = Integer.valueOf(typeDef.getAttribute("size").substring(2)).intValue();

				ctype = nesctype;
				_initialized = true;
			}
		}


		/** 
		 * Parse the struct def from param tuple 
		 */
		public nescStruct(String name, Vector params, NescApp app)
		{
			init(app);
			nesctype = name;
			ctype = nesctype;

			//get parameters
			_parseNescTypeFields(params);

			_initialized = true;
		}

	   
		/**
		 * Get struct parameters from xml   
		 */
		public void _parseXMLFields(Element typeDef)
		{
			int i;
			
		
			//Get parameter list from groups with tag-name as "field" 
			NodeList field = typeDef.getElementsByTagName("field");

			//Get info for each item in this struct
			if(field != null && field.getLength() > 0) {
				for(i = 0 ; i < field.getLength();i++) {					
					//General info
					Element el = (Element)field.item(i);
					_ParamField paramfield= new _ParamField();
					paramfield.name = el.getAttribute("name");
					paramfield.bitOffset = Integer.valueOf(el.getAttribute("bit-offset").substring(2)).intValue();
					if (el.hasAttribute("bit-size"))
						paramfield.bitSize = Integer.valueOf(el.getAttribute("bit-size").substring(2)).intValue();
					if (el.hasAttribute("size"))
						paramfield.bitSize = Integer.valueOf(el.getAttribute("size").substring(2)).intValue()*8;
					fields.addElement(paramfield);
			
					//Get parameter's type
					_FieldType type = new _FieldType();
					NescTypes.getTypeFromXML(el, type);
					if (type.fieldtype != null || type.typename != null){
						_ParamTuple paramtype = new _ParamTuple(paramfield.name, type);
					   	values.addElement(paramtype);
						type.offset = paramfield.bitOffset ;
						
						//System.out.println("field No="+i+":");
						//paramtype.print();   //YFHdebug
							/*
							try{
			if (typeDef.getAttribute("name").substring(0,4).equals("tTes")){
					System.out.println(typeDef.getAttribute("name"));
					System.out.println("up");
					System.out.println();}
			}
			catch(Exception ex){}
				*/
						
					}
					else{
						NescApp.skippedStruct.add(typeDef);
						//System.out.println(NescApp.skippedStruct.size());
						/*
							if (typeDef.getAttribute("name").substring(0,4).equals("tTes")){
					System.out.println(typeDef.getAttribute("name"));
							System.out.println("down");
							if (type.fieldtype == null){System.out.println("fieldtype: null");}
							if (type.typename == null){System.out.println("typename: null");}
							System.out.println();
								}*/
						//Uncomplete struct definition (with unknown field type)
						//System.out.println("in NescDecls.java: unidenfitied field type! fieldname="+paramfield.name);
						fields.clear();
						values.clear();
					
						break;
					}
				}
			}

			
		}


		public void _parseXMLFieldsForSkippedStruct(Element typeDef)
		{
			int i;
			
		
			//Get parameter list from groups with tag-name as "field" 
			NodeList field = typeDef.getElementsByTagName("field");

			//Get info for each item in this struct
			if(field != null && field.getLength() > 0) {
				for(i = 0 ; i < field.getLength();i++) {					
					//General info
					Element el = (Element)field.item(i);
					_ParamField paramfield= new _ParamField();
					paramfield.name = el.getAttribute("name");
					paramfield.bitOffset = Integer.valueOf(el.getAttribute("bit-offset").substring(2)).intValue();
					if (el.hasAttribute("bit-size"))
						paramfield.bitSize = Integer.valueOf(el.getAttribute("bit-size").substring(2)).intValue();
					if (el.hasAttribute("size"))
						paramfield.bitSize = Integer.valueOf(el.getAttribute("size").substring(2)).intValue()*8;
					fields.addElement(paramfield);
			
					//Get parameter's type
					_FieldType type = new _FieldType();
					NescTypes.getTypeFromXML(el, type);
					if (type.fieldtype != null || type.typename != null){
						_ParamTuple paramtype = new _ParamTuple(paramfield.name, type);
					   	values.addElement(paramtype);
						type.offset = paramfield.bitOffset ;			
					}
					else{
						NescApp.skippedStruct.add(typeDef);

						//Uncomplete struct definition (with unknown field type)
						//System.out.println("in NescDecls.java: unidenfitied field type! fieldname="+paramfield.name);
						fields.clear();
						values.clear();
					
						break;
					}
				}
			}

			
		}


		/**
		 * Get struct parameters from param tuple 
		 * Note: params should in _ParamTuple formate
		 */
		public void _parseNescTypeFields(Vector params)
		{
			Enumeration e;
			String ftype = "";
			_ParamTuple p = null;
			_ParamField paramfield = null;
			int filedsize;
			size = 0;
			for (e = params.elements(); e.hasMoreElements(); ) {
				p = (_ParamTuple)e.nextElement();
				filedsize = getFieldSize(p.type);
				
				paramfield= new _ParamField();
				paramfield.name = p.name;
				paramfield.bitOffset = size*8;
				paramfield.bitSize = filedsize*8;

				fields.addElement(paramfield);
				values.addElement(p);
				size += filedsize;

				//paramfield.print();  //YFHdebug
				//System.out.println("name="+p.name+", type="+p.type+", typesize="+typesize);
			}
		}

		public int getFieldSize(NescDecls._FieldType fieldInfo) 
		{
			int	size = 0;
			
			//Base case: a simple type
			if (fieldInfo.fieldtype == null && fieldInfo.typename != null) {
				System.out.println(app + " "+ fieldInfo);
				size = app.getsize(fieldInfo.typename);
				return size;
			}

			//Embedded type: array
			if (fieldInfo.isArray) {
				size = getFieldSize(fieldInfo.fieldtype)*fieldInfo.arraySize;
				return size;
			}

			//Embedded type: struct
			if (fieldInfo.isStruct) {
				size = getFieldSize(fieldInfo.fieldtype);
				return size;
			}

			return size;
		}

	}



    /* ======== Basic structures ======== */

	static public class _ParamField implements Serializable
	{
		public String name;
		public int bitOffset;
		public int bitSize;

		public _ParamField()
		{
			name = "";
			bitOffset = 0;
			bitSize = 0;
		}

		public void print()
		{
			System.out.println("_ParamField: name = " + name+ ", bitOffset =" + bitOffset
								+", bitSize =" + bitSize);
		}			
	};

	static public class _FieldType implements Serializable
	{
		public _FieldType fieldtype;
		public String typename;
		public boolean isArray;
		public int arraySize;
		public boolean isStruct;
		public boolean isPointer;
		public int offset;
		
		public _FieldType()
		{
			this.fieldtype = null;
			this.typename = null;
			this.isArray = false;
			this.arraySize = 0;
			this.isStruct = false;
			this.isPointer = false;
		}
		
		public _FieldType( _FieldType fieldtype, String typename,
			               boolean isArray, int arraySize, boolean isStruct, boolean isPointer)
		{
			this.fieldtype = fieldtype;
			this.typename = typename;
			this.isArray = isArray;
			this.arraySize = 0;
			this.isStruct = isStruct;
			this.isPointer = isPointer;
		}		
	};


	static public class _ParamTuple implements Serializable
	{
		public String name;
		public _FieldType type;

		public _ParamTuple(String name, _FieldType type)
		{
			this.name = name;
			this.type = type;
		}

		public void print()
		{
			System.out.println("_ParamTuple: name = " + name);
			int level = 0;
			_FieldType ftype = type;
			while (ftype.fieldtype!= null) {
				System.out.println("level="+level+", isArray="+ftype.isArray
			               +", isStruct="+ftype.isStruct
			               +", isPointer="+ftype.isPointer);
				ftype = ftype.fieldtype;
				level++;
			}
			System.out.println("level="+level+", elememtType="+ftype.typename);
			System.out.println("");
		}		
			
	};

}


