/*
 * Operation.java
 *
 * Created on 22. August 2005, 19:18
 */

/**
 *
 * @author Till Wimmer
 */
package net.tinyos.tinycops;
public class Operation {
    private int id;
    private String name=null;
    private String description=null;
    
    /** Creates a new instance of Operation */
    public Operation() {
    }
    
    public Operation(int id, String name, String description) {
        this.id = id;
        this.name = name;
        this.description = description;
    }
    
    public void setId (int id) {
        this.id = id;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
            
    public int getId() {
        return id;
    }
    
    public String getName() {
        return name;
    }
    
    public String getDescription() {
        return description;
    }
}
