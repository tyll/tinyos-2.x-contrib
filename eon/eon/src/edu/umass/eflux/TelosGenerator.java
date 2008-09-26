package edu.umass.eflux;

import java.io.IOException;
import java.io.FileInputStream;
import java.io.PrintWriter;

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

public class TelosGenerator  {
	
	//private static ProgramGraph programGraph;
	
	
	protected static Hashtable<String, Boolean> defined 
	= new Hashtable<String, Boolean>();
	
	protected static String M_STRUCT_H = "structs.h";
	protected static String M_NODES_H = "nodes.h";
	protected static String M_CALLS_H = "calls.h";
	protected static String M_TYPES_H = "typechecks.h";
	protected static String M_EDGES_NC = "RuntimeM.nc";
	protected static String M_RUNTIMEM_NC = "RuntimeM.nc";
	protected static String M_RUNTIME_NC = "Runtime.nc";
	protected static String M_MARSHALL_H = "marshaller.h";
	protected static String M_MAKEFILE = "Makefile";
	
	protected static Hashtable<String, Integer> nodeID = new Hashtable<String,Integer>();
	
	//private static int totalStages;
	
	// The stage number corresponding to a given name.
	//private static Hashtable<String, Integer> stageNumber
	//	= new Hashtable<String, Integer>();
	

	
	public static void generateTimedSourceInit(ProgramGraph g, VirtualDirectory out)
	{
		Vector<Source> sources = g.getProgram().getSources();
		StateOrder order = g.getProgram().getStates();
		Vector<Vector<String>> ordering = order.getOrdering();
		Vector<TimeConstraint> constraints = g.getProgram().getTimeConstraints();
		
		
		System.out.println("generateTSI...");
		int s=0;
		for (Source src: sources)
		{
			System.out.println("Source:"+src);
			out.getWriter(M_NODES_H).print("{");
			if (g.isTimedSource(src.getSourceFunction()))
			{
				
				//make timeline
				Vector<TimeConstraint> timeline = new Vector<TimeConstraint>();
				int max = -1;
				int min = -1;
				int lvl=0;
				
				for (Vector<String> level : ordering)
				{
					
					TimeConstraint thecon = null;
					for(TimeConstraint con : constraints)
					{
						if (src.getSourceFunction().equals(con.getTimer()))
						{
							String st = con.getState();
							int lnum = order.GetStateLevel(st);
							if (lnum == lvl)
							{
								thecon = con;							
							}
						}
					}
					if (thecon != null)
					{
						if (max == -1)
						{
							max = thecon.getLoVal();
						} else {
							if (max > thecon.getLoVal())
							{
								System.out.println("WARNING: non-monotonic timer (LO)");
							} else {
								max = thecon.getLoVal();
							}
						}
						if (min == -1)
						{
							min = thecon.getHiVal();
						} else {
							if (min < thecon.getHiVal())
							{
								System.out.println("WARNING: non-monotonic timer (Hi)");
								min = thecon.getHiVal();
							} 
						}
					}
					
					//timeline.add(0,thecon);
					timeline.add(thecon);
					lvl++;
				} //end build timeline
				if (max == -1) max = 10000;
				if (min == -1) min = 10000;
				//now go through the timeline and fill in missing values
				int i=0;
				for (TimeConstraint con: timeline)
				{
					
					int themin;
					int themax;
					
					if (con == null)
					{ 
						themin = min;
						themax = min;
					} else {
						themin = con.getHiVal();
						themax = con.getLoVal();
					}
					min = themax;
					System.out.println("writing..."+i+","+(timeline.size()-1));
					out.getWriter(M_NODES_H).print("{"+themin+","+themax+"}");
					if (i < (timeline.size()-1))
					{
						out.getWriter(M_NODES_H).print(",");
					}
					i++;
						
				}
				
			} else {
				int i=0;
				for (Vector<String> level : ordering)
				{
					out.getWriter(M_NODES_H).print("{-1,-1}");
					if (i >= (ordering.size()-1))
					{
						out.getWriter(M_NODES_H).print(",");
					}
				}
			}
			out.getWriter(M_NODES_H).print("}");
			if (s < (sources.size() -1))
			{
				out.getWriter(M_NODES_H).print(",");
			}
			s++;
		}
	
	}
	
	
	public static Integer getSourceNum(ProgramGraph g, String name)
	{
		Integer index = 0;
		
		Vector<Source> sources = g.getProgram().getSources();
		
		
		for (Source src: sources)
		{
			String srcname = src.getSourceFunction();
			if (name.equals(srcname))
			{
				return index;
			}
			index++;
		}
		
		return -1;
	}
	
	public static Vector<String> getTypeType(ProgramGraph g, TypeDeclaration td, FlowStatement flow)
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
	
	public static Vector<String> getAllTypeTypes(ProgramGraph g, TypeDeclaration td)
	{
		Collection fns = g.getFunctions();
		Iterator fit = fns.iterator();
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
	
	public static void generateTypeChecks(ProgramGraph g, VirtualDirectory out)
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
	
	
	public static void generateMarshallers(ProgramGraph g, VirtualDirectory out)
	{
		
		
		printHHeader(M_MARSHALL_H,out.getWriter(M_MARSHALL_H));
		
		out.getWriter(M_MARSHALL_H).println("#include \"fluxmarshal.h\"");
		
		Collection<TaskDeclaration> funcs = g.getProgram().getFunctions();
		for (TaskDeclaration td : funcs)
		{
			Vertex v = g.getVertex(td.getName());
			EdgeIterator eit = g.getGraph().incidentEdges(v, EdgeDirection.IN);
			boolean iscross = false;
			
			while (eit.hasNext())
			{
				Edge ed = eit.nextEdge();
				if (!isEdgeLocal(g.getGraph().origin(ed), g.getGraph().destination(ed), g))
				{
					iscross = true;
				}
				
			}
			if (iscross)
			{
				int counter = 2;
				out.getWriter(M_MARSHALL_H).println("uint8_t encode_"+td.getName()+"_in(uint16_t connid, EdgeIn edge, int count)");
				out.getWriter(M_MARSHALL_H).println("{");
				//out.getWriter(M_MARSHALL_H).println("uint8_t result = MARSH_OK;");
				out.getWriter(M_MARSHALL_H).println(td.getName()+"_in **in;");
				out.getWriter(M_MARSHALL_H).println("in=("+td.getName()+"_in**)edge.invar;");
				out.getWriter(M_MARSHALL_H).println("switch(count)");
				out.getWriter(M_MARSHALL_H).println("{");
				out.getWriter(M_MARSHALL_H).println("case 0:");
				out.getWriter(M_MARSHALL_H).println("{");
				out.getWriter(M_MARSHALL_H).println("return encode_start(connid, edge.node_id);");
				out.getWriter(M_MARSHALL_H).println("}");
				
				out.getWriter(M_MARSHALL_H).println("case 1:");
				out.getWriter(M_MARSHALL_H).println("{");
				out.getWriter(M_MARSHALL_H).println("return encode_session(connid, (*in)->_pdata);");
				out.getWriter(M_MARSHALL_H).println("}");
				
				
				Vector<Argument> ins = td.getInputs();
				
				
				for (Argument a : ins) 
				{
					out.getWriter(M_MARSHALL_H).println("case "+counter+":");
					out.getWriter(M_MARSHALL_H).println("{");
					out.getWriter(M_MARSHALL_H).println("return encode_"+a.getType()+"(connid, (*in)->"+a.getName()+");");
					out.getWriter(M_MARSHALL_H).println("}");
					counter++;
					
					
				}
				out.getWriter(M_MARSHALL_H).println("case "+counter+":");
				out.getWriter(M_MARSHALL_H).println("{");
				out.getWriter(M_MARSHALL_H).println("return MARSH_DONE;");
				out.getWriter(M_MARSHALL_H).println("}");
				out.getWriter(M_MARSHALL_H).println("} //switch");
				
				out.getWriter(M_MARSHALL_H).println("return MARSH_ERR;");
				out.getWriter(M_MARSHALL_H).println("}\n");
			}
		}
		
		//generate the main marshalling func
		out.getWriter(M_MARSHALL_H).println("bool encodeEdge(uint16_t connid, EdgeIn edge, int count)");
		out.getWriter(M_MARSHALL_H).println("{");
		out.getWriter(M_MARSHALL_H).println("switch(edge.node_id)");
		out.getWriter(M_MARSHALL_H).println("{");
		
		for (TaskDeclaration td : funcs)
		{
			Vertex v = g.getVertex(td.getName());
			EdgeIterator eit = g.getGraph().incidentEdges(v, EdgeDirection.IN);
			boolean iscross = false;
			
			while (eit.hasNext())
			{
				Edge ed = eit.nextEdge();
				if (!isEdgeLocal(g.getGraph().origin(ed), g.getGraph().destination(ed), g))
				{
					iscross = true;
				}
				
			}
			if (iscross)
			{
				out.getWriter(M_MARSHALL_H).println("case "+td.getName().toUpperCase() +"_NODEID:");
				out.getWriter(M_MARSHALL_H).println("return encode_"+td.getName()+"_in(connid,edge,count);");
			}
		}
		out.getWriter(M_MARSHALL_H).println("}");
		out.getWriter(M_MARSHALL_H).println("return MARSH_ERR; //you tried to encode an errant edge, dropping it into the ether.");
		out.getWriter(M_MARSHALL_H).println("}");
		
		printHFooter(M_MARSHALL_H,out.getWriter(M_MARSHALL_H));
	}
	
	
	
	public static void printCallParamDecl(TaskDeclaration td,
			PrintWriter out) 
	{
		String name = td.getName();
		//Vector<Argument> ins = td.getInputs();
		//Vector<Argument> outs = td.getOutputs();
		
		out.print(name + "_in **in,"+name+"_out **out");
	}
	
	public static void printCallDoneParamDecl(TaskDeclaration td,
			PrintWriter out) 
	{
		//String name = td.getName();
		//Vector<Argument> ins = td.getInputs();
		//Vector<Argument> outs = td.getOutputs();
		printCallParamDecl(td,out);
		out.print("uint8_t error");
	}
	
	public static void generateStdControlImpl(PrintWriter pw)
	{
		pw.println("command result_t StdControl.init()");
		pw.println("{");
		pw.println("\treturn SUCCESS;");
		pw.println("}");
		pw.println("");
		pw.println("command result_t StdControl.start()");
		pw.println("{");
		pw.println("\treturn SUCCESS;");
		pw.println("}");
		pw.println("");
		pw.println("command result_t StdControl.stop()");
		pw.println("{");
		pw.println("\treturn SUCCESS;");
		pw.println("}");
		pw.println("");
	}
	
	public static void generateEnergyCostImpl(PrintWriter pw)
	{
		pw.println("command uint16_t IEnergyCost.getMinCost()");
		pw.println("{");
		pw.println("\treturn 1;");
		pw.println("}");
		pw.println("");
		pw.println("command uint16_t IEnergyCost.getMaxCost()");
		pw.println("{");
		pw.println("\treturn 1;");
		pw.println("}");
		pw.println("");
	}
	
	public static void generateSourceInterface(TaskDeclaration td, 
												VirtualDirectory out,
												boolean timed)
	{
		String name = td.getName();
		String interfaceName = "I"+name;
		String filename = interfaceName +".nc";
		out.getWriter(filename).println("interface "+interfaceName);
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("command result_t srcStart("+name+"_out **out);");
		out.getWriter(filename).println("event result_t srcFired("+name+"_out **out);");
		if (timed)
		{
			out.getWriter(filename).println("command result_t setInterval(uint32_t value);");
		}
		out.getWriter(filename).println("}");
	}
	
	public static void generateSourceConfig(TaskDeclaration td, 
											VirtualDirectory out,
											boolean timed)
	{
		if (timed)
		{
			generateTimedSourceConfig(td,out);
		} else {
			generateNodeConfig(td,out);
		}
	}
	public static void generateTimedSourceConfig(TaskDeclaration td, VirtualDirectory out)
	{
		String name = td.getName();
		String mName = name+"M";
		String interfaceName = "I"+name;
		String filename = name +".nc";
		out.getWriter(filename).println("configuration "+name);
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("provides {");
		out.getWriter(filename).println("interface StdControl;");
		out.getWriter(filename).println("interface "+interfaceName+";");
		//out.getWriter(filename).println("interface IEnergyCost;");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("implementation");
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("components "+mName+", TimerC;");
		out.getWriter(filename).println("");
		out.getWriter(filename).println("StdControl = "+mName+".StdControl;");
		
		out.getWriter(filename).println(interfaceName+" = "+mName+"."+interfaceName+";");
		out.getWriter(filename).println(mName+".Timer -> TimerC.Timer[unique(\"Timer\")];");
		//out.getWriter(filename).println("IEnergyCost = "+mName+".IEnergyCost;");
		out.getWriter(filename).println("}");
	
	}
	
	public static void generateNodeModuleHeader(TaskDeclaration td, VirtualDirectory out)
	{
		String name = td.getName();
		String mName = name+"M";
		String interfaceName = "I"+name;
		String filename = mName +".nc";
		
		out.getWriter(filename).println("includes structs;\n");
		out.getWriter(filename).println("module "+mName);
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("provides {");
		out.getWriter(filename).println("interface StdControl;");
		out.getWriter(filename).println("interface "+interfaceName+";");
		//out.getWriter(filename).println("interface IEnergyCost;");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("implementation");
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("#include \"fluxconst.h\"\n");
		generateStdControlImpl(out.getWriter(filename));
		//generateEnergyCostImpl(out.getWriter(filename));
	
	}
	
	public static void generateTimedSourceModuleHeader(TaskDeclaration td, VirtualDirectory out)
	{
		String name = td.getName();
		String mName = name+"M";
		String interfaceName = "I"+name;
		String filename = mName +".nc";
		
		out.getWriter(filename).println("includes structs;\n");
		out.getWriter(filename).println("module "+mName);
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("provides {");
		out.getWriter(filename).println("interface StdControl;");
		out.getWriter(filename).println("interface "+interfaceName+";");
		//out.getWriter(filename).println("interface IEnergyCost;");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("uses {");
		out.getWriter(filename).println("interface Timer;");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("implementation");
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("#include \"fluxconst.h\"\n");
		out.getWriter(filename).println("uint32_t value_ms=0;");
		out.getWriter(filename).println(name+"_out **myout = NULL;\n");
		generateStdControlImpl(out.getWriter(filename));
		//generateEnergyCostImpl(out.getWriter(filename));
	
	}
	
	public static void generateSourceModule(TaskDeclaration td, 
											VirtualDirectory out, 
											boolean timed)
	{
		String name = td.getName();
		String mName = name+"M";
		String interfaceName = "I"+name;
		String filename = mName +".nc";
		
		if (timed)
		{
			generateTimedSourceModuleHeader(td,out);
		} else {
			generateNodeModuleHeader(td,out);
		}
		//generate source specific interface
		
		//srcStart Implementation
		out.getWriter(filename).print("command result_t "+interfaceName+".srcStart(");
		out.getWriter(filename).print(name+"_out **out");
		out.getWriter(filename).println(")");
		
		out.getWriter(filename).println("{");
		if (timed)
		{
			out.getWriter(filename).println("myout = out;");			
		}
		
		out.getWriter(filename).println("return SUCCESS;");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("");
		if (timed)
		{
//			setInterval Implementation
			//TODO: Everytime you change the interval this resets the timer.
			//Should fix it so that it does this more intelligently
			out.getWriter(filename).print("command result_t "+interfaceName+".setInterval(");
			out.getWriter(filename).print("uint32_t value)");			
			out.getWriter(filename).println("{");
			out.getWriter(filename).println("value_ms = value;");
			out.getWriter(filename).println("call Timer.start(TIMER_REPEAT, value_ms);");
			out.getWriter(filename).println("return SUCCESS;");
			out.getWriter(filename).println("}");
			
			out.getWriter(filename).println("event result_t Timer.fired()");			
			out.getWriter(filename).println("{");
			out.getWriter(filename).println("signal "+interfaceName+".srcFired(myout);");
			out.getWriter(filename).println("return SUCCESS;");
			out.getWriter(filename).println("}");
			
			
		}
		out.getWriter(filename).println("}");
	}
	
	public static void generateNodeInterface(TaskDeclaration td, VirtualDirectory out)
	{
		String name = td.getName();
		String interfaceName = "I"+name;
		String filename = interfaceName +".nc";
		out.getWriter(filename).println("includes structs;");
		out.getWriter(filename).println("interface "+interfaceName);
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("command bool ready();");
		out.getWriter(filename).println("command result_t nodeCall("+name+"_in **in,"+name+"_out **out);");
		out.getWriter(filename).println("event result_t nodeDone("+name+"_in **in,"+name+"_out **out, uint8_t error);");
		out.getWriter(filename).println("}");
	}
	
	public static void generateNodeConfig(TaskDeclaration td, VirtualDirectory out)
	{
		String name = td.getName();
		String mName = name+"M";
		String interfaceName = "I"+name;
		String filename = name +".nc";
		out.getWriter(filename).println("configuration "+name);
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("provides {");
		out.getWriter(filename).println("interface StdControl;");
		out.getWriter(filename).println("interface "+interfaceName+";");
		//out.getWriter(filename).println("interface IEnergyCost;");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("implementation");
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("components "+mName+";");
		out.getWriter(filename).println("");
		out.getWriter(filename).println("StdControl = "+mName+".StdControl;");
		out.getWriter(filename).println(interfaceName+" = "+mName+"."+interfaceName+";");
		//out.getWriter(filename).println("IEnergyCost = "+mName+".IEnergyCost;");
		out.getWriter(filename).println("}");
	
	}
	
	public static void generateNodeModule(TaskDeclaration td, VirtualDirectory out)
	{
		String name = td.getName();
		String mName = name+"M";
		String interfaceName = "I"+name;
		String filename = mName +".nc";
		
		generateNodeModuleHeader(td,out);
		//generate node specific interface
		
//		ready Implementation
		out.getWriter(filename).println("command bool "+interfaceName+".ready()");
		
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("//PUT READY IMPLEMENTATION HERE\n");
		out.getWriter(filename).println("return TRUE;");
		out.getWriter(filename).println("}");
		
		out.getWriter(filename).println("");
		
		//nodeCall Implementation
		out.getWriter(filename).print("command result_t "+interfaceName+".nodeCall(");
		printCallParamDecl(td,out.getWriter(filename));
		out.getWriter(filename).println(")");
		
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("//PUT NODE IMPLEMENTATION HERE\n");
		out.getWriter(filename).println("//Done signal can be moved if node makes split phase calls.");
		out.getWriter(filename).println("signal "+interfaceName+".nodeDone(in,out,ERR_OK);");
		out.getWriter(filename).println("return SUCCESS;");
		out.getWriter(filename).println("}");
		
		out.getWriter(filename).println("}");
	}
	
	

	public static void generateErrHandlerModuleHeader(ErrorHandler eh, VirtualDirectory out)
	{
		String name = eh.getFunction();
		//String target = eh.getTarget();
		String mName = name+"M";
		String interfaceName = "I"+name;
		String filename = mName +".nc";
		
		out.getWriter(filename).println("includes structs;\n");
		out.getWriter(filename).println("module "+mName);
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("provides {");
		out.getWriter(filename).println("interface StdControl;");
		out.getWriter(filename).println("interface "+interfaceName+";");
		out.getWriter(filename).println("interface IEnergyCost;");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("implementation");
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("#include \"fluxconst.h\"\n");
		generateStdControlImpl(out.getWriter(filename));
		generateEnergyCostImpl(out.getWriter(filename));
	
	}
	
	
	public static void generateErrHandlerInterface(ErrorHandler eh, VirtualDirectory out)
	{
		String name = eh.getFunction();
		String target = eh.getTarget();
		String interfaceName = "I"+name;
		String filename = interfaceName +".nc";
		out.getWriter(filename).println("includes structs;");
		out.getWriter(filename).println("interface "+interfaceName);
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("command result_t errCall("+target+"_in **in, uint8_t error);");
		out.getWriter(filename).println("event result_t errDone("+target+"_in **in);");
		out.getWriter(filename).println("}");
	}
	
	public static void generateErrHandlerConfig(ErrorHandler eh, VirtualDirectory out)
	{
		String name = eh.getFunction();
		//String target = eh.getTarget();
		String interfaceName = "I"+name;
		String mName = name+"M";
		String filename = name +".nc";
		out.getWriter(filename).println("configuration "+name);
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("provides {");
		out.getWriter(filename).println("interface StdControl;");
		out.getWriter(filename).println("interface "+interfaceName+";");
		out.getWriter(filename).println("interface IEnergyCost;");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("implementation");
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("components "+mName+";");
		out.getWriter(filename).println("");
		out.getWriter(filename).println("StdControl = "+mName+".StdControl;");
		out.getWriter(filename).println(interfaceName+" = "+mName+"."+interfaceName+";");
		out.getWriter(filename).println("IEnergyCost = "+mName+".IEnergyCost;");
		out.getWriter(filename).println("}");
	
	}
	
	public static void generateErrHandlerModule(ErrorHandler eh, VirtualDirectory out)
	{
		String name = eh.getFunction();
		String target = eh.getTarget();
		String interfaceName = "I"+name;
		String mName = name+"M";
		String filename = mName +".nc";
		
		generateErrHandlerModuleHeader(eh,out);
		//generate node specific interface
		

		
		//nodeCall Implementation
		out.getWriter(filename).print("command result_t "+interfaceName+".errCall(");
		out.getWriter(filename).print(target+"_in **in, uint8_t error");
		out.getWriter(filename).println(")");
		
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("//PUT ERROR HANDLER IMPLEMENTATION HERE\n");
		out.getWriter(filename).println("//Done signal can be moved if node makes split phase calls.");
		out.getWriter(filename).println("signal "+interfaceName+".errDone(in);");
		out.getWriter(filename).println("return SUCCESS;");
		out.getWriter(filename).println("}");
		
		out.getWriter(filename).println("}");
	}
	
	
	
	public static void generateNodes(ProgramGraph g, VirtualDirectory out)
	{
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		//Program p = g.getProgram();
		//Collection<Source> sources = g.getSources();
		
		while (it.hasNext()) 
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
			//printStructs(td, out.getWriter(M_STRUCT_H));
			
			if (isNodeAbstract(g,td.getName()))
			{
				//System.out.println(td.getName()+":is abstract.");
			} else {
				if (td.getPlatformName().equals("TELOS"))
				{
					
					if (g.isSource(td.getName()))
					{
						boolean timed = g.isTimedSource(td.getName());
						
						generateSourceInterface(td,out, timed);
						generateSourceConfig(td,out, timed);
						generateSourceModule(td,out, timed);
					} else {	
						generateNodeInterface(td,out);
						generateNodeConfig(td,out);
						generateNodeModule(td,out);
					}
				}
			}
		}
	} //generateNodes
	
	public static void generateErrHandlers(ProgramGraph g, VirtualDirectory out)
	{
		Vector<ErrorHandler> errs = g.getProgram().getErrorHandlers();
		
		for (ErrorHandler eh : errs) 
		{
			TaskDeclaration td = g.findTask(eh.getTarget());
			if (td.getPlatformName().equals("TELOS"))
			{
				generateErrHandlerInterface(eh,out);
				generateErrHandlerConfig(eh,out);
				generateErrHandlerModule(eh,out);
			}
		}
	} //generateNodes
	
	public static void generateRuntimeStdControlImpl(ProgramGraph g, VirtualDirectory out)
	{
		PrintWriter pw = out.getWriter(M_RUNTIMEM_NC);
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();
		Vector<ErrorHandler> errs;
		
		pw.println("command result_t StdControl.init()");
		pw.println("{");
		pw.println("result_t result;");
		pw.println("session_id = 0;");
		pw.println("queue_init(&moteQ);");
		pw.println("queue_init(&remoteQ);");
		pw.println("call Leds.init();");
		pw.println("");
		pw.println("localCAlive = FALSE;");
		pw.println("remoteCAlive = FALSE;");
		pw.println("");
		pw.println("result = SUCCESS;");
		pw.println("//initialize nodes");
		while (it.hasNext()) 
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
			//printStructs(td, out.getWriter(M_STRUCT_H));
			
			if (!isNodeAbstract(g,td.getName()))
			{
				if (td.getPlatformName().equals("TELOS"))
				{
					pw.println("result &= call "+td.getName()+"Control.init();");
				}
			}
		}
		errs = g.getProgram().getErrorHandlers();
		for (ErrorHandler eh : errs) 
		{
			TaskDeclaration etd = g.findTask(eh.getTarget());			
			if (!isNodeAbstract(g,etd.getName()))
			{
				if (etd.getPlatformName().equals("TELOS"))
				{
					pw.println("result &= call "+eh.getFunction()+"Control.init();");
				}
			}
		}
		pw.println("return result;");
		pw.println("}");
		pw.println("");
		
		
		pw.println("command result_t StdControl.start()");
		pw.println("{");
		pw.println("result_t result;");
		pw.println("Handle hnd;");
		pw.println("");
		pw.println("result = SUCCESS;");
		pw.println("//start nodes");
		
		it = fns.iterator();
		while (it.hasNext()) 
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
					
			if (!isNodeAbstract(g,td.getName()) && td.getPlatformName().equals("TELOS"))
			{
				if (!g.isSource(td.getName()))
				{
					pw.println("result &= call "+td.getName()+"Control.start();");
				}
			}
		}
		errs = g.getProgram().getErrorHandlers();
		for (ErrorHandler eh : errs) 
		{
			TaskDeclaration etd = g.findTask(eh.getTarget());			
			if (!isNodeAbstract(g,etd.getName()))
			{
				if (etd.getPlatformName().equals("TELOS"))
				{
					pw.println("result &= call "+eh.getFunction()+"Control.start();");
				}
			}
		}
		pw.println("//start sources");
		
		it = fns.iterator();
		while (it.hasNext()) 
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
					
			if (!isNodeAbstract(g,td.getName()) && td.getPlatformName().equals("TELOS"))
			{
				if (g.isSource(td.getName()))
				{
					pw.println("result &= call "+td.getName()+"Control.start();");
					pw.println("result &= call BAlloc.allocate(&hnd, sizeof("+td.getName()+"_out));");
					pw.println("result &= call I"+td.getName()+".srcStart(("+td.getName()+"_out**)hnd);");
				}
			}
		}
		
		pw.println("");
		//pw.println("call PathRateTimer.start(TIMER_REPEAT, PATHRATESECONDS*1024);");
		//pw.println("call DutyCycleTimer.start(TIMER_REPEAT, 2*1024);");
		pw.println("return result;");
		pw.println("}");
		
		pw.println("command result_t StdControl.stop()");
		pw.println("{");
		pw.println("result_t result;");
		pw.println("");
		pw.println("result = SUCCESS;");
		pw.println("//initialize nodes");
		it = fns.iterator();
		while (it.hasNext()) 
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
			//printStructs(td, out.getWriter(M_STRUCT_H));
			
			if (!isNodeAbstract(g,td.getName()))
			{
				if (td.getPlatformName().equals("TELOS"))
				{
					pw.println("result &= call "+td.getName()+"Control.stop();");
				}
			}
		}
		errs = g.getProgram().getErrorHandlers();
		for (ErrorHandler eh : errs) 
		{
			TaskDeclaration etd = g.findTask(eh.getTarget());			
			if (!isNodeAbstract(g,etd.getName()))
			{
				if (etd.getPlatformName().equals("TELOS"))
				{
					pw.println("result &= call "+eh.getFunction()+"Control.stop();");
				}
			}
		}
		pw.println("return result;");
		pw.println("}");
		pw.println("");
	}
	
	public static void generateRuntimeModuleHdr(ProgramGraph g, VirtualDirectory out)
	{
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();
		
		out.getWriter(M_RUNTIMEM_NC).println("includes structs;");
		out.getWriter(M_RUNTIMEM_NC).println("");
		out.getWriter(M_RUNTIMEM_NC).println("module RuntimeM {");
		out.getWriter(M_RUNTIMEM_NC).println("provides {");
		out.getWriter(M_RUNTIMEM_NC).println("interface StdControl;");
		out.getWriter(M_RUNTIMEM_NC).println("}");
		out.getWriter(M_RUNTIMEM_NC).println("uses {");
		
		out.getWriter(M_RUNTIMEM_NC).println("//Node Interfaces");
		while (it.hasNext()) 
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
			
			if (!isNodeAbstract(g,td.getName()))
			{
				if (td.getPlatformName().equals("TELOS"))
				{
					out.getWriter(M_RUNTIMEM_NC).println("interface I"+td.getName()+";");
					out.getWriter(M_RUNTIMEM_NC).println("interface StdControl as "+td.getName()+"Control;");
				}
			}
		}
		out.getWriter(M_RUNTIMEM_NC).println("//END of Node Interfaces");
		out.getWriter(M_RUNTIMEM_NC).println("//Error Handler Interfaces");
		Vector<ErrorHandler> errs = g.getProgram().getErrorHandlers();
		for (ErrorHandler eh : errs) 
		{
			TaskDeclaration etd = g.findTask(eh.getTarget());			
			if (!isNodeAbstract(g,etd.getName()))
			{
				if (etd.getPlatformName().equals("TELOS"))
				{
					out.getWriter(M_RUNTIMEM_NC).println("interface I"+eh.getFunction()+";");
					out.getWriter(M_RUNTIMEM_NC).println("interface StdControl as "+eh.getFunction()+"Control;");
				}
			}
		}
		out.getWriter(M_RUNTIMEM_NC).println("//END of Error Handler Interfaces");
		out.getWriter(M_RUNTIMEM_NC).println("");
		out.getWriter(M_RUNTIMEM_NC).println("interface BAlloc;");
		out.getWriter(M_RUNTIMEM_NC).println("interface LocalTime;");
		out.getWriter(M_RUNTIMEM_NC).println("interface SGWakeup;");
		out.getWriter(M_RUNTIMEM_NC).println("interface Timer as localQTimer;");
		out.getWriter(M_RUNTIMEM_NC).println("interface Timer as remoteQTimer;");
		//out.getWriter(M_RUNTIMEM_NC).println("interface Timer as PathRateTimer;");
		//out.getWriter(M_RUNTIMEM_NC).println("interface Timer as DutyCycleTimer;");
		out.getWriter(M_RUNTIMEM_NC).println("interface Timer as SleepTimer;");
		//out.getWriter(M_RUNTIMEM_NC).println("interface Connect as RemoteConnect;");
		out.getWriter(M_RUNTIMEM_NC).println("interface StreamRead as RemoteRead;");
		out.getWriter(M_RUNTIMEM_NC).println("interface StreamWrite as RemoteWrite;");
		out.getWriter(M_RUNTIMEM_NC).println("interface IEnergyCost[uint8_t id];");
		out.getWriter(M_RUNTIMEM_NC).println("interface Leds;");
		out.getWriter(M_RUNTIMEM_NC).println("}");
		out.getWriter(M_RUNTIMEM_NC).println("}");
	}
	
	public static void generateRuntimeModuleImpl(ProgramGraph g, VirtualDirectory out)
	{
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();
		
		out.getWriter(M_RUNTIMEM_NC).println("implementation");
		out.getWriter(M_RUNTIMEM_NC).println("{");
		out.getWriter(M_RUNTIMEM_NC).println("");
		out.getWriter(M_RUNTIMEM_NC).println("#include \"fluxconst.h\"");
		out.getWriter(M_RUNTIMEM_NC).println("#include \"nodequeue.h\"");
		out.getWriter(M_RUNTIMEM_NC).println("#include \"nodes.h\"");
		out.getWriter(M_RUNTIMEM_NC).println("#include \"stats.h\"");
		
		
		
		out.getWriter(M_RUNTIMEM_NC).println("");
		out.getWriter(M_RUNTIMEM_NC).println("uint16_t session_id;");
		out.getWriter(M_RUNTIMEM_NC).println("EdgeQueue moteQ;");
		out.getWriter(M_RUNTIMEM_NC).println("EdgeQueue remoteQ;");
		out.getWriter(M_RUNTIMEM_NC).println("bool localCAlive, remoteCAlive;");
		
		
		out.getWriter(M_RUNTIMEM_NC).println("");
		out.getWriter(M_RUNTIMEM_NC).println("#include \"calls.h\"");
		out.getWriter(M_RUNTIMEM_NC).println("#include \"marshaller.h\"");
		out.getWriter(M_RUNTIMEM_NC).println("#include \"fluxmarshal.h\"");
		out.getWriter(M_RUNTIMEM_NC).println("#include \"fluxhandler.h\"");
		
		
		out.getWriter(M_RUNTIMEM_NC).println("");
		
		generateRuntimeStdControlImpl(g,out);
		
		out.getWriter(M_RUNTIMEM_NC).println("//BEGIN EDGES");
		generateNodeDoneHandlers(g,out);
		generateErrDoneHandlers(g,out);
		out.getWriter(M_RUNTIMEM_NC).println("}");
		
	}
	
	public static void generateRuntimeModule(ProgramGraph g, VirtualDirectory out)
	{
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();
		
		generateRuntimeModuleHdr(g,out);
		generateRuntimeModuleImpl(g,out);
		
	} //generateRuntimeModule
	
	public static void generateRuntimeConfig(ProgramGraph g, VirtualDirectory out)
	{
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();
		
		generateRuntimeConfigHdr(g,out);
		generateRuntimeConfigImpl(g,out);
		
	} //generateRuntimeModule
	
	

	public static void generateRuntimeConfigHdr(ProgramGraph g, VirtualDirectory out)
	{
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();
		
		out.getWriter(M_RUNTIME_NC).println("includes nodes;\n");
		out.getWriter(M_RUNTIME_NC).println("configuration Runtime {");
		out.getWriter(M_RUNTIME_NC).println("}");
		
	}
	
	public static void generateRuntimeConfigImpl(ProgramGraph g, VirtualDirectory out)
	{
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();
		
		out.getWriter(M_RUNTIME_NC).println("implementation");
		out.getWriter(M_RUNTIME_NC).println("{");
		//out.getWriter(M_RUNTIME_NC).println("#include \"nodes.h\"\n");
		out.getWriter(M_RUNTIME_NC).println("components ");
		
		while (it.hasNext()) 
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
						
			if (!isNodeAbstract(g,td.getName()) && td.getPlatformName().equals("TELOS"))
			{
				out.getWriter(M_RUNTIME_NC).print(td.getName()+", ");
			}
		}
		Vector<ErrorHandler> errs = p.getErrorHandlers();
		for (ErrorHandler eh : errs)
		{
			TaskDeclaration td = g.findTask(eh.getTarget());
			if (td.getPlatformName().equals("TELOS"))
			{
				out.getWriter(M_RUNTIME_NC).print(eh.getFunction()+", ");
			}
		}
			
		out.getWriter(M_RUNTIME_NC).println("");
		out.getWriter(M_RUNTIME_NC).println("Main, TimerC, RuntimeM, BAllocC, UARTTinyStream as Stream,");
		out.getWriter(M_RUNTIME_NC).println("Stargate, LedsC as Leds;");
		out.getWriter(M_RUNTIME_NC).println("");
		
		out.getWriter(M_RUNTIME_NC).println("Main.StdControl -> RuntimeM.StdControl;");
		out.getWriter(M_RUNTIME_NC).println("Main.StdControl -> BAllocC.StdControl;");
		out.getWriter(M_RUNTIME_NC).println("Main.StdControl -> TimerC.StdControl;");
		out.getWriter(M_RUNTIME_NC).println("Main.StdControl -> Stream.StdControl;");
		out.getWriter(M_RUNTIME_NC).println("Main.StdControl -> Stargate.StdControl;");
		out.getWriter(M_RUNTIME_NC).println("");
		out.getWriter(M_RUNTIME_NC).println("RuntimeM.Leds -> Leds;");
		out.getWriter(M_RUNTIME_NC).println("RuntimeM.BAlloc -> BAllocC.BAlloc;");
		out.getWriter(M_RUNTIME_NC).println("RuntimeM.LocalTime -> TimerC.LocalTime;");
		out.getWriter(M_RUNTIME_NC).println("RuntimeM.localQTimer -> TimerC.Timer[unique(\"Timer\")];");
		out.getWriter(M_RUNTIME_NC).println("RuntimeM.remoteQTimer -> TimerC.Timer[unique(\"Timer\")];");
		//out.getWriter(M_RUNTIME_NC).println("RuntimeM.PathRateTimer -> TimerC.Timer[unique(\"Timer\")];");
		//out.getWriter(M_RUNTIME_NC).println("RuntimeM.DutyCycleTimer -> TimerC.Timer[unique(\"Timer\")];");
		out.getWriter(M_RUNTIME_NC).println("RuntimeM.SleepTimer -> TimerC.Timer[unique(\"Timer\")];");
		out.getWriter(M_RUNTIME_NC).println("");
		//out.getWriter(M_RUNTIME_NC).println("RuntimeM.RemoteConnect -> Stream.Connect;");
		out.getWriter(M_RUNTIME_NC).println("RuntimeM.RemoteRead -> Stream.StreamRead;");
		out.getWriter(M_RUNTIME_NC).println("RuntimeM.RemoteWrite -> Stream.StreamWrite;");
		out.getWriter(M_RUNTIME_NC).println("RuntimeM.SGWakeup -> Stargate.SGWakeup;");
		out.getWriter(M_RUNTIME_NC).println("");
		out.getWriter(M_RUNTIME_NC).println("//NODE Wiring");
		
		it = fns.iterator();
		while (it.hasNext()) 
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
						
			if (!isNodeAbstract(g,td.getName()) && td.getPlatformName().equals("TELOS"))
			{
				out.getWriter(M_RUNTIME_NC).print("RuntimeM.I"+td.getName()+" -> ");
				out.getWriter(M_RUNTIME_NC).println(td.getName()+".I"+td.getName()+";");
				out.getWriter(M_RUNTIME_NC).print("RuntimeM."+td.getName()+"Control -> ");
				out.getWriter(M_RUNTIME_NC).println(td.getName()+".StdControl;");
			}
		}
		
		
		for (ErrorHandler eh : errs)
		{
			TaskDeclaration td = g.findTask(eh.getTarget());
			if (td.getPlatformName().equals("TELOS"))
			{
				out.getWriter(M_RUNTIME_NC).print("RuntimeM.I"+eh.getFunction()+" -> ");
				out.getWriter(M_RUNTIME_NC).print(eh.getFunction()+".I"+eh.getFunction()+";");
				out.getWriter(M_RUNTIME_NC).print("RuntimeM."+eh.getFunction()+"Control -> ");
				out.getWriter(M_RUNTIME_NC).println(eh.getFunction()+".StdControl;");
			}
		}
		
		it = fns.iterator();
		while (it.hasNext()) 
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
						
			/*if (!isNodeAbstract(g,td.getName()) && td.getPlatformName().equals("TELOS"))
			{
				out.getWriter(M_RUNTIME_NC).print("RuntimeM.IEnergyCost["+td.getName().toUpperCase()+"_NODEID] -> ");
				out.getWriter(M_RUNTIME_NC).println(td.getName()+".IEnergyCost;");
			}*/
		}
		out.getWriter(M_RUNTIME_NC).println("}\n");
	}
	
	
	
	public static void printHHeader(String name, PrintWriter out)
	{
		String newname = name.replace('.','_');
		out.println("#ifndef "+newname.toUpperCase()+"_INCLUDED");
		out.println("#define "+newname.toUpperCase()+"_INCLUDED");
		out.println("");
	}
	
	public static void printHFooter(String name, PrintWriter out)
	{
		String newname = name.replace('.','_');
		out.println("#endif // "+newname.toUpperCase()+"_INCLUDED");
	}
	
	public static void generateStructs(ProgramGraph g, VirtualDirectory out)
	{
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();
		
		printHHeader(M_STRUCT_H,out.getWriter(M_STRUCT_H));
		
		out.getWriter(M_STRUCT_H).println("#include \"rt_structs.h\"");
		out.getWriter(M_STRUCT_H).println("#include \"userstructs.h\"");
		out.getWriter(M_STRUCT_H).println("");
		
		while (it.hasNext()) 
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
			//printStructs(td, out.getWriter(M_STRUCT_H));
			
			
			if (!g.isSource(td.getName()))
			{
				generateInStruct(td,out.getWriter(M_STRUCT_H));
				
			} 
			generateOutStruct(td,out.getWriter(M_STRUCT_H));
			
		}
		
		printHFooter(M_STRUCT_H,out.getWriter(M_STRUCT_H));
		
	}
	
	public static void generateNodeDoneHandler(TaskDeclaration td, ProgramGraph g, PrintWriter out)
	{
		out.print("event result_t I"+td.getName()+".nodeDone(");
		out.println(td.getName()+"_in **in,"+td.getName()+"_out **out, uint8_t error)");
		out.println("{");
		out.println("result_t result;");
		out.println("uint32_t now;");

		out.println("now = call LocalTime.read();");
		//out.print("factorTime("+td.getName().toUpperCase()+"_NODEID,");
		//out.println("(*out)->_pdata.starttime, now);");
		out.println("if (error != ERR_OK)");
		out.println("{");
		out.print("return handle_error("+td.getName().toUpperCase()+"_NODEID,");
		out.println("(Handle)in, error);");
		out.println("}");
		out.println("//free previous in variable.");
		out.println("result = call BAlloc.free((Handle)in);");
		out.println("if (result == FAIL)");
		out.println("{");
		out.println("return handle_error("+td.getName().toUpperCase()+"_NODEID,NULL,ERR_FREEMEM);");
		out.println("}");
		
		Vertex vert = g.getVertex(td.getName());
		EdgeIterator ei = g.getGraph().incidentEdges(vert,EdgeDirection.OUT);
		while (ei.hasNext())
		{
			Edge e = ei.nextEdge();
			//out.println("Edge: "+g.getGraph().origin(e)+"->"+g.getGraph().destination(e)+"("+e+")");
			
			Vertex src,dest;
			GraphNode srcnode,destnode;
			TaskDeclaration srctd, desttd;
			src = g.getGraph().origin(e);
			dest = g.getGraph().destination(e);
			srcnode = (GraphNode)src.element();
			destnode = (GraphNode)dest.element();
			
			
			if (destnode.getNodeType() != GraphNode.ERROR &&
					destnode.getNodeType() != GraphNode.ERROR_HANDLER)
			{
				if (dest == g.getVertexExit())
				{
					out.println("result = handle_exit((Handle)out);");
				} else {
					desttd = (TaskDeclaration)destnode.getElement();
					out.println("result = handle_edge("+desttd.getName().toUpperCase()+"_NODEID,");
					out.println("(Handle)out,");
					String plat = desttd.getPlatformName();
					if (plat == null || plat.equals("TELOS"))
					{
						out.print("TRUE");
					} else {
						out.print("FALSE");
					}
					out.println(","+e.get("count")+");");
				}
			}
			
			
			
		}
		out.println("return result;");
		out.println("}");
	}
	
	public static void generateSrcFiredHandler(TaskDeclaration td, ProgramGraph g, PrintWriter out)
	{
		out.print("event result_t I"+td.getName()+".srcFired(");
		out.println(td.getName()+"_out **out)");
		out.println("{");
		out.println("result_t result;");
		out.println("uint16_t session;");
		out.println("");
		out.println("session = getNextSession();");
		out.println("");
		
		Vertex vert = g.getVertex(td.getName());
		EdgeIterator inedges = g.getGraph().incidentEdges(vert,EdgeDirection.IN);
		if (inedges.hasNext())
		{
			Edge e = inedges.nextEdge();
			System.out.println("Edge Wt="+e.get("count"));
			out.println("(*out)->_pdata.weight = "+e.get("count")+";");
		} else {
			System.out.println("ERROR.  NO EDGE FROM ENTRY -> "+td.getName());
			return;
		}
		
		EdgeIterator ei = g.getGraph().incidentEdges(vert,EdgeDirection.OUT);
		while (ei.hasNext())
		{
			Edge e = ei.nextEdge();
			//out.println("Edge: "+g.getGraph().origin(e)+"->"+g.getGraph().destination(e)+"("+e+")");
			
			Vertex src,dest;
			GraphNode srcnode,destnode;
			TaskDeclaration srctd, desttd;
			src = g.getGraph().origin(e);
			dest = g.getGraph().destination(e);
			srcnode = (GraphNode)src.element();
			destnode = (GraphNode)dest.element();
			
			
			if (destnode.getNodeType() != GraphNode.ERROR &&
					destnode.getNodeType() != GraphNode.ERROR_HANDLER)
			{
				if (dest == g.getVertexExit())
				{
					out.println("result = handle_exit((Handle)out);");
				} else {
					desttd = (TaskDeclaration)destnode.getElement();
					out.println("result = handle_src_edge("+desttd.getName().toUpperCase()+"_NODEID,");
					out.print("(Handle)out,");
					out.println("session,");
					String plat = desttd.getPlatformName();
					if (plat == null || plat.equals("TELOS"))
					{
						out.print("TRUE");
					} else {
						out.print("FALSE");
					}
					out.println(","+e.get("count")+");");
				}
			}
			
			
			
		}
		out.println("return result;");
		out.println("}");
	}
	
	public static void generateNodeDoneHandlers(ProgramGraph g, VirtualDirectory out)
	{
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();
		
		while (it.hasNext()) 
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
			
			
			if (!isNodeAbstract(g,td.getName()) && !g.isSource(td.getName()))
			{
				if (td.getPlatformName().equals("TELOS"))
				{
					generateNodeDoneHandler(td,g,out.getWriter(M_EDGES_NC));
				
				}
			}
			
			if (!isNodeAbstract(g,td.getName()) && g.isSource(td.getName()))
			{
				if (td.getPlatformName().equals("TELOS"))
				{
					generateSrcFiredHandler(td,g,out.getWriter(M_EDGES_NC));
				
				}
			}
		}
		
	}
	
	
	public static void generateErrDoneHandler(ErrorHandler eh, PrintWriter out)
	{
		out.print("event result_t I"+eh.getFunction()+".errDone(");
		out.println(eh.getTarget()+"_in **in)");
		out.println("{");
		out.println("handle_exit((Handle)in);");
		out.println("return SUCCESS;");
		out.println("}");
	}
		

	public static void generateErrDoneHandlers(ProgramGraph g, VirtualDirectory out)
	{
		Vector<ErrorHandler> errs = g.getProgram().getErrorHandlers();
		
		for (ErrorHandler eh : errs) 
		{
			TaskDeclaration td = g.findTask(eh.getTarget());
			if (td.getPlatformName().equals("TELOS"))
			{
				generateErrDoneHandler(eh,out.getWriter(M_EDGES_NC));
				
			}
		}
	
	}
	
	
	
	public static int getStateID(ProgramGraph g, String state)
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
	
	public static String getMinPathState(ProgramGraph g, Vector<Vertex> path, int endidx)
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

	public static boolean isEdgeLocal(Vertex a, Vertex b, ProgramGraph g)
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
	
	public static void generatePathEnergyCalculator(int index, PrintWriter pw, 
			Vector<Vertex> path, boolean maximum, ProgramGraph g)
	{
		pw.print("return (");
		
		int localcount = 0;
		int remotecount = 0;
		
		for (int i=0; i < path.size(); i++)
		{
			Vertex cur = path.get(i);
			Vertex next = null;
			if (i < (path.size()-1) ) next = path.get(i+1);
			boolean wrote = false;
			
			GraphNode curnode,nextnode;
			curnode = (GraphNode)cur.element();
			if (curnode.getElement() instanceof TaskDeclaration)
			{
				wrote = true;
				TaskDeclaration td = (TaskDeclaration)curnode.getElement();
				
				if (maximum)
				{
					pw.print("getMaxNodeEnergy("+td.getName().toUpperCase()+"_NODEID)");
				} else {
					pw.print("(state <= STATE_"+getMinPathState(g,path,i).toUpperCase());
					pw.print(" ? getMinNodeEnergy("+td.getName().toUpperCase()+"_NODEID) ");
					pw.print(" : getMaxNodeEnergy("+td.getName().toUpperCase()+"_NODEID))");
				}
				
			}
			if (next != null)
			{
				//is the edge local or remote?
				if (isEdgeLocal(cur,next,g))
				{
					localcount++;
				} else {
					remotecount++;
				}
					
				/*nextnode = (GraphNode)next.element();
				if (nextnode.getElement() instanceof TaskDeclaration)
				{
					TaskDeclaration nexttd = (TaskDeclaration)nextnode.getElement();
					
				}*/
				
			}
			
			
			if (next != null && wrote)
			{
				pw.println("+");
			}
		}
		pw.print(" ("+localcount+" * LOCALEDGEENERGY) + ("+remotecount+" * REMOTEEDGEENERGY)");
		pw.println(");");
	}
	
	public static void generatePathEnergyCalculators(PrintWriter pw, Vector<Vector<Vertex>> paths, 
														ProgramGraph g)
	{
		pw.println("//get the max energy (in mJ) for one node");
		pw.println("double getMaxNodeEnergy(uint16_t nodeid)");
		pw.println("{");
		pw.println("return (nodeTimeMS[nodeid] * nodePowerMax[nodeid]);");
		pw.println("}");
		pw.println("//get the min energy (in mJ) for one node");
		pw.println("double getMinNodeEnergy(uint16_t nodeid)");
		pw.println("{");
		pw.println("return (nodeTimeMS[nodeid] * nodePowerMin[nodeid]);");
		pw.println("}");
		pw.println("//get the energy (in mJ) for one request down path");
		pw.println("double getMaxPathEnergy(uint8_t path, uint8_t states)");
		pw.println("{");
		pw.println("switch(path)");
		pw.println("{");
		for (int i=0; i < paths.size(); i++)
		{
			pw.println("case ("+i+"):");
			pw.println("{");
			Vector<Vertex> v = paths.get(i);
			generatePathEnergyCalculator(i,pw,v,true, g);
			pw.println("}");
		}
		pw.println("}");
		pw.println("return -1.0;");
		pw.println("}");
		pw.println("");
		pw.println("//get the energy (in mJ) for one request down path");
		pw.println("double getMinPathEnergy(uint8_t path, uint8_t state)");
		pw.println("{");
		pw.println("switch(path)");
		pw.println("{");
		for (int i=0; i < paths.size(); i++)
		{
			pw.println("case ("+i+"):");
			pw.println("{");
			Vector<Vertex> v = paths.get(i);
			generatePathEnergyCalculator(i,pw,v,false, g);
			pw.println("}");
		}
		pw.println("}");
		pw.println("return -1.0;");
		pw.println("}");
		
		pw.println("\n#include \"nodepower.h\"\n");
	}
	
	public static void generateNodesHeader(ProgramGraph g, VirtualDirectory out, boolean needint)
	{
		int i;
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();
		
		
		printHHeader(M_NODES_H,out.getWriter(M_NODES_H));
		
		if (needint)
		{
			out.getWriter(M_NODES_H).println("#include <stdint.h>");
			out.getWriter(M_NODES_H).println("#define TRUE 1");
			out.getWriter(M_NODES_H).println("#define FALSE 0");
		}
		
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
		
		//generate state ids
		Vector<String> sts = g.getProgram().getStates().GetAllStates();
		it = sts.iterator();
		int state_count = 0;
		int max_state = 0;
		for (String s: sts) 
		{						
			//out.getWriter(M_NODES_H).println("#define STATE_"+s.toUpperCase()+" "+state_count);
			out.getWriter(M_NODES_H).println("#define STATE_"+s.toUpperCase()+" "+g.getProgram().getStates().GetStateLevel(s));
			state_count++;
			if (g.getProgram().getStates().GetStateLevel(s) > max_state) max_state = g.getProgram().getStates().GetStateLevel(s);
			
		}
		//out.getWriter(M_NODES_H).println("#define NUMSTATES "+state_count);
		out.getWriter(M_NODES_H).println("#define NUMSTATES "+(max_state+1));
		out.getWriter(M_NODES_H).println("");
		out.getWriter(M_NODES_H).println("#define WAKEPOWER 1.5 //W");
		out.getWriter(M_NODES_H).println("#define IDLEPOWER 0.005 //W");
		out.getWriter(M_NODES_H).println("#define STARGATEIDLEPOWER 1.2 //W");
		out.getWriter(M_NODES_H).println("#define LOCALEDGEENERGY 1.42 //mJ");
		out.getWriter(M_NODES_H).println("#define REMOTEEDGEENERGY 1.42 //mJ");
		out.getWriter(M_NODES_H).println("double wakeTimeMS = 0.0;");
		
		Vector<Vector<Vertex>> paths = g.getPaths();
		out.getWriter(M_NODES_H).println("#define NUMPATHS "+paths.size());
		out.getWriter(M_NODES_H).println("#define PATHRATESECONDS 20 //Path rates are in requests/PATHRATESECONDS");
		out.getWriter(M_NODES_H).println("#define PATHRATEHISTORY 30 //Path rate averages over PATHRATEHISTORY samples");
		
		out.getWriter(M_NODES_H).println("uint8_t curstate = STATE_BASE;");
		out.getWriter(M_NODES_H).print("uint8_t minPathState[NUMPATHS]={");
		for (i=0; i < paths.size(); i++)
		{
			Vector<Vertex> path = paths.get(i);
			
			String state = getMinPathState(g, path, path.size());
			
			out.getWriter(M_NODES_H).print("STATE_"+state.toUpperCase());
			if (i < (paths.size()-1))
				out.getWriter(M_NODES_H).print(",");
		}
		out.getWriter(M_NODES_H).println("};");
		
		//***********
		out.getWriter(M_NODES_H).print("uint8_t isPathTimed[NUMPATHS]={");
		Vector<Integer> timedPaths = new Vector<Integer>();
		for (i=0; i < paths.size(); i++)
		{
			Vector<Vertex> path = paths.get(i);
			
			Vertex v = path.get(1);
			GraphNode node = (GraphNode)v.element();
			TaskDeclaration td = (TaskDeclaration)node.getElement();
			
			if (g.isTimedSource(td.getName()))
			{
				timedPaths.add(i);
				out.getWriter(M_NODES_H).print("TRUE");
			} else {
				out.getWriter(M_NODES_H).print("FALSE");
			}
			if (i < (paths.size()-1))
				out.getWriter(M_NODES_H).print(",");
		}
		out.getWriter(M_NODES_H).println("};");
		
		//***********
		out.getWriter(M_NODES_H).print("uint8_t pathSrc[NUMPATHS]={");
		//Vector<Integer> timedPaths = new Vector<Integer>();
		int maxidx = 0;
		for (i=0; i < paths.size(); i++)
		{
			Vector<Vertex> path = paths.get(i);
			
			Vertex v = path.get(1);
			GraphNode node = (GraphNode)v.element();
			TaskDeclaration td = (TaskDeclaration)node.getElement();
			
			Integer idx = getSourceNum(g,td.getName());
			if (idx > maxidx) maxidx = idx;
			
			out.getWriter(M_NODES_H).print(idx);
			if (i < (paths.size()-1))
				out.getWriter(M_NODES_H).print(",");
		}
		out.getWriter(M_NODES_H).println("};");
		out.getWriter(M_NODES_H).println("#define NUMSOURCES "+(maxidx+1));
		out.getWriter(M_NODES_H).println("#define NUMTIMEDPATHS "+timedPaths.size());
		out.getWriter(M_NODES_H).println("uint8_t timedPaths[NUMTIMEDPATHS]={");
		i=0;
		for (Integer pathidx: timedPaths)
		{
			out.getWriter(M_NODES_H).print(pathidx.toString());
			if (i < (timedPaths.size()-1))
			{
				out.getWriter(M_NODES_H).print(",");
			}
		}
		out.getWriter(M_NODES_H).println("};");
		
		out.getWriter(M_NODES_H).println("uint32_t timerVals[NUMSOURCES][NUMSTATES][2]={");
		generateTimedSourceInit(g,out);
		out.getWriter(M_NODES_H).println("};");
		
		out.getWriter(M_NODES_H).print("uint8_t srcNodes[NUMSOURCES][2]={");
		Vector<Source> srcs = g.getProgram().getSources();
		i=0;
		for (Source s: srcs)
		{
			out.getWriter(M_NODES_H).print("{");
			if (g.isTimedSource(s.getSourceFunction()))
			{
				out.getWriter(M_NODES_H).print("TRUE,");
			} else {
				out.getWriter(M_NODES_H).print("FALSE,");
			}
			out.getWriter(M_NODES_H).print(nodeID.get(s.getSourceFunction()));
			out.getWriter(M_NODES_H).print("}");
			if (i < (srcs.size()-1))
			{
				out.getWriter(M_NODES_H).print(",");
			}
			i++;
		}
		out.getWriter(M_NODES_H).println("};");
		//generatePathEnergyCalculators(out.getWriter(M_NODES_H), paths,g);
		
		/*
		//DEBUG OUTPUT
		EdgeIterator myit = g.getGraph().edges();
		while (myit.hasNext())
		{
			Edge e = (Edge)myit.nextEdge();
			Vertex src,dest;
			GraphNode srcnode,destnode;
			TaskDeclaration srctd, desttd;
			src = g.getGraph().origin(e);
			dest = g.getGraph().destination(e);
			srcnode = (GraphNode)src.element();
			destnode = (GraphNode)dest.element();
			
			//System.out.print("Edge from ("+srcnode+")["+srcnode.getNodeType()+"] to ("+destnode+")["+destnode.getNodeType()+"][");
			//System.out.println(e.get("count")+"]");
		}
		//END DEBUG
		*/
		
		printHFooter(M_NODES_H,out.getWriter(M_NODES_H));
		
	}
	
	public static String getProperState(String state)
	{
		if (state == null || state.equals(" ") || state.equals("*"))
		{
			return "BASE";			
		}
		return state;
	}
	
	public static Vector<SimpleFlowStatement> getFlowList(FlowStatement flow)
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
	
	public static void generateAbstractDeciders(ProgramGraph g, VirtualDirectory out) 
	{
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		
		while (it.hasNext()) 
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
			
			if (isNodeAbstract(g,td.getName()))
			{
				out.getWriter(M_CALLS_H).println("uint16_t decide"+td.getName()+"(EdgeIn *e, uint16_t *wt)");
				out.getWriter(M_CALLS_H).println("{");
			
				Vector<Argument> inputs = td.getInputs();
				FlowStatement flow = g.getProgram().getFlow(td.getName());
				Vector<SimpleFlowStatement> paths = getFlowList(flow);
				
				for (SimpleFlowStatement sfs : paths)
				{
					Vector<String> types = sfs.getTypes();
					Vector<String> args = sfs.getArguments();
					String state = getProperState(sfs.getState());
					String target = args.get(0);
					
					if (types == null )
					{
						//System.out.println("getting args for "+td.getName()+":"+sfs);
						out.getWriter(M_CALLS_H).println("if (isFunctionalState(STATE_"+state.toUpperCase()+"))");
											
					} 
					else 
					{
						if (types.size() != inputs.size())
						{
							System.out.println("Task("+td+"): inputs and types of different arrity.");
							System.out.println("Fix it.  Bad things will probably happen if you don't.");
						}
						out.getWriter(M_CALLS_H).print("if (");

						int count = 0;
						for (String s : types)
						{
							if (s.equals("*"))
							{
								out.getWriter(M_CALLS_H).print("TRUE");
							} else {
								Argument arg = inputs.get(count);
								out.getWriter(M_CALLS_H).print(p.getType(s).getFunction()+"(");
								out.getWriter(M_CALLS_H).print("(*(("+td.getName()+"_in**)");
								out.getWriter(M_CALLS_H).print("(e->invar)))->"+arg.getName()+")");
							}
							out.getWriter(M_CALLS_H).print(" && ");
							count++;
						}
						out.getWriter(M_CALLS_H).println("isFunctionalState(STATE_"+state.toUpperCase()+"))");
						
					}
					
					out.getWriter(M_CALLS_H).println("{");

					int weight = getEdgeWeight(g, td.getName(),target, types, state);
					out.getWriter(M_CALLS_H).println("*wt = "+weight+";");
					
					//end weight
					out.getWriter(M_CALLS_H).println("return "+target.toUpperCase()+"_NODEID;");
					out.getWriter(M_CALLS_H).println("}");
					
				}
				
				out.getWriter(M_CALLS_H).println("return NO_NODEID; //Error state");
				out.getWriter(M_CALLS_H).println("}\n");
				
			}
		}
		out.getWriter(M_CALLS_H).println("//end deciders");
		
		
	}
	
	private static int getEdgeWeight(ProgramGraph g, String source, String target, Vector<String> typesVector, String state)
	{
		String types = "";
		String signature = "[]";
		state = state.trim();
		if (state.equals("BASE"))
			state = "*"; 
				
		if (typesVector != null)
		{
			types = typesVector.toString();	
		 
			types = types.replace("[", " ");
			types = types.replace("]", " ");
			types = types.trim();
			signature = "[" + types + " | " + state + "]";
		}
		 
		int weight = g.getEdgeWeight(source, target, signature);
		//System.out.println("signature: " + signature + " : " + weight);
		return weight;
	}
	
	public static void generateCallHandlers(ProgramGraph g, VirtualDirectory out)
	{
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		//Program p = g.getProgram();
		//Collection<Source> sources = g.getSources();
		
		printHHeader(M_CALLS_H,out.getWriter(M_CALLS_H));
		
		
		out.getWriter(M_CALLS_H).println("#include \""+M_NODES_H+"\"\n");
		out.getWriter(M_CALLS_H).println("#include \""+M_TYPES_H+"\"\n");
		out.getWriter(M_CALLS_H).println("#include \"fluxhandler.h\"\n");
		
		generateAbstractDeciders(g,out);
		
		// generate is Local
		out.getWriter(M_CALLS_H).println("bool islocal(uint16_t nodeid)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("switch(nodeid)");
		out.getWriter(M_CALLS_H).println("{");
		it = fns.iterator();
		while (it.hasNext()) 	
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
			
			out.getWriter(M_CALLS_H).print("case "+td.getName().toUpperCase()+"_NODEID: ");
			
			if (td.getPlatformName().equals("TELOS"))
			{
				out.getWriter(M_CALLS_H).println("return TRUE;");
			} else {
				out.getWriter(M_CALLS_H).println("return FALSE;");
			}
		}
		
		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return FALSE;");
		out.getWriter(M_CALLS_H).println("}//islocal");
		
		//		generate translateID
		out.getWriter(M_CALLS_H).println("uint16_t translateID(EdgeIn *e, uint16_t *wt)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("*wt = 0;");
		out.getWriter(M_CALLS_H).println("switch(e->node_id)");
		out.getWriter(M_CALLS_H).println("{");
		it = fns.iterator();
		while (it.hasNext()) 	
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
			
			out.getWriter(M_CALLS_H).print("case "+td.getName().toUpperCase()+"_NODEID: ");
			
			if (isNodeAbstract(g,td.getName()))
			{
				out.getWriter(M_CALLS_H).println("return decide"+td.getName()+"(e,wt);");
			} else {
				out.getWriter(M_CALLS_H).println("return e->node_id;");
			}
		}
		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return NO_NODEID; //should never happen");
		out.getWriter(M_CALLS_H).println("}//translateID\n");
		
//		generate translateIDAll

		out.getWriter(M_CALLS_H).println("uint16_t translateIDAll(EdgeIn *e, uint16_t *wt)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("bool change=TRUE;");
		out.getWriter(M_CALLS_H).println("uint16_t result = NO_NODEID;");
		out.getWriter(M_CALLS_H).println("uint16_t original = e->node_id;");
		out.getWriter(M_CALLS_H).println("uint16_t totalwt = 0;");
		out.getWriter(M_CALLS_H).println("uint16_t nodewt = 0;");
		out.getWriter(M_CALLS_H).println("while (change)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("nodewt = 0;");
		out.getWriter(M_CALLS_H).println("result = translateID(e,&nodewt);");
		out.getWriter(M_CALLS_H).println("if (result == NO_NODEID) return result;");
		out.getWriter(M_CALLS_H).println("change = (result != e->node_id);");
		out.getWriter(M_CALLS_H).println("if (change)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("totalwt += nodewt;");
		out.getWriter(M_CALLS_H).println("e->node_id = result;");
		out.getWriter(M_CALLS_H).println("}");
		out.getWriter(M_CALLS_H).println("}");
		out.getWriter(M_CALLS_H).println("*wt = totalwt;");
		out.getWriter(M_CALLS_H).println("e->node_id = original;");
		out.getWriter(M_CALLS_H).println("return result;");
		out.getWriter(M_CALLS_H).println("}\n");
		
		
		//		generate isReadyByID
		out.getWriter(M_CALLS_H).println("bool isReadyByID(EdgeIn *e)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("uint16_t wt;");
		out.getWriter(M_CALLS_H).println("uint16_t dest = translateIDAll(e,&wt);");
		out.getWriter(M_CALLS_H).println("e->node_id = dest;");
		out.getWriter(M_CALLS_H).println("((GenericNode*)(*(e->invar)))->_pdata.weight += wt;");
		out.getWriter(M_CALLS_H).println("");
		out.getWriter(M_CALLS_H).println("switch(dest)");
		out.getWriter(M_CALLS_H).println("{");
		it = fns.iterator();
		while (it.hasNext()) 	
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
					
			
			
			if (!isNodeAbstract(g,td.getName()) && !g.isSource(td.getName()) &&
					td.getPlatformName().equals("TELOS"))
			{
				out.getWriter(M_CALLS_H).print("case "+td.getName().toUpperCase()+"_NODEID: ");
				out.getWriter(M_CALLS_H).println("return call I"+td.getName()+".ready();");
			} 
		}
		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return TRUE; //should never happen");
		out.getWriter(M_CALLS_H).println("}//isReadyByID\n");
		
//		generate getOutSize
		out.getWriter(M_CALLS_H).println("result_t getOutSize(EdgeIn *e)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("uint16_t dest = e->node_id;");
		out.getWriter(M_CALLS_H).println("switch(dest)");
		out.getWriter(M_CALLS_H).println("{");
		it = fns.iterator();
		while (it.hasNext()) 	
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
								
			if (!isNodeAbstract(g,td.getName()) && !g.isSource(td.getName()) &&
					td.getPlatformName().equals("TELOS"))
			{
				out.getWriter(M_CALLS_H).println("case "+td.getName().toUpperCase()+"_NODEID: ");
				out.getWriter(M_CALLS_H).println("return sizeof("+td.getName()+"_out);");
				
			} 
		}
		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return 0; //should never happen");
		out.getWriter(M_CALLS_H).println("}//getOutSize\n");
		
		
		
//		generate callEdge
		out.getWriter(M_CALLS_H).println("result_t callEdge(EdgeIn *e)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("uint16_t dest = e->node_id;");
		out.getWriter(M_CALLS_H).println("uint16_t outsize;");
		out.getWriter(M_CALLS_H).println("result_t result;");
		
//		allocate output var;
		out.getWriter(M_CALLS_H).println("outsize = getOutSize(e);");
		out.getWriter(M_CALLS_H).println("if (outsize == 0) return FAIL;");
		out.getWriter(M_CALLS_H).println("result = call BAlloc.allocate ((HandlePtr)&(e->outvar), outsize);");
		out.getWriter(M_CALLS_H).println("if (result == FAIL)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("return handle_error (e->node_id, (Handle)e->invar, ERR_NOMEMORY);");
		out.getWriter(M_CALLS_H).println("}");
		
		// on your mark...
		out.getWriter(M_CALLS_H).println("((GenericNode*)(*(e->invar)))->_pdata.starttime = call LocalTime.read();");
		out.getWriter(M_CALLS_H).println("((GenericNode*)(*(e->outvar)))->_pdata.starttime = ((GenericNode*)(*(e->invar)))->_pdata.starttime;");
		out.getWriter(M_CALLS_H).println("((GenericNode*)(*(e->outvar)))->_pdata.weight = ((GenericNode*)(*(e->invar)))->_pdata.weight;");
		
		
		out.getWriter(M_CALLS_H).println("switch(dest)");
		out.getWriter(M_CALLS_H).println("{");
		it = fns.iterator();
		while (it.hasNext()) 	
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
								
			if (!isNodeAbstract(g,td.getName()) && !g.isSource(td.getName()) &&
					td.getPlatformName().equals("TELOS"))
			{
				out.getWriter(M_CALLS_H).println("case "+td.getName().toUpperCase()+"_NODEID: ");
				out.getWriter(M_CALLS_H).print("return call I"+td.getName()+".nodeCall(");
				out.getWriter(M_CALLS_H).print("("+td.getName()+"_in**)e->invar,");
				out.getWriter(M_CALLS_H).println("("+td.getName()+"_out**)e->outvar);");
			} 
		}
		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return FALSE; //should never happen");
		out.getWriter(M_CALLS_H).println("}//callEdge\n");
		

		
//		generate callError
		out.getWriter(M_CALLS_H).println("result_t callError(uint16_t nodeid, Handle in, uint8_t error)");
		out.getWriter(M_CALLS_H).println("{");
				
		out.getWriter(M_CALLS_H).println("switch(nodeid)");
		out.getWriter(M_CALLS_H).println("{");
		
		Vector<ErrorHandler> errs = g.getProgram().getErrorHandlers();
		it = errs.iterator();
		while (it.hasNext()) 	
		{
			ErrorHandler eh = (ErrorHandler)it.next();
			TaskDeclaration target = g.getProgram().getTask(eh.getTarget());
		
			if (target.getPlatformName().equals("TELOS"))
			{
				out.getWriter(M_CALLS_H).println("case "+eh.getTarget().toUpperCase()+"_NODEID: ");
				out.getWriter(M_CALLS_H).print("return call I"+eh.getFunction()+".errCall(");
				out.getWriter(M_CALLS_H).println("("+target.getName()+"_in**)in,error);");
				
			} 
		}
		
		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return handle_exit(in);");
		out.getWriter(M_CALLS_H).println("}//callError\n");

		//		generate getErrorWeight
		out.getWriter(M_CALLS_H).println("uint16_t getErrorWeight(uint16_t nodeid)");
		out.getWriter(M_CALLS_H).println("{");
		
		out.getWriter(M_CALLS_H).println("switch(nodeid)");
		out.getWriter(M_CALLS_H).println("{");
		
		it = fns.iterator();
		while (it.hasNext()) 	
		{
			TaskDeclaration td = (TaskDeclaration)it.next();
			
			
			Vertex src = g.getVertex(td.getName());
			Vertex dest = null;
			Vector<ErrorHandler> errhs = g.getProgram().getErrorHandlers();
			
			for (ErrorHandler err : errhs)
			{
				if (err.getTarget().equals(td.getName()))
				{
					dest = g.getVertex(err.getFunction());
					break;
				}
			}
			if (dest == null)
			{
				dest = g.getVertexError();
			}
			//System.out.println("about to connect: " + src.toString() + " to " + dest.toString());
			int weight = g.getEdgeWeight(src, dest , null);
			
			out.getWriter(M_CALLS_H).println("case "+td.getName().toUpperCase()+"_NODEID: ");
			out.getWriter(M_CALLS_H).println("return "+weight+";");
			
			
		}
		
		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return 0;//This is an error");
		out.getWriter(M_CALLS_H).println("}//callError\n");
		
		
		
		printHFooter(M_CALLS_H,out.getWriter(M_CALLS_H));
		
	}
	
	
	public static void generateStruct(TaskDeclaration td, PrintWriter out, String trail, boolean in)
	{
		Vector<Argument> args;
		
		if (in)
		{
			args = td.getInputs();
		} else {
			args = td.getOutputs();
		}
		
		// if the ins are greater than zero, it can't be a source node?
		//if (ins.size() > 0) {
		out.println("typedef struct "+td.getName()+trail);
		out.println("{");
		out.println("\trt_data _pdata;");
		
		for (Argument a : args) 
		    out.println("\t"+a.getType()+" "+a.getName()+";");
		out.println("} "+td.getName()+trail+";");
		out.println();
		//}
	}
	
	public static boolean isNodeAbstract(ProgramGraph g, String name)
	{
		FlowStatement flow = g.getProgram().getFlow(name);
		if (flow == null)
			return false;
		return true;
	
	}
	
	public static void generateOutStruct(TaskDeclaration td, PrintWriter out) 
	{	
		generateStruct(td,out,"_out", false);
	}	
	
	public static void generateInStruct(TaskDeclaration td, PrintWriter out) 
	{
		generateStruct(td,out,"_in", true);
	}	
		
	public static void getNodeIDs(ProgramGraph pg)
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
	
	
	
	public static void generate(String root, ProgramGraph pg, Program pm, boolean stubbs) 
	throws IOException
	{
		//totalStages = h.size();
		//stageNumber = h;
		generate(root, pg, stubbs);
		
	}
	
	
	
	
	
	/**
	 * Generate a threaded program
	 * @param root The root directory to output into
	 * @param g The program graph
	 **/
	public static void generate(String root, ProgramGraph g, boolean stubbs) 
	throws IOException
	{
		
		//ProgramGraph progGraph = g;
		VirtualDirectory out = new VirtualDirectory(root);
		
		
		//prologue(g, out);
		defined.clear();
		getNodeIDs(g);
		if (stubbs)
		{
			generateNodes(g,out);
			generateErrHandlers(g,out);
		}
		
		generateStructs(g,out);
		generateNodesHeader(g,out, false);
		generateCallHandlers(g,out);
		
		generateRuntimeModule(g,out);
		generateRuntimeConfig(g,out);
		if (stubbs)
		{
			generateTypeChecks(g,out);
		}
		generateMarshallers(g, out);
		
		generateMakefile(g,out);
		//epilogue(out);
		out.flushAndClose();
		callBash("indent "+root+"/*.nc");
		callBash("indent "+root+"/*.h");
		callBash("rm "+root+"/*~");
	}
	

	public static int callBash(String s)
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
	
	
	public static void generateMakefile(ProgramGraph g, VirtualDirectory out)
	{
		out.getWriter(M_MAKEFILE).println("COMPONENT = Runtime");
		out.getWriter(M_MAKEFILE).println("PFLAGS +=-I%T/lib/TinyRely");
		out.getWriter(M_MAKEFILE).println("PFLAGS +=-Iruntime");
		out.getWriter(M_MAKEFILE).println("MSG_SIZE = 60");
		out.getWriter(M_MAKEFILE).println("include ../Makerules");
		out.getWriter(M_MAKEFILE).println("");
	
	}
	
	/*protected static int getStageNumber(String name) {
		Integer stg = stageNumber.get(name);
		if (stg == null) {
			stg = new Integer(totalStages);
			totalStages++;
			stageNumber.put(name, stg);
		}
		return stg.intValue();
	}*/
	
	/*public static void generateSimpleStatement
	(SimpleFlowStatement sfs, Program p, VirtualDirectory out) 
	{
		Vector<String> args = sfs.getArguments();
		
		for (int i=args.size()-1;i>=0;i--) {
			int stg = getStageNumber(args.get(i));
			out.getWriter(M_LOGIC_CPP).println
			("\t\tev->push("+stg+"); // "+args.get(i));
		}
	}*/
	
	
	
	/**
	 * Main routine
	 **/
	public static void main(String[] args) 
	throws Exception
	{
		parser p = new parser(new Yylex(new FileInputStream(args[0])));
		Program pm = (Program)p.parse().value;
		if (pm.verifyExpressions()) {
			pm.unifyExpressions();
			ProgramGraph pg = new ProgramGraph(pm);
			generate(args[1], pg, true);
		}
	}
}


