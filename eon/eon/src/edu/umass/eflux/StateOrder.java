package edu.umass.eflux;


import java.util.*;
/**
 * Declaration of a state
 * @author Jacob Sorber
 * @version $version: 1$
 **/
public class StateOrder {
    private Vector<Vector<String>> order;
    private Hashtable<String,Integer> defined;
    /**
     * Constructor
     * @param name The name of the type
     * @param function The name of the function that tests this type
     **/
    public StateOrder(Vector<Vector<String>> ordering) throws Exception {
        this.order = ordering;
        Vector<String> baseLvl = new Vector<String>();
        baseLvl.add("BASE");
        this.order.add(baseLvl);
        this.defined = new Hashtable<String,Integer>();
        
        
        //check for duplicate states in ordering
        int level = 0;
    	for (Vector<String> v: this.order)
    	{
    		for (String s : v)
    		{
    			if (this.defined.containsKey(s))
    			{
    				throw new Exception("ERROR: duplicate state "+s+" in state order.");
    			}
    			this.defined.put(s,level);
    			
    		}
    		level++;
    	} //for
    }
    
    /**
     * Get the number of distinct states in the program
     * @return The number of states
     **/
    public int NumStates () 
    {
    	int count = 0;
    	for (Vector<String> v: this.order)
    	{
    		for (String s : v)
    		{
    			count++;
    		}
    	}
        return count;
    }
    
    public int NumLevels()
    {
    	int count = 0;
    	for (Vector<String> v: this.order)
    	{
    		count++;
    	}
        return count;
    }
    
    public Vector<String> GetLevelByIdx(int index)
    {
    	return this.order.get(index);
    }
    
    
    public Vector<String> GetLevelByState(String state)
    {
    	int index = this.GetStateLevel(state);
    	return this.order.get(index);
    }
    
    public int GetStateLevel(String state)
    {
    	return this.defined.get(state);
    }
    
    public Vector<String> GetAllStates()
    {
    	Enumeration keys = defined.keys();
    	Vector<String> states = new Vector<String>();
    	while (keys.hasMoreElements())
    	{
    		states.add((String)keys.nextElement());
    	}
    	return states;
    } 
    
    public Vector<Vector<String>> getOrdering()
    {
    	return order;
    }
    	
}