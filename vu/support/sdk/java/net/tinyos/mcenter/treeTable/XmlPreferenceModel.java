
package net.tinyos.mcenter.treeTable;

import java.util.*;

import org.jdom.Document;
import org.jdom.Element;

import java.util.prefs.*;

public class XmlPreferenceModel extends AbstractTreeTableModel {
    
    // Names of the columns.
    static protected String[]  cNames = {"Name", "Value", "Selected"};
    
    // Types of the columns.
    static protected Class[]  cTypes = { TreeTableModel.class,
    String.class, Boolean.class};
    
    
    
    
    Preferences prefs = null;
    
    XmlPreferenceModel.PreferenceTreeItem itemTreeRoot;
    
    private JTreeTable jTreeTable = null;
    
    public XmlPreferenceModel() {
        super(null);
        
    }
    
    public XmlPreferenceModel(Document xmlDoc) {
        super(null);
        //prefs = Preferences.userNodeForPackage(this.getClass());
        prefs = Preferences.userRoot();
        Element elementRoot =  xmlDoc.getRootElement();
        itemTreeRoot = new XmlPreferenceModel.PreferenceRoot(prefs,null,elementRoot.getName());
        createXmlTree(prefs, itemTreeRoot,elementRoot);
        root = itemTreeRoot;
    }
    
    
    
    public void setTreeTable(JTreeTable jTreeTable){
        this.jTreeTable = jTreeTable;
    }
    
    public void importSelection( Preferences prefs){
        itemTreeRoot.registerPreference(true, prefs);
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
    
    private void createXmlTree(Preferences parentPrefs, PreferenceTreeItem treeParent, Element parentElement){
        ArrayList childList = new ArrayList();
        if(treeParent == null){
            return;
        }
        
        List childElements = parentElement.getChildren("node");
        Iterator childIt = childElements.iterator();
        while (childIt.hasNext()){
            Element childElement = (Element) childIt.next();
            PreferenceTreeItem childTree = new PreferenceTreeItem(parentPrefs, treeParent, childElement.getAttributeValue("name"));
            childList.add(childTree);
            createXmlTree(parentPrefs, childTree, childElement );
        }
        childElements = parentElement.getChildren("entry");
        childIt = childElements.iterator();
        while (childIt.hasNext()){
            Element childElement = (Element) childIt.next();
            PreferenceAttribute prefAttr = new PreferenceAttribute(parentPrefs,treeParent,childElement.getAttributeValue("key"),childElement.getAttributeValue("value"));
            childList.add(prefAttr);
        }
        treeParent.addChilds(childList);
        
        
        
    }
    
    
    
    
    public class PreferenceTreeItem{
        protected Preferences parentPrefs;
        protected boolean selected = false;
        protected ArrayList childs = new ArrayList();
        protected PreferenceTreeItem parentItem;
        private String prefsNodeName;
        
        public PreferenceTreeItem(Preferences parentPrefs, PreferenceTreeItem parent, String prefsNodeName){
            this.parentPrefs = parentPrefs;
            this.prefsNodeName = prefsNodeName;
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
            return prefsNodeName;
        }
        
        public String toString(int column){
            switch (column){
                case 0: return prefsNodeName;
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
        
        public void registerPreference(boolean deep, Preferences parentPrefs){
            
            if(!selected)
                return;
            String separator = (parentPrefs.absolutePath().endsWith("/"))? "" : "/";
            Preferences childPref = parentPrefs.node(parentPrefs.absolutePath() + separator +prefsNodeName);
            if(deep){
                Iterator childIt = childs.iterator();
                while (childIt.hasNext()){
                    ((PreferenceTreeItem)childIt.next()).registerPreference(deep,childPref);
                    
                }
            }
            
        }
        
    }
    
    public class PreferenceRoot extends PreferenceTreeItem{
        
        public PreferenceRoot(Preferences parentPrefs, PreferenceTreeItem parent, String prefsNodeName){
            super(parentPrefs,parent,prefsNodeName);
            
        }
        
        public String toString(){
            return "User Preferences";
        }
        
        public void registerPreference(boolean deep, Preferences parentPrefs){
            
            if(!selected)
                return;
            
            if(deep){
                Iterator childIt = childs.iterator();
                
                while (childIt.hasNext()){
                    ((PreferenceTreeItem)childIt.next()).registerPreference(deep,parentPrefs);
                    
                }
            }
            
        }
        
        
    }
    
    
    public class PreferenceAttribute extends PreferenceTreeItem{
        private String key;
        private String value;
        
        public PreferenceAttribute(Preferences parentPrefs, PreferenceTreeItem parent, String key, String value){
            super(parentPrefs,parent,key);
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
        
        public void registerPreference(boolean deep, Preferences parentPrefs){
            
            if(!selected)
                return ;
            parentPrefs.put(key, value);
            
        }
        
    }
    
    
    
    
    
}
