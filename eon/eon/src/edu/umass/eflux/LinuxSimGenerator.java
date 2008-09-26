package edu.umass.eflux;

import java.io.*;

import java.util.Collection;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Stack;
import java.util.Vector;

import edu.umass.eflux.Argument;
import edu.umass.eflux.ErrorHandler;
import edu.umass.eflux.FlowStatement;
import edu.umass.eflux.GraphNode;
import edu.umass.eflux.VirtualDirectory;
import edu.umass.eflux.Yylex;

import jdsl.graph.ref.IncidenceListGraph;
import jdsl.graph.api.*;

public class LinuxSimGenerator implements CodeGenerator {
	private String M_TYPES_H = "mTypes.h";
	private String M_STRUCTS_H = "mStructs.h";
	private String M_IMPL_H = "mImpl.h";
	//private String M_IMPL_C = "mImpl.c";
	private String M_IMPL_C = "stubs.c";
	private String M_EXEC_C = "mExec.c";
	
	private String M_NODES_H = "mNodes.h";
	private String M_NODES_C = "mNodes.c";
	private String M_MAKEFILE = "Makefile";
	
	
	 
	protected Hashtable<String, Boolean> defined 
	= new Hashtable<String, Boolean>();
	

	private Hashtable<String, Integer> nodeID = new Hashtable<String,Integer>();
	
	
	protected String MyName = "linuxsim";
	
	public String getName()
	{
		return MyName;
	}
	
	public Vector<String> getTargets()
	{
		Vector<String> plats = new Vector<String>();
		
		plats.add("linuxsim");
		
		return plats;
	}
	
	
	public  void generateTimedSourceInit(ProgramGraph g,
			VirtualDirectory out) {
		
		
		
		Vector<Source> sources = g.getProgram().getSources();
		StateOrder order = g.getProgram().getStates();
		Vector<Vector<String>> ordering = order.getOrdering();
		Vector<TimeConstraint> constraints = g.getProgram()
				.getTimeConstraints();

		int s = 0;
		out.getWriter(M_NODES_C).println("// SOURCE_NUMBER_ definitions... to be used with timerVals");
		
		for (Source src : sources)
		{
			out.getWriter(M_NODES_H).println("#define SOURCE_NUMBER_" + src.source_fn.toUpperCase() + "\t" + s++);
		}

		s = 0;
		//System.out.println("generateTSI...");
		
		out.getWriter(M_NODES_C).println("int32_t timerVals[NUMSOURCES][NUMSTATES][2]  ={");
		for (Source src : sources) 
		{
			//System.out.println("Source:" + src);
			out.getWriter(M_NODES_C).print("{");
			
			if (g.isTimedSource(src.getSourceFunction())) 
			{
				// make timeline
				Vector<TimeConstraint> timeline = new Vector<TimeConstraint>();
				int max = -1;
				int min = -1;
				int lvl = 0;
				
				//System.out.println("ordering:" + ordering);
				for (Vector<String> level : ordering) {

					TimeConstraint thecon = null;
					for (TimeConstraint con : constraints) {
						if (src.getSourceFunction().equals(con.getTimer())) {
							String st = con.getState();
							int lnum = order.GetStateLevel(st);
							if (lnum == lvl) {
								thecon = con;
							}
						}
					}
					if (thecon != null) 
					{
						if (max == -1) 
						{
							max = thecon.getLoVal();
						} 
						else 
						{
							if (max > thecon.getLoVal()) 
							{
								//System.out.println("max: " + max + " getLoVal(): " + thecon.getLoVal());
								//System.out.println("WARNING: non-monotonic timer (LO)");
							} 
							else 
							{
								max = thecon.getLoVal();
							}
						}
						if (min == -1) 
						{
							min = thecon.getHiVal();
						} 
						else 
						{
							if (min < thecon.getHiVal()) 
							{
								//System.out.println("min: " + max + " getHiVal(): " + thecon.getHiVal());
								//System.out.println("WARNING: non-monotonic timer (Hi)");
								min = thecon.getHiVal();
							}
						}
					}

					// timeline.add(0,thecon);
					timeline.add(thecon);
					lvl++;
				} // end build timeline
				if (max == -1)
					max = 10000;
				if (min == -1)
					min = 10000;
				// now go through the timeline and fill in missing values
				int i = 0;
				for (TimeConstraint con : timeline) {

					int themin;
					int themax;

					if (con == null) {
						themin = min;
						themax = min;
					} else {
						themin = con.getHiVal();
						themax = con.getLoVal();
					}
					min = themax;
					//System.out.println("writing..." + i + ","	+ (timeline.size() - 1));
					out.getWriter(M_NODES_C).print(
							"{" + themin + "L," + themax + "L}");
					if (i < (timeline.size() - 1)) {
						out.getWriter(M_NODES_C).print(",");
					}
					i++;

				}

			} else {
				int i = 0;
				for (Vector<String> level : ordering) {
					out.getWriter(M_NODES_C).print("{-1,-1}");
					if (i <= (ordering.size() - 1)) {
						out.getWriter(M_NODES_C).print(",");
					}
				}
			}
			out.getWriter(M_NODES_C).print("}");
			if (s < (sources.size() - 1)) {
				out.getWriter(M_NODES_C).print(",");
			}
			s++;
		}
		out.getWriter(M_NODES_C).println("};");

	}
	
	public  Integer getSourceNum(ProgramGraph g, String name) {
		Integer index = 0;

		Vector<Source> sources = g.getProgram().getSources();

		for (Source src : sources) {
			String srcname = src.getSourceFunction();
			if (name.equals(srcname)) {
				return index;
			}
			index++;
		}

		return -1;
 	}
	
	/**
	 * Generate a threaded program
	 * @param root The root directory to output into
	 * @param g The program graph
	 **/
	public void generate(String root, ProgramGraph g, Program pm, boolean stubbs)
	{	
		try 
		{	
			VirtualDirectory out = new VirtualDirectory(root);
			defined.clear();
			getNodeIDs(g);
			generateNodesHeader(g,out, true);
			generateNodesData(g,out, true);
			generateStructs(g,out);
			
			generateExecHandler(g,out);
			
			if (stubbs)
			{
				generateImpl(g,out);
			}
			
			if (stubbs)
			{
				generateTypeChecks(g,out);
			}
			
			generateMakefile(g,out);
			
			out.flushAndClose();
			System.out.println("Cleaning up auto generated code...root = "+root+"...");
			//String cmd = "indent  "+root+"/*.c";
			String cmd = "echo $PWD";
			//Process p = Runtime.getRuntime().exec(cmd);
			String pwd = System.getenv("PWD");
			System.out.println(pwd);
			//String[] CMD = {"/bin/bash", "-c", "'/usr/bin/indent "+pwd+"/"+root+"/*.c'"};
			
			callBash("/usr/bin/indent "+root+"/*.c");
			callBash("/usr/bin/indent "+root+"/*.h");
			callBash("rm "+root+"/*~");
		} //try
		catch (Exception e)
		{
			System.out.println("Generate FAILED! : "+e.toString());
			System.exit(3);
		
		}
	}	
	
	public  int callBash(String s)
	{
		int result = -1;
		System.out.println("BASH("+s+")");
		try {
			String[] CMD = {"/bin/bash", "-c", s};
			ProcessBuilder pb = new ProcessBuilder(CMD);
			pb.redirectErrorStream(true);
			Process p = pb.start();
			int data = 0;
			while (data >= 0)
			{
				data = p.getInputStream().read();
				if (data >= 0)
				{
					char c = (char)data;
					System.out.print(c);
				}
			}
			
			p.waitFor();
			result =  p.exitValue();
		}
		catch (Exception e)
		{
			System.out.println("Exception:"+e.getMessage());
		}
		return result;
			
	}
	
	public  void generateMakefile(ProgramGraph g, VirtualDirectory out)
	{
		out.getWriter(M_MAKEFILE).println("CC = gcc");
		out.getWriter(M_MAKEFILE).println("CCFLAGS = -I./runtime");
		out.getWriter(M_MAKEFILE).println("LIBS = -lnsl -lpthread -lm");
		out.getWriter(M_MAKEFILE).println("");
		out.getWriter(M_MAKEFILE).println("eflux.out: mImpl.c mExec.c mNodes.c runtime_build");
		out.getWriter(M_MAKEFILE).println("\t${CC} ${CCFLAGS} -o $@ mImpl.c mExec.c mNodes.c *.o ${LIBS}");
		out.getWriter(M_MAKEFILE).println("\tsim_submit.py 1 eflux.out");
		out.getWriter(M_MAKEFILE).println("");
		out.getWriter(M_MAKEFILE).println("runtime_build:");
		out.getWriter(M_MAKEFILE).println("\tcd runtime; make; cd ..");
		out.getWriter(M_MAKEFILE).println("\tcp runtime/*.o .");
		
		
		out.getWriter(M_MAKEFILE).println("");
		out.getWriter(M_MAKEFILE).println("clean:");
		out.getWriter(M_MAKEFILE).println("\tcd runtime; make clean; cd ..");
		out.getWriter(M_MAKEFILE).println("\trm *.o");
		out.getWriter(M_MAKEFILE).println("\trm server");
		out.getWriter(M_MAKEFILE).println("");
	
	}
	
	/*public  void generateMarshallers(ProgramGraph g, VirtualDirectory out)
	{
		printHHeader(M_MARSH_H, out.getWriter(M_MARSH_H));
		
		out.getWriter(M_MARSH_H).println("#include \""+M_STRUCTS_H+"\"");
		out.getWriter(M_MARSH_H).println("#include \""+M_NODES_H+"\"");
		
		out.getWriter(M_MARSH_C).println("#include \""+M_MARSH_H+"\"");
		out.getWriter(M_MARSH_C).println("#include \"runtime/rt_marshall.h\"");
		out.getWriter(M_MARSH_C).println("");
		//find entry points
		EdgeIterator eit = g.getGraph().edges();
		while (eit.hasNext())
		{
			Edge e = eit.nextEdge();
			if (isEdgeOutgoing(e,g))
			{
				generateMarshaller(e,g,out);
				
			}
			if (isEdgeIncoming(e,g))
			{
				generateUnmarshaller(e,g,out);
			}
		}
		
		//make incoming handler
		//prototype
		out.getWriter(M_MARSH_H).println("int UnmarshallByID(int cid, uint16_t nodeid);");
		//definition
		out.getWriter(M_MARSH_C).println("int UnmarshallByID(int cid, uint16_t nodeid)");
		out.getWriter(M_MARSH_C).println("{");
		out.getWriter(M_MARSH_C).println("switch (nodeid)");
		out.getWriter(M_MARSH_C).println("{");
		
		eit = g.getGraph().edges();
		while (eit.hasNext())
		{
			Edge e = eit.nextEdge();
			
			if (isEdgeIncoming(e,g))
			{
				Vertex vs = g.getGraph().origin(e);
				Vertex vd = g.getGraph().destination(e);
				GraphNode srcnode = (GraphNode)vs.element();
				GraphNode destnode = (GraphNode)vd.element();
				TaskDeclaration tdsrc = (TaskDeclaration)srcnode.getElement();
				TaskDeclaration tddest = (TaskDeclaration)destnode.getElement();
				
				out.getWriter(M_MARSH_C).print("case "+tddest.getName().toUpperCase()+"_NODEID: ");
				out.getWriter(M_MARSH_C).println("return handle"+tddest.getName()+"Incoming(cid);");
			}
		}
		out.getWriter(M_MARSH_C).println("}//switch");
		out.getWriter(M_MARSH_C).println("return -1;");
		out.getWriter(M_MARSH_C).println("} //UnmarshallByID");
		printHFooter(M_MARSH_H, out.getWriter(M_MARSH_H));
		
	}*/
	
	/*public  void generateMarshaller(Edge e, ProgramGraph g, VirtualDirectory out)
	{
		Vertex vs = g.getGraph().origin(e);
		Vertex vd = g.getGraph().destination(e);
		GraphNode srcnode = (GraphNode)vs.element();
		GraphNode destnode = (GraphNode)vd.element();
		TaskDeclaration tdsrc = (TaskDeclaration)srcnode.getElement();
		TaskDeclaration tddest = (TaskDeclaration)destnode.getElement();
		
		//generate prototype
		out.getWriter(M_MARSH_H).print("int handle"+tddest.getName()+"Outgoing(int cid,");
		out.getWriter(M_MARSH_H).println(tddest.getName()+"_in *in);");
		
		//	generate implementation
		out.getWriter(M_MARSH_C).print("int handle"+tddest.getName()+"Outgoing(int cid,");
		out.getWriter(M_MARSH_C).println(tddest.getName()+"_in *in)");
		out.getWriter(M_MARSH_C).println("{");
		out.getWriter(M_MARSH_C).println("int err = 0; //success ");
		//start marshalling
		out.getWriter(M_MARSH_C).println("err = marshall_start(cid,"+tddest.getName().toUpperCase()+"_NODEID);");
		out.getWriter(M_MARSH_C).println("if (err) return err;");
		
		//marshall session data
		out.getWriter(M_MARSH_C).println("err = marshall_session(cid,in->_pdata);");
		out.getWriter(M_MARSH_C).println("if (err) return err;");
		
		Vector<Argument> ins = tddest.getInputs();
		for (Argument arg : ins)
		{
			//marshall argument
			out.getWriter(M_MARSH_C).println("err = marshall_"+arg.getType()+"(cid,in->"+arg.getName()+");");
			out.getWriter(M_MARSH_C).println("if (err) return err;");
			
		}
		out.getWriter(M_MARSH_C).println("return err;");
		out.getWriter(M_MARSH_C).println("}");
		out.getWriter(M_MARSH_C).println("");
	}*/
	

	/*public  void generateUnmarshaller(Edge e, ProgramGraph g, VirtualDirectory out)
	{
		Vertex vs = g.getGraph().origin(e);
		Vertex vd = g.getGraph().destination(e);
		GraphNode srcnode = (GraphNode)vs.element();
		GraphNode destnode = (GraphNode)vd.element();
		TaskDeclaration tdsrc = (TaskDeclaration)srcnode.getElement();
		TaskDeclaration tddest = (TaskDeclaration)destnode.getElement();
		
		//generate prototype
		out.getWriter(M_MARSH_H).println("int handle"+tddest.getName()+"Incoming(int cid);");
		
		
		//	generate implementation
		out.getWriter(M_MARSH_C).println("int handle"+tddest.getName()+"Incoming(int cid)");
		out.getWriter(M_MARSH_C).println("{");
		out.getWriter(M_MARSH_C).println("int err = 0; //success ");
		out.getWriter(M_MARSH_C).println(tddest.getName()+"_in in;");
		
		//unmarshall session data
		out.getWriter(M_MARSH_C).println("err = unmarshall_session(cid,&in._pdata);");
		out.getWriter(M_MARSH_C).println("if (err) return err;");
		
		Vector<Argument> ins = tddest.getInputs();
		for (Argument arg : ins)
		{
			//marshall argument
			out.getWriter(M_MARSH_C).println("err = unmarshall_"+arg.getType()+"(cid,&in."+arg.getName()+");");
			out.getWriter(M_MARSH_C).println("if (err) return err;");
			
		}
		
		//execute handler
		//for better concurrency, could spawn new thread
		out.getWriter(M_MARSH_C).println(tddest.getName()+"_Handler(cid,&in);");
		
		out.getWriter(M_MARSH_C).println("return 0;");
		out.getWriter(M_MARSH_C).println("}");
		out.getWriter(M_MARSH_C).println("");
	}*/
	
	
	public  void generateNodesHeader(ProgramGraph g,
			VirtualDirectory out, boolean needint) {
		int i;
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();

		printHHeader(M_NODES_H, out.getWriter(M_NODES_H));

		out.getWriter(M_NODES_H).println("#ifdef SIMULATOR");
		//out.getWriter(M_NODES_H).println("#include \"pgm_util.h\"");
		out.getWriter(M_NODES_H).println("#else");
		//out.getWriter(M_NODES_H).println("#include \"runtime/pgm_util.h\"");
		out.getWriter(M_NODES_H).println("#endif");
		
		if (needint) {
			out.getWriter(M_NODES_H).println("#include <stdint.h>");
			out.getWriter(M_NODES_H).println("#define TRUE 1");
			out.getWriter(M_NODES_H).println("#define FALSE 0");
			out.getWriter(M_NODES_H).println("typedef int bool;");
		}

		// generate node ids
		out.getWriter(M_NODES_H).println("enum {");
		out.getWriter(M_NODES_H).println("NO_NODEID = 0xFFFF,");

		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();

			// out.getWriter(M_NODES_H).println("#define
			// "+td.getName().toUpperCase()+"_NODEID
			// "+nodeID.get(td.getName()));
			out.getWriter(M_NODES_H).println(
					td.getName().toUpperCase() + "_NODEID = "
							+ nodeID.get(td.getName()) + ",");

		}
		out.getWriter(M_NODES_H).println("};");
		out.getWriter(M_NODES_H).println("");
		out.getWriter(M_NODES_H).println("#define NUMNODES  " + nodeID.size());

		out.getWriter(M_NODES_H).println("extern uint8_t __node_locks[" + ((nodeID.size() / 8)+1)+"]; //1-bit locks for each node");
		
		// generate state ids
		Vector<String> sts = g.getProgram().getStates().GetAllStates();
		it = sts.iterator();
		int state_count = 0;
		int max_state = 0;
		for (String s : sts) {
			// out.getWriter(M_NODES_H).println("#define
			// STATE_"+s.toUpperCase()+" "+state_count);
			out.getWriter(M_NODES_H).println(
					"#define STATE_" + s.toUpperCase() + " "
							+ g.getProgram().getStates().GetStateLevel(s));
			state_count++;
			if (g.getProgram().getStates().GetStateLevel(s) > max_state)
				max_state = g.getProgram().getStates().GetStateLevel(s);

		}
		// out.getWriter(M_NODES_H).println("#define NUMSTATES "+state_count);
		out.getWriter(M_NODES_H)
				.println("#define NUMSTATES " + (max_state + 1));
		out.getWriter(M_NODES_H).println("");
		
		
		Vector<Vector<Vertex>> paths = g.getPaths();
		out.getWriter(M_NODES_H).println("#define NUMPATHS " + paths.size());
		out.getWriter(M_NODES_H).println("extern uint8_t curstate;");
		out.getWriter(M_NODES_H).println("extern double curgrade;");
		out.getWriter(M_NODES_H).print("extern uint8_t minPathState[NUMPATHS];");
		
		
		
		// ***********
		out.getWriter(M_NODES_H).print("extern uint8_t isPathTimed[NUMPATHS];");
		Vector<Integer> timedPaths = new Vector<Integer>();
		
		// ***********
		out.getWriter(M_NODES_H).print("extern uint8_t pathSrc[NUMPATHS];");
		// Vector<Integer> timedPaths = new Vector<Integer>();
		
		int maxidx = 0;
		for (i = 0; i < paths.size(); i++) {
			Vector<Vertex> path = paths.get(i);

			Vertex v = path.get(1);
			GraphNode node = (GraphNode) v.element();
			TaskDeclaration td = (TaskDeclaration) node.getElement();

			Integer idx = getSourceNum(g, td.getName());
			if (idx > maxidx)
				maxidx = idx;

			//out.getWriter(M_NODES_C).print(idx);
			//if (i < (paths.size() - 1))
			//	out.getWriter(M_NODES_C).print(",");
		}
		
		//Vector<Integer> timedPaths = new Vector<Integer>();
		for (i = 0; i < paths.size(); i++) {
			Vector<Vertex> path = paths.get(i);

			Vertex v = path.get(1);
			GraphNode node = (GraphNode) v.element();
			TaskDeclaration td = (TaskDeclaration) node.getElement();
			
			if (g.isTimedSource(td.getName())) {
				timedPaths.add(i);
			}
		
		}
		
		
		out.getWriter(M_NODES_H).println("#define NUMSOURCES " + (maxidx + 1));
		out.getWriter(M_NODES_H).println(
				"#define NUMTIMEDPATHS " + timedPaths.size());
		out.getWriter(M_NODES_H).println("extern uint8_t timedPaths[NUMTIMEDPATHS];");
		
		
		//generateTimedSourceInit(g, out);
		
		
		out.getWriter(M_NODES_H).println("extern int32_t timerVals[NUMSOURCES][NUMSTATES][2];");
		
		out.getWriter(M_NODES_H).print("extern uint8_t srcNodes[NUMSOURCES][2];");
		
		
		printHFooter(M_NODES_H, out.getWriter(M_NODES_H));

	}
	
	
	public  void generateNodesData(ProgramGraph g,
			VirtualDirectory out, boolean needint) {
		int i;
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();

		out.getWriter(M_NODES_C).println("#include \"mNodes.h\"");
		
		
		
		out.getWriter(M_NODES_C).println("uint8_t __node_locks[" + ((nodeID.size() / 8)+1)+"]; //1-bit locks for each node");
		
		// generate state ids
		Vector<String> sts = g.getProgram().getStates().GetAllStates();
		
		Vector<Vector<Vertex>> paths = g.getPaths();
		out.getWriter(M_NODES_C).println("uint8_t curstate = STATE_BASE;");
		out.getWriter(M_NODES_C).println("double curgrade = 0.0;");
		out.getWriter(M_NODES_C).print("uint8_t minPathState[NUMPATHS] ={");
		for (i = 0; i < paths.size(); i++) {
			Vector<Vertex> path = paths.get(i);

			String state = getMinPathState(g, path, path.size());

			out.getWriter(M_NODES_C).print("STATE_" + state.toUpperCase());
			if (i < (paths.size() - 1))
				out.getWriter(M_NODES_C).print(",");
		}
		out.getWriter(M_NODES_C).println("};");

		
		
		// ***********
		out.getWriter(M_NODES_C).print("uint8_t isPathTimed[NUMPATHS] ={");
		Vector<Integer> timedPaths = new Vector<Integer>();
		for (i = 0; i < paths.size(); i++) {
			Vector<Vertex> path = paths.get(i);

			Vertex v = path.get(1);
			GraphNode node = (GraphNode) v.element();
			TaskDeclaration td = (TaskDeclaration) node.getElement();

			if (g.isTimedSource(td.getName())) {
				timedPaths.add(i);
				out.getWriter(M_NODES_C).print("TRUE");
			} else {
				out.getWriter(M_NODES_C).print("FALSE");
			}
			if (i < (paths.size() - 1))
				out.getWriter(M_NODES_C).print(",");
		}
		out.getWriter(M_NODES_C).println("};");

		// ***********
		out.getWriter(M_NODES_C).print("uint8_t pathSrc[NUMPATHS] ={");
		// Vector<Integer> timedPaths = new Vector<Integer>();
		int maxidx = 0;
		for (i = 0; i < paths.size(); i++) {
			Vector<Vertex> path = paths.get(i);

			Vertex v = path.get(1);
			GraphNode node = (GraphNode) v.element();
			TaskDeclaration td = (TaskDeclaration) node.getElement();

			Integer idx = getSourceNum(g, td.getName());
			if (idx > maxidx)
				maxidx = idx;

			out.getWriter(M_NODES_C).print(idx);
			if (i < (paths.size() - 1))
				out.getWriter(M_NODES_C).print(",");
		}
		out.getWriter(M_NODES_C).println("};");
		out.getWriter(M_NODES_C).println("uint8_t timedPaths[NUMTIMEDPATHS] ={");
		i = 0;
		for (Integer pathidx : timedPaths) {
			out.getWriter(M_NODES_C).print(pathidx.toString());
			if (i < (timedPaths.size() - 1)) {
				out.getWriter(M_NODES_C).print(",");
			}
		}
		out.getWriter(M_NODES_C).println("};");

		
		generateTimedSourceInit(g, out);
		
		
		//out.getWriter(M_NODES_C).println("int32_t get_timer_interval(uint32_t src_num, uint32_t st_num, bool min){");
		//out.getWriter(M_NODES_C).println("int max;");
		//out.getWriter(M_NODES_C).println("max = (min+1)%2;");
		//out.getWriter(M_NODES_C).println("return timerVals[src_num][st_num][max];");
		//out.getWriter(M_NODES_C).println("}");
				
		out.getWriter(M_NODES_C).print("uint8_t srcNodes[NUMSOURCES][2] ={");
		Vector<Source> srcs = g.getProgram().getSources();
		i = 0;
		for (Source s : srcs) {
			out.getWriter(M_NODES_C).print("{");
			if (g.isTimedSource(s.getSourceFunction())) {
				out.getWriter(M_NODES_C).print("TRUE,");
			} else {
				out.getWriter(M_NODES_C).print("FALSE,");
			}
			out.getWriter(M_NODES_C).print(nodeID.get(s.getSourceFunction()));
			out.getWriter(M_NODES_C).print("}");
			if (i < (srcs.size() - 1)) {
				out.getWriter(M_NODES_C).print(",");
			}
			i++;
		}
		out.getWriter(M_NODES_C).println("};");
	
		out.getWriter(M_NODES_C).println("");
	}
	
	
	public  void generateExecHandler(ProgramGraph g, VirtualDirectory out)
	{
		
		out.getWriter(M_EXEC_C).println("#include \""+M_STRUCTS_H+"\"");
		out.getWriter(M_EXEC_C).println("#include \""+M_IMPL_H+"\"");
		out.getWriter(M_EXEC_C).println("#include \""+M_TYPES_H+"\"");
		//out.getWriter(M_EXEC_C).println("#include \""+M_MARSH_H+"\"");
		out.getWriter(M_EXEC_C).println("#include \""+M_NODES_H+"\"");
		out.getWriter(M_EXEC_C).println("#include <string.h>");
		out.getWriter(M_EXEC_C).println("#include <pthread.h>");
		out.getWriter(M_EXEC_C).println("#include \"runtime/rt_handler.h\"");
		out.getWriter(M_EXEC_C).println("");
		out.getWriter(M_EXEC_C).println("int theglobalfd;");
		
		//find local sources
		Vector<Source> srcs = g.program.getSources();
		Collection<TaskDeclaration> fncs = g.program.getFunctions();
		
		for (TaskDeclaration t : fncs)
		{
			if (g.program.isSource(t) && t.getPlatformName().equals(MyName))
			{
				//got a local source
				generateSrcCall(t,g,out);
				generateSrcWrapper(t,g,out);
			}
		}
		
		out.getWriter(M_EXEC_C).println("");
		out.getWriter(M_EXEC_C).println("int start_sources(int fd)");
		out.getWriter(M_EXEC_C).println("{");
		out.getWriter(M_EXEC_C).println("int error;");
		out.getWriter(M_EXEC_C).println("pthread_t tid;");
		out.getWriter(M_EXEC_C).println("theglobalfd = fd;");
		for (TaskDeclaration t : fncs)
		{
			if (g.program.isSource(t) && t.getPlatformName().equals(MyName))
			{
				
				out.getWriter(M_EXEC_C).print("error = sim_pthread_create(&tid, ");
				out.getWriter(M_EXEC_C).println("NULL, "+t.getName()+"_wrapper, NULL);");
				out.getWriter(M_EXEC_C).println("if (error) {");
				out.getWriter(M_EXEC_C).println("printf(\"Error starting source "+t.getName()+"\");");
				out.getWriter(M_EXEC_C).println("return error;");
				out.getWriter(M_EXEC_C).println("}");
			
			}
		}
		out.getWriter(M_EXEC_C).println("}");
		//find entry points
		EdgeIterator eit = g.getGraph().edges();
		while (eit.hasNext())
		{
			Edge e = eit.nextEdge();
			if (isEdgeIncoming(e,g))
			{
				generateFlowCall(e,g,out);
				
			}
		}
		
	}
	
	public  void generateSrcWrapper(TaskDeclaration t, ProgramGraph g, VirtualDirectory out)
	{
		
		out.getWriter(M_EXEC_C).println("void *"+t.getName()+"_wrapper(void *arg)");
		out.getWriter(M_EXEC_C).println("{");
		out.getWriter(M_EXEC_C).println("int err = 0;");
		out.getWriter(M_EXEC_C).println("");
		out.getWriter(M_EXEC_C).print("while (TRUE)");
		out.getWriter(M_EXEC_C).println("{");
		out.getWriter(M_EXEC_C).println("\t"+t.getName()+"_Handler();");
		out.getWriter(M_EXEC_C).println("\tsim_sleep(1);");
		out.getWriter(M_EXEC_C).println("}");
		out.getWriter(M_EXEC_C).println("}\n");
		
	}
	
	public  void generateSrcCall(TaskDeclaration t, ProgramGraph g, VirtualDirectory out)
	{
		
		out.getWriter(M_EXEC_C).println("void "+t.getName()+"_Handler()");
		out.getWriter(M_EXEC_C).println("{");
		out.getWriter(M_EXEC_C).println("int err = 0;");
		out.getWriter(M_EXEC_C).println("");
		out.getWriter(M_EXEC_C).print(t.getName()+"_out "+t.getName() + "_out_var;");
		out.getWriter(M_EXEC_C).println("");
		out.getWriter(M_EXEC_C).println("memset(&"+t.getName()+"_out_var._pdata, 0, sizeof(rt_data));");
		
		//get initial weight
		out.getWriter(M_EXEC_C).print(t.getName() + "_out_var._pdata.weight = ");
		out.getWriter(M_EXEC_C).println(g.getEdgeWeight(g.getVertexEntry(),g.getVertex(t.getName()),"[]")+";");
		out.getWriter(M_EXEC_C).print(t.getName() + "_out_var._pdata.sessionID = getNextSession();");
		out.getWriter(M_EXEC_C).println("");
		
		
		//run the program
		out.getWriter(M_EXEC_C).println("");
		out.getWriter(M_EXEC_C).print("err = "+t.getName()+"(&"+t.getName()+"_out_var);");
		out.getWriter(M_EXEC_C).println("if (err) {return;}");
		
		
		//report pathstart
		out.getWriter(M_EXEC_C).println("start_path("+t.getName() + "_out_var._pdata.sessionID);");
		
		//out.getWriter(M_EXEC_C).println("sendPathStartPacket("+t.getName()+"_out_var._pdata.sessionID);");
		Vertex vs = g.getVertex(t.getName());
		EdgeIterator eit = g.getGraph().incidentEdges(vs, EdgeDirection.OUT);
		boolean found = false;
		while (eit.hasNext() && !found)
		{
			Edge ne = eit.nextEdge();
			Vertex newdest = g.getGraph().destination(ne);
			GraphNode newnode = (GraphNode)newdest.element();
							
			if (newnode.getNodeType() == GraphNode.DEFAULT)
			{
				found = true;
				//normal node
				generateNodeRecursive(ne, g, out, false);
			} 
			else if (newnode.getNodeType() == GraphNode.EXIT)
			{
				found = true;
				//end node
				generateEndNode(ne,g,out);
			}
		}
		
		out.getWriter(M_EXEC_C).println("}");
		out.getWriter(M_EXEC_C).println("\n");
	
	}
	
	public  void generateFlowCall(Edge e, ProgramGraph g, VirtualDirectory out)
	{
		Vertex v = g.getGraph().destination(e);
		GraphNode node = (GraphNode)v.element();
		TaskDeclaration td = (TaskDeclaration)node.getElement();
		
		out.getWriter(M_EXEC_C).println("void "+td.getName()+"_Handler(int cid, "+td.getName()+"_in *in)");
		out.getWriter(M_EXEC_C).println("{");
		out.getWriter(M_EXEC_C).println("int err = 0;");
		generateNodeRecursive(e,g,out,true);
		out.getWriter(M_EXEC_C).println("}");
		out.getWriter(M_EXEC_C).println("\n");
	}
	
	public  void generateNodeRecursive(Edge e, ProgramGraph g, VirtualDirectory out, boolean first)
	{
		Vertex vs = g.getGraph().origin(e);
		Vertex vd = g.getGraph().destination(e);
		GraphNode srcnode = (GraphNode)vs.element();
		GraphNode destnode = (GraphNode)vd.element();
		TaskDeclaration tdsrc = (TaskDeclaration)srcnode.getElement();
		TaskDeclaration tddest = (TaskDeclaration)destnode.getElement();
		
		if (isEdgeOutgoing(e,g))
		{
			generateOutgoingNodeRecursive(e,g,out, first);
			return;
		}
		if (isNodeAbstract(g,tddest.getName()))
		{
			generateAbstractNodeRecursive(e,g,out,first);
			return;
		} else {
			out.getWriter(M_EXEC_C).println(tddest.getName()+"_in "+tddest.getName()+"_in_var;");
			out.getWriter(M_EXEC_C).println(tddest.getName()+"_out "+tddest.getName()+"_out_var;");
			if (first)
			{
				//copy session data
				out.getWriter(M_EXEC_C).print("memcpy(&"+tddest.getName()+"_in_var._pdata,");
				out.getWriter(M_EXEC_C).print("&in->_pdata,");
				out.getWriter(M_EXEC_C).println("sizeof(rt_data));");
				Vector<Argument> inputs = tddest.getInputs();
				for (Argument arg : inputs)
				{
					out.getWriter(M_EXEC_C).print(tddest.getName()+"_in_var."+arg.getName()+" = ");
					out.getWriter(M_EXEC_C).println("in->"+arg.getName()+";");
				}
			} else {				
				//copy session data
				out.getWriter(M_EXEC_C).print("memcpy(&"+tddest.getName()+"_in_var._pdata,");
				out.getWriter(M_EXEC_C).print("&"+tdsrc.getName()+"_out_var._pdata,");
				out.getWriter(M_EXEC_C).println("sizeof(rt_data));");
				
				// add weight to path
				out.getWriter(M_EXEC_C).println("//!!!!!!!!!!!!!!!!!!!1here!!!!!!!!!!!!111eleven");
				out.getWriter(M_EXEC_C).print(tddest.getName() + "_in_var._pdata.weight += ");
				
				
				out.getWriter(M_EXEC_C).println(g.getEdgeWeight(tdsrc.getName(),tddest.getName())+";");
				Vector<Argument> inputs = tddest.getInputs();
				for (Argument arg : inputs)
				{
					out.getWriter(M_EXEC_C).print(tddest.getName()+"_in_var."+arg.getName()+" = ");
					out.getWriter(M_EXEC_C).println(tdsrc.getName()+"_out_var."+arg.getName()+";");
				}
			}
			out.getWriter(M_EXEC_C).print("err = "+tddest.getName()+"(&"+tddest.getName()+"_in_var,");
			out.getWriter(M_EXEC_C).println(" &"+tddest.getName()+"_out_var);");
			out.getWriter(M_EXEC_C).print("memcpy(&"+tddest.getName()+"_out_var._pdata,");
			out.getWriter(M_EXEC_C).print("&"+tddest.getName()+"_in_var._pdata,");
			out.getWriter(M_EXEC_C).println("sizeof(rt_data));");
			
			//error handling
			out.getWriter(M_EXEC_C).println("if (err) {");
			out.getWriter(M_EXEC_C).println("//error handling");
//			get error handler
			ErrorHandler eh = getErrorHandler(tddest.getName(), g);
			//add error weight
			out.getWriter(M_EXEC_C).print(tddest.getName() + "_out_var._pdata.weight += ");
			out.getWriter(M_EXEC_C).println(getErrorWeight(vd,g) +";");
			
			
			if (eh != null)
			{
				out.getWriter(M_EXEC_C).println(eh.getFunction()+"(&"+tddest.getName()+"_in_var,err);");
			}
			out.getWriter(M_EXEC_C).print("reportError("+tddest.getName().toUpperCase()+"_NODEID,err,");
			out.getWriter(M_EXEC_C).println(tddest.getName()+"_out_var._pdata);");
			out.getWriter(M_EXEC_C).println("return;");
			out.getWriter(M_EXEC_C).println("}");
			
			EdgeIterator eit = g.getGraph().incidentEdges(vd, EdgeDirection.OUT);
			boolean found = false;
			while (eit.hasNext() && !found)
			{
				Edge ne = eit.nextEdge();
				Vertex newdest = g.getGraph().destination(ne);
				GraphNode newnode = (GraphNode)newdest.element();
								
				if (newnode.getNodeType() == GraphNode.DEFAULT)
				{
					found = true;
					//normal node
					generateNodeRecursive(ne, g, out, false);
				} 
				else if (newnode.getNodeType() == GraphNode.EXIT)
				{
					found = true;
					//end node
					generateEndNode(ne,g,out);
				}
			}
		}
	}
	
	
	public  void generateAbstractNodeRecursive(Edge e, ProgramGraph g, VirtualDirectory out, boolean first)
	{
		Vertex vs = g.getGraph().origin(e);
		Vertex vd = g.getGraph().destination(e);
		GraphNode srcnode = (GraphNode)vs.element();
		GraphNode destnode = (GraphNode)vd.element();
		TaskDeclaration tdsrc = (TaskDeclaration)srcnode.getElement();
		TaskDeclaration tddest = (TaskDeclaration)destnode.getElement();
		
		out.getWriter(M_EXEC_C).println(tddest.getName()+"_in "+tddest.getName()+"_out_var;");
		//out.getWriter(M_EXEC_C).println(tddest.getName()+"_in "+tddest.getName()+"_out_var;");
		if (first)
		{
			//copy session data
			out.getWriter(M_EXEC_C).print("memcpy(&"+tddest.getName()+"_out_var._pdata,");
			out.getWriter(M_EXEC_C).print("&in->_pdata,");
			out.getWriter(M_EXEC_C).println("sizeof(rt_data));");
			Vector<Argument> inputs = tddest.getInputs();
			for (Argument arg : inputs)
			{
				out.getWriter(M_EXEC_C).print(tddest.getName()+"_out_var."+arg.getName()+" = ");
				out.getWriter(M_EXEC_C).println("in->"+arg.getName()+";");
			}
		} else {				
			//copy session data
			out.getWriter(M_EXEC_C).print("memcpy(&"+tddest.getName()+"_out_var._pdata,");
			out.getWriter(M_EXEC_C).print("&"+tdsrc.getName()+"_out_var._pdata,");
			out.getWriter(M_EXEC_C).println("sizeof(rt_data));");
//			add weight to path
			out.getWriter(M_EXEC_C).print(tddest.getName() + "_out_var._pdata.weight += ");
			out.getWriter(M_EXEC_C).println(g.getEdgeWeight(tdsrc.getName(),tddest.getName())+";");
			Vector<Argument> inputs = tddest.getInputs();
			for (Argument arg : inputs)
			{
				out.getWriter(M_EXEC_C).print(tddest.getName()+"_out_var."+arg.getName()+" = ");
				out.getWriter(M_EXEC_C).println(tdsrc.getName()+"_out_var."+arg.getName()+";");
			}
		} //end if
		
		Vector<Argument> inputs = tddest.getInputs();
		FlowStatement flow = g.getProgram().getFlow(tddest.getName());
		Vector<SimpleFlowStatement> paths = getFlowList(flow);
		int flowcount = 0;
		
		for (SimpleFlowStatement sfs : paths)
		{
			Vector<String> types = sfs.getTypes();
			Vector<String> args = sfs.getArguments();
			String state = getProperState(sfs.getState());
			String target = args.get(0);
			
			//check to make sure the state is valid
			Vector<String> sts =g.getProgram().getStates().GetAllStates();
			boolean found = false;
			for (String s : sts) 
			{
				if (s.equals(state))
				{
					found = true;
				}
			}
			if (!found)
			{
				
				System.out.println("ERROR!! Energy state "+state+" is used but not declared!");
				System.exit(1);
			}
		
			
			if (types == null )
			{
				//System.out.println("getting args for "+td.getName()+":"+sfs);
				out.getWriter(M_EXEC_C).println("if (isFunctionalState(STATE_"+state.toUpperCase()+"))");
									
			} else {
				if (types.size() != inputs.size())
				{
					System.out.println("Task("+tddest+"): inputs and types of different arrity.");
					System.out.println("Fix it.  Bad things will probably happen if you don't.");
				}
				if (flowcount > 0)
				{
					out.getWriter(M_EXEC_C).print("else ");
				}
				out.getWriter(M_EXEC_C).print("if (");
				int count = 0;
				for (String s : types)
				{
					if (s.equals("*"))
					{
						out.getWriter(M_EXEC_C).print("TRUE");
					} else {
						Argument arg = inputs.get(count);
						out.getWriter(M_EXEC_C).print(g.getProgram().getType(s).getFunction()+"(");
						out.getWriter(M_EXEC_C).print(tddest.getName()+"_out_var.");
						out.getWriter(M_EXEC_C).print(arg.getName()+")");
					}
					out.getWriter(M_EXEC_C).print(" && ");
					count++;
				}
				if( state.equals("*"))
					out.getWriter(M_EXEC_C).println("TRUE)");
				else
					out.getWriter(M_EXEC_C).println("isFunctionalState(STATE_"+state.toUpperCase()+"))");
				
			}//else
			out.getWriter(M_EXEC_C).println("{");
			Edge ne = g.getGraph().aConnectingEdge(vd,g.getVertex(target));
			generateNodeRecursive(ne, g, out, false);
			out.getWriter(M_EXEC_C).println("}");
			flowcount++;
		}//for
		out.getWriter(M_EXEC_C).println("else");
		out.getWriter(M_EXEC_C).println("{");
		out.getWriter(M_EXEC_C).println("//Big problem.  No mapped edge.");
		//		add error weight
		out.getWriter(M_EXEC_C).print(tddest.getName() + "_out_var._pdata.weight += ");
		out.getWriter(M_EXEC_C).println(getErrorWeight(vd,g) +";");
		out.getWriter(M_EXEC_C).print("reportError("+tddest.getName().toUpperCase()+"_NODEID,err,");
		out.getWriter(M_EXEC_C).println(tddest.getName()+"_out_var._pdata);");
		out.getWriter(M_EXEC_C).println("return;");
		out.getWriter(M_EXEC_C).println("}");
	}
	
	public  String getProperState(String state)
	{
		if (state == null)
		{
			return "BASE";			
		}
		return state;
	}
	
	public  int getErrorWeight(Vertex v, ProgramGraph g)
	{
		EdgeIterator eit = g.getGraph().incidentEdges(v, EdgeDirection.OUT);
		while (eit.hasNext())
		{
			Edge e = eit.nextEdge();
			Vertex vd = g.getGraph().destination(e);
			GraphNode gnode = (GraphNode)vd.element();
							
			if (gnode.getNodeType() == GraphNode.ERROR_HANDLER)
			{
				ErrorHandler eh = (ErrorHandler)gnode.getElement();
				
				return g.getEdgeWeight(eh.getTarget(), eh.getFunction());
			} 
			if (gnode.getNodeType() == GraphNode.ERROR)
			{
				return g.getEdgeWeight(v, g.getVertexError(), null);
			} 
			
		}
		return -1;
	}
	
	
	public  ErrorHandler getErrorHandler(String s, ProgramGraph g)
	{
		return getErrorHandler(g.getVertex(s), g);
	}
	
	public  ErrorHandler getErrorHandler(Vertex v, ProgramGraph g)
	{
		EdgeIterator eit = g.getGraph().incidentEdges(v, EdgeDirection.OUT);
		while (eit.hasNext())
		{
			Edge e = eit.nextEdge();
			Vertex vd = g.getGraph().destination(e);
			GraphNode gnode = (GraphNode)vd.element();
							
			if (gnode.getNodeType() == GraphNode.ERROR_HANDLER)
			{
				ErrorHandler eh = (ErrorHandler)gnode.getElement();
				return eh;
			} 
		}
		return null;
	}
	
	public  void generateEndNode(Edge e, ProgramGraph g, VirtualDirectory out)
	{
		Vertex vs = g.getGraph().origin(e);
		GraphNode srcnode = (GraphNode)vs.element();
		TaskDeclaration tdsrc = (TaskDeclaration)srcnode.getElement();
		
		
		out.getWriter(M_EXEC_C).println("//end of path.");
		out.getWriter(M_EXEC_C).print("reportExit(");
		out.getWriter(M_EXEC_C).println(tdsrc.getName()+"_out_var._pdata);");
		out.getWriter(M_EXEC_C).println("return;");
	}
	
	public  void generateOutgoingNodeRecursive(Edge e, ProgramGraph g, VirtualDirectory out, boolean first)
	{
		out.getWriter(M_EXEC_C).println("//Outgoing node.");
		Vertex vs = g.getGraph().origin(e);
		Vertex vd = g.getGraph().destination(e);
		GraphNode srcnode = (GraphNode)vs.element();
		GraphNode destnode = (GraphNode)vd.element();
		TaskDeclaration tdsrc = (TaskDeclaration)srcnode.getElement();
		TaskDeclaration tddest = (TaskDeclaration)destnode.getElement();
		
		
		
		out.getWriter(M_EXEC_C).println(tddest.getName()+"_in "+tddest.getName()+"_in_var;");
		out.getWriter(M_EXEC_C).println(tddest.getName()+"_out "+tddest.getName()+"_out_var;");
		if (first)
		{
			//copy session data
			out.getWriter(M_EXEC_C).print("memcpy(&"+tddest.getName()+"_in_var._pdata,");
			out.getWriter(M_EXEC_C).print("&in->_pdata,");
			out.getWriter(M_EXEC_C).println("sizeof(rt_data));");
			Vector<Argument> inputs = tddest.getInputs();
			for (Argument arg : inputs)
			{
				out.getWriter(M_EXEC_C).print(tddest.getName()+"_in_var."+arg.getName()+" = ");
				out.getWriter(M_EXEC_C).println("in->"+arg.getName()+";");
			}
		} else {				
			//copy session data
			out.getWriter(M_EXEC_C).print("memcpy(&"+tddest.getName()+"_in_var._pdata,");
			out.getWriter(M_EXEC_C).print("&"+tdsrc.getName()+"_out_var._pdata,");
			out.getWriter(M_EXEC_C).println("sizeof(rt_data));");
			//				add weight to path
			out.getWriter(M_EXEC_C).print(tddest.getName() + "_in_var._pdata.weight += ");
			//out.getWriter(M_EXEC_C).println("!!!!!!!!!!!!!!!!!!!!1here!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			out.getWriter(M_EXEC_C).println(g.getEdgeWeight(tdsrc.getName(),tddest.getName())+";");
			Vector<Argument> inputs = tddest.getInputs();
			for (Argument arg : inputs)
			{
				out.getWriter(M_EXEC_C).print(tddest.getName()+"_in_var."+arg.getName()+" = ");
				out.getWriter(M_EXEC_C).println(tdsrc.getName()+"_out_var."+arg.getName()+";");
			}
		}
		out.getWriter(M_EXEC_C).print("handle"+tddest.getName()+"Outgoing(cid, ");
		out.getWriter(M_EXEC_C).println("&"+tddest.getName()+"_in_var);");
		//out.getWriter(M_EXEC_C).print("err = "+tddest.getName()+"(&"+tddest.getName()+"_in_var,");
		//out.getWriter(M_EXEC_C).println(" &"+tddest.getName()+"_out_var);");
		out.getWriter(M_EXEC_C).println("return;");
		
		
	}

	public  void generateImpl(ProgramGraph g, VirtualDirectory out)
	{
		printHHeader(M_IMPL_H, out.getWriter(M_IMPL_H));	
		
		out.getWriter(M_IMPL_H).println("#include \""+M_NODES_H+"\"");
		out.getWriter(M_IMPL_H).println("#include \"runtime/rt_structs.h\"");
		out.getWriter(M_IMPL_H).println("#include \""+M_STRUCTS_H+"\"");
		out.getWriter(M_IMPL_H).println("void init(int argc, char **argv);");
		
		out.getWriter(M_IMPL_C).println("#include \""+M_IMPL_H+"\"");
		out.getWriter(M_IMPL_C).println("");
		out.getWriter(M_IMPL_C).println("int sample_global_var;");
		out.getWriter(M_IMPL_C).println("");
		out.getWriter(M_IMPL_C).println("");
		out.getWriter(M_IMPL_C).println("");
		out.getWriter(M_IMPL_C).println("void init(int argc, char **argv) {");
		out.getWriter(M_IMPL_C).println("sample_global_var = 0;\n}");
		out.getWriter(M_IMPL_C).println("");
		
		Collection<TaskDeclaration> fns = g.getFunctions();
		
		for (TaskDeclaration td : fns)
		{
			if (td.getPlatformName().equals(MyName))
			{
				if (!isNodeAbstract(g, td.getName()))
				{
					if (g.isTimedSource(td.getName()))
					{
						printTimedSrcSignature(td,g,out);
					} else {
						printSignature(td,g,out);
						printErrorHandler(td,g,out);
					}
				}
			}
			
		}
		
		
		
		printHFooter(M_IMPL_H, out.getWriter(M_IMPL_H));
	}
	
	public  boolean isNodeAbstract(ProgramGraph g, String name)
	{
		FlowStatement flow = g.getProgram().getFlow(name);
		if (flow == null)
			return false;
		return true;
	
	}

	
	public  Vector<SimpleFlowStatement> getFlowList(FlowStatement flow)
	{
		Vector<SimpleFlowStatement> result = new Vector<SimpleFlowStatement>();
		if (flow instanceof SimpleFlowStatement)
		{
			result.add((SimpleFlowStatement)flow);
			return result;
		}
		if (flow instanceof TypedFlowStatement)
		{
			Vector<FlowStatement> stmts = ((TypedFlowStatement)flow).getFlowStatements(); 
			for (FlowStatement fs : stmts)
			{
				Vector<SimpleFlowStatement> subresult = getFlowList(fs);
				result.addAll(subresult);
			}
			return result;
		}
		
		System.out.println("ERROR! We only support Simple and Typed Flow Statements.");
		return null;
	}
	
	
	public  boolean isEdgeOutgoing(Edge e, ProgramGraph g)
	{
		if (isEdgeLocal(e,g))
		{
			return false;
		}
		return (!isEdgeIncoming(e,g));
	}
	
	public  boolean isEdgeIncoming(Edge e, ProgramGraph g)
	{
		if (isEdgeLocal(e,g))
		{
			return false;
		}
		try {
			Vertex s,d;
			GraphNode src, dest;
			TaskDeclaration std, dtd;
			s = g.getGraph().origin(e);
			d = g.getGraph().destination(e);
			src = (GraphNode)s.element();
			dest = (GraphNode)d.element();
			std = (TaskDeclaration)src.getElement();
			dtd = (TaskDeclaration)dest.getElement();
			if (dtd.getPlatformName().equals(MyName) &&
					!std.getPlatformName().equals(MyName))
			{
				return true;
			}	
			return false;
		}
		catch(Exception ex)
		{
			return false;
		}
	}
	
	public  boolean isEdgeLocal(Edge e, ProgramGraph g)
	{
		return isEdgeLocal(g.getGraph().origin(e), g.getGraph().destination(e), g);		
	}
	
	public  boolean isEdgeLocal(Vertex a, Vertex b, ProgramGraph g)
	{
		boolean adj = false;
		EdgeIterator edgeIterator = g.getGraph().incidentEdges(a, EdgeDirection.OUT);
		while (edgeIterator.hasNext())
		{
			Edge edge = edgeIterator.nextEdge();
			Vertex currDestination = g.getGraph().destination(edge);
			if (currDestination == b)
				adj = true;
		}
		if (!adj)
		{
			System.out.println(a.element().toString() + " is not connected to: " + b.element().toString());
			System.exit(1);
		}
	
		GraphNode anode,bnode;
		anode = (GraphNode)a.element();
		bnode = (GraphNode)b.element();
		
		if (anode.getElement() instanceof TaskDeclaration && 
				bnode.getElement() instanceof TaskDeclaration)
		{
			TaskDeclaration atd,btd;
			atd = (TaskDeclaration)anode.getElement();
			btd = (TaskDeclaration)bnode.getElement();
			if (!atd.getPlatformName().equals(btd.getPlatformName()))
			{
				return false;
			}
		}
		
		return true;
	}
	
	/**
     * Print the matching error handlers
     * @param current The current task
     * @param p The program
     * @param out The directory to write to
     **/
    protected  void printErrorHandler(TaskDeclaration current,
					    ProgramGraph g, VirtualDirectory out) 
    {
    	Program p = g.getProgram();
    	int matches = 0;
    	int pathWeight = 0;
    	Vector<ErrorHandler> errs = p.getErrorHandlers();
    	for (ErrorHandler err : errs) 
    	{
		    if (err.matches(current.getName())) 
		    {
		    	pathWeight = g.getEdgeWeight(current.getName(), err.getFunction());
		    	
		    	if (defined.get(current.getName())==null) 
		    	{
		    		out.getWriter(M_IMPL_C).println("// IN:\t" + current.getInputs().toString());
		    		out.getWriter(M_IMPL_H).println("void "+err.getFunction() + "("+current.getName()+"_in *in, int err);");
                    out.getWriter(M_IMPL_C).println("void "+err.getFunction()+"("+current.getName()+"_in *in, int err) {");
				    out.getWriter(M_IMPL_C).println("\n}");
				    defined.put(current.getName(), Boolean.TRUE);
		    	}
		    	matches++;
		    }
    	}
    	
    	//return pathWeight;
    }

	
	/**
     * Print a function signature and stub for a task
     * @param td The task
     * @param virt The virtual directory to contain the .h and .cpp files
     **/
    public  void printSignature(TaskDeclaration td, ProgramGraph g,
				      VirtualDirectory virt) 
    {
	Vector<Argument> ins = td.getInputs();
	Vector<Argument> outs = td.getOutputs();
	
	virt.getWriter(M_IMPL_H).print("int "+td.getName()+" (");
	
	virt.getWriter(M_IMPL_C).println("// IN:\t" + td.getInputs().toString());
	virt.getWriter(M_IMPL_C).println("// OUT:\t" + td.getOutputs().toString());
	virt.getWriter(M_IMPL_C).print("int "+td.getName()+" (");
	if (!g.program.isSource(td)) {
	    virt.getWriter(M_IMPL_H).print(td.getName()+"_in *in");
	    virt.getWriter(M_IMPL_C).print(td.getName()+"_in *in");
	    //if (outs.size() > 0) {
		virt.getWriter(M_IMPL_H).print(", ");
		virt.getWriter(M_IMPL_C).print(", ");
	    //}
	}
	//if (outs.size() > 0) {
	    virt.getWriter(M_IMPL_H).print(td.getName()+"_out *out");
	    virt.getWriter(M_IMPL_C).print(td.getName()+"_out *out");
	//}
	virt.getWriter(M_IMPL_H).println(");");
	virt.getWriter(M_IMPL_C).println(") {\n\n}\n");
    }
	
	/**
     * Print a timed source function signature and impl
     * @param td The task
     * @param virt The virtual directory to contain the .h and .cpp files
     **/
    public  void printTimedSrcSignature(TaskDeclaration td, ProgramGraph g,
				      VirtualDirectory virt) 
    {
	Vector<Argument> ins = td.getInputs();
	Vector<Argument> outs = td.getOutputs();
	
	virt.getWriter(M_IMPL_H).print("int "+td.getName()+" (");
	
	virt.getWriter(M_EXEC_C).println("//****************GENERATED SOURCE IMPLEMENTATION!********");
	virt.getWriter(M_EXEC_C).println("//****************DO NOT MODIFY!***********************");
	virt.getWriter(M_EXEC_C).println("// IN:\t" + td.getInputs().toString());
	virt.getWriter(M_EXEC_C).println("// OUT:\t" + td.getOutputs().toString());
	virt.getWriter(M_EXEC_C).print("int "+td.getName()+" (");
	
	
	virt.getWriter(M_IMPL_H).print(td.getName()+"_out *out");
	virt.getWriter(M_EXEC_C).print(td.getName()+"_out *out");
	
	virt.getWriter(M_IMPL_H).println(");");
	virt.getWriter(M_EXEC_C).println(") {");
	
	virt.getWriter(M_EXEC_C).println("static unsigned int lasttime=0;\n");
	virt.getWriter(M_EXEC_C).println("unsigned int delta;");
	virt.getWriter(M_EXEC_C).println("unsigned int nexttime;");
	virt.getWriter(M_EXEC_C).println("unsigned int curtime = get_current_time();");
	virt.getWriter(M_EXEC_C).println("unsigned int cur_ival;");
	
	virt.getWriter(M_EXEC_C).println("cur_ival = get_timer_interval(SOURCE_NUMBER_"+td.getName().toUpperCase()+");");
	
	virt.getWriter(M_EXEC_C).println("sim_sleep((cur_ival/100)+1);"); 
	virt.getWriter(M_EXEC_C).println("return 0;"); 
	
	virt.getWriter(M_EXEC_C).println("nexttime = lasttime + cur_ival;");
	
	virt.getWriter(M_EXEC_C).println("delta = nexttime - curtime;");
	
	virt.getWriter(M_EXEC_C).println("if (curtime > nexttime && lasttime > nexttime)");
	virt.getWriter(M_EXEC_C).println("{");
	virt.getWriter(M_EXEC_C).println("sim_sleep((cur_ival/100)+1);");
	virt.getWriter(M_EXEC_C).println("return 0;");
	virt.getWriter(M_EXEC_C).println("}");
	
	virt.getWriter(M_EXEC_C).println("while (curtime < nexttime) ");
	virt.getWriter(M_EXEC_C).println("{");
	virt.getWriter(M_EXEC_C).println("curtime = get_current_time();");
	virt.getWriter(M_EXEC_C).println("if (curtime < lasttime && curtime < nexttime) break;");
	virt.getWriter(M_EXEC_C).println("if (cur_ival > 200)");
	virt.getWriter(M_EXEC_C).println("{");
	virt.getWriter(M_EXEC_C).println("\tsim_sleep(1);");
	virt.getWriter(M_EXEC_C).println("} else {");
	virt.getWriter(M_EXEC_C).println("\tsim_usleep(10000);");
	virt.getWriter(M_EXEC_C).println("}");
	virt.getWriter(M_EXEC_C).println("}");
	virt.getWriter(M_EXEC_C).println("nexttime = curtime;");
	virt.getWriter(M_EXEC_C).println("return 0;");
	virt.getWriter(M_EXEC_C).println("}");
	virt.getWriter(M_EXEC_C).println("//****************END OF GENERATED CODE");
    }
	
	
	public  void generateStructs(ProgramGraph g, VirtualDirectory out)
	{
		printHHeader(M_STRUCTS_H, out.getWriter(M_STRUCTS_H));	
		
		out.getWriter(M_STRUCTS_H).println("#include \"runtime/rt_structs.h\"");
		out.getWriter(M_STRUCTS_H).println("#include \"userstructs.h\"");
		
		Collection<TaskDeclaration> fns = g.getFunctions();
		
		for (TaskDeclaration td : fns)
		{
			//if (td.getPlatformName().equals("STARGATE"))
			{
				printStructs(td,out.getWriter(M_STRUCTS_H));
			}
			
		}
		
		printHFooter(M_STRUCTS_H, out.getWriter(M_STRUCTS_H));
	}
	

	public  void printHHeader(String name, PrintWriter out)
	{
		String newname = name.replace('.','_');
		out.println("#ifndef _"+newname.toUpperCase()+"_");
		out.println("#define _"+newname.toUpperCase()+"_");
		out.println("");
	}
	
	public  void printHFooter(String name, PrintWriter out)
	{
		String newname = name.replace('.','_');
		out.println("#endif // _"+newname.toUpperCase()+"_");
	}
	
	
	/**
     * Print the structs for input/output for a task
     * @param td The task
     * @param out Where to write
     **/
	public  void printStructs(TaskDeclaration td, PrintWriter out) {
		Vector<Argument> ins = td.getInputs();
		
		//ins
		out.println("typedef struct ");
		out.println("{");
		out.println("rt_data _pdata;");
		for (Argument a : ins) 
			out.println("\t"+a.getType()+" "+a.getName()+";");
		out.println("} "+td.getName()+"_in;");
		out.println();
		
		//outs
		Vector<Argument> outs = td.getOutputs();

		out.println("typedef struct ");
		out.println("{");
		out.println("rt_data _pdata;");
		for (Argument a : outs) 
			out.println("\t"+a.getType()+" "+a.getName()+";");
		out.println("} "+td.getName()+"_out;");
		out.println();
		
		
	}
	
	public  void getNodeIDs(ProgramGraph pg)
	{
		int id=0;
		Collection fns = pg.getFunctions();
		Iterator it = fns.iterator();
		
		
		nodeID.clear();
		
		while (it.hasNext()) 
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
			//printStructs(td, out.getWriter(M_STRUCT_H));
			nodeID.put(td.getName(),id);
			id++;
			
		}
		//System.out.println("id="+nodeID.size());
	
	}
	
	
	public  String getMinPathState(ProgramGraph g, Vector<Vertex> path, int endidx)
	{
		int minState;
		
		Vector<String> states = g.getProgram().getStates().GetAllStates();
		
		minState = 0;
		
		for (int i=0; i < Math.min(path.size(),endidx); i++)
		{
			Vertex v = path.get(i);
			Vertex next = null;
			if (i < path.size()-1)
				next = path.get(i+1);
			
			int nodestate = -1;
			
			GraphNode node = (GraphNode)v.element();
			if (node.getElement() instanceof TaskDeclaration && next != null)
			{
				TaskDeclaration td = (TaskDeclaration)node.getElement();
				FlowStatement fs = g.getProgram().getFlow(td.getName());
				
				GraphNode nextnode = (GraphNode)next.element();
				
				//only check abstract nodes since only they
				//have type/state checks
				if (fs != null && nextnode.getElement() instanceof TaskDeclaration)
				{
					TaskDeclaration nexttd = (TaskDeclaration)nextnode.getElement();
					Vector<SimpleFlowStatement> flows = getFlowList(fs);
					for (SimpleFlowStatement sfs : flows)
					{
						if (sfs.inRightHandSide(nexttd.getName()))
						{
							if (sfs.getState() != null)
								nodestate = getStateID(g,sfs.getState());
						}
					}
				} //if Abstract
			} //if Task
			
			if (nodestate > -1 && nodestate < states.size())
			{
				minState = Math.max(minState,nodestate);
			}
		}//for
		
		return states.get(minState);		
	}


	
	public  int getStateID(ProgramGraph g, String state)
	{
		Vector<String> states = g.getProgram().getStates().GetAllStates();
		
		int count = 0;
		for (String s : states)
		{
			if (s.equals(state))
				return count;
			count++;
		}
		return -1;
	}
	
	public  void generateTypeChecks(ProgramGraph g, VirtualDirectory out)
	{
		Iterator typeit = g.getProgram().getTypes().iterator();
		
		printHHeader(M_TYPES_H,out.getWriter(M_TYPES_H));
		
		while (typeit.hasNext())
		{
			TypeDeclaration typedc = (TypeDeclaration)typeit.next();
			//System.out.println("Type check:"+ typedc.getName()+"-"+typedc.getFunction());
			
			//make sure that all types match
			Vector<String> thetypes = getAllTypeTypes(g, typedc);
			//System.out.println(thetypes);
			if (!thetypes.isEmpty())
			{
				boolean bad = false;
				for (String s : thetypes)
				{
					
					if (!s.equals(thetypes.get(0)))
					{
						bad = true;
					}
				}//for
				if (bad) System.out.println("Type: "+typedc.getName()+" is mapped to multiple types."+thetypes);
				out.getWriter(M_TYPES_H).println("bool "+typedc.getFunction()+"("+thetypes.get(0)+" value)");
				out.getWriter(M_TYPES_H).println("{");
				out.getWriter(M_TYPES_H).println("return FALSE;");
				out.getWriter(M_TYPES_H).println("}");
				out.getWriter(M_TYPES_H).println("");
			}
			
		}
		printHFooter(M_TYPES_H,out.getWriter(M_TYPES_H));
	}
	
	public  Vector<String> getTypeType(ProgramGraph g, TypeDeclaration td, FlowStatement flow)
	{
		Vector<String> result = new Vector<String>();
		
		Vector<SimpleFlowStatement> flows = getFlowList(flow);
		for (SimpleFlowStatement sfs : flows)
		{	
			//does this flow have types?
			Vector<String> vtypes = sfs.getTypes();
			if (vtypes != null)
			{
				//is this type in the flow
				int index = 0;
				for (String typ : vtypes)
				{
					if (typ.equals(td.getName()))
					{
						//it's here. What data type is it?
						String assignee = sfs.getAssignee();
						Vector<Argument> args = g.getProgram().getTask(assignee).getInputs();
						Argument thearg = args.get(index);
						result.add(thearg.getType());
						
					}
					index++;
				}
			
				
			}//if
		}//for
		return result;
		
	}
	
	public  Vector<String> getAllTypeTypes(ProgramGraph g, TypeDeclaration td)
	{
		Collection fns = g.getFunctions();
		Iterator fit = fns.iterator();
		//String type = null;
		Vector<String> result = new Vector<String>();
		
		while (fit.hasNext()) 
		{
			TaskDeclaration taskdec = (TaskDeclaration)fit.next();
			FlowStatement fs = g.getProgram().getFlow(taskdec.getName());
			if (fs != null)
			{
				Vector<String> datatypes = getTypeType(g,td,fs);
				//System.out.println("Matched : "+datatypes);
				result.addAll(datatypes);
			}
		}
		return result;
	}
	
	
	/*
	public  void generateStatement
	(FlowStatement fs, Program p, VirtualDirectory out) 
	{
		TaskDeclaration task = p.getTask(fs.getAssignee());
		out.getWriter(M_LOGIC_CPP).println
		("inline int "+task.getName()+"_exec(" 
				+ (task.getInputs().size() > 0 ? task.getName() + "_in *in," : "")
				+ (task.getOutputs().size() > 0 ? task.getName() + "_out *out," : "")
				+ " markov::event *ev) {");
		Source s = p.getSessionStart(fs);
		if (s != null && s.getSessionFunction() != null) {
			out.getWriter(M_LOGIC_CPP).println 
			("int id = "+ s.getSessionFunction()+"(in);");
			out.getWriter(M_LOGIC_CPP).println
			("in->_mSession=session_locks.getSession(id);");
		}
		if (fs instanceof SimpleFlowStatement)
		{
			if (loggingOn)
			{
				out.getWriter(M_LOGIC_CPP).println("int int_stats_logger = stats_logger[ev->type].start();");
			}
			generateSimpleStatement((SimpleFlowStatement)fs, p, out);
			if (loggingOn)
			{
				out.getWriter(M_LOGIC_CPP).println("stats_logger[ev->type].stop(int_stats_logger);");
			}
		}
		else
		{	
			if (loggingOn)
			{
				out.getWriter(M_LOGIC_CPP).println("int int_stats_logger = stats_logger[ev->type].start();");	
			}
			out.getWriter(M_LOGIC_CPP).println(task.getName() + "_in * " + task.getName() 
					+ "_var_in = (" + task.getName() + "_in *) ev->in;"); 
			generateTypedStatement((TypedFlowStatement)fs, p, out);
			if (loggingOn)
			{
				out.getWriter(M_LOGIC_CPP).println("stats_logger[ev->type].stop(int_stats_logger);");
			}
		}
		out.getWriter(M_LOGIC_CPP).println("return 0;");
		out.getWriter(M_LOGIC_CPP).println("}");
	}
	
	
	
	public static void generateSimpleStatement
	(SimpleFlowStatement sfs, Program p, VirtualDirectory out) 
	{
		Vector<String> args = sfs.getArguments();
		
		for (int i=args.size()-1;i>=0;i--) {
			int stg = getStageNumber(args.get(i));
			out.getWriter(M_LOGIC_CPP).println
			("\t\tev->push("+stg+"); // "+args.get(i));
		}
	}
	*/
	
	

}

