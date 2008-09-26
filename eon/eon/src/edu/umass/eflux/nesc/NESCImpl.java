package edu.umass.eflux.nesc;

import java.util.*;

public class NESCImpl {
	private Vector<NESCComponent> components;
	private Vector<WiringStatement> wirings;
	private Vector<InternalWiringStatement> internals;
	
	public NESCImpl(Vector statements)
	{
		Iterator it = statements.iterator();
		components = new Vector<NESCComponent>();
		wirings = new Vector<WiringStatement>();
		internals = new Vector<InternalWiringStatement>();
		
		while (it.hasNext())
		{
			Object o = it.next();
			
			if (o instanceof ComponentStatement)
			{
				ComponentStatement cs = (ComponentStatement)o;
				Vector<NESCComponent> comps = cs.getComponents();
				
				for (NESCComponent c : comps)
				{
					components.add(c);
				}
			}
			
			if (o instanceof WiringStatement)
			{
				wirings.add((WiringStatement)o);
			}
			
			if (o instanceof InternalWiringStatement)
			{
				internals.add((InternalWiringStatement)o);
			}
		}
	}
	
}
