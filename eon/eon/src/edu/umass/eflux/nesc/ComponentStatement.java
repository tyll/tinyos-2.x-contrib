package edu.umass.eflux.nesc;

import java.util.*;

public class ComponentStatement {
	private Vector<NESCComponent> components;
	
	public ComponentStatement(Vector<NESCComponent> c)
	{
		components = c;
	}
	
	public Vector<NESCComponent> getComponents()
	{
		return components;
	}
}
