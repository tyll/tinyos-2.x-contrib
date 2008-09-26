package edu.umass.eflux;

import java.util.Vector;
import java.util.Iterator;

import edu.umass.eflux.FlowStatement;

/**
 * A simple flow statement is single expression of flow.  It may be typed.
 * @see TypedFlowStatement
 * @author Brendan Burns
 * @version $version: $
 **/
public class SimpleFlowStatement extends FlowStatement {
    protected Vector<String> types;
    protected Vector<String> args;
    protected String state;
    
    /**
     * Constructor
     * @param assignee Left hand side
     * @param args Vector of strings defining the right hand side
     **/
    public SimpleFlowStatement(String assignee, Vector<String> args) {
        this(assignee, null, args, null);
    }
    
    /**
     * Constructor
     * @param assignee Left hand side
     * @param args Vector of strings defining the right hand side
     * @param state String which identifies the minimum state required for this flow
     **/
    public SimpleFlowStatement(String assignee, Vector<String> args, String state) {
        this(assignee, null, args, state);
    }
    
    /**
     * Constructor with types
     * @param assignee Left hand side
     * @param types Vector of String defining the type pattern
     * @param args Vector of String defining the right hand side
     **/
    public SimpleFlowStatement(String assignee, Vector<String> types, Vector<String> args) {
        this(assignee, types, args, null);
    }
    
    /**
     * Constructor with types
     * @param assignee Left hand side
     * @param types Vector of String defining the type pattern
     * @param args Vector of String defining the right hand side
     **/
    public SimpleFlowStatement(String assignee,
    						   Vector<String> types,
    						   Vector<String> args,
							   String state) {
        super(assignee);
        this.types = types;
	if (args != null)
	{
        	this.args = (Vector<String>) args.clone();
	} else {
		this.args = new Vector<String>();
	}
        this.state = state;
        //System.out.println("SimpleFlow : "+assignee + " args: " + args + " state: " + state);
    }
    
    
    
    /**
     * Get the types Vector for this statement
     * @return A Vector of String defining the type pattern, null if untyped
     **/
    public Vector<String> getTypes() {
        return this.types;
    }
    
    /**
     * Get the right hand side of this statement
     * @return A Vector of String defining the right hand side of the statement
     **/
    public Vector<String> getArguments() {
        return this.args;
    }
    
    
    
    /**
     * @return Returns the state.
     */
    public String getState() {
    	return state;
    }
    
    /**
     * Test for presence in the right hand side
     * @param name The name to test
     * @return true if name appears in the right hand side of this statement
     **/
    public boolean inRightHandSide(String name) {
        for (int i=0; i < this.args.size(); i++)
            if (name.equals(this.args.get(i))) 
                return true;
        return false;
    }
    
    /**
     * Return a string representation of this statement
     * @return The string-i-fied version of this statement
     **/
    public String toString() {
        StringBuffer b = new StringBuffer(getAssignee()+":"+getState()+":"+this.types+"=");
	
	for (String s : this.args)
	{
        	//Iterator it = this.args.iterator();
        	b.append(s);
        	b.append("|");
        	
	}
        return b.toString();
    }
}
