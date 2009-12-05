/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package xml.Parser;

import SensorwebObject.Rpc.RpcField;
import SensorwebObject.Rpc.RpcObject;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Enumeration;
import java.util.Vector;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import xml.RemoteObject.ExecuteTypeObject;
import xml.RemoteObject.MessageHierarchyDetail;
import xml.RemoteObject.StreamDataObject;
import xml.RemoteObject.StructureField;
import xml.RemoteObject.StructureObject;
import rpc.message.*;
/**
 *
 * @author xiaogang
 */
public class XMLMessageParser {

    // Debug
    boolean debug = false;
    boolean big = true; //big endien
    String xmlMsgFormat = "";
    //For regular expression
    Pattern sensorPattern;
    Pattern messagePattern;
    Pattern fieldPattern;
    int Options = 0;
    String eventList = "";
    Vector<MessageType> messageTypes; //temp vector to hold platform types (cname,size): in xml file
    MessageHierarchyParser messageHierarchy;
    ExecuteParser execute;
    StructureParser structure;
    int dxm_port;
    String typeKeyWord = "type";
    String channelKeyWord = "channel";
    String readingKeyWord = "reading";
    Vector keywordList = new Vector();

    public XMLMessageParser(String xmlMsgFormat,boolean big) throws FileNotFoundException, IOException {
        this.xmlMsgFormat = xmlMsgFormat;
        this.big = big;
        messageTypes = new Vector<MessageType>();
        //initializeMsgFormat();

        keywordList.add(typeKeyWord);
        keywordList.add(channelKeyWord);
        keywordList.add(readingKeyWord);


        initializeMsgFormat();



        messageHierarchy = new MessageHierarchyParser(xmlMsgFormat);
        structure = new StructureParser(xmlMsgFormat);
        execute = new ExecuteParser(xmlMsgFormat);
        //URL xmlFile = ClassLoader.getSystemResource(xmlMsgFormat);
        //BufferedReader xmlbuffer = new BufferedReader(new InputStreamReader(xmlFile.openStream()));


        for (int i = 0; i < messageHierarchy.messageHierarchyList.size(); i++) {
            Vector temp = (Vector) messageHierarchy.messageHierarchyList.get(i);
            for (int j = 0; j < temp.size(); j++) {
                MessageHierarchyDetail temp2 = (MessageHierarchyDetail) temp.get(j);
            //System.out.println(temp2.name + " " + temp2.type);
            }

        }

        for (int i = 0; i < structure.structureObjectList.size(); i++) {
            StructureObject tempStructure = structure.structureObjectList.get(i);
            if (debug) {
                tempStructure.tostring();
            }
        }

        for (int i = 0; i < execute.executeTypeList.size(); i++) {
            ExecuteTypeObject tempExecute = execute.executeTypeList.get(i);
            if (debug) {
                tempExecute.tostring();
            }
        }

        for (int j = 0; j < messageTypes.size(); j++) {
            MessageType messageType = messageTypes.get(j);
            //System.out.println("MessageType: " + messageType.name + " " + messageType.bitOffset);
            for (int k = 0; k < messageType.field.size(); k++) {
                MessageField messageField = messageType.field.get(k);
            //System.out.println("MessageField: " + messageField.name + " " +  messageField.repeat);
            }
        //System.out.println();
        }
    }

    public void initializeMsgFormat() {

        String inline;
        Enumeration<MessageType> e;
        boolean found = false;
        //SensorNetwork currentSensorNetwork = null;
        MessageType currentMessageType = null;
        MessageField currentMessageField = null;

        try {
            BufferedReader xmlbuffer = new BufferedReader(new FileReader(new File(xmlMsgFormat)));
            inline = xmlbuffer.readLine();

            Options |= Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE;
            messagePattern = Pattern.compile("bit-offset=\"I:(\\d+?)\" size=\"I:(\\d+?)\" name=\"([\\w\\s]+?)\"", Options);
            fieldPattern = Pattern.compile("bit-offset=\"I:(\\d+?)\" name=\"([\\w\\s]+?)\" size=\"I:(\\d+?)\" repeat=\"(\\d+?)\"", Options);
            Matcher regexMatcher;
            while (inline != null) {
                //Match the top layer : sensornetwork
                eventList += inline;

                //Match the second layer : message
                regexMatcher = messagePattern.matcher(inline);
                if (regexMatcher.find()) {
                    int bitoffset = Integer.valueOf(regexMatcher.group(1)).intValue();
                    int size = Integer.valueOf(regexMatcher.group(2)).intValue();
                    //int type = Integer.valueOf(regexMatcher.group(3)).intValue();
                    String name = regexMatcher.group(3);


                    currentMessageType = new MessageType(bitoffset, size, name);
                    messageTypes.add(currentMessageType);
                    //Log information for debugging
                    if (debug) {
                        System.out.println(bitoffset + " " +
                                size + " " +
                                name);
                    }

                } else {
                    //Match the third layer : message
                    regexMatcher = fieldPattern.matcher(inline);
                    if (regexMatcher.find()) {
                        int bitoffset = Integer.valueOf(regexMatcher.group(1)).intValue();
                        String name = regexMatcher.group(2);
                        int size = Integer.valueOf(regexMatcher.group(3)).intValue();
                        int repeat = Integer.valueOf(regexMatcher.group(4)).intValue();

                        currentMessageField = new MessageField(bitoffset, name, size, repeat);
                        currentMessageType.field.addElement(currentMessageField);

                        if (debug) {
                            System.out.println(bitoffset + " " +
                                    name + " " +
                                    size + " " +
                                    repeat);
                        }
                    //Log information for debugging


                    }
                }
                inline = xmlbuffer.readLine();
            }


            xmlbuffer.close();
        } catch (FileNotFoundException filenotfound) {
            System.out.println(xmlMsgFormat + "  doesn't exist!");
        } catch (IOException ioexception) {
            ioexception.printStackTrace();
        }

    }
//extract information from message

    public Vector getValueByName(byte[] message, String searchName) {
        try {
            Vector result = new Vector();

            //Vector structureElements = new Vector();
            for (int i = 0; i < structure.structureObjectList.size(); i++) {
                //System.out.println(i);
                StructureObject structureObject = (StructureObject) structure.structureObjectList.get(i);
                if (structureObject.name.equals(searchName)) {
                    Vector messageHierarchySearch = new Vector();
                    for (int j = 0; j < structureObject.structureFields.size(); j++) {
                        StructureField structureField = (StructureField) structureObject.structureFields.get(j);
                        messageHierarchySearch.add(structureField.message);
                        if (debug) {
                            System.out.println(structureField.messageField + " " + structureField.message);
                        }
                    //result.add(getSingleValue(message, structureField.messageField, structureField.message));
                    }


                    Vector possibleMessageReceive = new Vector();
                    for (int j = 0; j < messageHierarchy.messageHierarchyList.size(); j++) {
                        Vector currentMessageHierarchy = (Vector) messageHierarchy.messageHierarchyList.get(j);
                        boolean found = false;
                        for (int k = 0; k < messageHierarchySearch.size(); k++) {
                            found = false;
                            for (int l = 0; l < currentMessageHierarchy.size(); l++) {
                                String messageName1 = (String) messageHierarchySearch.get(k);
                                MessageHierarchyDetail hierarchyDetail = (MessageHierarchyDetail) currentMessageHierarchy.get(l);
                                String messageName2 = hierarchyDetail.name;
                                //if (debug)System.out.println(messageName1+" "+messageName2);
                                if (messageName1.equals(messageName2)) {
                                    found = true;
                                    break;
                                }
                            }
                            if (!found) {
                                break;
                            }
                        }

                        if (found) {
                            possibleMessageReceive.add(currentMessageHierarchy);
                        }
                    }


                    Vector correctHierarchy = null;
                    for (int j = 0; j < possibleMessageReceive.size(); j++) {
                        Vector tempMessageHierarchy = (Vector) possibleMessageReceive.get(j);
                        boolean wrongMessage = false;
                        for (int k = 1; k < tempMessageHierarchy.size(); k++) {
                            MessageHierarchyDetail hierarchyDetail = (MessageHierarchyDetail) tempMessageHierarchy.get(k);
                            if (hierarchyDetail.type != -1) {
                                int type = getTypeValue(message, hierarchyDetail.name);
                                //if(searchName.equalsIgnoreCase("general"))System.err.println(j+" "+k+" "+hierarchyDetail.name+" "+type+" "+hierarchyDetail.type);
                                if (type != hierarchyDetail.type) {
                                    wrongMessage = true;
                                    // if (debug)System.out.println(type+" "+hierarchyDetail.type);
                                    break;
                                } else {
                                    //if (debug)System.err.println(type+" "+hierarchyDetail.type);
                                }
                            }
                        }
                        if (!wrongMessage) {
                            correctHierarchy = tempMessageHierarchy;
                            // if(searchName.equalsIgnoreCase("general"))System.err.println("find correct");
                            break;
                        }
                    }


                    if (correctHierarchy != null) {
                        for (int k = 1; k < correctHierarchy.size(); k++) {
                            MessageHierarchyDetail hierarchyDetail = (MessageHierarchyDetail) correctHierarchy.get(k);
                        //System.err.println("hierarchyDetail.name:  " + hierarchyDetail.name);
                        }
                    } else {
                        return null;
                    }


                    for (int j = 0; j < structureObject.structureFields.size(); j++) {
                        StructureField structureField = (StructureField) structureObject.structureFields.get(j);
                        messageHierarchySearch.add(structureField.message);
                        //System.out.println(structureField.messageField + " " + structureField.message+" "+structureField.value);
                        result.add(getSingleValue(message, structureField.messageField, structureField.message, structureField.encode));
                    }

                }


            }
            //System.out.println("result.size(): " + result.size());
            return result;
        } catch (Exception ex) {
        }
        return null;
    }

    public int getTypeValue(byte[] message, String messageHeaderName) {

        for (int j = 0; j < messageTypes.size(); j++) {
            MessageType messageType = messageTypes.get(j);
            if (messageType.name.equals(messageHeaderName)) {
                for (int k = 0; k < messageType.field.size(); k++) {
                    MessageField messageField = messageType.field.get(k);
                    if (messageField.name.equals(typeKeyWord)) {
                        return getValueAtOffSet(messageType.bitOffset / 8 + messageField.bitOffset / 8, messageField.size, message);
                    }
                }
                break;
            }
        }

        return -1;
    }

    public StreamDataObject getSingleValue(byte[] message, String fieldName, String messageHeader, String encode) {

        int repeat = -1;
        boolean found = false;
        MessageField field = null;
        MessageType type = null;
        for (int j = 0; j < messageTypes.size(); j++) {
            MessageType messageType = messageTypes.get(j);
            if (messageHeader.equals(messageType.name)) {
                for (int k = 0; k < messageType.field.size(); k++) {
                    MessageField messageField = messageType.field.get(k);
                    if (fieldName.equals(messageField.name)) {
                        repeat = messageField.repeat;
                        found = true;
                        type = messageType;
                        field = messageField;
                        break;
                    }
                }
                if (found) {
                    break;
                }
            }
        }

        //System.out.println("repeat: " + repeat + " " +fieldName);
        Vector result = new Vector();
        if (repeat == 1) {
            int offset = (field.bitOffset + type.bitOffset) / 8;
            int value = getValueAtOffSet(offset, field.size, message);
            result.add(value);
        } else if (repeat == 0) {
            int offset = (field.bitOffset + type.bitOffset) / 8;
            for (int i = offset; i < message.length; i = i + field.size / 8) {
                int value = getValueAtOffSet(i, field.size, message);
                result.add(value);
            }
        } else if (repeat > 0) {
            for (int i = field.bitOffset / 8 + type.bitOffset / 8; i < field.bitOffset / 8 + type.bitOffset / 8 + repeat; i = i + field.size / 8) {
                int value = getValueAtOffSet(i, field.size, message);
                result.add(value);
            }
        }
        //System.out.println(result);
        return new StreamDataObject(fieldName, result);

    }

    public int parseMessage(Vector currentMessageHierarchy, String fieldName, String messageHeader, byte[] message) {

        for (int j = 0; j < messageTypes.size(); j++) {
            MessageType messageType = messageTypes.get(j);
            if (messageType.name.equals(messageHeader)) {
                for (int k = 0; k < messageType.field.size(); k++) {
                    MessageField messageField = messageType.field.get(k);
                    if (messageField.name.equals(fieldName)) {
                        //System.out.println(messageField.bitOffset + " " + messageType.bitOffset);
                        return getValueAtOffSet(messageField.bitOffset / 8 + messageType.bitOffset / 8, messageField.size, message);
                    }
                }
            }
        }
        return -1;
    }

    private int getValueAtOffSet(int offset, int size, byte[] message) {
        return getFieldValue(offset * 8, size, message);
    }

    public int getFieldValue(int offSet, int size, byte[] data) {
        return (int) getUIntElement(offSet, size, data);
    }

    protected long getUIntElement(int offset, int length, byte[] data) {
        //checkBounds(offset, length);
        byte[] tempData = new byte[length / 8];
        for (int i = 0; i < length / 8; i++) {
            //tempData[length/8 - 1 - i] = data[offset/8 + i];
            tempData[i] = data[offset / 8 + i];
        }
        for (int i = 0; i < tempData.length; i++) {
            //	System.out.println(tempData[i]);
        }

        offset = 0;

        int byteOffset = offset >> 3;
        int bitOffset = offset & 7;
        int shift = 0;
        long val = 0;
	if(big == false){
		// all in one byte case
		if (length + bitOffset <= 8) {
		    return (ubyte(byteOffset, tempData) >> bitOffset) & ((1 << length) - 1);
		}

		// get some high order bits
		if (bitOffset > 0) {
		    val = ubyte(byteOffset, tempData) >> bitOffset;
		    byteOffset++;
		    shift += 8 - bitOffset;
		    length -= 8 - bitOffset;
		}

		while (length >= 8) {
		    val |= (long) ubyte(byteOffset++, tempData) << shift;
		    shift += 8;
		    length -= 8;
		}

		// data from last byte
		if (length > 0) {
		    val |= (long) (ubyte(byteOffset, tempData) & ((1 << length) - 1)) << shift;
		}
        }
        else{
        
        	for(int i = tempData.length-1; i >= 0; i--){
        		val|= ((long) ubyte(i, tempData)) << (8*(tempData.length-i-1));
        	}
        
        }

        return val;
    }

    private int ubyte(int offset, byte[] data) {
        int val = data[offset];

        //System.out.println("offset: " +  offset + " ");

        if (val < 0) {
            return val + 256;
        } else {
            return val;
        }
    }

//message come in
    public class MessageType {

        public int bitOffset;
        public int size;
        public String name;
        public Vector<MessageField> field;

        public MessageType(int bitOffset, int size, String name) {
            this.bitOffset = bitOffset;
            this.size = size;
            this.name = name;
            field = new Vector<MessageField>();
        }

        public String print() {
            return "bitOffset " + bitOffset + " size " + size;
        }
    }

    public class MessageField {

        public int bitOffset;
        public String name;
        public int size;
        public int repeat;

        public MessageField(int bitOffset, String name, int size, int repeat) {
            this.bitOffset = bitOffset;
            this.name = name;
            this.size = size;
            this.repeat = repeat;
        }

        public String print() {
            return "bitOffset " + bitOffset + " name " + name + " size " + size;
        }
    }
    public Vector obtaRinRpcCommands() {
				Vector<RpcObject> rpcList = new Vector<RpcObject>();
				for (int i = 0 ; i < execute.executeTypeList.size(); i++){
					ExecuteTypeObject tempExecuteTypeObject = execute.executeTypeList.get(i);
					if (tempExecuteTypeObject.executeType.equals("write")){
						RpcObject rpcObject = getRpcObjectByStructName(tempExecuteTypeObject.dataName);
						rpcList.add(rpcObject);
					}
				}
				return rpcList;
			}
    public RpcObject getRpcObjectByStructName(String structName){
				RpcObject rpcObject = new RpcObject(structName);
				for (int i = 0 ; i < structure.structureObjectList.size(); i++){
					StructureObject structureObject = (StructureObject) structure.structureObjectList.get(i);
					if (structureObject.name.equals(structName)){
						for (int j = 0 ; j < structureObject.structureFields.size(); j++){
							StructureField structureField = (StructureField)structureObject.structureFields.get(j);
							if (structureField.value.equals("input")){
								MessageField messageField = getMessageFieldByName(structureField.message,structureField.messageField);
								//System.out.println(structureField.message + " " + structureField.messageField);
								RpcField rpcField = new RpcField(messageField.bitOffset,messageField.name,messageField.size);
								rpcObject.addCommandField(rpcField);
							}
						}
					}
				}
				return rpcObject;
			}
    //byte[] data = null;
    public byte[] computeRpcMessageHierarchy(String functionName) {
        //Vector structureElements = new Vector();
        byte[] data = null;
        for (int i = 0; i < structure.structureObjectList.size(); i++) {
            StructureObject structureObject = (StructureObject) structure.structureObjectList.get(i);
            if (structureObject.name.equals(functionName)) {
                Vector messageHierarchySearch = new Vector();
                for (int j = 0; j < structureObject.structureFields.size(); j++) {
                    StructureField structureField = (StructureField) structureObject.structureFields.get(j);
                    messageHierarchySearch.add(structureField.message);
                //System.out.println(structureField.messageField + " " + structureField.message);
                //result.add(getSingleValue(message, structureField.messageField, structureField.message));
                }


                Vector possibleMessageReceive = new Vector();
                for (int j = 0; j < messageHierarchy.messageHierarchyList.size(); j++) {
                    Vector currentMessageHierarchy = (Vector) messageHierarchy.messageHierarchyList.get(j);
                    boolean found = false;
                    for (int k = 0; k < messageHierarchySearch.size(); k++) {
                        found = false;
                        for (int l = 0; l < currentMessageHierarchy.size(); l++) {
                            String messageName1 = (String) messageHierarchySearch.get(k);
                            MessageHierarchyDetail hierarchyDetail = (MessageHierarchyDetail) currentMessageHierarchy.get(l);
                            String messageName2 = hierarchyDetail.name;

                            if (messageName1.equals(messageName2)) {
                                found = true;
                                break;
                            }
                        }
                        if (!found) {
                            break;
                        }
                    }

                    if (found) {
                        possibleMessageReceive.add(currentMessageHierarchy);
                        break;
                    }
                }

                int size = 0;
                Vector typeHierarchy = new Vector();
                Vector currentMessageHierarchy = (Vector) possibleMessageReceive.get(0);
                for (int j = 1; j < currentMessageHierarchy.size(); j++) {
                    MessageHierarchyDetail hierarchyDetail = (MessageHierarchyDetail) currentMessageHierarchy.get(j);
                     if(debug)System.out.println("hierarchyDetail.name.******:  " + hierarchyDetail.name);
                    for (int k = 0; k < messageTypes.size(); k++) {
                        MessageType messageType = messageTypes.get(k);
                        if (messageType.name.equals(hierarchyDetail.name)) {
                            size += messageType.size;
                             if(debug)System.out.println("messageType.size: " + messageType.size + messageType.name);
                            for (int l = 0; l < messageType.field.size(); l++) {
                                MessageField messageField = messageType.field.get(l);
                                if (messageField.name.equals(typeKeyWord)) {
                                    Vector typeDetail = new Vector();
                                    typeDetail.add(messageField.bitOffset + messageType.bitOffset);
                                    typeDetail.add(messageField.size);
                                    typeDetail.add(hierarchyDetail.type);
                                    typeHierarchy.add(typeDetail);
                                    break;
                                }
                            }
                        }
                    }
                }

                 if(debug)System.out.println("size: " + size);
                data = new byte[size / 8];
                for (int j = 0; j < typeHierarchy.size(); j++) {
                     if(debug)System.out.println(typeHierarchy.get(j));
                    Vector currentTypeHierarchy = (Vector) typeHierarchy.get(j);
                    int offset = (Integer) currentTypeHierarchy.get(0);
                    int fieldsize = (Integer) currentTypeHierarchy.get(1);
                    int value = (Integer) currentTypeHierarchy.get(2);
                    data = setValueByOffset(fieldsize, offset, value, data);
                    for (int k = 0; k < data.length; k++) {
                        if(debug)System.out.print(data[k] + " ");
                    }
                     if(debug)System.out.println();
                }

            }
        }
        return data;
    }

    public byte[] setValueByOffset(int length, int offset, long value, byte[] data) {
        return setUIntElement(offset, length, value, data);
    }

    protected byte[] setUIntElement(int offset, int length, long val, byte[] data) {


        int byteOffset = offset >> 3;
        int bitOffset = offset & 7;
        int shift = 0;

        // all in one byte case
        if (length + bitOffset <= 8) {
            data[byteOffset] = (byte) ((ubyte(byteOffset, data) & ~(((1 << length) - 1) << bitOffset)) | val << bitOffset);
            return data;
        }

        // set some high order bits
        if (bitOffset > 0) {
            data[byteOffset] = (byte) ((ubyte(byteOffset, data) & ((1 << bitOffset) - 1)) | val << bitOffset);
            byteOffset++;
            shift += 8 - bitOffset;
            length -= 8 - bitOffset;
        }

        while (length >= 8) {
            data[(byteOffset++)] = (byte) (val >> shift);
            shift += 8;
            length -= 8;
        }

        // data for last byte
        if (length > 0) {
            data[byteOffset] = (byte) ((ubyte(byteOffset, data) & ~((1 << length) - 1)) | val >> shift);
        }

        return data;
    }

    public long calculateValueFromEncoding(String encoding, String value) {
        if (encoding.equals("hex")) {
            return Long.parseLong(value, 16);
        }
        return Long.parseLong(value);
    }

    public String calculateReceiveDataFromEncoding(String encoding, String value) {
        if (encoding.equals("hex")) {
            int b = Integer.parseInt(value);
            String bs = Integer.toHexString(b & 0xff).toUpperCase();
            if (b >= 0 && b < 16) {
                bs = "0" + bs;
            }
            //System.out.println(b + " " + bs);
            return bs;
        }
        return value;
    }

    public byte[] processRPCCommands(Vector fieldValue, String functionName) {
        //EventParser eventParser = new EventParser(xmlPath, dxm_port);
        byte[] data = computeRpcMessageHierarchy(functionName);


        for (int i = 0; i < structure.structureObjectList.size(); i++) {
            StructureObject structureObject = (StructureObject) structure.structureObjectList.get(i);
            if (structureObject.name.equals(functionName)) {
                for (int j = 0; j < structureObject.structureFields.size(); j++) {
                    StructureField structureField = (StructureField) structureObject.structureFields.get(j);
                    if (structureField.value.equals("input")) {
                        MessageField messageField = getMessageFieldByName(structureField.message, structureField.messageField);
                        //RpcField rpcField = new RpcField(messageField.bitOffset,messageField.name,messageField.size);
                        for (int k = 0; k < fieldValue.size(); k++) {
                            RpcField inputRpcField = (RpcField) fieldValue.get(k);
                            if (inputRpcField.name.equals(structureField.messageField)) {
                                Vector fieldInfo = getFieldOffsetAndSizeByName(structureField.message, structureField.messageField);
                                int offset = (Integer) fieldInfo.get(0);
                                int size = (Integer) fieldInfo.get(1);
                                setValueByOffset(data,size, offset, calculateValueFromEncoding(structureField.encode, inputRpcField.value));
                            }
                        }
                    } else {

                        MessageField messageField = getMessageFieldByName(structureField.message, structureField.messageField);
                        Vector fieldInfo = getFieldOffsetAndSizeByName(structureField.message, structureField.messageField);
			//structureField.tostring();
                        if(debug)System.out.println(structureField.message + " " + structureField.messageField);
                        int offset = (Integer) fieldInfo.get(0);
                        int size = (Integer) fieldInfo.get(1);
                        setValueByOffset(data,size, offset, calculateValueFromEncoding(structureField.encode, structureField.value));

                    }
                }
            }
        }
        //Dump.dump("Xmp, processRPCCommands",data);

        for (int k = 0; k < data.length; k++) {
            if(debug) System.out.print(data[k] + " ");
        }
         if(debug)System.out.println();

        //setValueByOffset(data,8, 0, data.length - 10);
        rpcReady = true;

        return data;

    }

    public MessageField getMessageFieldByName(String headerName, String fieldname) {
        for (int j = 0; j < messageTypes.size(); j++) {
            MessageType messageType = messageTypes.get(j);
            if (messageType.name.equals(headerName)) {
                for (int k = 0; k < messageType.field.size(); k++) {
                    MessageField messageField = messageType.field.get(k);
                    if (messageField.name.equals(fieldname)) {
                        return messageField;
                    }
                }
            }
        }
        return null;
    }

    public Vector getFieldOffsetAndSizeByName(String messageName, String fieldName) {

        Vector typeList = messageTypes;
        for (int j = 0; j < typeList.size(); j++) {
            MessageType currentMessageType = (MessageType) typeList.get(j);
            // System.out.println(currentMessageType.name);
            if (currentMessageType.name.equals(messageName)) {
                for (int k = 0; k < currentMessageType.field.size(); k++) {
                    MessageField field = currentMessageType.field.get(k);
                    if (field.name.equals(fieldName)) {
                        Vector fieldInfo = new Vector();
                        fieldInfo.add(field.bitOffset + currentMessageType.bitOffset);
                        fieldInfo.add(field.size);
                        return fieldInfo;
                    }
                }
            }
        }

        return null;
    }
 
    public boolean rpcReady = false;

    public void setValueByOffset(byte[] data,int length, int offset, long value) {
        setUIntElement(data,offset, length, value);
    }

    protected void setUIntElement(byte[] data,int offset, int length, long val) {


        int byteOffset = offset >> 3;
        int bitOffset = offset & 7;
        int shift = 0;

        // all in one byte case
        if (length + bitOffset <= 8) {
            data[byteOffset] = (byte) ((ubyte(data,byteOffset) & ~(((1 << length) - 1) << bitOffset)) | val << bitOffset);
            return;
        }

        // set some high order bits
        if (bitOffset > 0) {
            data[byteOffset] = (byte) ((ubyte(data,byteOffset) & ((1 << bitOffset) - 1)) | val << bitOffset);
            byteOffset++;
            shift += 8 - bitOffset;
            length -= 8 - bitOffset;
        }

        while (length >= 8) {
            data[(byteOffset++)] = (byte) (val >> shift);
            shift += 8;
            length -= 8;
        }

        // data for last byte
        if (length > 0) {
            data[byteOffset] = (byte) ((ubyte(data,byteOffset) & ~((1 << length) - 1)) | val >> shift);
        }
    }

    private int ubyte(byte[] data,int offset) {
        int val = data[offset];

        if (val < 0) {
            return val + 256;
        } else {
            return val;
        }
    }
			public Vector getValue(byte[] message) {

			String searchName=null;
			Vector<String> vs = new Vector<String>();
			String res = "";
			Vector result = new Vector();

			//Vector structureElements = new Vector();
			for (int i = 0; i < structure.structureObjectList.size(); i++) {
				//System.out.println(i);
				StructureObject structureObject = (StructureObject) structure.structureObjectList.get(i);
				searchName = structureObject.name;

				
				try {
					Vector streamEvent = null;
					res=searchName;
					//System.out.println("asdf");
					streamEvent = getValueByName(message, searchName);
					if(streamEvent!=null){
						Iterator it = streamEvent.iterator();
						//System.out.println("streamEvent: "+streamEvent.size()+" "+it.hasNext());
						int count = 0;
						while (it.hasNext()) {
							//System.out.println("ss ");
							StreamDataObject curS = (StreamDataObject) it.next();
						//	System.out.print(((count++) % streamEvent.size()) + " name: " + curS.name + " size: " + curS.data.size() + " value: ");
							res+="["+curS.name+"=";
							Iterator resIt = curS.data.iterator();
							while (resIt.hasNext()) {
							//	System.out.print((Integer) resIt.next() + " ");
								res+=(Integer) resIt.next()+" " ;
							}
							res+="]";
							//System.out.println();
						}
						//	System.out.println();
						//return res;
						vs.add(res);
					}

				} catch (Exception ex) {
				}

			}
			//System.out.println("result.size(): " + result.size());
		if(vs.size() == 0){
			for(int i = 0; i < message.length; i++){
				res+="["+message[i]+"]";
			}
			vs.add(res);
		}




			return vs;



		}

		public String  getValue(String searchName, byte[] message) {
			String res = searchName;
			if(searchName.equalsIgnoreCase("rawdata")){
				for(int i = 0; i < message.length; i++){
					res+="["+message[i]+"]";
				}
			}
			else{
				try {
					Vector streamEvent = null;
					res=searchName;
					//System.out.println("asdf");
					streamEvent = getValueByName(message, searchName);
					if(streamEvent!=null){
						Iterator it = streamEvent.iterator();
						int count = 0;
						while (it.hasNext()) {
							StreamDataObject curS = (StreamDataObject) it.next();
							res+="["+curS.name+"=";
							Iterator resIt = curS.data.iterator();
							while (resIt.hasNext()) {
								res+=(Integer) resIt.next()+" " ;
							}
							res+="]";
						}

					}

				} catch (Exception ex) {
				}
			}

			return res;
		}

		public String  getValue(String searchName, Vector  streamEvent) {
			String res = searchName;
			if(searchName.equalsIgnoreCase("rawdata")){

				int size = ((Integer)(streamEvent.get(0))).intValue();
				byte[] msgdata = new byte[size];

				for (int i = 0; i < size; i++) {
					msgdata[i] = (byte)((Byte)(streamEvent.get(i+1))).byteValue();
				}
				int start = 0;
				int end = size;

				String data = "", current = "";
				for (int tt = start; tt < end; tt++) {
					//current = Integer.toHexString((int)msgdata[tt]);
					current = Integer.toHexString((int) msgdata[tt]);
					int len = current.length();
					if (len < 2) {
						data += "0x0" + current + " ";
					} else {
						current = current.substring(len - 2, len);
						data += ("0x" + current + " ");
					}
				}

				res = data;

			}
			else{
				try {
					if(streamEvent!=null){
						Iterator it = streamEvent.iterator();
						int count = 0;
						while (it.hasNext()) {
							StreamDataObject curS = (StreamDataObject) it.next();
							res+="["+curS.name+"=";
							Iterator resIt = curS.data.iterator();
							while (resIt.hasNext()) {
								res+=(Integer) resIt.next()+" " ;
							}
							res+="]";
						}

					}

				} catch (Exception ex) {
				}
			}

			return res;
		}


}
