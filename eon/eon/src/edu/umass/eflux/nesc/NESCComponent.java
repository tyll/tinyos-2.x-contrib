package edu.umass.eflux.nesc;

public class NESCComponent {

	String component;
	String alias;
	
	public NESCComponent(String comp, String alias)
	{
		component = comp;
		this.alias = alias;
		
	}
	
	public NESCComponent(String comp)
	{
		this(comp, null);		
	}
}
