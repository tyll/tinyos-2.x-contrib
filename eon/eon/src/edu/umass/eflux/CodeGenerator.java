package edu.umass.eflux;

import java.util.*;

interface CodeGenerator
{
	void generate(String root, ProgramGraph pg, Program pm,
			boolean stubbs); 
	
	Vector<String> getTargets();
	String getName();
}