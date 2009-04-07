
package net.tinyos.mcenter.treeTable;

import java.io.IOException;
import java.util.*;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.XMLOutputter;

import java.util.prefs.*;

public class PreferenceModel extends AbstractTreeTableModel {
    
    // Names of the columns.
    static protected String[]  cNames = {"Name", "Value", "Selected"};
    
    // Types of the columns.
    static protected Class[]  cTypes = { TreeTableModel.class,
    String.class, Boolean.class};
    
    
    
    
    Preferences prefs = null;
    
    PreferenceModel.PreferenceTreeItem itemTreeRoot;
    
    private JTreeTable jTreeTable = null;
    
    public PreferenceModel() {
        super(null);
        //prefs = Preferences.userNodeForPackage(this.getClass());
        prefs = Preferences.userRoot();
        itemTreeRoot = new PreferenceModel.PreferenceRoot(prefs,null);
        createTree(prefs, itemTreeRoot);
        root = itemTreeRoot;
    }
    public PreferenceModel(Class path) {
        super(null);
        prefs = Preferences.userNodeForPackage(path);
        itemTreeRoot = new PreferenceModel.PreferenceTreeItem(prefs,null);
        createTree(prefs, itemTreeRoot);
        root = itemTreeRoot;
    }
    

    
    
    
    public void setTreeTable(JTreeTable jTreeTable){
        this.jTreeTable = jTreeTable;
    }
    
    public void exportSelection(java.io.OutputStream outStream){
        
        Document document = new Document();

        
        Element treeElement = itemTreeRoot.getXMLElement(true);
        if(treeElement != null)
            document.setRootElement(treeElement);
        XMLOutputter outputter = new XMLOutputter();
        outputter.setIndent("  "); // use two space indent
        outputter.setNewlines(true);
        
        try {
            outputter.output(document,outStream);
        }
        catch (IOException e) {
            System.err.println(e);
        }
    }
    
    /**
     * Creates a FileSystemModel2 with the root being <code>rootPath</code>.
     * This does not load it, you should invoke
     * <code>reloadChildren</code> with the root to start loading.
     */
    
    //
    // The TreeModel interface
    //
    
    /**
     * Returns the number of children of <code>node</code>.
     */
    public int getChildCount(Object node) {
        //return ((PreferencesTreeAdapter)node).getChildCount();
        return ((PreferenceTreeItem)node).getChildCount();
    }
    
    /**
     * Returns the child of <code>node</code> at index <code>i</code>.
     */
    public Object getChild(Object node, int i) {
        //return ((PreferencesTreeAdapter)node).getChild(i);
        return ((PreferenceTreeItem)node).getChild(i);
    }
    
    /**
     * Returns true if the passed in object represents a leaf, false
     * otherwise.
     */
    public boolean isLeaf(Object node) {
        //return ((PreferencesTreeAdapter)node).isLeaf();
        return ((PreferenceTreeItem)node).isLeaf();
    }
    
    public boolean isCellEditable(Object node, int column) {
        if(column==0)
            return getColumnClass(column) == TreeTableModel.class;
        else if(column==2)
            return true;
        return false;
    }
    
    //
    //  The TreeTableNode interface.
    //
    
    /**
     * Returns the number of columns.
     */
    public int getColumnCount() {
        return cNames.length;
    }
    
    /**
     * Returns the name for a particular column.
     */
    public String getColumnName(int column) {
        return cNames[column];
    }
    
    /**
     * Returns the class for the particular column.
     */
    public Class getColumnClass(int column) {
        return cTypes[column];
    }
    
    /**
     * Returns the value of the particular column.
     */
    public Object getValueAt(Object node, int column) {
        PreferenceTreeItem parent = (PreferenceTreeItem)node;
        
        try {
            switch(column) {
                case 0:
                    return "";
                case 1:
                    return parent.toString(column);
                case 2:
                    return new Boolean(parent.getSelected());
                    
            }
        }
        catch  (SecurityException se) { }
        /*catch(java.util.prefs.BackingStoreException bse){
            System.out.println("StoreException4");
        }*/
        return null;
    }
    public void setValueAt(Object aValue, Object node, int column) {
        if(column ==2){
            ((PreferenceTreeItem)node).setSelected(((Boolean)aValue).booleanValue(),true);
            this.jTreeTable.tableChanged(new javax.swing.event.TableModelEvent(jTreeTable.getModel(),0,jTreeTable.getRowCount(),2)); 
        }
    }

   
    
    private void createTree(Preferences parentPrefs, PreferenceTreeItem treeParent){
        PreferenceTreeItem parent;
        ArrayList childList = new ArrayList();
        if(treeParent == null){
            parent = new PreferenceTreeItem(parentPrefs,null);
        }else{
            parent = treeParent;
        }
        try{
            String[] childNames = parentPrefs.childrenNames();
            for(int i=0; i< childNames.length; i++){
                Preferences childPrefs = parentPrefs.node(childNames[i]);
                PreferenceTreeItem childTree = new PreferenceTreeItem(childPrefs, parent);
                childList.add(childTree);
                createTree(childPrefs, childTree );
            }
            String[] keyNames = parentPrefs.keys();
            for(int i=0; i< keyNames.length; i++){
                PreferenceAttribute prefAttr = new PreferenceAttribute(parentPrefs,parent,keyNames[i],parentPrefs.get(keyNames[i], ""));
                childList.add(prefAttr);
            }
            parent.addChilds(childList);
        }catch(java.util.prefs.BackingStoreException bse){
        }
        
        
    }
   
    
    public class PreferenceTreeItem{
        protected Preferences parentPrefs;
        protected boolean selected = false;
        protected ArrayList childs = new ArrayList();
        protected PreferenceTreeItem parentItem;
        
        public PreferenceTreeItem(Preferences parentPrefs, PreferenceTreeItem parent){
            this.parentPrefs = parentPrefs;
            parentItem = parent;
            
        }
        
        public boolean addChilds(ArrayList newChilds){
            return childs.addAll(newChilds);
        }
        
        
        public boolean getSelected(){
            return selected;
        }
        
        public void setSelected(boolean selected, boolean deep){
            if(deep){
                Iterator childIt = childs.iterator();
                while (childIt.hasNext()){
                    ((PreferenceTreeItem)childIt.next()).setSelected(selected, deep);
                }
            }
            
            this.selected = selected;
            if(selected)
                setParentSelection();
            
        }
        
        protected void setParentSelection(){
            selected = true;
            if(selected && (parentItem != null))
                parentItem.setParentSelection();
        }
        
        public String toString(){
            //return parentPrefs.absolutePath();
            return parentPrefs.name();
        }
        
        public String toString(int column){
            switch (column){
                case 0: return parentPrefs.absolutePath();
                case 1: return "";
                case 2: return new String(""+selected);
                
            }
            return "";
        }
        
        public int getChildCount(){
            return childs.size();
        }
        
        public Object getChild(int i) {
            return childs.get(i);
        }
        
        public boolean isLeaf() {
            return (childs.size()==0);
        }
        
        public Element getXMLElement(boolean deep){
            if(!selected)
                return null;
            
            Element elem = new Element("node");
            elem.setAttribute("name",parentPrefs.name());
            
            if(deep){
                Iterator childIt = childs.iterator();
                while (childIt.hasNext()){
                    Element childElem = ((PreferenceTreeItem)childIt.next()).getXMLElement(deep);
                    if(childElem != null)
                        elem.addContent( childElem );
                }
            }
            return elem;
        }

    }

    public class PreferenceRoot extends PreferenceTreeItem{

        public PreferenceRoot(Preferences parentPrefs, PreferenceTreeItem parent){
            super(parentPrefs,parent);

        }
        
        public String toString(){
            return "User Preferences";
        }
        
                public Element getXMLElement(boolean deep){
            if(!selected)
                return null;
            
            Element elem = new Element("preferences");
            if(deep){
                Iterator childIt = childs.iterator();
                while (childIt.hasNext()){
                    Element childElem = ((PreferenceTreeItem)childIt.next()).getXMLElement(deep);
                    if(childElem != null)
                        elem.addContent( childElem );
                }
            }
            return elem;
        }


    }

    
    
    
    public class PreferenceAttribute extends PreferenceTreeItem{
        private String key;
        private String value;
        
        public PreferenceAttribute(Preferences parentPrefs, PreferenceTreeItem parent, String key, String value){
            super(parentPrefs,parent);
            this.key =key;
            this. value = value;
        }
        
        public String toString(){
            return key;
        }
        
        
        public String toString(int column){
            switch (column){
                case 0: return "";
                case 1: return value;
                case 2: return new String(""+this.selected);
                
            }
            return "";
        }
        
        public Element getXMLElement(boolean deep){
            
            if(!selected)
                return null;
            
            Element elem = new Element("entry");
            elem.setAttribute("key",key);
            elem.setAttribute("value",value);
            return elem;
        }
        
    }
    
    
    
    
    
}
