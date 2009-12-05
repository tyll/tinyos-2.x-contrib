/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package xml.Parser;

import xml.RemoteObject.StructureField;
import xml.RemoteObject.StructureObject;
import java.io.*;
import java.util.*;
import java.util.regex.*;



/**
 *
 * @author xiaogang
 */
public class StructureParser {

    Vector<StructureObject> structureObjectList = null;
    String eventList = "";

    public StructureParser(String xmlMsgFormat) {
        structureObjectList = new Vector<StructureObject>();
        initializeStructureFormat(xmlMsgFormat);

    }

    public void initializeStructureFormat(String xmlFile) {

        String inline;
        Enumeration<StructureObject> e;
        boolean found = false;
        StructureObject currentStructureObject = null;
        StructureField currentStructureField = null;
        Pattern structurePattern;
        Pattern fieldPattern;
        Matcher regexMatcher;

        try {

            BufferedReader xmlbuffer = new BufferedReader(new FileReader(new File(xmlFile)));
            inline = xmlbuffer.readLine();

            int Options = Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE;
            structurePattern = Pattern.compile("structName=\"([\\w\\s]+?)\"", Options);
            fieldPattern = Pattern.compile("message=\"([\\w\\s]+?)\" messageField=\"([\\w\\s]+?)\" encode=\"([\\w\\s]+?)\" value=\"([\\w\\s]+?)\"", Options);


            while (inline != null) {
                //Match the top layer : sensornetwork
                eventList += inline;

                //Match the second layer : message
                regexMatcher = structurePattern.matcher(inline);
                if (regexMatcher.find()) {
                    String structName = regexMatcher.group(0);
                    structName = structName.substring(structName.indexOf("\"") + 1, structName.lastIndexOf("\""));
                    currentStructureObject = new StructureObject(structName);
                    structureObjectList.add(currentStructureObject);

                } else {
                    //Match the third layer : message
                    regexMatcher = fieldPattern.matcher(inline);
                    if (regexMatcher.find()) {
                        String stringvalue = regexMatcher.group(0);

                        String message = null;
                        String messageField = null;
                        String encode = null;
                        String value = null;

                        String temp = stringvalue.substring(stringvalue.indexOf("value"), stringvalue.length());
                        value = temp.substring(temp.indexOf("\"") + 1, temp.lastIndexOf("\""));

                        stringvalue = stringvalue.substring(0, stringvalue.indexOf("value"));
                        temp = stringvalue.substring(stringvalue.indexOf("encode"), stringvalue.length());
                        encode = temp.substring(temp.indexOf("\"") + 1, temp.lastIndexOf("\""));

                        stringvalue = stringvalue.substring(0, stringvalue.indexOf("encode"));
                        temp = stringvalue.substring(stringvalue.indexOf("messageField"), stringvalue.length());
                        messageField = temp.substring(temp.indexOf("\"") + 1, temp.lastIndexOf("\""));

                        stringvalue = stringvalue.substring(0, stringvalue.indexOf("messageField"));
                        temp = stringvalue.substring(stringvalue.indexOf("message"), stringvalue.length());
                        message = temp.substring(temp.indexOf("\"") + 1, temp.lastIndexOf("\""));



                        currentStructureField = new StructureField(message, messageField, encode, value);
                        currentStructureObject.structureFields.addElement(currentStructureField);
                    }
                }
                inline = xmlbuffer.readLine();
            }


            xmlbuffer.close();
        } catch (FileNotFoundException filenotfound) {
            System.out.println(xmlFile + "  doesn't exist!");
        } catch (IOException ioexception) {
            ioexception.printStackTrace();
        }
    }
}