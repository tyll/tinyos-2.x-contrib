package edu.umass.eflux.nesc;

public class InterfaceSpec {

	private String component;
	private String iface;
	private IndexExpr index;
	
	public InterfaceSpec(String comp, String ifc, IndexExpr idx)
	{
		component = comp;
		iface = ifc;
		index = idx;
	}
	
	public InterfaceSpec(String comp, IndexExpr idx)
	{
		this(comp, null, idx);
	}
}
