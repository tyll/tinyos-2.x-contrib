package edu.umass.eflux.nesc;

public class TypeSpec {

	private String type_name;
	private boolean pointer;
	
	public TypeSpec(String name, boolean ptr)
	{
		type_name = name;
		pointer = ptr;
	}
}
