package edu.umass.eflux.nesc;

public class WiringStatement {

	private InterfaceSpec src;
	private InterfaceSpec dst;
	
	public WiringStatement(InterfaceSpec s, InterfaceSpec d)
	{
		src = s;
		dst = d;
	}
}
