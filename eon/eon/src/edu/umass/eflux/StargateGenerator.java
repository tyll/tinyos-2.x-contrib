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

public class StargateGenerator implements CodeGenerator {
	private String M_TYPES_H = "mTypes.h";
	private String M_STRUCTS_H = "mStructs.h";
	private String M_IMPL_H = "mImpl.h";
	private String M_IMPL_C = "mImpl.c";
	private String M_EXEC_C = "mExec.c";
	private String M_MARSH_H = "mMarsh.h";
	private String M_MARSH_C = "mMarsh.c";
	private String M_NODES_H = "mNodes.h";
	private String M_MAKEFILE = "Makefile";
	
	
	 
	protected Hashtable<String, Boolean> defined 
	= new Hashtable<String, Boolean>();
	

	private Hashtable<String, Integer> nodeID = new Hashtable<String,Integer>();
	
	
	protected String MyName = "stargate";
	
	public String getName()
	{
		return MyName;
	}
	
	public Vector<String> getTargets()
	{
		Vector<String> plats = new Vector<String>();
		
		plats.add("stargate");
		
		return plats;
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
			generateNodesHeader(g,out, stubbs);
			generateStructs(g,out);
			if (stubbs)
			{
				generateImpl(g,out);
			}
			generateExecHandler(g,out);
			generateMarshallers(g,out);
			if (stubbs)
			{
				generateTypeChecks(g,out);
			}
			
			generateMakefile(g,out);
			
			out.flushAndClose();
			System.out.println("Indentation..."+root+"...");
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
		out.getWriter(M_MAKEFILE).println("CC = arm-linux-gcc");
		out.getWriter(M_MAKEFILE).println("CCFLAGS = -I./runtime -I./runtime/sfaccess");
		out.getWriter(M_MAKEFILE).println("LIBS = -lnsl -lpthread");
		out.getWriter(M_MAKEFILE).println("");
		out.getWriter(M_MAKEFILE).println("server: mImpl.c mMarsh.c mExec.c usermarshall.c runtime_build");
		out.getWriter(M_MAKEFILE).println("\t${CC} ${CCFLAGS} -o server mImpl.c mMarsh.c mExec.c usermarshall.c *.o ${LIBS}");
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
	
	public  void generateMarshallers(ProgramGraph g, VirtualDirectory out)
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
		
	}
	
	public  void generateMarshaller(Edge e, ProgramGraph g, VirtualDirectory out)
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
	}
	

	public  void generateUnmarshaller(Edge e, ProgramGraph g, VirtualDirectory out)
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
	}
	
	
	public  void generateNodesHeader(ProgramGraph g, VirtualDirectory out, boolean stubbs)
	{
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();
		
		printHHeader(M_NODES_H,out.getWriter(M_NODES_H));
		
		out.getWriter(M_NODES_H).println("#include <stdint.h>");
		
		//generate node ids
		out.getWriter(M_NODES_H).println("enum {");
		out.getWriter(M_NODES_H).println("NO_NODEID = 0xFFFF,");
		while (it.hasNext()) 
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
						
			//out.getWriter(M_NODES_H).println("#define "+td.getName().toUpperCase()+"_NODEID "+nodeID.get(td.getName()));
			out.getWriter(M_NODES_H).println(td.getName().toUpperCase()+"_NODEID = "+nodeID.get(td.getName())+",");
			
		}
		out.getWriter(M_NODES_H).println("};");
		out.getWriter(M_NODES_H).println("");
		out.getWriter(M_NODES_H).println("#define NUMNODES  "+nodeID.size());
		
		//TODO: Fix state generation
		//generate state ids
		Vector<String> sts = g.getProgram().getStates().GetAllStates();
		
		int state_count = 0;
		for (String s: sts) 
		{
							
			out.getWriter(M_NODES_H).println("#define STATE_"+s.toUpperCase()+" "+
					g.getProgram().getStates().GetStateLevel(s));
			state_count++;
			
		}
		//out.getWriter(M_NODES_H).println("#define NUMSTATES "+state_count);
		out.getWriter(M_NODES_H).println("#define NUMSTATES "+g.getProgram().getStates().NumStates());
		
		out.getWriter(M_NODES_H).println("");
		//out.getWriter(M_NODES_H).println("#define WAKEPOWER 1.5 //W");
		//out.getWriter(M_NODES_H).println("#define IDLEPOWER 0.005 //W");
		//out.getWriter(M_NODES_H).println("#define STARGATEIDLEPOWER 1.2 //W");
		//out.getWriter(M_NODES_H).println("#define LOCALEDGEENERGY 1.42 //mJ");
		//out.getWriter(M_NODES_H).println("#define REMOTEEDGEENERGY 1.42 //mJ");
		//out.getWriter(M_NODES_H).println("double wakeTimeMS = 0.0;");
		//out.getWriter(M_NODES_H).print("double nodeTimeMS[NUMNODES]={0.0");
		//int i=0;
		//for (i=0; i < nodeID.size()-1; i++)
		//{
		//	out.getWriter(M_NODES_H).print(",0.0");
		//}
		//out.getWriter(M_NODES_H).println("};");
		
		//out.getWriter(M_NODES_H).print("double nodePowerMax[NUMNODES]={0.0");
		
		/*for (i=0; i < nodeID.size()-1; i++)
		{
			out.getWriter(M_NODES_H).print(",0");
		}
		out.getWriter(M_NODES_H).println("};");
		
		out.getWriter(M_NODES_H).print("double nodePowerMin[NUMNODES]={0.0");
		
		for (i=0; i < nodeID.size()-1; i++)
		{
			out.getWriter(M_NODES_H).print(",0.0");
		}
		out.getWriter(M_NODES_H).println("};");*/
		
		Vector<Vector<Vertex>> paths = g.getPaths();
		out.getWriter(M_NODES_H).println("#define NUMPATHS "+paths.size());
		/*
		out.getWriter(M_NODES_H).println("#define PATHRATESECONDS 20 //Path rates are in requests/PATHRATESECONDS");
		out.getWriter(M_NODES_H).println("#define PATHRATEHISTORY 30 //Path rate averages over PATHRATEHISTORY samples");
		//generate path rate variables
		out.getWriter(M_NODES_H).print("uint16_t pathRate[NUMPATHS]={");
		for (i=0; i < paths.size(); i++)
		{
			out.getWriter(M_NODES_H).print("0");
			if (i < (paths.size()-1))
				out.getWriter(M_NODES_H).print(",");
		}
		out.getWriter(M_NODES_H).println("};");
		out.getWriter(M_NODES_H).print("double avgPathRate[NUMPATHS]={");
		for (i=0; i < paths.size(); i++)
		{
			out.getWriter(M_NODES_H).print("0.0");
			if (i < (paths.size()-1))
				out.getWriter(M_NODES_H).print(",");
		}
		out.getWriter(M_NODES_H).println("};");
		
//		generate path wakeup variables
		out.getWriter(M_NODES_H).println("//How long to make wakeup window in Requests");
		out.getWriter(M_NODES_H).println("#define WAKEUPPROBHISTORY 30");
		
		out.getWriter(M_NODES_H).print("double wakeupProb[NUMPATHS]={");
		for (i=0; i < paths.size(); i++)
		{
			out.getWriter(M_NODES_H).print("0.0");
			if (i < (paths.size()-1))
				out.getWriter(M_NODES_H).print(",");
		}
		out.getWriter(M_NODES_H).println("};");
		
		out.getWriter(M_NODES_H).println("#define SGDCHISTORY 60 //Minutes");
		out.getWriter(M_NODES_H).print("double stargateDutyCycle[NUMSTATES] = {");
		it = sts.iterator();
		while (it.hasNext()) 
		{
			StateDeclaration sd = (StateDeclaration)it.next();
						
			out.getWriter(M_NODES_H).print("0.0");
			if (it.hasNext())
			{
				out.getWriter(M_NODES_H).print(",");
			}
			
		}
		out.getWriter(M_NODES_H).println("};");*/
		//out.getWriter(M_NODES_H).println("uint8_t curstate = STATE_BASE;");
		if (stubbs)
		{
			out.getWriter(M_IMPL_C).println("#include \"mImpl.h\"\n");
			out.getWriter(M_IMPL_C).print("const uint8_t minPathState[NUMPATHS]={");
			for (int i=0; i < paths.size(); i++)
			{
				Vector<Vertex> path = paths.get(i);
				
				String state = getMinPathState(g, path, path.size());
			
				out.getWriter(M_IMPL_C).print("STATE_"+state.toUpperCase());
				if (i < (paths.size()-1))
					out.getWriter(M_IMPL_C).print(",");
			}
			out.getWriter(M_IMPL_C).println("};");
		}
		//generatePathEnergyCalculators(out.getWriter(M_NODES_H), paths,g);
		
		
		
		printHFooter(M_NODES_H,out.getWriter(M_NODES_H));
		
	}
	
	
	public  void generateExecHandler(ProgramGraph g, VirtualDirectory out)
	{
		
		out.getWriter(M_EXEC_C).println("#include \""+M_STRUCTS_H+"\"");
		out.getWriter(M_EXEC_C).println("#include \""+M_IMPL_H+"\"");
		out.getWriter(M_EXEC_C).println("#include \""+M_TYPES_H+"\"");
		out.getWriter(M_EXEC_C).println("#include \""+M_MARSH_H+"\"");
		out.getWriter(M_EXEC_C).println("#include \""+M_NODES_H+"\"");
		out.getWriter(M_EXEC_C).println("#include <string.h>");
		out.getWriter(M_EXEC_C).println("#include \"runtime/rt_handler.h\"");
		out.getWriter(M_EXEC_C).println("");
		out.getWriter(M_EXEC_C).println("int theglobalfd;");
		
		//find local sources
		Vector<Source> srcs = g.program.getSources();
		Collection<TaskDeclaration> fncs = g.program.getFunctions();
		
		for (TaskDeclaration t : fncs)
		{
			if (g.program.isSource(t) && t.getPlatformName().equals("STARGATE"))
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
			if (g.program.isSource(t) && t.getPlatformName().equals("STARGATE"))
			{
				
				out.getWriter(M_EXEC_C).print("error = pthread_create(&tid, ");
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
		
		//run the program
		out.getWriter(M_EXEC_C).println("");
		out.getWriter(M_EXEC_C).print("err = "+t.getName()+"(&"+t.getName()+"_out_var);");
		out.getWriter(M_EXEC_C).println("if (err) {return;}");
		
		out.getWriter(M_EXEC_C).println("sendPathStartPacket("+t.getName()+"_out_var._pdata.sessionID);");
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
		out.getWriter(M_IMPL_C).println("void init(int argc, char **argv) {");
		out.getWriter(M_IMPL_C).println("\n}");
		out.getWriter(M_IMPL_C).println("");
		
		Collection<TaskDeclaration> fns = g.getFunctions();
		
		for (TaskDeclaration td : fns)
		{
			if (td.getPlatformName().equals("STARGATE"))
			{
				printSignature(td,out);
				printErrorHandler(td,g,out);
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
			if (dtd.getPlatformName().equals("STARGATE") &&
					!std.getPlatformName().equals("STARGATE"))
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
    public  void printSignature(TaskDeclaration td,
				      VirtualDirectory virt) 
    {
	Vector<Argument> ins = td.getInputs();
	Vector<Argument> outs = td.getOutputs();
	
	virt.getWriter(M_IMPL_H).print("int "+td.getName()+" (");
	
	virt.getWriter(M_IMPL_C).println("// IN:\t" + td.getInputs().toString());
	virt.getWriter(M_IMPL_C).println("// OUT:\t" + td.getOutputs().toString());
	virt.getWriter(M_IMPL_C).print("int "+td.getName()+" (");
	if (ins.size() > 0) {
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

