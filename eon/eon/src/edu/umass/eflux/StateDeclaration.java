package edu.umass.eflux;

/**
 * Declaration of a state
 * @author Jacob Sorber
 * @version $version: $
 **/
public class StateDeclaration {
    private String name;
    
    
    /**
     * Constructor
     * @param name The name of the type
     * @param function The name of the function that tests this type
     **/
    public StateDeclaration(String name) {
        this.name = name;
    }
    
    /**
     * Get the name of this type
     * @return The type's name
     **/
    public String getName() {
        return this.name;
    }
    
    
}
