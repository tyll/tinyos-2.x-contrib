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

public class TinyNodeT2Generator extends TinyOS2Generator {


	public TinyNodeT2Generator()
	{
		MyName = "tinynode_2";
	}

	public String getName()
	{
		return MyName;
	}

	public Vector<String> getTargets()
	{
		Vector<String> plats = new Vector<String>();

		plats.add("tinyos2");
		plats.add("msp430_2");
		plats.add("at45db_2");
		plats.add("tinynode_2");

		return plats;
	}
}
