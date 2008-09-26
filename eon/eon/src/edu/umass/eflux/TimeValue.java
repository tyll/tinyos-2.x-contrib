package edu.umass.eflux;

/**
 * An argument for a function, contains a name and a type
 * @author Brendan Burns
 * @version $version: $
 **/
public class TimeValue {
    private Integer value_ms;
    private String unit;
    private Integer value_orig;
    
    final static public int M_MS = 1;
    final static public int M_SEC = 1024;
    final static public int M_MIN = 60;
    final static public int M_HR = 60;
    
    final static public int TIMER_OFF = -2;
    final static public int TIMER_INF = -1;
    final static public String OFFTEXT = "-2";
    final static public String INFTEXT = "-1";
    /**
     * Constructor
     * @param value the timevalue string.
     **/
    public TimeValue(String value) throws Exception{
    	//check for off and inf
    	if (value.toUpperCase().equals(TimeValue.OFFTEXT))
    	{
    		value_ms = TimeValue.TIMER_OFF;
    		value_orig = TimeValue.TIMER_OFF;
    		this.unit = null;
    		return;
    	}
    	
    	if (value.toUpperCase().equals(TimeValue.INFTEXT))
    	{
    		value_ms = TimeValue.TIMER_INF;
    		value_orig = TimeValue.TIMER_INF;
    		this.unit = null;
    		return;
    	}
    	
        //split value
    	String addspace = "";
    	boolean found = false;
    	for (int i=0; i < value.length(); i++)
    	{
    		if (!found && Character.isLetter(value.charAt(i)))
    		{
    			found = true;
    			addspace = addspace + " ";
    		}
    		addspace = addspace + value.charAt(i);
    	}
    	String[] tokens = addspace.split(" ");
    	if (tokens.length > 2) throw new Exception("Invalid time value "+value);
    	 
    	int numval = Integer.parseInt(tokens[0]);
    	String textUnit="";
    	if (tokens.length == 2)
    	{
    		textUnit = tokens[1];
    	} else {
    		textUnit = "MS";
    	}
    	
    	if (numval < 0) throw new Exception ("Error Negative Time value \""+tokens[0]+"\"");
    	
    	this.unit = textUnit.toUpperCase();
    	this.value_ms = -1;
    	if (this.unit.equals("MS")) this.value_ms = numval;
    	if (this.unit.equals("SEC")) this.value_ms = numval * M_SEC;
    	if (this.unit.equals("MIN")) this.value_ms = numval * M_SEC * M_MIN;
    	if (this.unit.equals("HR")) this.value_ms = numval * M_SEC * M_MIN * M_HR;
    	
    	if (value_ms < 0) throw new Exception ("Unsupported time unit \""+textUnit+"\"");
    	
    	this.value_orig  = numval;
    }    
    
    public Integer getMSValue() {
        return this.value_ms;
    }
    
    public Integer getOriginalValue() {
        return this.value_orig;
    }
    
    /**
     * Get the name
     * @return The name of the argument
     **/
    String getUnits() {
        return this.unit;
    }
    
    /**
     * Get the string representation of this argument
     * @return A string representing this argument
     **/
    public String toString() {
        return "TIME("+this.value_ms + " ms = "+this.value_orig +" "+this.unit+")";
    }
}
