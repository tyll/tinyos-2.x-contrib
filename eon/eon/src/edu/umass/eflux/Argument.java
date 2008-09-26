package edu.umass.eflux;

/**
 * An argument for a function, contains a name and a type
 * @author Brendan Burns
 * @version $version: $
 **/
public class Argument {
    private String type;
    private String name;
    
    /**
     * Constructor
     * @param argumentType The type of this argument
     * @param argumentName The name of this argument
     **/
    public Argument(String argumentType, String argumentName) {
        if (argumentName.charAt(0) == '*') {
	    this.type = argumentType+"*";
	    this.name = argumentName.substring(1);
	}
	else {
	    this.type = argumentType;
	    this.name = argumentName;
	}
    }
    
    /**
     * Get the type
     * @return The type of the argument
     **/
    String getType() {
        return this.type;
    }
    
    /**
     * Get the name
     * @return The name of the argument
     **/
    String getName() {
        return this.name;
    }
    
    /**
     * Get the string representation of this argument
     * @return A string representing this argument
     **/
    public String toString() {
        //return this.name + ":" + this.type;
    	return this.type + " " + this.name;
    }
    
}
