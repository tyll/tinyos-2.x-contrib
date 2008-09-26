package edu.umass.eflux;

/**
 * Declaration of a type
 * @author Brendan Burns
 * @version $version: $
 **/
public class TypeDeclaration {
    private String name;
    private String function;
    
    /**
     * Constructor
     * @param name The name of the type
     * @param function The name of the function that tests this type
     **/
    public TypeDeclaration(String name, String function) {
        this.name = name;
        this.function = function;
    }
    
    /**
     * Get the name of this type
     * @return The type's name
     **/
    public String getName() {
        return this.name;
    }
    
    /**
     * Get the name of the function that tests this type
     * @return The type testing function's name
     **/
    public String getFunction() {
        return this.function;
    }
}
