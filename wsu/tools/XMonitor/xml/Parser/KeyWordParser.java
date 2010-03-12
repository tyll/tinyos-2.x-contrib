/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package xml.Parser;

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
class KeyWordParser {
Vector keywordList = new Vector();

		public KeyWordParser(String xmlMsgFormat){
			try {
				  File file = new File(xmlMsgFormat);
				  DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
				  DocumentBuilder db = dbf.newDocumentBuilder();
				  Document doc = db.parse(file);
				  doc.getDocumentElement().normalize();
				  if (!doc.getDocumentElement().getNodeName().equals("sensorweb")){
					  System.out.println("Wrong XML, the root element isn't sensorweb");
					  System.exit(0);
				  }
				  NodeList keyword = doc.getElementsByTagName("keyword");
				  parseKeyWord(keyword, keywordList);
				  for (int i = 0 ; i < keywordList.size(); i++){
				 	 //System.out.println(keywordList.get(i));
				  }
			  }
			  catch (Exception ex){
				  ex.printStackTrace();
			  }
		}

		public void parseKeyWord( NodeList node, Vector<Vector<String>> preTempVector){

			 for (int s = 0; s < node.getLength(); s++) {

				    Node viewNode = node.item(s);

				    if (viewNode.getNodeType() == Node.ELEMENT_NODE) {
				      Vector<String> tempVector = new Vector<String>();
				      Element viewElmnt = (Element) viewNode;

				      NodeList nameElmntLst = viewElmnt.getElementsByTagName("dxm_key");
				      Element nameElmnt = (Element) nameElmntLst.item(0);
				      NodeList name = nameElmnt.getChildNodes();
				      tempVector.add(((Node) name.item(0)).getNodeValue());

				      NodeList fieldElmntLst = viewElmnt.getElementsByTagName("sensormessage_key");
				      Element fieldElmnt = (Element) fieldElmntLst.item(0);
				      NodeList field = fieldElmnt.getChildNodes();
				      tempVector.add(((Node) field.item(0)).getNodeValue());

				      preTempVector.add(tempVector);
				    }

			}
		}
}
