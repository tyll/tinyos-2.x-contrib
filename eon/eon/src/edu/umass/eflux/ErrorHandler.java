package edu.umass.eflux;

import java.util.Iterator;
import java.util.StringTokenizer;
import java.util.Vector;

public class ErrorHandler {
    Vector<String> pattern;
    String function;
    
    public ErrorHandler(Vector<String> pattern, String function) {
    	this.pattern = pattern;
    	this.function = function;
    }
 
    public String getFunction() {
    	return this.function;
    }
    
    
    public Vector<String> getPattern()
    {
        return this.pattern;
    }
    
    public String getTarget()
    {
        return this.pattern.firstElement();
    }
    
    public boolean matches(String path) 
    {
		StringTokenizer toks = new StringTokenizer(path, ",");
		Vector<String> vec = new Vector<String>();
		while (toks.hasMoreTokens())
		    vec.add(toks.nextToken());
		
		return matches(vec.iterator(), this.pattern.iterator());
    }
	
    public boolean matches(Vector<String> path) {
	return matches(path.iterator(), this.pattern.iterator());
    }
	 
    public static boolean matches (Iterator<String> candidate, 
				   Iterator<String> pattern)
    {
	while (pattern.hasNext()) {
	    String key = pattern.next();
	    if ("*".equals(key)) {
		String next = pattern.next();
		String current;
		
		do {
		    if (!candidate.hasNext())
			return false;
		    current = candidate.next();
		} while (!current.equals(next));
	    }
	    else {
		if (!candidate.hasNext())
		    return false;
		if (!candidate.next().equals(key))
		    return false;
	    }
	}
	return true;
    }
    
    public static void main(String[] args) {
	StringTokenizer toks = new StringTokenizer(args[0], ",");
	Vector<String> pattern = new Vector<String>();
	while (toks.hasMoreTokens()) 
	    pattern.add(toks.nextToken());

	Vector<String> path = new Vector<String>();
	while (toks.hasMoreTokens()) 
	    path.add(toks.nextToken());
	
	ErrorHandler eh = new ErrorHandler(pattern, "Foo");
	
	System.out.println(eh.matches(path));
	System.out.println(eh.matches(args[1]));
    }
}
