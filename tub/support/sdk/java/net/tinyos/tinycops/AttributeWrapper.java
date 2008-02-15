/*
 * AttributeWrapper.java
 *
 * Created on 22. August 2005, 18:45
 */
package net.tinyos.tinycops;
import javax.xml.parsers.DocumentBuilder; 
import javax.xml.parsers.DocumentBuilderFactory;  
import javax.xml.parsers.FactoryConfigurationError;  
import javax.xml.parsers.ParserConfigurationException;
 
import org.xml.sax.SAXException;  
import org.xml.sax.SAXParseException;  

import java.io.File;
import java.io.IOException;
import java.util.*;


import org.w3c.dom.Document;
import org.w3c.dom.DOMException;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.w3c.dom.NamedNodeMap;

/**
 *
 * @author Till Wimmer
 */
public class AttributeWrapper {
    
    private static Document document;
    private static Map attributes =  new TreeMap();
    private static String element_name = null;
    
    
    /** Creates a new instance of AttributeWrapper */
    public AttributeWrapper(String file, String element_name) {
        this.element_name = element_name;
                
        if (document == null) {        
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            //factory.setValidating(true);   
            //factory.setNamespaceAware(true);
            try {           
                DocumentBuilder builder = factory.newDocumentBuilder();
                document = builder.parse( new File(file) );
            } catch (SAXException sxe) {           
                // Error generated during parsing)
                Exception  x = sxe;
                if (sxe.getException() != null)
                    x = sxe.getException();
                x.printStackTrace();
                
            } catch (ParserConfigurationException pce) {            
                // Parser with specified options can't be built
                pce.printStackTrace();
                
            } catch (IOException ioe) {           
                // I/O error
                ioe.printStackTrace();
            }
        } // document == null
        adapterNode(document);
    }
    
    private void adapterNode(Node domNode) {
        if (domNode.getNodeName().equals(element_name)) {
            int id = -1;
            String name = null;
            String description = null;
            String type = null;
            String endianness = null;
            String preferred_visualization = null;
            long min = -1;
            long max = -1;
            Map operations = null;
            String metric_conversion = null;
            
            NamedNodeMap nmm = domNode.getAttributes();
            id = Integer.parseInt(nmm.getNamedItem("id").getNodeValue());
            //System.out.println("id = " + id);
            
            NodeList nl = domNode.getChildNodes();
            for (int i = 0; i < nl.getLength(); i++) {
                Node node;
                String value = null;
                String nodeName = nl.item(i).getNodeName();
                if ((node = nl.item(i).getFirstChild()) != null
                        && node.getNodeType() == node.TEXT_NODE
                        ) {
                    value = node.getNodeValue();
                }
                
                if (value == null)
                    continue;
                
                if (nodeName.equals("attribute_name")) {
                    name = value;
                    //System.out.println("name Value = " + value);                    
                }
                
                if (nodeName.equals("attribute_description")) {
                    description = value;
                    //System.out.println("description Value = " + value);                    
                }
                
                if (nodeName.equals("attribute_type")) {
                    type = value;
                    //System.out.println("type Value = " + value);                    
                }
                
                if (nodeName.equals("attribute_min")) {
                    min = Long.parseLong(value);
                    //System.out.println("min Value = " + value);                    
                }
                
                if (nodeName.equals("attribute_max")) {
                    max = Long.parseLong(value);
                    //System.out.println("max Value = " + value);                    
                }                 
                
                if (nodeName.equals("attribute_endianness")) {
                    endianness = value;
                    //System.out.println("endianness Value = " + value);                    
                }                
                
                if (nodeName.equals("attribute_preferred_visualization")) {
                    preferred_visualization = value;
                    //System.out.println("preferred_visualization Value = " + value);                    
                }

                // METRIC
                if (nodeName.equals("ps_metric")) {                                                       
                    NodeList me_nl = nl.item(i).getChildNodes();

                    for (int j=0; j < me_nl.getLength(); j++) {
                        Node n = me_nl.item(j);
                        if (n.getNodeName().equals("metric_conversion")) {
                            metric_conversion = n.getFirstChild().getNodeValue();
                            //System.out.println("metric_conversion Value = " + metric_conversion);
                        }
                    }
                }                
                    
                // OERATIONS
                if (nodeName.equals("ps_operation")) {
                    int op_id = -1;
                    String op_name = null;
                    String op_description = null;
                    NamedNodeMap op_nmm = nl.item(i).getAttributes();
                    op_id = Integer.parseInt(op_nmm.getNamedItem("id").getNodeValue());
                    
                    //System.out.println("op_id = " + op_id);
                    
                    NodeList op_nl = nl.item(i).getChildNodes();
                    
                    for (int j=0; j < op_nl.getLength(); j++) {
                        //System.out.println("j = " + j);
                        
                        Node op_node;
                        String op_value = null;
                        String op_nodeName = op_nl.item(j).getNodeName();
                        
                        if ((op_node = op_nl.item(j).getFirstChild()) != null
                                && op_node.getNodeType() == op_node.TEXT_NODE
                                ) {                    
                            op_value = op_node.getNodeValue();
                        }
                        
                        if (op_value == null)
                            continue;
                        
                        if (op_nodeName.equals("operation_name")) {
                            op_name = op_value;
                            //System.out.println("op_name Value = " + op_value);                    
                        }                        
                        
                        if (op_nodeName.equals("operation_description")) {
                            op_description = op_value;
                            //System.out.println("op_description Value = " + op_value);                    
                        }                        
                    } // element = "operation"
                    
                    if (op_id >= 0 && op_name != null) {
                        if (operations == null)
                            operations = new TreeMap();
                        
                        Operation operation = new Operation(op_id, op_name, op_description);
                        operations.put(new Integer(op_id), operation);
                    }
                }
               
            }
            if (id >= 0 && name != null && type != null ) {
                Attribute attribute = new Attribute(id, name, description, type, min, max, 
                        endianness, (TreeMap)operations, preferred_visualization, metric_conversion);
                attributes.put(new Integer(id), attribute);
            }
        }
        
        if (!domNode.hasChildNodes())
            return;
        
        NodeList nl = domNode.getChildNodes();
        for (int i = 0; i < nl.getLength(); i++) {
            adapterNode(nl.item(i));
        }                
    }
    
    public static Map getAttributesMap() {
        return attributes;
    }
}
