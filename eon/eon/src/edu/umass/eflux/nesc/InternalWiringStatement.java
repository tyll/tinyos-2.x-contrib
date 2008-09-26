package edu.umass.eflux.nesc;

public class InternalWiringStatement {
	private String iface;
	private InterfaceSpec dest;
	
	public InternalWiringStatement(String s, InterfaceSpec d)
	{
		iface = s;
		dest = d;
	}
}
