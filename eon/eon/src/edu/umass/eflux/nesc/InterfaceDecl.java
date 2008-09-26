package edu.umass.eflux.nesc;

public class InterfaceDecl {

	protected String name;
	protected String type;
	
	public InterfaceDecl(String ifname, String iftype)
	{
		name = ifname;
		type = iftype;
	}
	
	public InterfaceDecl(String iftype)
	{
		this(null,iftype);
		
	}
	
	public InterfaceDecl(CommandDecl cmd)
	{
		
		
	}
	
	public InterfaceDecl(EventDecl cmd)
	{
		
		
	}
}
