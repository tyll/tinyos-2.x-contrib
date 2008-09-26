/*
 * Created on Jul 8, 2005
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package edu.umass.eflux;

/**
 * @author emery, Jul 8, 2005
 * Lock
 * 
 */
public class Lock {
    
    public Lock (String n, int type)
    {
        scope = type & 3;
        variety = type & ~3;
        name = n;
	if (variety == 0)
	    variety = 4;
    }
    
    public String getName () {
        return name;
    }

    public boolean isReader() {
	return variety == READER;
    }

    public boolean isWriter() {
	return variety == WRITER;
    }

    public boolean isConnection() {
	return scope == CONNECTION;
    }

    public boolean isProgram() {
	return scope == PROGRAM;
    }

    public boolean isSession() {
	return scope == SESSION;
    }

    public int hashCode() {
	return name.hashCode();
    }

    public boolean equals(Object o) {
	if (o instanceof Lock) {
		Lock l = (Lock)o;
		return name.equals(l.getName());
	}
	return false;
    }

    public String toString() {
	return name+
	    (isSession()?" session ":"")+
	    (isProgram()?" program ":"");
    }
    
    private String name;
    private int scope;
    private int variety;
    
    public static final int SESSION = 0;    // 00
    public static final int CONNECTION = 1; // 01
    public static final int PROGRAM = 2;    // 10
    public static final int WRITER = 4;     
    public static final int READER = 8;     
}
