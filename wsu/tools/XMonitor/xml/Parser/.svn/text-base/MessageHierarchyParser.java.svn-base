/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package xml.Parser;


import xml.RemoteObject.MessageHierarchyDetail;
import java.io.*;
import java.net.URL;
import java.util.*;
import java.util.regex.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
/**
 *
 * @author xiaogang
 */
class MessageHierarchyParser {
        	Vector messageHierarchyList = new Vector();

		public MessageHierarchyParser(String xmlMsgFormat){

			  try {
				  File file = new File(xmlMsgFormat);
				  DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
				  DocumentBuilder db = dbf.newDocumentBuilder();
				  Document doc = db.parse(file);
				  doc.getDocumentElement().normalize();
				  if (!doc.getDocumentElement().getNodeName().equals("Sensorweb")){
					  System.out.println("Wrong XML, the root element isn't sensorweb");
					  System.exit(0);
				  }
				   NodeList node = doc.getElementsByTagName("MessageHierarchy");
				  Vector tempVector = new Vector();
				  parseMessageHierarchy(node, tempVector);

				  for (int i = 0 ; i < messageHierarchyList.size(); i++){
				 	// System.out.println(messageHierarchyList.get(i));
				  }
			  }
			  catch (Exception ex){
				  ex.printStackTrace();
			  }

		}

		public void parseMessageHierarchy( NodeList node, Vector tempVector){

			Vector innerVector = new Vector();
			 for (int i = 0 ; i < tempVector.size(); i++){
	    		 innerVector.add(tempVector.get(i));
	    	 }



			for (int s = 0; s < node.getLength(); s++) {
				  Node fstNode = node.item(s);
				  if (fstNode.getNodeType() == Node.ELEMENT_NODE) {



			         Element fstElmnt = (Element) fstNode;

			         String type = fstElmnt.getAttribute("type");
			         int typeInt = -1;
			         if (type != null && !type.equals(""))
			        	 typeInt = Integer.parseInt(type);

			         innerVector.add(new MessageHierarchyDetail(fstNode.getNodeName(),typeInt));

			         NodeList fstNmElmntLst = fstElmnt.getChildNodes();
			         if (fstNmElmntLst != null){
			        	 parseMessageHierarchy(fstNmElmntLst, innerVector);
			         }
				   }



				   	 innerVector = new Vector();
					 for (int i = 0 ; i < tempVector.size(); i++){
			    		 innerVector.add(tempVector.get(i));
			    	 }
			  	}
			if (tempVector.size() > 0){
				messageHierarchyList.add(tempVector);
			}

		}
}
