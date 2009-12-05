package xml;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.*;

import java.io.*;
import java.net.URL;

import org.xml.sax.SAXException;


public class XMLReader {

    /** Creates a new instance of XMLReader */
    public XMLReader() {
    }

    /** Method to retrieve a String from an XML element with the given name.
     *
     * @param parentElement the parent of the node to be read
     * @param elementName the tag name of the String to be read
     * @return the String read, or null if no such tag was found.
     */
    public static String readStringElement(Element parentElement, String elementName) {
        NodeList nodeList = parentElement.getElementsByTagName(elementName);

        if(nodeList.getLength() < 1)
            return null;

        Element element = (Element)nodeList.item(0);
        NodeList list = element.getChildNodes();
        Node node = (Node)list.item(0);
        return node.getNodeValue().trim();
    }

    /** Method to retrieve an integer from an XML element with the given name.
     *
     * @param parentElement the parent of the node to be read
     * @param elementName the tag name of the integer to be read
     * @return the integer value of the specified tag, or null if
     * no such tag exists.
     * @throws java.lang.NumberFormatException if the specified element exists
     * and is not an integer
     */
    public static Integer readIntegerElement(Element parentElement, String elementName) throws NumberFormatException {
        String elementString = readStringElement(parentElement, elementName);
        if(elementString == null)
            return null;

        return Integer.valueOf(elementString);
    }

    /** Method to retrieve a dobule-precision floating point number from
     * the XML node with the specified tag name.
     *
     * @param parentElement the parent of the node to be read
     * @param elementName the tag name of the number to be read
     * @return the specified number, or null if no such tag exists.
     * @throws java.lang.NumberFormatException if the tag exists but can not
     * be parsed as a double-precision value.
     */
    public static Double readDoubleElement(Element parentElement, String elementName) throws NumberFormatException {
        String elementString = readStringElement(parentElement, elementName);
        if(elementString == null)
            return null;

        return Double.valueOf(elementString);
    }


    /** Method to retrieve a boolean value from the XML node with the specified
     * tag name.
     *
     * @param parentElement the parent of the node to be read.
     * @param elementName the tag name of the boolean value to be read
     * @return true if the tag exists and contains "true", false if the tag
     * exists but does not contain this string, and null if the tag does
     * not exist.
     */
    public static Boolean readBooleanElement(Element parentElement, String elementName) {
        String elementString = readStringElement(parentElement, elementName);

        if(elementString == null)
            return null;

        return Boolean.valueOf(elementString);
    }

    /** Method to retrieve a particular attribute from an XML node (attributes
     * are specified inside XML tags.
     * @param parentElement the parent of the node to be read
     * @param elementName the tag name to read the attribute from
     * @param typeName the attribute in question
     * @return the value of the specified attribute, or null if no such tag
     * exists.
     */
    public static String readStringType(Element parentElement, String elementName, String typeName) {
        NodeList nodeList = parentElement.getElementsByTagName(elementName);

        if(nodeList.getLength() < 1)
            return null;

        Element element = (Element)nodeList.item(0);

        return element.getAttribute(typeName);
    }


    /** Method to open an XML document from a given filename and return
     * it so that business logic can parse it.
     *
     * @param filename the name of the file to open
     * @return the built and normalized XML document from that filename.
     * @throws java.lang.IOException if the specified file could not
     * be found or parsed as an XML file.
     */
    public static Document openDocument(String filename) throws IOException {
        try {
            DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
            Document doc = docBuilder.parse(new File(filename));

            //Normalize text representation
            doc.getDocumentElement().normalize();

            return doc;
        } catch (SAXException ex) {
            Logger.getLogger(XMLReader.class.getName()).log(Level.SEVERE, null, ex);
            throw new IOException("Invalid file format");
        } catch (ParserConfigurationException ex) {
            Logger.getLogger(XMLReader.class.getName()).log(Level.SEVERE, null, ex);
            throw new IOException("Invalid file format");
        }
    }


    /** Method to open an XML document from a given filename and return
     * it so that business logic can parse it.
     *
     * @param filename the name of the file to open
     * @return the built and normalized XML document from that filename.
     * @throws java.lang.IOException if the specified file could not
     * be found or parsed as an XML file.
     */
    public static Document openDocument(URL filename) throws IOException {
        try {
            DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
            Document doc = docBuilder.parse(new File(filename.getFile()));

            //Normalize text representation
            doc.getDocumentElement().normalize();

            return doc;
        } catch (SAXException ex) {
            Logger.getLogger(XMLReader.class.getName()).log(Level.SEVERE, null, ex);
            throw new IOException("Invalid file format");
        } catch (ParserConfigurationException ex) {
            Logger.getLogger(XMLReader.class.getName()).log(Level.SEVERE, null, ex);
            throw new IOException("Invalid file format");
        }
    }


    /** Method to open an XML document from a given InputStream - used particularly
     * for reading resource XMLs that are compiled into the jar. The document
     * is returned in a state in which the business logic can begin parsing it.
     *
     * @param input the InputStream object to read the XML file from.
     * @return the built and normalized XML document object from that input stream.
     * @throws java.io.IOException if the given InputStream does not represent
     * a valid XML file.
     */
    public static Document openDocument(InputStream input) throws IOException {
        try {
            DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
            Document doc = docBuilder.parse(input);

            //Normalize text representation
            doc.getDocumentElement().normalize();

            return doc;
        } catch (SAXException ex) {
            Logger.getLogger(XMLReader.class.getName()).log(Level.SEVERE, null, ex);
            throw new IOException("Invalid file format");
        } catch (ParserConfigurationException ex) {
            Logger.getLogger(XMLReader.class.getName()).log(Level.SEVERE, null, ex);
            throw new IOException("Invalid file format");
        }


    }
}


