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

public class Mica2DotGenerator extends TinyOSGenerator {

	protected static String MyName = "mica2dot";

	public String getName()
	{
		return MyName;
	}
	
	public Vector<String> getTargets()
	{
		Vector<String> plats = new Vector<String>();
		
		plats.add("tinyos");
		plats.add("avr");
		plats.add("at45db");
		plats.add("mica2");
		plats.add("mica2dot");
		
		return plats;
	}
}
