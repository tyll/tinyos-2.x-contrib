package edu.umass.eflux;

import java.io.*;
import java.util.*;

import jdsl.graph.ref.IncidenceListGraph;
import jdsl.graph.api.*;
import java.*;

import edu.umass.eflux.ErrorHandler;
import edu.umass.eflux.FlowStatement;
import edu.umass.eflux.GraphNode;
import edu.umass.eflux.Yylex;

/**
 * The program graph class constructs a graph representing a Markov program
 * By default it uses a single edge, even when edges are shared by multiple
 * paths.  The number of connections using that path is stored with each edge.
 *
 * @author Brendan
 * @version 0.1
 **/
public class ProgramGraph {
	IncidenceListGraph graph;
	Hashtable vertex_map;
	Program program;
	
	private static int totalStages = 0;
	private static Hashtable<String, Integer> stageNumber
	= new Hashtable<String, Integer>();
	
	private int numErrors = 0;
	private static Hashtable<String, Integer> errorNumber
	= new Hashtable<String, Integer>();
	
	private GraphNode graphNodeEntry;
	private GraphNode graphNodeExit;
	private GraphNode graphNodeError;
	private Vertex ENTRY;
	private Vertex EXIT;
	private Vertex ERROR;
	
	private static String _WEIGHT = "count";
	
	private Collection<ErrorHandler> errs;
	
	private int intNumPaths = 0; 
	
	//private Vector <GraphNode> sortedVertices = new Vector <GraphNode>();
	private Vector <Vertex> sortedVertices = new Vector <Vertex>();
	
	/**
	 * Constructor
	 * @param p The program represented by this graph
	 **/
	public ProgramGraph(Program p) 
	{
		this.program = p;
		this.graph = new IncidenceListGraph();
		this.vertex_map = new Hashtable();
		
		Collection fns = p.getFunctions();
		Iterator it = fns.iterator();
		while (it.hasNext()) 
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
			GraphNode graphNode = new GraphNode(td, GraphNode.DEFAULT);
			Vertex v = this.graph.insertVertex(graphNode);
			this.vertex_map.put(td.getName(), v);
		}
		
		
		Collection<Source> sources = p.getSources();
		
		errs = p.getErrorHandlers();
		for (ErrorHandler err : errs)
		{
			errorNumber.put(err.getFunction() , numErrors++);
			GraphNode graphNode = new GraphNode(err, GraphNode.ERROR_HANDLER);
			Vertex v = this.graph.insertVertex(graphNode);
			this.vertex_map.put(err.getFunction(), v);
			Vertex target = (Vertex) this.vertex_map.get(err.getTarget());
			if (target == null)
				System.err.println("Error target : "+err.getTarget()+" does not exist.");
			GraphNode gNode = (GraphNode)target.element();
			TaskDeclaration td = (TaskDeclaration)gNode.getElement();
			td.setErrorHandler(err.getFunction());
			this.graph.insertDirectedEdge(target, v, "[]");
		}
		
		for (Source src : sources) 
		{
			//System.out.println(src.getSourceFunction());
			FlowStatement fs = p.getFlow(src.getSourceFunction());
			TaskDeclaration td = p.getTask(src.getSourceFunction());
			td.setIsSrc(true);
			
			if (fs!=null)
			{
				recursiveGenerate(fs, null, p);
				findLeafNodes(src.getSourceFunction());
			} 
			else {
				td.setSrcName(td.getName());
				Vertex source = (Vertex)vertex_map.get(src.getSourceFunction());
				Vertex target = (Vertex)vertex_map.get(src.getTarget());
				if (target == null)
				{
					System.err.println("ERROR: Unknown Target: " + src.getTarget());
					System.exit(1);
				}
				
				td.setIsSrcEnd(true);
				this.graph.insertDirectedEdge(source, target, "[]");
			}
			
			// Recursively Generate on the Target
			fs = p.getFlow(src.getTarget());
			if (fs!=null)
				recursiveGenerate(fs, null, p);
		}
		
		fns = p.getFunctions();
		it = fns.iterator();
		while (it.hasNext()) 
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
		}
		setUpGraph();
		
		sortVertices();
		this.getNumPaths();
	}
	
	public boolean isSource(String nodeName)
	{
		Collection<Source> sources = program.getSources();
		for (Source src : sources) 
		{
			String srcName = src.getSourceFunction();
			if (nodeName.equals(srcName))
				return true;
		}
		return false;
	}
	
	public boolean isTimedSource(String nodeName)
	{
		
		Collection<Source> sources = program.getSources();
		for (Source src : sources) 
		{
			String srcName = src.getSourceFunction();
			if (nodeName.equals(srcName) &&
				src instanceof TimerSource)
			{
				return true;
			}
		}
		return false;
	}
	
	
	private void findLeafNodes(String nodeName)
	{
		Vertex vertex = (Vertex)this.vertex_map.get(nodeName);
		String target = program.getSource(nodeName).getTarget();
		findLeafNodesHelper(vertex, target, nodeName);
	}
	
	private void findLeafNodesHelper(Vertex vertex, String target, String sourceNodeName)
	{
		EdgeIterator edgeIterator = this.graph.incidentEdges(vertex, EdgeDirection.OUT);
		//System.out.println(vertex.element().toString());
		
		TaskDeclaration td = program.getTask(vertex.element().toString());
		
		td.setIsSrc(true);
		td.setSrcName(sourceNodeName);
		if(edgeIterator.hasNext())
		{
			while(edgeIterator.hasNext())
			{
				Edge edge = edgeIterator.nextEdge();
				Vertex destination = this.graph.destination(edge);
				if (destination.element().toString().equals(target) != true)
					findLeafNodesHelper(destination, target, sourceNodeName);
			}
		}
		else
		{
			Vertex vTarget = (Vertex)vertex_map.get(target);
			this.graph.insertDirectedEdge(vertex, vTarget, null);
			td.setIsSrcEnd(true);
			
		}	
		
	}
	
	private void setUpGraph()
	{
		// add a directed edge from ERROR to EXIT
		graphNodeEntry = new GraphNode(null, GraphNode.ENTRY);
		graphNodeExit = new GraphNode(null, GraphNode.EXIT);
		graphNodeError = new GraphNode(null, GraphNode.ERROR);
		ENTRY = this.graph.insertVertex(graphNodeEntry);
		EXIT  = this.graph.insertVertex(graphNodeExit);
		ERROR = this.graph.insertVertex(graphNodeError);
		graphNodeExit.setNodeColor(GraphNode.BLACK);
		graphNodeError.setNodeColor(GraphNode.BLACK);
		this.graph.insertDirectedEdge(ERROR, EXIT, "[]");
		
		VertexIterator graphNodes = graph.vertices();
		while (graphNodes.hasNext())
		{
			Vertex vert = graphNodes.nextVertex();
			GraphNode graphNode = (GraphNode)vert.element();
			
			// if it's a source:
			// - add an edge from entry to source
			// - add an edge from source to error
			if (graphNode.getNodeType() == GraphNode.ERROR_HANDLER)
			{
				this.graph.insertDirectedEdge(vert, ERROR, "[]");
			}
			else if (graphNode.getNodeType() == GraphNode.DEFAULT)
			{
				int in = graph.degree(vert, EdgeDirection.IN);
				int out = graph.degree(vert, EdgeDirection.OUT);
				
				Vertex errNode = getErrorNode(vert);
				if (errNode == null)
					this.graph.insertDirectedEdge(vert, ERROR, "[]");
				
				if (in == 0)
				{
					this.graph.insertDirectedEdge(ENTRY, vert, "[]");
				}
				// if its an end node:
				// - add an edge from the end node to EXIT
				if (out == 0) 
				{
					this.graph.insertDirectedEdge(vert, EXIT, "[]");
				}
			}
			
		}
	}
	
	private Vertex getErrorNode(Vertex vertex)
	{
		EdgeIterator edgeIterator = this.graph.incidentEdges(vertex, EdgeDirection.OUT);
		while(edgeIterator.hasNext())
		{
			Edge edge = edgeIterator.nextEdge();
			Vertex destination = this.graph.destination(edge);
			GraphNode graphNode =  (GraphNode)destination.element();
			
			//if (destination.element() instanceof ErrorHandler)
			if (graphNode.getNodeType() == GraphNode.ERROR_HANDLER)
				return destination;
		}
		return null;
	}
	
	void sortVertices()
	{
		// make sure all of the vertices are white by default
		VertexIterator vertexIterator = graph.vertices();
		while(vertexIterator.hasNext())
		{
			Vertex vert = vertexIterator.nextVertex();
			GraphNode graphNode = (GraphNode)vert.element();
			graphNode.setNodeColor(GraphNode.WHITE);
		}
		
		this.sortVerticesHelper(ENTRY);
	}
	
	private void sortVerticesHelper(Vertex currVertex)
	{
		GraphNode graphNode = (GraphNode)currVertex.element();
		
		if (graphNode.getNodeColor() == GraphNode.BLACK)
			return;
		
		graphNode.setNodeColor(GraphNode.GREY);
		
		//System.out.println("now visiting: " + graphNode.toString());
		
		// now, call the helper function for all of the children of 
		EdgeIterator edgeIterator = this.graph.incidentEdges(currVertex, EdgeDirection.OUT);
		while(edgeIterator.hasNext())
		{
			Edge edge = edgeIterator.nextEdge();
			Vertex destination = this.graph.destination(edge);
			GraphNode tempNode = (GraphNode)destination.element();
			
			if (tempNode.getNodeColor() != GraphNode.GREY) // no loop so far...
			{
				if (tempNode.getNodeColor() == GraphNode.WHITE)
				{
					sortVerticesHelper(destination);
				}
			}
			else
			{
				//System.out.println(tempNode.toString());
				System.err.println("Error: This graph has a loop in it!");
				this.graph.removeEdge(edge);
				//this.outputDot(out, 
				//System.exit(1);
			}
		}
		
		graphNode.setNodeColor(GraphNode.BLACK);
		sortedVertices.add(currVertex);
	}
	
	/**
	 * This function enumerates all the paths in the DAG that is the eFlux program
	 * @author alex
	 * @version 1.0
	 ** */
	public void getNumPaths()
	{
		Iterator<Vertex> iter = sortedVertices.iterator();
		while (iter.hasNext())
		{
			Vertex vertex = (Vertex)iter.next();
			GraphNode graphNode = (GraphNode)vertex.element();
			// if the vertex is a leaf vertex
			int out = graph.degree(vertex, EdgeDirection.OUT);
			if (out == 0)
			{
				//System.out.println("Hi, " + graphNode.toString());
				graphNode.setNumPaths(1);
			}
			else
			{
				EdgeIterator edgeIterator = this.graph.incidentEdges(vertex, EdgeDirection.OUT);
				graphNode.setNumPaths(0);
				while(edgeIterator.hasNext())
				{
					Edge edge = edgeIterator.nextEdge();
					Vertex destination = this.graph.destination(edge);
					GraphNode destinationGraphNode = (GraphNode)destination.element();
					Integer val = graphNode.getNumPaths();
					
					edge.set(_WEIGHT, (Integer)val);
					int numPaths = graphNode.getNumPaths() + destinationGraphNode.getNumPaths();
					graphNode.setNumPaths(numPaths);
				}
			}
		}
		
		/*Print out all edges:*/
		iter = sortedVertices.iterator();
		while (iter.hasNext())
		{
			Vertex vertex = (Vertex)iter.next();
			GraphNode vertexGnode = (GraphNode)vertex.element();
			EdgeIterator edgeIterator = this.graph.incidentEdges(vertex, EdgeDirection.OUT);
			while(edgeIterator.hasNext())
			{
				Edge edge = edgeIterator.nextEdge();
				Vertex destination = this.graph.destination(edge);
				GraphNode destinationGraphNode = (GraphNode)destination.element();
				//System.out.println(vertexGnode.toString() + "->" + destinationGraphNode.toString() +":  " + edge.get(_WEIGHT));
			}
		}
	}
	//int currSum = 0;
	public String printPaths(PrintWriter out) throws IOException
	{
		String ret = "// ";
		return printPathsHelper(out, ENTRY, ret, 0);
		//return printPathsHelper(out, ENTRY, ret);
	}
	
	
	private String printPathsHelper(PrintWriter out, Vertex vertex, String currString, int currSum) throws IOException
	{
		String str = "";
		if (vertex == ENTRY)
		{
			currSum = 0;
			currString += vertex.element().toString();
		}
		else
			currString += " -> " + vertex.element().toString();
		
		int outCt = graph.degree(vertex, EdgeDirection.OUT);
		if (outCt > 0)
		{
			EdgeIterator edgeIterator = this.graph.incidentEdges(vertex, EdgeDirection.OUT);
			
			while(edgeIterator.hasNext())
			{
				String edgeString = "";
				Edge edge = edgeIterator.nextEdge();
				Vertex destination = this.graph.destination(edge);
				
				Integer edgeValue = (Integer)edge.get(_WEIGHT);
				if (edge.element() != null)
				{
				//		System.out.println((String)edge.element() + " :: " + (Integer)edge.get(_WEIGHT));
					//edgeString = ":" + (String)edge.element().toString();
					edgeString = (String)edge.element().toString();
				}
				currSum += edgeValue;
				
				str = currString + edgeString;

				printPathsHelper(out, destination, str, currSum);
				currSum -= edgeValue;
				
			}
		}
		else
		{
			//currString += ":  " + getPathSum(currString);
			currString += ":  " + currSum;  //NOOOOOOO
			out.println(currString);
			//currSum = 0;
			this.intNumPaths++;
		}
		return str;
	}
	/*
	private String printPathsHelper(PrintWriter out, Vertex vertex, String currString, int currSum) throws IOException
	{
		String str = "";
		if (vertex == ENTRY)
		{
			currSum = 0;
			currString += vertex.element().toString();
		}
		else
			currString += " -> " + vertex.element().toString();
		
		int outCt = graph.degree(vertex, EdgeDirection.OUT);
		if (outCt > 0)
		{
			EdgeIterator edgeIterator = this.graph.incidentEdges(vertex, EdgeDirection.OUT);
			
			while(edgeIterator.hasNext())
			{
				String edgeString = "";
				Edge edge = edgeIterator.nextEdge();
				Vertex destination = this.graph.destination(edge);
				
				Integer edgeValue = (Integer)edge.get(_WEIGHT);
				if (edge.element() != null)
				{
				//		System.out.println((String)edge.element() + " :: " + (Integer)edge.get(_WEIGHT));
					//edgeString = ":" + (String)edge.element().toString();
					edgeString = (String)edge.element().toString();
				}
				currSum += edgeValue;
				
				str = currString + edgeString;

				printPathsHelper(out, destination, str, currSum);
			}
		}
		else
		{
			currString += ":  " + getPathSum(currString);
			//currString += ":  " + currSum; NOOOOOOO
			out.println(currString);
			currSum = 0;
			this.intNumPaths++;
		}
		return str;
	}
	*/
	public Vector<Vector<Vertex>> getPaths()
	{
		Vector<Vector<Vertex>> result = new Vector<Vector<Vertex>>();
		Stack<Vertex> ret = new Stack<Vertex>();
		
		getPathsHelper(result, ENTRY, ret, 0);
		return result;
		//return printPathsHelper(out, ENTRY, ret);
	}
	
	private void getPathsHelper(Vector<Vector<Vertex>> result, Vertex vertex, Stack<Vertex> curPath, int currSum)
	{
		String str = "";
		curPath.push(vertex);
		
		int outCt = graph.degree(vertex, EdgeDirection.OUT);
		if (outCt > 0)
		{
			EdgeIterator edgeIterator = this.graph.incidentEdges(vertex, EdgeDirection.OUT);
			
			while(edgeIterator.hasNext())
			{
				Edge edge = edgeIterator.nextEdge();
				Vertex destination = this.graph.destination(edge);
				
				Integer edgeValue = (Integer)edge.get(_WEIGHT);
				currSum += edgeValue;
				
				getPathsHelper(result, destination, curPath, currSum);
			}
		}
		else
		{
			//export path
			Vector<Vertex> path = (Vector<Vertex>)curPath.clone();
			result.add(path);
			//System.out.println("PATH: "+path);
			
			
			currSum = 0;
			//this.intNumPaths++;
			//System.out.println(currString);
		}
		curPath.pop();
		return;
	}
	
	public int getIntNumPaths()
	{
		
		return intNumPaths;
	}
	
	private int getPathSum(String path)
	{
		int currPathSum = 0;
		String parent;
		String child;
		//StringTokenizer tokenizer = new StringTokenizer (path, " ;->{}[]\"");
		StringTokenizer tokenizer = new StringTokenizer (path, " ->");
		System.out.println("getPathSum: "+path);
		String str1 = tokenizer.nextToken();
		str1 += "";
		parent = tokenizer.nextToken();
		while (tokenizer.hasMoreTokens())
		{
			child = tokenizer.nextToken();
			if (!child.equals("EXIT"))
			{
				if (child.charAt(child.length()-1) != ']')
					child += " " +  tokenizer.nextToken() + " " + tokenizer.nextToken();
			}
			child = child.trim();
			parent = parent.trim();
			
			if (parent.equals("ENTRY[]"))
			{
				Vertex destination = this.getVertex(child);
				if (child.contains("[") &&  child.contains("]"))
				{
					int start = child.indexOf("[");
					int end = child.indexOf("]");

					String str = child.substring(0,start);
					str = str.trim();
					destination = this.getVertex(str);
					if (destination == null)
					{
						System.err.println("Error: Destination  is null");
						System.exit(1);
					}
				}
				//currPathSum += this.getEdgeWeight(this.getVertexEntry(), destination, signature);
				currPathSum += this.getEdgeWeight(this.getVertexEntry(), destination, "[]");
			}
			else if (parent.equals("ERROR[]") && child.equals("EXIT"))
			{
				currPathSum += this.getEdgeWeight(this.getVertexError(), this.getVertexExit(), "[]");
			}
			else if(child.equals("EXIT"))
			{
				String signature = "[]";
				Vertex source = this.getVertex(parent);
				if (parent.contains("[") && parent.contains("]"))
				{
					int start = parent.indexOf("[");
					int end = parent.indexOf("]");
					
					String str = parent.substring(0, start);
					
					str = str.trim();
					if(!parent.contains("[]"))
						signature = parent.substring(start + 1, end - 1);
					/*
					int a = parent.length();
					if(end != parent.length()-1)
						signature = parent.substring(end+1, child.length()-1);
					else
						signature = "";
					*/
					source = this.getVertex(str);
					
				}
				currPathSum += this.getEdgeWeight(source, this.getVertexExit(), signature);
			}
			else if (parent.equals("ERROR[]"))
			{
				Vertex destination = null;
				if (child.contains("[") && child.contains("]"))
				{
					int start = child.indexOf("[");
					int end = child.indexOf("]");
					
					String str = child.substring(0, start-1);
					str = str.trim();
					
					destination =  this.getVertex(str);
					if (destination == null)
					{
						System.out.println("Error: Destination  is null");
						System.exit(1);
					}

				}
				/*
				if (child.contains(":"))
				{
					int end = child.indexOf(":");
					String str = child.substring(0,end);
					destination = this.getVertex(str);
				}
				*/
				currPathSum += this.getEdgeWeight(this.getVertexError(), destination, "[]");
			}
			else if (child.equals("ERROR[]"))
			{
				//String signature = null;
				Vertex source = this.getVertex(parent);
				
				if (parent.contains("[") && parent.contains("]"))
				{
					int start  = parent.indexOf("[");
					int end = parent.indexOf("]");
					String str = parent.substring(0,start);
					source = this.getVertex(str);
					if (source == null)
					{
						System.err.println("Error: Source  is null");
						System.exit(1);
					}
				}
				currPathSum += this.getEdgeWeight(source, this.getVertexError(), "[]");
			}
			else
			{
				String signature = "[]";
				Vertex source = this.getVertex(parent);
				if (parent.contains("[") && parent.contains("]"))
				{
					int start = parent.indexOf("[");
					int end = parent.indexOf("]");

					String str = parent.substring(0,start);
					int a = parent.length();
					if(!parent.contains("[]"))
					//if(end != parent.length()-1)
						signature = parent.substring(start, end+1);
					source = this.getVertex(str);
					if (source == null)
					{
						System.out.println("Error: Source  is null");
						System.exit(1);
					}
				}
				Vertex destination = this.getVertex(child);
				if (child.contains("[") && child.contains("]"))
				{
					int start = child.indexOf("[");
					int end = child.indexOf("]");
					
					String str = child.substring(0,start);
					str = str.trim();
					destination = this.getVertex(str);
					if (destination == null)
					{
						System.err.println("Error: Destination  is null");
						System.exit(1);
					}
				}
				currPathSum += this.getEdgeWeight(source, destination, signature);	
			}
			parent = child;
		}
		return currPathSum;
	}
	
	
	public int getEdgeWeight(String s, String d)
	{
		Vertex source = this.getVertex(s);
		Vertex destination  = this.getVertex(d);
		
		return this.getEdgeWeight(source, destination, "[]");
	}
	
	public int getEdgeWeight(String s, String d, String parentSignature)
	{
		Vertex source = this.getVertex(s);
		Vertex destination  = this.getVertex(d);

		return this.getEdgeWeight(source, destination, parentSignature);		
	}
	
	/**
	 * getEdgeWeight
	 * @param Vertex source - the source vertex
	 * @param Vertex destination - the destination vertex
	 ***/
	public int getEdgeWeight(Vertex source, Vertex destination, String parentSignature)
	{
		//System.out.println("GETWEIGHT: source: " + source.element().toString() + " destination: " + destination.element().toString()+"..."+parentSignature);
		EdgeIterator edgeIterator = this.graph.incidentEdges(source, EdgeDirection.OUT);
		while (edgeIterator.hasNext())
		{
			Edge edge = edgeIterator.nextEdge();
			Vertex currDestination = this.graph.destination(edge);
			//System.out.println("C("+source.element().toString()+","+destination.element().toString()+") - "+currDestination.element().toString());
			if(parentSignature != null)
			{
				//System.out.println("GEW: psig != null");
				if (currDestination == destination)
				{
					
					//if (edge)
					String currentEdgeSignature = (String)edge.element();
					
					//System.out.println("GEW" + currentEdgeSignature + "| curr == dest");
					
					if (currentEdgeSignature.equals(parentSignature))
					{
						return (Integer)edge.get(_WEIGHT);
					}
				}
			}
			else
			{
				if (currDestination == destination)
				{
					return (Integer)edge.get(_WEIGHT);
				}
				
			}
		}
		System.err.println(source.element().toString() + " is not connected to: " + destination.element().toString());
		return -1;
	}
	
	
	public Program getProgram() {
		return this.program;
	}
	
	public Vertex getVertex(String name) {
		return (Vertex) this.vertex_map.get(name);
	}
	
	//public InspectableGraph getGraph() {
	public IncidenceListGraph getGraph() {
		return this.graph;
	}
	
	/**
	 * Output this graph in dot format suitable for 
	 * <a href="http://www.graphviz.org/">GraphViz Toolkit</a>
	 *
	 * @param out Where to write
	 * @param name The name to give this graph
	 **/
	public void outputDot(PrintWriter out, String name) throws IOException 
	{
		out.println("digraph "+name.replace('-','_')+" {");
		VertexIterator vi = graph.vertices();
		while (vi.hasNext()) 
		{
			Vertex v = vi.nextVertex();
			GraphNode graphNode = (GraphNode)v.element();
			if ( (graphNode.getNodeType() == GraphNode.DEFAULT) || (graphNode.getNodeType() == GraphNode.ERROR_HANDLER))
			{            
				Object o = graphNode.getElement();
				if (o instanceof TaskDeclaration) 
				{
					String plat = "";
					TaskDeclaration td = (TaskDeclaration)o;
					/*if (td.getPlatformName().equals("STARGATE"))
						plat = "[shape=box]";*/
						
					out.println(td.getName() + plat + ";\t // " + getStageNumber(td.getName()));
					
				}
				else if (o instanceof ErrorHandler)
				{
					ErrorHandler err = (ErrorHandler)o;
					//out.println(err.getTarget() + " -> " + err.getFunction() + ";");
					out.println(err.getFunction() + ";\t //" + getStageNumber(err.getFunction()));
				}
				/*
				else if (o instanceof Source)
				{
					Source src = (Source)o;
					out.println(src.getSourceFunction()+";\t // " + getStageNumber(src.getSourceFunction()));
				}
				*/
			}
		}
		
		// print out the paths so that path profiling can occur
		out.println("\n");
		printPaths(out);
		out.println("\n");
		
		EdgeIterator ei = this.graph.edges();
		while (ei.hasNext()) 
		{
			Edge e = ei.nextEdge();
			GraphNode graphNode = (GraphNode)this.graph.origin(e).element();
			if (graphNode.getNodeType() == GraphNode.DEFAULT)
			{
				Object o = graphNode.getElement();
				String start_name;
				//TaskDeclaration end;
				if (o instanceof TaskDeclaration)
					start_name = ((TaskDeclaration)o).getName();
				else
					start_name = ((Source)o).getSourceFunction();
				
				GraphNode gNode = (GraphNode)this.graph.destination(e).element();
				if (gNode.getNodeType() == GraphNode.DEFAULT)
				{
					TaskDeclaration end = (TaskDeclaration)gNode.getElement();
					String label = (String) e.element();
					if (label.equals("[]"))
						label = null;
					out.println(start_name + " -> " + end.getName()+ 
							(label !=null ?"[label=\""+label+"\"]":"")+";");
				}
				else if (gNode.getNodeType() == GraphNode.ERROR_HANDLER)
				{
					ErrorHandler err = (ErrorHandler)gNode.getElement();
					out.println(err.getTarget() + " -> " + err.getFunction() +
							"[style=dotted, label=\"error\"]"+";");
				}
			}
		}
		out.println("}");
	}
	
	
	/**
	 * Recursively generate a graph piece from a FlowStatement
	 * @param fs The statement
	 * @param last A vector of the last vertices (the "frontier")
	 * @param p The program
	 **/
	protected Vector<Vertex> recursiveGenerate (FlowStatement fs, Vector<Vertex> last, Program p) 
	{
		if (fs instanceof SimpleFlowStatement) 
		{
			//System.out.println("***rGen: Simple : "+fs.toString());
			SimpleFlowStatement sfs = (SimpleFlowStatement)fs;
			
			//if (sfs.getAssignee().toString().equals(last.el))
			
			// Go through the list "last" and make sure it doesn't contain any  
			if ((last != null) && (last.size() > 0)) 
			{
				Iterator<Vertex> iter = last.iterator();
				while(iter.hasNext())
				{
					Vertex v = iter.next();
					if (v.element().toString().equals(sfs.getAssignee()))
						iter.remove();
				}
			}
			//System.out.println("\nrecursiveGenerate: \nfrom:\t" + sfs + " \nto:\t" + last + "\n");
			return recursiveGenerate(sfs, last, p);
		}
		else 
		{
			//System.out.println("***rGen: TYPED : "+fs.toString());
			TypedFlowStatement tfs = (TypedFlowStatement)fs;
			return recursiveGenerate(tfs, last, p);
		}
	}
	
	/**
	 * Recursively generate a graph piece from a SimpleFlowStatement
	 * @param sfs The statement
	 * @param last A vector of the last vertices (the "frontier")
	 * @param p The program
	 **/
	protected Vector<Vertex> recursiveGenerate (SimpleFlowStatement sfs, Vector<Vertex> last, Program p)
	{
		Vertex first = (Vertex)vertex_map.get(sfs.getAssignee());
		if (last != null) 
		{
			for ( int i=0; i<last.size(); i++ ) 
			{
				if(!sfs.getAssignee().equals(last.get(i).element().toString()))
				{
					System.out.println("connecting: " + last.get(i).toString() + " to " + first.toString());
					connect( last.get(i), first );
				}
			}
		}
		
		Vector<String> args = sfs.getArguments();
		
		StringBuffer label = new StringBuffer();
		Vector<String> types = sfs.getTypes();
		if (types != null) 
		{
			for (String s : types) 
			{
				if (label.length() > 0)
					label.append(", ");
				label.append(s);
			}
		}
		if (args.size() == 0)
		{
			Vector<Vertex> res = new Vector<Vertex>();
			res.add(first);
			return res;
		}
		String state = sfs.getState();
		if (state != null)
			label.append(" | " + state);
		Vertex next = (Vertex) this.vertex_map.get(args.get(0));
		connect(first, next, label.toString());
		
		Vector<Vertex> lst = new Vector<Vertex>();
		for (int i=0; i<args.size(); i++)
		{
			FlowStatement fs = p.getFlow(args.get(i));
			Vector<Vertex> v;
			// Flow Statement
			lst.clear();
			lst.add(next);
			if (fs!=null) 
			{
				//if(fs.getAssignee().to)
				v = recursiveGenerate(fs, lst, p);
			}
			// Terminal Task
			else 
			{
				v = lst;
			}
			// Connect them
			if (i < (args.size()-1)) 
			{
				next = (Vertex)vertex_map.get(args.get(i+1));
				for (int j=0;j<v.size();j++) 
				{
					connect(v.get(j),next);
				}
			}
		}
		
		lst.clear();
		lst.add(next);
		return lst;
	}
	
	/**
	 * Recursively generate a graph piece from a TypedFlowStatement
	 * @param tfs The statement
	 * @param last A vector of the last vertices (the "frontier")
	 * @param p The program
	 **/
	protected Vector<Vertex> recursiveGenerate (TypedFlowStatement tfs, Vector<Vertex> last, Program p)
	{
		Vector<FlowStatement> stmts = tfs.getFlowStatements();
		Vector<Vertex> result = new Vector<Vertex>();
		Vector<Vertex> ret;
		ret = recursiveGenerate(stmts.get(0), null, p);
		
		for (int i=0; i<ret.size(); i++)
			result.add(ret.get(i));
		
		for (int i=1; i<stmts.size(); i++) 
		{
			ret = recursiveGenerate(stmts.get(i), null, p);
			for (int j=0;j<ret.size();j++)
				result.add(ret.get(j));
		}
		
		return result;
	}
	
	public Collection<ErrorHandler> getErrors()
	{
		return this.errs;
	}
	
	protected void connect(Vertex from, Vertex to) 
	{
		connect(from, to, null);
	}
	
	/**
	 * Connect two vertices if unconnected, or increment the weight of
	 * their edge.  The edge is directed.
	 * @param from The from vertex
	 * @param to The to vertex
	 * @param label The edge label
	 **/
	protected void connect(Vertex from, Vertex to, Object label) 
	{
		if (label == null)
			label = (String)"[]";
		else
			label = (String)("[" + label.toString() + "]");
		
		if (graph.areAdjacent(from, to))
		{
			Edge e = this.graph.connectingEdges(from, to).nextEdge();
			if ( (label != null) && (!e.element().toString().equals(label.toString())) )
			{
				this.graph.insertDirectedEdge(from, to, label);
			}
			//Integer i = (Integer)e.get(_WEIGHT);
			//e.set(_WEIGHT, new Integer(i.intValue()+1));
			//System.out.println("Connecting: " + from.toString() + " with " + to.toString() + " weight: " + (i+1) + "\n\n\n");
		}
		else 
		{
			
			this.graph.insertDirectedEdge(from, to, label);
		}
	}
	
	public Collection<TaskDeclaration> getFunctions() 
	{
		Vector<TaskDeclaration> result = new Vector<TaskDeclaration>();
		
		VertexIterator vi = this.graph.vertices();
		while (vi.hasNext()) 
		{
			Vertex v = vi.nextVertex();
			GraphNode graphNode = (GraphNode)v.element();
			if (graphNode.getNodeType() == GraphNode.DEFAULT)
			{
				if (this.graph.degree(v, EdgeDirection.IN) > 0) 
				{
					Object o = graphNode.getElement();
					if (o instanceof TaskDeclaration)
						result.add((TaskDeclaration)o);
				}
			}
		}
		return result;
	}
	
	
	// The way to determine if a node is a source is if its only input is from ENTRY
	public Collection<Source> getSources() 
	{
		Collection<Source> sources = program.getSources();
		return sources;
	}
	
	public int getErrorNumber(String ErrorName)
	{
		int ret = errorNumber.get(ErrorName);
		return ret;
	}
	
	public TaskDeclaration findTask(String name) 
	{
		VertexIterator vi = this.graph.vertices();
		while (vi.hasNext()) {
			Vertex v = vi.nextVertex();
			GraphNode graphNode = (GraphNode)v.element();
			if (graphNode.getElement() instanceof TaskDeclaration) {
				TaskDeclaration td = (TaskDeclaration)graphNode.getElement();
				if (td.getName().equals(name))
					return td;
			}
		}
		return null;
	}
	
	public static int getStageNumber(String name) 
	{
		Integer stg = stageNumber.get(name);
		if (stg == null) {
			stg = new Integer(totalStages);
			totalStages++;
			stageNumber.put(name, stg);
		}
		return stg.intValue();
	}
	
	public int getWeight (Edge e)
	{
		return (Integer)e.get(_WEIGHT);
	}
	
	public Hashtable<String, Integer> getStageHashtable()
	{
		return stageNumber;
	}
	
	public Vertex getVertexEntry()
	{
		return ENTRY;
	}
	
	public Vertex getVertexExit()
	{
		return EXIT;
	}
	
	public Vertex getVertexError()
	{
		return ERROR; 
	}
	
	/**
	 * Main routine, test it out...
	 **/
	public static void main(String args[])  throws Exception {
		parser p;
		if (args.length > 0) {
			p = new parser(new Yylex(new FileInputStream(args[0])));
			Program pm = (Program)p.parse().value;
			if (pm.verifyExpressions()) {
				pm.unifyExpressions();
			}
			ProgramGraph pg = new ProgramGraph(pm);
			PrintWriter pw = new PrintWriter(System.out);
			int ix = args[0].lastIndexOf(File.separator);
			pg.outputDot(pw, args[0].substring(ix+1));
			pw.flush();
			pw.close();
		}
	}
}
