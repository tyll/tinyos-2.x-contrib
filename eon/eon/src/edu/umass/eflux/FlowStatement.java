package edu.umass.eflux;

/**
 * The interface implemented by both simple and compound flow statements
 * @author Brendan Burns
 * @version $version: $
 **/
public abstract class FlowStatement {
    protected String assignee;
    
    /**
     * Constructor
     * @param lhs The left hand side of the statement
     **/
    public FlowStatement(String lhs) {
        this.assignee = lhs;
    }
    
    /**
     * Get the left hand side of the statement
     * @return The value to which this is assigned
     **/
    public String getAssignee() {
        return this.assignee;
    }
    
    /**
     * Test for presence in the right hand side
     * @param name The name to test
     * @return true if name appears in the right hand side of this statement
     **/
    public abstract boolean inRightHandSide(String name);
}
