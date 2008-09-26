package edu.umass.eflux.nesc;

public class IndexExpr {
	protected boolean resolved = false;
	protected int index; 
	protected String ident;
	protected boolean unique;
	
	public IndexExpr(int i)
	{
		index = i;
		resolved = true;
		unique = false;
	}
	
	public IndexExpr(String s)
	{
		ident = s;
		resolved = false;
		unique = false;
	} 
}
