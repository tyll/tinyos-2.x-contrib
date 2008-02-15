/*
 * Attribute.java
 *
 * Created on 22. August 2005, 19:17
 */
package net.tinyos.tinycops;
import java.util.*;

/**
 *
 * @author Till Wimmer
 */
public class Attribute {
    private TreeMap operations=null;
    private int id;
    private String name=null;
    private String description=null;
    private String type=null;
    private long min;
    private long max;
    private String endianness=null;
    private String preferred_visualization=null;
    private String metric_conversion=null;
    
    /** Creates a new instance of Attribute */
    public Attribute() {
    }
    
    public Attribute(int id, String name, String description, String type, long min, long max, 
            String endianness, TreeMap operations, String preferred_visualization, String metric_conversion) {
        this.id = id;
        this.operations = operations;
        this.name = name;
        this.description = description;
        this.type = type;
        this.min = min;
        this.max = max;
        this.endianness = endianness;
        this.preferred_visualization = preferred_visualization;
        this.metric_conversion = metric_conversion;
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
    
    public void setType(String type) {
        this.type = type;
    }
    
    public void setMin(long min) {
        this.min = min;
    }
    
    public void setMax(long max) {
        this.max = max;
    }
    
    public void setOperations(TreeMap operations) {
        this.operations = operations;
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
    
    public String getType() {
        return type;
    }
    
    public long getMin() {
        return min;
    }
    
    public long getMax() {
        return max;
    }
    
    public String getEndianness() {
        return endianness;
    }
    
    public TreeMap getOperations() {
        return operations;
    }
    
    public String getPreferredVisualization () {
        return preferred_visualization;
    }
    
    public String getMetricConversion () {
        return metric_conversion;
    }
    
}
