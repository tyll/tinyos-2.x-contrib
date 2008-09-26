package edu.umass.eflux.nesc;

import java.util.*;

public class NESCInterfaceListing {

	Vector<InterfaceDecl> uses_list;
	Vector<InterfaceDecl> provides_list;
	
	public NESCInterfaceListing(Vector<InterfaceDecl> pl, Vector<InterfaceDecl> ul)
	{
		uses_list = ul;
		provides_list = pl;
	}
}
