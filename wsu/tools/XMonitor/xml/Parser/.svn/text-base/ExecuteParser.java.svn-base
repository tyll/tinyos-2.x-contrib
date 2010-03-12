/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package xml.Parser;

import xml.RemoteObject.ExecuteTypeObject;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author xiaogang
 */
public class ExecuteParser {

    Vector<ExecuteTypeObject> executeTypeList = null;
    String eventList = "";

    public ExecuteParser(String xmlFile) throws FileNotFoundException, IOException {
        executeTypeList = new Vector<ExecuteTypeObject>();

        initializeExecuteType(xmlFile);
    }

    public void initializeExecuteType(String xmlFile) throws FileNotFoundException, IOException {

        String inline;

        boolean found = false;
        //SensorNetwork currentSensorNetwork = null;
        ExecuteTypeObject currentExecuteTypeObject;
        Pattern executePattern;
        Matcher regexMatcher;


        try {
            BufferedReader xmlbuffer = new BufferedReader(new FileReader(new File(xmlFile)));
            inline = xmlbuffer.readLine();


            int Options = Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE;
            executePattern = Pattern.compile("dataName=\"([\\w\\s]+?)\" excuteType=\"([\\w\\s]+?)\"", Options);

            while (inline != null) {
                eventList += inline;

                //Match the second layer : message
                regexMatcher = executePattern.matcher(inline);
                if (regexMatcher.find()) {
                    String stringvalue = regexMatcher.group(0);
                    String dataName = null;
                    String executeType = null;

                    String temp = stringvalue.substring(stringvalue.indexOf("excuteType"), stringvalue.length());
                    executeType = temp.substring(temp.indexOf("\"") + 1, temp.lastIndexOf("\""));

                    stringvalue = stringvalue.substring(0, stringvalue.indexOf("excuteType"));
                    temp = stringvalue.substring(stringvalue.indexOf("dataName"), stringvalue.length());
                    dataName = temp.substring(temp.indexOf("\"") + 1, temp.lastIndexOf("\""));


                    currentExecuteTypeObject = new ExecuteTypeObject(dataName, executeType);
                    executeTypeList.add(currentExecuteTypeObject);

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
		
