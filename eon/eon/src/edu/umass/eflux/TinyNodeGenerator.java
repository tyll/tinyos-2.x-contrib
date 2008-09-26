package edu.umass.eflux;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collection;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;

import jdsl.graph.api.Edge;
import jdsl.graph.api.EdgeDirection;
import jdsl.graph.api.EdgeIterator;
import jdsl.graph.api.Vertex;

public class TinyNodeGenerator extends TinyOSGenerator {


	public TinyNodeGenerator()
	{
		MyName = "tinynode";
	}
	
	public String getName()
	{
		return MyName;
	}
	
	public Vector<String> getTargets()
	{
		Vector<String> plats = new Vector<String>();
		
		plats.add("tinyos");
		plats.add("msp430");
		plats.add("at45db");
		plats.add("tinynode");
		
		return plats;
	}
}
