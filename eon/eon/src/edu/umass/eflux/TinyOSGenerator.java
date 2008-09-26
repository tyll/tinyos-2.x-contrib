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

public class TinyOSGenerator implements CodeGenerator {

	// private  ProgramGraph programGraph;

	protected  Hashtable<String, Boolean> defined = new Hashtable<String, Boolean>();

	protected  String M_STRUCT_H = "structs.h";

	protected  String M_NODES_H = "nodes.h";

	protected  String M_CALLS_H = "calls.h";

	protected  String M_TYPES_H = "typechecks.h";

	protected  String M_EDGES_NC = "RuntimeM.nc";

	protected  String M_RUNTIMEM_NC = "RuntimeM.nc";

	protected  String M_RUNTIME_NC = "Runtime.nc";

	protected  String M_MAKEFILE = "Makefile";

	protected  Hashtable<String, Integer> nodeID = new Hashtable<String, Integer>();

	// private  int totalStages;

	// The stage number corresponding to a given name.
	// private  Hashtable<String, Integer> stageNumber
	// = new Hashtable<String, Integer>();

	protected String MyName;

	public TinyOSGenerator()
	{
		MyName = "tinyos";
	}

	public String getName()
	{
		return MyName;
	}

	public Vector<String> getTargets()
	{
		Vector<String> plats = new Vector<String>();

		plats.add("tinyos");

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
		out.getWriter(M_NODES_H).println("// SOURCE_NUMBER_ definitions... to be used with timerVals");

		for (Source src : sources)
		{
			out.getWriter(M_NODES_H).println("#define SOURCE_NUMBER_" + src.source_fn.toUpperCase() + "\t" + s++);
		}

		s = 0;
		System.out.println("generateTSI...");

		out.getWriter(M_NODES_H).println("int32_t timerVals[NUMSOURCES][NUMSTATES][2] PROGMEM ={");
		for (Source src : sources)
		{
			System.out.println("Source:" + src);
			out.getWriter(M_NODES_H).print("{");

			if (g.isTimedSource(src.getSourceFunction()))
			{
				// make timeline
				Vector<TimeConstraint> timeline = new Vector<TimeConstraint>();
				int max = -1;
				int min = -1;
				int lvl = 0;

				System.out.println("ordering:" + ordering);
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
								System.out.println("max: " + max + " getLoVal(): " + thecon.getLoVal());
								System.out.println("WARNING: non-monotonic timer (LO)");
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
								System.out.println("min: " + max + " getHiVal(): " + thecon.getHiVal());
								System.out.println("WARNING: non-monotonic timer (Hi)");
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
					System.out.println("writing..." + i + ","
							+ (timeline.size() - 1));
					out.getWriter(M_NODES_H).print(
							"{" + themin + "L," + themax + "L}");
					if (i < (timeline.size() - 1)) {
						out.getWriter(M_NODES_H).print(",");
					}
					i++;

				}

			} else {
				int i = 0;
				for (Vector<String> level : ordering) {
					out.getWriter(M_NODES_H).print("{-1,-1}");
					if (i <= (ordering.size() - 1)) {
						out.getWriter(M_NODES_H).print(",");
					}
				}
			}
			out.getWriter(M_NODES_H).print("}");
			if (s < (sources.size() - 1)) {
				out.getWriter(M_NODES_H).print(",");
			}
			s++;
		}
		out.getWriter(M_NODES_H).println("};");

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

	public  Vector<String> getTypeType(ProgramGraph g,
			TypeDeclaration td, FlowStatement flow) {
		Vector<String> result = new Vector<String>();

		Vector<SimpleFlowStatement> flows = getFlowList(flow);
		for (SimpleFlowStatement sfs : flows) {
			// does this flow have types?
			Vector<String> vtypes = sfs.getTypes();
			if (vtypes != null) {
				// is this type in the flow
				int index = 0;
				for (String typ : vtypes) {
					if (typ.equals(td.getName())) {
						// it's here. What data type is it?
						String assignee = sfs.getAssignee();
						Vector<Argument> args = g.getProgram()
								.getTask(assignee).getInputs();
						Argument thearg = args.get(index);
						result.add(thearg.getType());

					}
					index++;
				}

			}// if
		}// for
		return result;

	}

	public  Vector<String> getAllTypeTypes(ProgramGraph g,
			TypeDeclaration td) {
		Collection fns = g.getFunctions();
		Iterator fit = fns.iterator();
		Vector<String> result = new Vector<String>();

		while (fit.hasNext()) {
			TaskDeclaration taskdec = (TaskDeclaration) fit.next();
			FlowStatement fs = g.getProgram().getFlow(taskdec.getName());
			if (fs != null) {
				Vector<String> datatypes = getTypeType(g, td, fs);
				// System.out.println("Matched : "+datatypes);
				result.addAll(datatypes);
			}
		}
		return result;
	}

	public  void generateTypeChecks(ProgramGraph g, VirtualDirectory out) {
		Iterator typeit = g.getProgram().getTypes().iterator();

		printHHeader(M_TYPES_H, out.getWriter(M_TYPES_H));

		//System.out.print("\n\n\n");

		while (typeit.hasNext()) {
			TypeDeclaration typedc = (TypeDeclaration) typeit.next();

			//System.out.println("Type check:"+
			// typedc.getName()+"-"+typedc.getFunction());

			// make sure that all types match
			Vector<String> thetypes = getAllTypeTypes(g, typedc);
			//System.out.println(thetypes);
			if (!thetypes.isEmpty()) {
				boolean bad = false;
				for (String s : thetypes) {

					if (!s.equals(thetypes.get(0))) {
						bad = true;
					}
				}// for
				if (bad)
				{
					System.out.println("Type: " + typedc.getName()
							+ " is mapped to multiple types." + thetypes);
				}

				out.getWriter(M_TYPES_H).println("bool " + typedc.getFunction() + "(" + thetypes.get(0)	+ " value)");
				out.getWriter(M_TYPES_H).println("{");
				out.getWriter(M_TYPES_H).println("return FALSE;");
				out.getWriter(M_TYPES_H).println("}");
				out.getWriter(M_TYPES_H).println("");
			}

		}
		//System.out.print("\n\n\n");
		printHFooter(M_TYPES_H, out.getWriter(M_TYPES_H));
	}

	/*public  void generateMarshallers(ProgramGraph g, VirtualDirectory out) {

		printHHeader(M_MARSHALL_H, out.getWriter(M_MARSHALL_H));

		out.getWriter(M_MARSHALL_H).println("#include \"fluxmarshal.h\"");

		Collection<TaskDeclaration> funcs = g.getProgram().getFunctions();
		for (TaskDeclaration td : funcs) {
			Vertex v = g.getVertex(td.getName());
			EdgeIterator eit = g.getGraph().incidentEdges(v, EdgeDirection.IN);
			boolean iscross = false;

			while (eit.hasNext()) {
				Edge ed = eit.nextEdge();
				if (!isEdgeLocal(g.getGraph().origin(ed), g.getGraph()
						.destination(ed), g)) {
					iscross = true;
				}

			}
			if (iscross) {
				int counter = 2;
				out
						.getWriter(M_MARSHALL_H)
						.println(
								"uint8_t encode_"
										+ td.getName()
										+ "_in(uint16_t connid, EdgeIn edge, int count)");
				out.getWriter(M_MARSHALL_H).println("{");
				// out.getWriter(M_MARSHALL_H).println("uint8_t result =
				// MARSH_OK;");
				out.getWriter(M_MARSHALL_H).println(td.getName() + "_in **in;");
				out.getWriter(M_MARSHALL_H).println(
						"in=(" + td.getName() + "_in**)edge.invar;");
				out.getWriter(M_MARSHALL_H).println("switch(count)");
				out.getWriter(M_MARSHALL_H).println("{");
				out.getWriter(M_MARSHALL_H).println("case 0:");
				out.getWriter(M_MARSHALL_H).println("{");
				out.getWriter(M_MARSHALL_H).println(
						"return encode_start(connid, edge.node_id);");
				out.getWriter(M_MARSHALL_H).println("}");

				out.getWriter(M_MARSHALL_H).println("case 1:");
				out.getWriter(M_MARSHALL_H).println("{");
				out.getWriter(M_MARSHALL_H).println(
						"return encode_session(connid, (*in)->_pdata);");
				out.getWriter(M_MARSHALL_H).println("}");

				Vector<Argument> ins = td.getInputs();

				for (Argument a : ins) {
					out.getWriter(M_MARSHALL_H)
							.println("case " + counter + ":");
					out.getWriter(M_MARSHALL_H).println("{");
					out.getWriter(M_MARSHALL_H).println(
							"return encode_" + a.getType() + "(connid, (*in)->"
									+ a.getName() + ");");
					out.getWriter(M_MARSHALL_H).println("}");
					counter++;

				}
				out.getWriter(M_MARSHALL_H).println("case " + counter + ":");
				out.getWriter(M_MARSHALL_H).println("{");
				out.getWriter(M_MARSHALL_H).println("return MARSH_DONE;");
				out.getWriter(M_MARSHALL_H).println("}");
				out.getWriter(M_MARSHALL_H).println("} //switch");

				out.getWriter(M_MARSHALL_H).println("return MARSH_ERR;");
				out.getWriter(M_MARSHALL_H).println("}\n");
			}
		}

		// generate the main marshalling func
		out.getWriter(M_MARSHALL_H).println(
				"bool encodeEdge(uint16_t connid, EdgeIn edge, int count)");
		out.getWriter(M_MARSHALL_H).println("{");
		out.getWriter(M_MARSHALL_H).println("switch(edge.node_id)");
		out.getWriter(M_MARSHALL_H).println("{");

		for (TaskDeclaration td : funcs) {
			Vertex v = g.getVertex(td.getName());
			EdgeIterator eit = g.getGraph().incidentEdges(v, EdgeDirection.IN);
			boolean iscross = false;

			while (eit.hasNext()) {
				Edge ed = eit.nextEdge();
				if (!isEdgeLocal(g.getGraph().origin(ed), g.getGraph()
						.destination(ed), g)) {
					iscross = true;
				}

			}
			if (iscross) {
				out.getWriter(M_MARSHALL_H).println(
						"case " + td.getName().toUpperCase() + "_NODEID:");
				out.getWriter(M_MARSHALL_H).println(
						"return encode_" + td.getName()
								+ "_in(connid,edge,count);");
			}
		}
		out.getWriter(M_MARSHALL_H).println("}");
		out
				.getWriter(M_MARSHALL_H)
				.println(
						"return MARSH_ERR; //you tried to encode an errant edge, dropping it into the ether.");
		out.getWriter(M_MARSHALL_H).println("}");

		printHFooter(M_MARSHALL_H, out.getWriter(M_MARSHALL_H));
	}*/

	public  void printCallParamDecl(TaskDeclaration td, PrintWriter out) {
		String name = td.getName();
		// Vector<Argument> ins = td.getInputs();
		// Vector<Argument> outs = td.getOutputs();

		out.print(name + "_in *in," + name + "_out *out");
	}

	public  void printCallDoneParamDecl(TaskDeclaration td,
			PrintWriter out) {
		// String name = td.getName();
		// Vector<Argument> ins = td.getInputs();
		// Vector<Argument> outs = td.getOutputs();
		printCallParamDecl(td, out);
		out.print("uint8_t error");
	}

	public  void generateStdControlImpl(PrintWriter pw) {
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

	public  void generateEnergyCostImpl(PrintWriter pw) {
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

	public  void generateSourceInterface(TaskDeclaration td,
			VirtualDirectory out, boolean timed) {
		String name = td.getName();
		String interfaceName = "I" + name;
		String filename = interfaceName + ".nc";
		out.getWriter(filename).println("includes structs;");
		out.getWriter(filename).println("interface " + interfaceName);
		out.getWriter(filename).println("{");
		out.getWriter(filename).println(
				"command result_t srcStart(" + name + "_out *out);");
		out.getWriter(filename).println(
				"event result_t srcFired(" + name + "_out *out);");
		if (timed) {
			out.getWriter(filename).println(
					"command result_t setInterval(uint32_t value);");
		}
		out.getWriter(filename).println("}");
	}

	public  void generateSourceConfig(TaskDeclaration td,
			VirtualDirectory out, boolean timed) {
		if (timed) {
			generateTimedSourceConfig(td, out);
		} else {
			generateNodeConfig(td, out);
		}
	}

	public  void generateTimedSourceConfig(TaskDeclaration td,
			VirtualDirectory out) {
		String name = td.getName();
		String mName = name + "M";
		String interfaceName = "I" + name;
		String filename = name + ".nc";
		out.getWriter(filename).println("configuration " + name);
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("provides {");
		out.getWriter(filename).println("interface StdControl;");
		out.getWriter(filename).println("interface " + interfaceName + ";");
		// out.getWriter(filename).println("interface IEnergyCost;");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("implementation");
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("components " + mName + ", TimerC;");
		out.getWriter(filename).println("");
		out.getWriter(filename).println(
				"StdControl = " + mName + ".StdControl;");

		out.getWriter(filename).println(
				interfaceName + " = " + mName + "." + interfaceName + ";");
		out.getWriter(filename).println(
				mName + ".Timer -> TimerC.Timer[unique(\"Timer\")];");
		// out.getWriter(filename).println("IEnergyCost =
		// "+mName+".IEnergyCost;");
		out.getWriter(filename).println("}");

	}

	public  void generateNodeModuleHeader(TaskDeclaration td,
			VirtualDirectory out) {
		String name = td.getName();
		String mName = name + "M";
		String interfaceName = "I" + name;
		String filename = mName + ".nc";

		out.getWriter(filename).println("includes structs;\n");
		out.getWriter(filename).println("module " + mName);
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("provides {");
		out.getWriter(filename).println("interface StdControl;");
		out.getWriter(filename).println("interface " + interfaceName + ";");
		// out.getWriter(filename).println("interface IEnergyCost;");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("implementation");
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("#include \"fluxconst.h\"\n");
		generateStdControlImpl(out.getWriter(filename));
		// generateEnergyCostImpl(out.getWriter(filename));

	}

	public  void generateTimedSourceModuleHeader(TaskDeclaration td,
			VirtualDirectory out) {
		String name = td.getName();
		String mName = name + "M";
		String interfaceName = "I" + name;
		String filename = mName + ".nc";

		out.getWriter(filename).println("includes structs;\n");
		out.getWriter(filename).println("module " + mName);
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("provides {");
		out.getWriter(filename).println("interface StdControl;");
		out.getWriter(filename).println("interface " + interfaceName + ";");
		// out.getWriter(filename).println("interface IEnergyCost;");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("uses {");
		out.getWriter(filename).println("interface Timer;");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("implementation");
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("#include \"fluxconst.h\"\n");
		out.getWriter(filename).println("uint32_t value_ms;");
		out.getWriter(filename).println("bool __started = FALSE;");
		out.getWriter(filename).println(name + "_out *myout = NULL;\n");
		generateStdControlImpl(out.getWriter(filename));
		// generateEnergyCostImpl(out.getWriter(filename));

	}

	public  void generateSourceModule(TaskDeclaration td,
			VirtualDirectory out, boolean timed) {
		String name = td.getName();
		String mName = name + "M";
		String interfaceName = "I" + name;
		String filename = mName + ".nc";

		if (timed) {
			generateTimedSourceModuleHeader(td, out);
		} else {
			generateNodeModuleHeader(td, out);
		}
		// generate source specific interface

		// srcStart Implementation
		out.getWriter(filename).print(
				"command result_t " + interfaceName + ".srcStart(");
		out.getWriter(filename).print(name + "_out *out");
		out.getWriter(filename).println(")");

		out.getWriter(filename).println("{");
		if (timed) {
			out.getWriter(filename).println("myout = out;");
		}

		out.getWriter(filename).println("return SUCCESS;");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("");
		if (timed) {
			// setInterval Implementation
			// TODO: Everytime you change the interval this resets the timer.
			// Should fix it so that it does this more intelligently
			out.getWriter(filename).print(
					"command result_t " + interfaceName + ".setInterval(");
			out.getWriter(filename).print("uint32_t value)");
			out.getWriter(filename).println("{");
			out.getWriter(filename).println("value_ms = value;");
			out.getWriter(filename).println("if (!__started)");
			out.getWriter(filename).println("{");
			out.getWriter(filename).println("__started = TRUE;");
			out.getWriter(filename).println("call Timer.start(TIMER_ONE_SHOT, value_ms);");
			out.getWriter(filename).println("}");
			out.getWriter(filename).println("return SUCCESS;");
			out.getWriter(filename).println("}");

			out.getWriter(filename).println("event result_t Timer.fired()");
			out.getWriter(filename).println("{");
			out.getWriter(filename).println("signal " + interfaceName + ".srcFired(myout);");
			out.getWriter(filename).println("call Timer.start(TIMER_ONE_SHOT, value_ms);");
			out.getWriter(filename).println("return SUCCESS;");
			out.getWriter(filename).println("}");

		}
		out.getWriter(filename).println("}");
	}

	public  void generateNodeInterface(TaskDeclaration td,
			VirtualDirectory out) {
		String name = td.getName();
		String interfaceName = "I" + name;
		String filename = interfaceName + ".nc";
		out.getWriter(filename).println("includes structs;");
		out.getWriter(filename).println("interface " + interfaceName);
		out.getWriter(filename).println("{");
		out.getWriter(filename).println(
				"command result_t nodeCall(" + name + "_in *in," + name
						+ "_out *out);");
		out.getWriter(filename).println(
				"event result_t nodeDone(" + name + "_in *in," + name
						+ "_out *out, uint8_t error);");
		out.getWriter(filename).println("}");
	}

	public  void generateNodeConfig(TaskDeclaration td,
			VirtualDirectory out) {
		String name = td.getName();
		String mName = name + "M";
		String interfaceName = "I" + name;
		String filename = name + ".nc";
		out.getWriter(filename).println("configuration " + name);
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("provides {");
		out.getWriter(filename).println("interface StdControl;");
		out.getWriter(filename).println("interface " + interfaceName + ";");
		// out.getWriter(filename).println("interface IEnergyCost;");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("implementation");
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("components " + mName + ";");
		out.getWriter(filename).println("");
		out.getWriter(filename).println(
				"StdControl = " + mName + ".StdControl;");
		out.getWriter(filename).println(
				interfaceName + " = " + mName + "." + interfaceName + ";");
		// out.getWriter(filename).println("IEnergyCost =
		// "+mName+".IEnergyCost;");
		out.getWriter(filename).println("}");

	}

	public  void generateNodeModule(TaskDeclaration td,
			VirtualDirectory out) {
		String name = td.getName();
		String mName = name + "M";
		String interfaceName = "I" + name;
		String filename = mName + ".nc";

		generateNodeModuleHeader(td, out);
		// generate node specific interface

		
		out.getWriter(filename).println("");

		// nodeCall Implementation
		out.getWriter(filename).print(
				"command result_t " + interfaceName + ".nodeCall(");
		printCallParamDecl(td, out.getWriter(filename));
		out.getWriter(filename).println(")");

		out.getWriter(filename).println("{");
		out.getWriter(filename).println("//PUT NODE IMPLEMENTATION HERE\n");
		out.getWriter(filename).println(
				"//Done signal can be moved if node makes split phase calls.");
		out.getWriter(filename).println(
				"signal " + interfaceName + ".nodeDone(in,out,ERR_OK);");
		out.getWriter(filename).println("return SUCCESS;");
		out.getWriter(filename).println("}");

		out.getWriter(filename).println("}");
	}

	public  void generateErrHandlerModuleHeader(ErrorHandler eh,
			VirtualDirectory out) {
		String name = eh.getFunction();
		// String target = eh.getTarget();
		String mName = name + "M";
		String interfaceName = "I" + name;
		String filename = mName + ".nc";

		out.getWriter(filename).println("includes structs;\n");
		out.getWriter(filename).println("module " + mName);
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("provides {");
		out.getWriter(filename).println("interface StdControl;");
		out.getWriter(filename).println("interface " + interfaceName + ";");
		out.getWriter(filename).println("interface IEnergyCost;");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("implementation");
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("#include \"fluxconst.h\"\n");
		generateStdControlImpl(out.getWriter(filename));
		generateEnergyCostImpl(out.getWriter(filename));

	}

	public  void generateErrHandlerInterface(ErrorHandler eh,
			VirtualDirectory out) {
		String name = eh.getFunction();
		String target = eh.getTarget();
		String interfaceName = "I" + name;
		String filename = interfaceName + ".nc";
		out.getWriter(filename).println("includes structs;");
		out.getWriter(filename).println("interface " + interfaceName);
		out.getWriter(filename).println("{");
		out.getWriter(filename).println(
				"command result_t errCall(" + target
						+ "_in *in, uint8_t error);");
		out.getWriter(filename).println(
				"event result_t errDone(" + target + "_in *in);");
		out.getWriter(filename).println("}");
	}

	public  void generateErrHandlerConfig(ErrorHandler eh,
			VirtualDirectory out) {
		String name = eh.getFunction();
		// String target = eh.getTarget();
		String interfaceName = "I" + name;
		String mName = name + "M";
		String filename = name + ".nc";
		out.getWriter(filename).println("configuration " + name);
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("provides {");
		out.getWriter(filename).println("interface StdControl;");
		out.getWriter(filename).println("interface " + interfaceName + ";");
		out.getWriter(filename).println("interface IEnergyCost;");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("}");
		out.getWriter(filename).println("implementation");
		out.getWriter(filename).println("{");
		out.getWriter(filename).println("components " + mName + ";");
		out.getWriter(filename).println("");
		out.getWriter(filename).println(
				"StdControl = " + mName + ".StdControl;");
		out.getWriter(filename).println(
				interfaceName + " = " + mName + "." + interfaceName + ";");
		out.getWriter(filename).println(
				"IEnergyCost = " + mName + ".IEnergyCost;");
		out.getWriter(filename).println("}");

	}

	public  void generateErrHandlerModule(ErrorHandler eh,
			VirtualDirectory out) {
		String name = eh.getFunction();
		String target = eh.getTarget();
		String interfaceName = "I" + name;
		String mName = name + "M";
		String filename = mName + ".nc";

		generateErrHandlerModuleHeader(eh, out);
		// generate node specific interface

		// nodeCall Implementation
		out.getWriter(filename).print(
				"command result_t " + interfaceName + ".errCall(");
		out.getWriter(filename).print(target + "_in *in, uint8_t error");
		out.getWriter(filename).println(")");

		out.getWriter(filename).println("{");
		out.getWriter(filename).println(
				"//PUT ERROR HANDLER IMPLEMENTATION HERE\n");
		out.getWriter(filename).println(
				"//Done signal can be moved if node makes split phase calls.");
		out.getWriter(filename).println(
				"signal " + interfaceName + ".errDone(in);");
		out.getWriter(filename).println("return SUCCESS;");
		out.getWriter(filename).println("}");

		out.getWriter(filename).println("}");
	}

	public  void generateNodes(ProgramGraph g, VirtualDirectory out) {
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		// Program p = g.getProgram();
		// Collection<Source> sources = g.getSources();

		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();
			// printStructs(td, out.getWriter(M_STRUCT_H));

			if (isNodeAbstract(g, td.getName())) {
				// System.out.println(td.getName()+":is abstract.");
			} else {
				if (td.getPlatformName().equals(MyName)) {

					if (g.isSource(td.getName())) {
						boolean timed = g.isTimedSource(td.getName());

						generateSourceInterface(td, out, timed);
						generateSourceConfig(td, out, timed);
						generateSourceModule(td, out, timed);
					} else {
						generateNodeInterface(td, out);
						generateNodeConfig(td, out);
						generateNodeModule(td, out);
					}
				}
			}
		}
	} // generateNodes

	public  void generateErrHandlers(ProgramGraph g, VirtualDirectory out) {
		Vector<ErrorHandler> errs = g.getProgram().getErrorHandlers();

		for (ErrorHandler eh : errs) {
			TaskDeclaration td = g.findTask(eh.getTarget());
			if (td.getPlatformName().equals(MyName)) {
				generateErrHandlerInterface(eh, out);
				generateErrHandlerConfig(eh, out);
				generateErrHandlerModule(eh, out);
			}
		}
	} // generateNodes

	public  void generateRuntimeStdControlImpl(ProgramGraph g,
			VirtualDirectory out)
	{

		PrintWriter pw = out.getWriter(M_RUNTIMEM_NC);
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();
		Vector<ErrorHandler> errs;

		///////////////////////////////////////////////////////////////////////////////////////////
		//  StdControl.init()
		///////////////////////////////////////////////////////////////////////////////////////////

		pw.println("command result_t StdControl.init()");
		pw.println("{");
		pw.println("result_t result;");
		pw.println("session_id = 0;");
		pw.println("queue_init(&moteQ);");

		pw.println("call Leds.init();");
		pw.println("");
		pw.println("localCAlive = FALSE;");
		//pw.println("remoteCAlive = FALSE;");
		pw.println("");
		pw.println("result = SUCCESS;");
		pw.println("//initialize nodes");
		while (it.hasNext())
		{
			TaskDeclaration td = (TaskDeclaration) it.next();

			if (!isNodeAbstract(g, td.getName()))
			{
				if (td.getPlatformName().equals(MyName))
				{
					pw.println("result &= call " + td.getName()
							+ "Control.init();");
				}
			}
		}
		errs = g.getProgram().getErrorHandlers();
		for (ErrorHandler eh : errs)
		{
			TaskDeclaration etd = g.findTask(eh.getTarget());
			if (!isNodeAbstract(g, etd.getName()))
			{
				if (etd.getPlatformName().equals(MyName))
				{
					pw.println("result &= call " + eh.getFunction()
							+ "Control.init();");
				}
			}
		}
		pw.println("return result;");
		pw.println("}");
		pw.println("");

		///////////////////////////////////////////////////////////////////////////////////////////
		//  StdControl.start()
		///////////////////////////////////////////////////////////////////////////////////////////

		pw.println("command result_t StdControl.start()");
		pw.println("{");
		pw.println("result_t result;");
		pw.println("void* tmpptr;");
		pw.println("");
		pw.println("result = SUCCESS;");

		//pw.println("recoverRunTimeData();");
		pw.println("call RecoverTimer.start(TIMER_ONE_SHOT, RT_RECOVER_TIME);");
		pw.println("call SaveTimer.start(TIMER_REPEAT, RT_SAVE_TIME);");
		pw.println("call PowerEnable();");
		pw.println("//start nodes");

		it = fns.iterator();

		while (it.hasNext())
		{
			TaskDeclaration td = (TaskDeclaration) it.next();

			if (!isNodeAbstract(g, td.getName()) && td.getPlatformName().equals(MyName))
			{
				if (!g.isSource(td.getName()))
				{
					pw.println("result &= call " + td.getName()	+ "Control.start();");
				}
			}
		}
		errs = g.getProgram().getErrorHandlers();
		for (ErrorHandler eh : errs)
		{
			TaskDeclaration etd = g.findTask(eh.getTarget());
			if (!isNodeAbstract(g, etd.getName()))
			{
				if (etd.getPlatformName().equals(MyName))
				{
					pw.println("result &= call " + eh.getFunction()	+ "Control.start();");
				}
			}
		}
		pw.println("//start sources");

		Vector<TimeConstraint> constraints = g.getProgram().getTimeConstraints();


		it = fns.iterator();
		while (it.hasNext())
		{
			TaskDeclaration td = (TaskDeclaration) it.next();

			if (!isNodeAbstract(g, td.getName())	 && td.getPlatformName().equals(MyName))
			{
				if (g.isSource(td.getName()))
				{
					pw.println("result &= call " + td.getName()	+ "Control.start();");
					pw.println("tmpptr = getOutVar(" + td.getName().toUpperCase() + "_NODEID);");
					pw.println("result &= call I" + td.getName() + ".srcStart((" + td.getName() + "_out*)tmpptr);");
					if (g.isTimedSource(td.getName()))
					{

						/*
						//uint32_t timerVals[NUMSOURCES][NUMSTATES][2] = {
						System.out.println("This is a timer... initially we set it to the highest granularity... ");
						int interval = Integer.MAX_VALUE;
						for (TimeConstraint con: constraints)
						{
							if ((con.low_val > 0) && (interval > con.low_val))
							{
								interval = con.low_val;
							}
						}
						//TODO: asdf
						*/

						pw.print("result &= call I" + td.getName()	+ ".setInterval(get_timer_interval(");
						pw.println("SOURCE_NUMBER_" + td.getName().toUpperCase() + ", curstate, TRUE));");
					}

				}
			}
		}
		pw.println("result &= call RTClockTimer.start(TIMER_REPEAT, RTCLOCKINTERVAL);");
		pw.println("result &= call EvalTimer.start(TIMER_REPEAT, EVALINTERVAL);");
		pw.println("");
		pw.println("return result;");
		pw.println("}");

		///////////////////////////////////////////////////////////////////////////////////////////
		//  StdControl.stop()
		///////////////////////////////////////////////////////////////////////////////////////////
		pw.println("command result_t StdControl.stop()");
		pw.println("{");
		pw.println("result_t result;");
		pw.println("");
		pw.println("result = SUCCESS;");
		pw.println("result &= call RTClockTimer.stop();");
		pw.println("result &= call EvalTimer.stop();");
		pw.println("//stop nodes");
		it = fns.iterator();
		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();
			// printStructs(td, out.getWriter(M_STRUCT_H));

			if (!isNodeAbstract(g, td.getName())) {
				if (td.getPlatformName().equals(MyName)) {
					pw.println("result &= call " + td.getName()
							+ "Control.stop();");
				}
			}
		}
		errs = g.getProgram().getErrorHandlers();
		for (ErrorHandler eh : errs) {
			TaskDeclaration etd = g.findTask(eh.getTarget());
			if (!isNodeAbstract(g, etd.getName())) {
				if (etd.getPlatformName().equals(MyName)) {
					pw.println("result &= call " + eh.getFunction()
							+ "Control.stop();");
				}
			}
		}
		pw.println("return result;");
		pw.println("}");
		pw.println("");
	}

	public  void generateRuntimeModuleHdr(ProgramGraph g,
			VirtualDirectory out) {
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();

		out.getWriter(M_RUNTIMEM_NC).println("includes structs;");
		out.getWriter(M_RUNTIMEM_NC).println("");
		out.getWriter(M_RUNTIMEM_NC).println("module RuntimeM {");
		out.getWriter(M_RUNTIMEM_NC).println("provides {");
		out.getWriter(M_RUNTIMEM_NC).println("interface StdControl;");
		out.getWriter(M_RUNTIMEM_NC).println("interface IPathDone; //self-awareness for programs");
		out.getWriter(M_RUNTIMEM_NC).println("}");
		out.getWriter(M_RUNTIMEM_NC).println("uses {");

		out.getWriter(M_RUNTIMEM_NC).println("interface IPathDone as DummyPathDone; //in case the app doesn't\n");

		out.getWriter(M_RUNTIMEM_NC).println("//Node Interfaces");
		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();

			if (!isNodeAbstract(g, td.getName())) {
				if (td.getPlatformName().equals(MyName)) {
					out.getWriter(M_RUNTIMEM_NC).println(
							"interface I" + td.getName() + ";");
					out.getWriter(M_RUNTIMEM_NC).println(
							"interface StdControl as " + td.getName()
									+ "Control;");
				}
			}
		}
		out.getWriter(M_RUNTIMEM_NC).println("//END of Node Interfaces");
		out.getWriter(M_RUNTIMEM_NC).println("//Error Handler Interfaces");
		Vector<ErrorHandler> errs = g.getProgram().getErrorHandlers();
		for (ErrorHandler eh : errs) {
			TaskDeclaration etd = g.findTask(eh.getTarget());
			if (!isNodeAbstract(g, etd.getName())) {
				if (etd.getPlatformName().equals(MyName)) {
					out.getWriter(M_RUNTIMEM_NC).println(
							"interface I" + eh.getFunction() + ";");
					out.getWriter(M_RUNTIMEM_NC).println(
							"interface StdControl as " + eh.getFunction()
									+ "Control;");
				}
			}
		}
		out.getWriter(M_RUNTIMEM_NC).println(
				"//END of Error Handler Interfaces");
		out.getWriter(M_RUNTIMEM_NC).println("");
		//out.getWriter(M_RUNTIMEM_NC).println("interface BAlloc;");
		out.getWriter(M_RUNTIMEM_NC).println("interface PageEEPROM;");
		//out.getWriter(M_RUNTIMEM_NC).println("interface LocalTime;");
		out.getWriter(M_RUNTIMEM_NC).println("interface SysTime;");

		out.getWriter(M_RUNTIMEM_NC).println("interface Timer as localQTimer;");

		out.getWriter(M_RUNTIMEM_NC).println("command result_t PowerEnable();");
		out.getWriter(M_RUNTIMEM_NC).println("command result_t PowerDisable();");


		out.getWriter(M_RUNTIMEM_NC).println("interface Timer as RecoverTimer;");
		out.getWriter(M_RUNTIMEM_NC).println("interface Timer as SaveTimer;");
		out.getWriter(M_RUNTIMEM_NC).println("interface Timer as EvalTimer;");
		out.getWriter(M_RUNTIMEM_NC).println("interface Timer as RTClockTimer;");
		out.getWriter(M_RUNTIMEM_NC).println("interface IEval;");
		out.getWriter(M_RUNTIMEM_NC).println("interface IEnergyMap;");
		out.getWriter(M_RUNTIMEM_NC).println("#ifdef RUNTIME_TEST");
		out.getWriter(M_RUNTIMEM_NC).println("interface SendMsg;");
		out.getWriter(M_RUNTIMEM_NC).println("#endif");


		out.getWriter(M_RUNTIMEM_NC).println(
				"interface IEnergyCost[uint8_t id];");
		out.getWriter(M_RUNTIMEM_NC).println("interface Leds;");
		out.getWriter(M_RUNTIMEM_NC).println("}");
		out.getWriter(M_RUNTIMEM_NC).println("}");
	}

	public  void generateRuntimeModuleImpl(ProgramGraph g,
			VirtualDirectory out) {
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
		//out.getWriter(M_RUNTIMEM_NC).println("EdgeQueue remoteQ;");
		out.getWriter(M_RUNTIMEM_NC).println("bool localCAlive;");

		out.getWriter(M_RUNTIMEM_NC).println("");
		out.getWriter(M_RUNTIMEM_NC).println("#include \"calls.h\"");
		//out.getWriter(M_RUNTIMEM_NC).println("#include \"marshaller.h\"");
		//out.getWriter(M_RUNTIMEM_NC).println("#include \"fluxmarshal.h\"");
		out.getWriter(M_RUNTIMEM_NC).println("#include \"fluxhandler.h\"");

		out.getWriter(M_RUNTIMEM_NC).println("");

		generateRuntimeStdControlImpl(g, out);

		out.getWriter(M_RUNTIMEM_NC).println("//BEGIN EDGES");
		generateNodeDoneHandlers(g, out);
		generateErrDoneHandlers(g, out);
		out.getWriter(M_RUNTIMEM_NC).println("}");

	}

	public  void generateRuntimeModule(ProgramGraph g,
			VirtualDirectory out) {
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();

		generateRuntimeModuleHdr(g, out);
		generateRuntimeModuleImpl(g, out);

	} // generateRuntimeModule

	public  void generateRuntimeConfig(ProgramGraph g,
			VirtualDirectory out) {
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();

		generateRuntimeConfigHdr(g, out);
		generateRuntimeConfigImpl(g, out);

	} // generateRuntimeModule

	public  void generateRuntimeConfigHdr(ProgramGraph g,
			VirtualDirectory out) {
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();

		out.getWriter(M_RUNTIME_NC).println("includes nodes;\n");
		out.getWriter(M_RUNTIME_NC).println("configuration Runtime {");
		out.getWriter(M_RUNTIME_NC).println("}");

	}

	public  void generateRuntimeConfigImpl(ProgramGraph g,
			VirtualDirectory out) {
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();

		out.getWriter(M_RUNTIME_NC).println("implementation");
		out.getWriter(M_RUNTIME_NC).println("{");
		// out.getWriter(M_RUNTIME_NC).println("#include \"nodes.h\"\n");
		out.getWriter(M_RUNTIME_NC).println("components ");

		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();

			if (!isNodeAbstract(g, td.getName())
					&& td.getPlatformName().equals(MyName)) {
				out.getWriter(M_RUNTIME_NC).print(td.getName() + ", ");
			}
		}
		Vector<ErrorHandler> errs = p.getErrorHandlers();
		for (ErrorHandler eh : errs) {
			TaskDeclaration td = g.findTask(eh.getTarget());
			if (td.getPlatformName().equals(MyName)) {
				out.getWriter(M_RUNTIME_NC).print(eh.getFunction() + ", ");
			}
		}

		out.getWriter(M_RUNTIME_NC).println("");
		out.getWriter(M_RUNTIME_NC).println(
				"Main, TimerC, RuntimeM, Evaluator, PageEEPROMC, HPLPowerManagementM as Power,");
		out.getWriter(M_RUNTIME_NC).println("SysTimeC , LedsC as Leds;");
		out.getWriter(M_RUNTIME_NC).println("");

		//out.getWriter(M_RUNTIME_NC).println("components DelugeCustomC as Deluge;");
		out.getWriter(M_RUNTIME_NC).println("components EnergyMapper;");
		out.getWriter(M_RUNTIME_NC).println("#ifdef RUNTIME_TEST");
		out.getWriter(M_RUNTIME_NC).println("components RadioComm;");
		out.getWriter(M_RUNTIME_NC).println("Main.StdControl -> RadioComm;");
		out.getWriter(M_RUNTIME_NC).println("RuntimeM.SendMsg -> RadioComm.SendMsg[0xd5];");
		out.getWriter(M_RUNTIME_NC).println("#endif");

		//System.out.println("Wrote Deluge StdControl...");
		out.getWriter(M_RUNTIME_NC).println("Main.StdControl -> PageEEPROMC;");
		out.getWriter(M_RUNTIME_NC).println("RuntimeM.PageEEPROM -> PageEEPROMC.PageEEPROM[unique(\"PageEEPROM\")];");
		out.getWriter(M_RUNTIME_NC).println("RuntimeM.PowerEnable -> Power.Enable;");
		out.getWriter(M_RUNTIME_NC).println("RuntimeM.PowerDisable -> Power.Disable;");
		out.getWriter(M_RUNTIME_NC).println("Main.StdControl -> EnergyMapper.StdControl;");
		out.getWriter(M_RUNTIME_NC).println(
				"Main.StdControl -> RuntimeM.StdControl;");
		out.getWriter(M_RUNTIME_NC).println(
				"Main.StdControl -> TimerC.StdControl;");
		out.getWriter(M_RUNTIME_NC).println(
				"Main.StdControl -> Evaluator.StdControl;");
		out.getWriter(M_RUNTIME_NC).println("");
		out.getWriter(M_RUNTIME_NC).println("RuntimeM.Leds -> Leds;");
		out.getWriter(M_RUNTIME_NC).println("RuntimeM.DummyPathDone -> RuntimeM.IPathDone;");
		//out.getWriter(M_RUNTIME_NC).println("RuntimeM.BAlloc -> BAllocC.BAlloc;");
		//out.getWriter(M_RUNTIME_NC).println("RuntimeM.LocalTime -> TimerC.LocalTime;");
		//out.getWriter(M_RUNTIME_NC).println("RuntimeM.LocalTime -> TimerC.LocalTime;");
		out.getWriter(M_RUNTIME_NC).println("RuntimeM.IEnergyMap -> EnergyMapper;");
		out.getWriter(M_RUNTIME_NC).println("RuntimeM.SysTime -> SysTimeC.SysTime;");
		out.getWriter(M_RUNTIME_NC).println(
				"RuntimeM.localQTimer -> TimerC.Timer[unique(\"Timer\")];");
		out.getWriter(M_RUNTIME_NC).println(
				"RuntimeM.SaveTimer -> TimerC.Timer[unique(\"Timer\")];");
		out.getWriter(M_RUNTIME_NC).println(
				"RuntimeM.RecoverTimer -> TimerC.Timer[unique(\"Timer\")];");
		out.getWriter(M_RUNTIME_NC).println(
				"RuntimeM.EvalTimer -> TimerC.Timer[unique(\"Timer\")];");
		out.getWriter(M_RUNTIME_NC).println(
				"RuntimeM.RTClockTimer -> TimerC.Timer[unique(\"Timer\")];");
		out.getWriter(M_RUNTIME_NC).println(
				"RuntimeM.IEval -> Evaluator.IEval;");
		//out.getWriter(M_RUNTIME_NC).println(
		//		"RuntimeM.remoteQTimer -> TimerC.Timer[unique(\"Timer\")];");
		// out.getWriter(M_RUNTIME_NC).println("RuntimeM.PathRateTimer ->
		// TimerC.Timer[unique(\"Timer\")];");
		// out.getWriter(M_RUNTIME_NC).println("RuntimeM.DutyCycleTimer ->
		// TimerC.Timer[unique(\"Timer\")];");
		//out.getWriter(M_RUNTIME_NC).println(
		//		"RuntimeM.SleepTimer -> TimerC.Timer[unique(\"Timer\")];");
		out.getWriter(M_RUNTIME_NC).println("");
		// out.getWriter(M_RUNTIME_NC).println("RuntimeM.RemoteConnect ->
		// Stream.Connect;");
		out.getWriter(M_RUNTIME_NC).println("");
		out.getWriter(M_RUNTIME_NC).println("//NODE Wiring");

		System.out.println("MyName == "+MyName);
		it = fns.iterator();
		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();


			if (!isNodeAbstract(g, td.getName())
					&& td.getPlatformName().equals(MyName)) {

				out.getWriter(M_RUNTIME_NC).print(
						"RuntimeM.I" + td.getName() + " -> ");
				out.getWriter(M_RUNTIME_NC).println(
						td.getName() + ".I" + td.getName() + ";");
				out.getWriter(M_RUNTIME_NC).print(
						"RuntimeM." + td.getName() + "Control -> ");
				out.getWriter(M_RUNTIME_NC).println(
						td.getName() + ".StdControl;");
			}
		}

		for (ErrorHandler eh : errs) {
			TaskDeclaration td = g.findTask(eh.getTarget());
			if (td.getPlatformName().equals(MyName)) {
				out.getWriter(M_RUNTIME_NC).print(
						"RuntimeM.I" + eh.getFunction() + " -> ");
				out.getWriter(M_RUNTIME_NC).print(
						eh.getFunction() + ".I" + eh.getFunction() + ";");
				out.getWriter(M_RUNTIME_NC).print(
						"RuntimeM." + eh.getFunction() + "Control -> ");
				out.getWriter(M_RUNTIME_NC).println(
						eh.getFunction() + ".StdControl;");
			}
		}

		it = fns.iterator();
		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();

			/*
			 * if (!isNodeAbstract(g,td.getName()) &&
			 * td.getPlatformName().equals(MyName)) {
			 * out.getWriter(M_RUNTIME_NC).print("RuntimeM.IEnergyCost["+td.getName().toUpperCase()+"_NODEID] ->
			 * ");
			 * out.getWriter(M_RUNTIME_NC).println(td.getName()+".IEnergyCost;"); }
			 */
		}
		out.getWriter(M_RUNTIME_NC).println("}\n");
	}

	public  void printHHeader(String name, PrintWriter out) {
		String newname = name.replace('.', '_');
		out.println("#ifndef " + newname.toUpperCase() + "_INCLUDED");
		out.println("#define " + newname.toUpperCase() + "_INCLUDED");
		out.println("");
	}

	public  void printHFooter(String name, PrintWriter out) {
		String newname = name.replace('.', '_');
		out.println("#endif // " + newname.toUpperCase() + "_INCLUDED");
	}

	public  void generateStructs(ProgramGraph g, VirtualDirectory out) {
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();

		printHHeader(M_STRUCT_H, out.getWriter(M_STRUCT_H));

		out.getWriter(M_STRUCT_H).println("#include \"rt_structs.h\"");
		out.getWriter(M_STRUCT_H).println("#include \"userstructs.h\"");
		//out.getWriter(M_STRUCT_H).println("#include \"nodes.h\"");
		out.getWriter(M_STRUCT_H).println("");

		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();
			// printStructs(td, out.getWriter(M_STRUCT_H));

			if (!g.isSource(td.getName())) {
				generateInStruct(g, td, out.getWriter(M_STRUCT_H));

			}
			generateOutStruct(g, td, out.getWriter(M_STRUCT_H));
			if (!isNodeAbstract(g, td.getName()))
			{
				out.getWriter(M_STRUCT_H).println("rt_data __"+td.getName()+"_rtdata;\n");
			}

		}

		printHFooter(M_STRUCT_H, out.getWriter(M_STRUCT_H));

	}

	public  void generateNodeDoneHandler(TaskDeclaration td,
			ProgramGraph g, PrintWriter out) {
		out.print("event result_t I" + td.getName() + ".nodeDone(");
		out.println(td.getName() + "_in *in," + td.getName()
				+ "_out *out, uint8_t error)");
		out.println("{");
		out.println("result_t result;");
		//out.println("uint32_t now;");

		out.println("call PowerEnable();");
		//out.println("atomic {");


		//handle errors
		out.println("if (error != ERR_OK)");
		out.println("{");
		out.println("return handle_error(" + td.getName().toUpperCase() + "_NODEID,error);");
		out.println("}");



		Vertex vert = g.getVertex(td.getName());
		EdgeIterator ei = g.getGraph().incidentEdges(vert, EdgeDirection.OUT);
		while (ei.hasNext()) {
			Edge e = ei.nextEdge();
			// out.println("Edge:
			// "+g.getGraph().origin(e)+"->"+g.getGraph().destination(e)+"("+e+")");

			Vertex src, dest;
			GraphNode srcnode, destnode;
			TaskDeclaration srctd, desttd;
			src = g.getGraph().origin(e);
			dest = g.getGraph().destination(e);
			srcnode = (GraphNode) src.element();
			destnode = (GraphNode) dest.element();

			if (destnode.getNodeType() != GraphNode.ERROR
					&& destnode.getNodeType() != GraphNode.ERROR_HANDLER) {
				if (dest == g.getVertexExit()) {
					srctd = (TaskDeclaration) srcnode.getElement();
					out.println("result = handle_exit("+srctd.getName().toUpperCase()+"_NODEID);");
				} else {
					srctd = (TaskDeclaration) srcnode.getElement();
					desttd = (TaskDeclaration) destnode.getElement();
					out.println("result = handle_edge("
							+ srctd.getName().toUpperCase() + "_NODEID,"
							+ desttd.getName().toUpperCase() + "_NODEID,"+e.get("count")+");");
				}
			}

		}
		out.println("return result;");
		out.println("}");
	}

	public  void generateSrcFiredHandler(TaskDeclaration td,
			ProgramGraph g, PrintWriter out) {
		out.print("event result_t I" + td.getName() + ".srcFired(");
		out.println(td.getName() + "_out *out)");
		out.println("{");
		out.println("result_t result;");
		//out.println("uint16_t session;");
		out.println("");
		//out.println("session = getNextSession();");
		//out.println("");

		Vertex vert = g.getVertex(td.getName());
		/*EdgeIterator inedges = g.getGraph().incidentEdges(vert,
				EdgeDirection.IN);
		if (inedges.hasNext()) {
			Edge e = inedges.nextEdge();
			System.out.println("Edge Wt=" + e.get("count"));
			out.println("out->_pdata.weight = " + e.get("count")+";");
		} else {
			System.out.println("ERROR.  NO EDGE FROM ENTRY -> " + td.getName());
			return;
		}*/

		EdgeIterator ei = g.getGraph().incidentEdges(vert, EdgeDirection.OUT);
		while (ei.hasNext()) {
			Edge e = ei.nextEdge();
			// out.println("Edge:
			// "+g.getGraph().origin(e)+"->"+g.getGraph().destination(e)+"("+e+")");

			Vertex src, dest;
			GraphNode srcnode, destnode;
			TaskDeclaration srctd, desttd;
			src = g.getGraph().origin(e);
			dest = g.getGraph().destination(e);
			srcnode = (GraphNode) src.element();
			destnode = (GraphNode) dest.element();

			if (destnode.getNodeType() != GraphNode.ERROR
					&& destnode.getNodeType() != GraphNode.ERROR_HANDLER) {
				if (dest == g.getVertexExit()) {
					srctd = (TaskDeclaration) srcnode.getElement();
					out.println("result = handle_exit("+srctd.getName().toUpperCase()+"_NODEID);");
				} else {
					srctd = (TaskDeclaration) srcnode.getElement();
					desttd = (TaskDeclaration) destnode.getElement();
					out.println("result = handle_src_edge("
							+ srctd.getName().toUpperCase()+"_NODEID,"
							+ desttd.getName().toUpperCase() + "_NODEID);");
					/*String plat = desttd.getPlatformName();
					if (plat == null || plat.equals(MyName)) {
						out.print("TRUE");
					} else {
						out.print("FALSE");
					}
					out.println("," + e.get("count") + ");");
					*/
				}
			}
		}
		out.println("return result;");
		out.println("}");
	}

	public  void generateNodeDoneHandlers(ProgramGraph g,
			VirtualDirectory out) {
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();

		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();

			if (!isNodeAbstract(g, td.getName()) && !g.isSource(td.getName())) {
				if (td.getPlatformName().equals(MyName)) {
					generateNodeDoneHandler(td, g, out.getWriter(M_EDGES_NC));

				}
			}

			if (!isNodeAbstract(g, td.getName()) && g.isSource(td.getName())) {
				if (td.getPlatformName().equals(MyName)) {
					generateSrcFiredHandler(td, g, out.getWriter(M_EDGES_NC));

				}
			}
		}

	}

	public  void generateErrDoneHandler(ErrorHandler eh, PrintWriter out) {
		out.print("event result_t I" + eh.getFunction() + ".errDone(");
		out.println(eh.getTarget() + "_in *in)");
		out.println("{");
		out.println("handle_exit((Handle)in);");
		out.println("return SUCCESS;");
		out.println("}");
	}

	public  void generateErrDoneHandlers(ProgramGraph g,
			VirtualDirectory out) {
		Vector<ErrorHandler> errs = g.getProgram().getErrorHandlers();

		for (ErrorHandler eh : errs) {
			TaskDeclaration td = g.findTask(eh.getTarget());
			if (td.getPlatformName().equals(MyName)) {
				generateErrDoneHandler(eh, out.getWriter(M_EDGES_NC));

			}
		}

	}

	public  int getStateID(ProgramGraph g, String state) {
		Vector<String> states = g.getProgram().getStates().GetAllStates();

		int count = 0;
		for (String s : states) {
			if (s.equals(state))
				return count;
			count++;
		}
		return -1;
	}

	public  String getMinPathState(ProgramGraph g, Vector<Vertex> path,
			int endidx) {
		int minState;

		Vector<String> states = g.getProgram().getStates().GetAllStates();

		minState = 0;

		for (int i = 0; i < Math.min(path.size(), endidx); i++) {
			Vertex v = path.get(i);
			Vertex next = null;
			if (i < path.size() - 1)
				next = path.get(i + 1);

			int nodestate = -1;

			GraphNode node = (GraphNode) v.element();
			if (node.getElement() instanceof TaskDeclaration && next != null) {
				TaskDeclaration td = (TaskDeclaration) node.getElement();
				FlowStatement fs = g.getProgram().getFlow(td.getName());

				GraphNode nextnode = (GraphNode) next.element();

				// only check abstract nodes since only they
				// have type/state checks
				if (fs != null
						&& nextnode.getElement() instanceof TaskDeclaration) {
					TaskDeclaration nexttd = (TaskDeclaration) nextnode
							.getElement();
					Vector<SimpleFlowStatement> flows = getFlowList(fs);
					for (SimpleFlowStatement sfs : flows) {
						if (sfs.inRightHandSide(nexttd.getName())) {
							if (sfs.getState() != null)
								nodestate = getStateID(g, sfs.getState());
						}
					}
				} // if Abstract
			} // if Task

			if (nodestate > -1 && nodestate < states.size()) {
				minState = Math.max(minState, nodestate);
			}
		}// for

		return states.get(minState);
	}

	public  boolean isEdgeLocal(Vertex a, Vertex b, ProgramGraph g) {
		boolean adj = false;
		EdgeIterator edgeIterator = g.getGraph().incidentEdges(a,
				EdgeDirection.OUT);
		while (edgeIterator.hasNext()) {
			Edge edge = edgeIterator.nextEdge();
			Vertex currDestination = g.getGraph().destination(edge);
			if (currDestination == b)
				adj = true;
		}
		if (!adj) {
			System.out.println(a.element().toString()
					+ " ! connected to: " + b.element().toString());
			System.exit(1);
		}

		GraphNode anode, bnode;
		anode = (GraphNode) a.element();
		bnode = (GraphNode) b.element();

		if (anode.getElement() instanceof TaskDeclaration
				&& bnode.getElement() instanceof TaskDeclaration) {
			TaskDeclaration atd, btd;
			atd = (TaskDeclaration) anode.getElement();
			btd = (TaskDeclaration) bnode.getElement();
			if (!atd.getPlatformName().equals(btd.getPlatformName())) {
				return false;
			}
		}

		return true;
	}

	//TODO: See if we can remove this
	public  void generatePathEnergyCalculator(int index, PrintWriter pw,
			Vector<Vertex> path, boolean maximum, ProgramGraph g) {
		pw.print("return (");

		int localcount = 0;
		int remotecount = 0;

		for (int i = 0; i < path.size(); i++) {
			Vertex cur = path.get(i);
			Vertex next = null;
			if (i < (path.size() - 1))
				next = path.get(i + 1);
			boolean wrote = false;

			GraphNode curnode, nextnode;
			curnode = (GraphNode) cur.element();
			if (curnode.getElement() instanceof TaskDeclaration) {
				wrote = true;
				TaskDeclaration td = (TaskDeclaration) curnode.getElement();

				if (maximum) {
					pw.print("getMaxNodeEnergy(" + td.getName().toUpperCase()
							+ "_NODEID)");
				} else {
					pw.print("(state <= STATE_"
							+ getMinPathState(g, path, i).toUpperCase());
					pw.print(" ? getMinNodeEnergy("
							+ td.getName().toUpperCase() + "_NODEID) ");
					pw.print(" : getMaxNodeEnergy("
							+ td.getName().toUpperCase() + "_NODEID))");
				}

			}
			if (next != null) {
				// is the edge local or remote?
				if (isEdgeLocal(cur, next, g)) {
					localcount++;
				} else {
					remotecount++;
				}

				/*
				 * nextnode = (GraphNode)next.element(); if
				 * (nextnode.getElement() instanceof TaskDeclaration) {
				 * TaskDeclaration nexttd =
				 * (TaskDeclaration)nextnode.getElement();
				 *  }
				 */

			}

			if (next != null && wrote) {
				pw.println("+");
			}
		}
		pw.print(" (" + localcount + " * LOCALEDGEENERGY) + (" + remotecount
				+ " * REMOTEEDGEENERGY)");
		pw.println(");");
	}

	public  void generatePathEnergyCalculators(PrintWriter pw,
			Vector<Vector<Vertex>> paths, ProgramGraph g) {
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
		for (int i = 0; i < paths.size(); i++) {
			pw.println("case (" + i + "):");
			pw.println("{");
			Vector<Vertex> v = paths.get(i);
			generatePathEnergyCalculator(i, pw, v, true, g);
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
		for (int i = 0; i < paths.size(); i++) {
			pw.println("case (" + i + "):");
			pw.println("{");
			Vector<Vertex> v = paths.get(i);
			generatePathEnergyCalculator(i, pw, v, false, g);
			pw.println("}");
		}
		pw.println("}");
		pw.println("return -1.0;");
		pw.println("}");

		pw.println("\n#include \"nodepower.h\"\n");
	}

	public  void generateNodesHeader(ProgramGraph g,
			VirtualDirectory out, boolean needint) {
		int i;
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();
		Collection<Source> sources = g.getSources();

		printHHeader(M_NODES_H, out.getWriter(M_NODES_H));

		out.getWriter(M_NODES_H).println("#ifdef SIMULATOR");
		out.getWriter(M_NODES_H).println("#include \"pgm_util.h\"");
		out.getWriter(M_NODES_H).println("#else");
		out.getWriter(M_NODES_H).println("#include \"pgm_util.h\"");
		out.getWriter(M_NODES_H).println("#endif");

		if (needint) {
			out.getWriter(M_NODES_H).println("#include <stdint.h>");
			out.getWriter(M_NODES_H).println("#define TRUE 1");
			out.getWriter(M_NODES_H).println("#define FALSE 0");
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

		out.getWriter(M_NODES_H).println("uint8_t __node_locks[" + ((nodeID.size() / 8)+1)+"]; //1-bit locks for each node");
		

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
		//out.getWriter(M_NODES_H).println("#define WAKEPOWER 1.5 //W");
		out.getWriter(M_NODES_H).println("#define IDLEPOWER 0.005 //W");
		//out.getWriter(M_NODES_H).println("#define STARGATEIDLEPOWER 1.2 //W");
		//out.getWriter(M_NODES_H).println("#define LOCALEDGEENERGY 1.42 //mJ");
		//out.getWriter(M_NODES_H).println("#define REMOTEEDGEENERGY 1.42 //mJ");
		//out.getWriter(M_NODES_H).println("double wakeTimeMS = 0.0;");

		Vector<Vector<Vertex>> paths = g.getPaths();
		out.getWriter(M_NODES_H).println("#define NUMPATHS " + paths.size());
		out
				.getWriter(M_NODES_H)
				.println(
						"#define PATHRATESECONDS 20 //Path rates are in requests/PATHRATESECONDS");
		out
				.getWriter(M_NODES_H)
				.println(
						"#define PATHRATEHISTORY 30 //Path rate averages over PATHRATEHISTORY samples");

		out.getWriter(M_NODES_H).println("uint8_t curstate = STATE_BASE;");
		out.getWriter(M_NODES_H).println("double curgrade = 0.0;");
		out.getWriter(M_NODES_H).print("uint8_t minPathState[NUMPATHS] PROGMEM ={");
		for (i = 0; i < paths.size(); i++) {
			Vector<Vertex> path = paths.get(i);

			String state = getMinPathState(g, path, path.size());

			out.getWriter(M_NODES_H).print("STATE_" + state.toUpperCase());
			if (i < (paths.size() - 1))
				out.getWriter(M_NODES_H).print(",");
		}
		out.getWriter(M_NODES_H).println("};");



		// ***********
		out.getWriter(M_NODES_H).print("uint8_t isPathTimed[NUMPATHS] PROGMEM ={");
		Vector<Integer> timedPaths = new Vector<Integer>();
		for (i = 0; i < paths.size(); i++) {
			Vector<Vertex> path = paths.get(i);

			Vertex v = path.get(1);
			GraphNode node = (GraphNode) v.element();
			TaskDeclaration td = (TaskDeclaration) node.getElement();

			if (g.isTimedSource(td.getName())) {
				timedPaths.add(i);
				out.getWriter(M_NODES_H).print("TRUE");
			} else {
				out.getWriter(M_NODES_H).print("FALSE");
			}
			if (i < (paths.size() - 1))
				out.getWriter(M_NODES_H).print(",");
		}
		out.getWriter(M_NODES_H).println("};");

		// ***********
		out.getWriter(M_NODES_H).print("uint8_t pathSrc[NUMPATHS] PROGMEM ={");
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

			out.getWriter(M_NODES_H).print(idx);
			if (i < (paths.size() - 1))
				out.getWriter(M_NODES_H).print(",");
		}
		out.getWriter(M_NODES_H).println("};");
		out.getWriter(M_NODES_H).println("#define NUMSOURCES " + (maxidx + 1));
		out.getWriter(M_NODES_H).println(
				"#define NUMTIMEDPATHS " + timedPaths.size());
		out.getWriter(M_NODES_H).println("uint8_t timedPaths[NUMTIMEDPATHS] PROGMEM ={");
		i = 0;
		for (Integer pathidx : timedPaths) {
			out.getWriter(M_NODES_H).print(pathidx.toString());
			if (i < (timedPaths.size() - 1)) {
				out.getWriter(M_NODES_H).print(",");
			}
		}
		out.getWriter(M_NODES_H).println("};");


		generateTimedSourceInit(g, out);


		out.getWriter(M_NODES_H).println("int32_t get_timer_interval(uint32_t src_num, uint32_t st_num, bool min){");
		out.getWriter(M_NODES_H).println("if (min)");
		out.getWriter(M_NODES_H).println("{");
		//out.getWriter(M_NODES_H).println("return (read_pgm_int32((int32_t*)&timerVals[src_num][st_num][1]));");
		out.getWriter(M_NODES_H).println("return (timerVals[src_num][st_num][1]);");
		out.getWriter(M_NODES_H).println("} else {");
		//out.getWriter(M_NODES_H).println("return (read_pgm_int32((int32_t*)&timerVals[src_num][st_num][0]));");
		out.getWriter(M_NODES_H).println("return (timerVals[src_num][st_num][0]);");
		out.getWriter(M_NODES_H).println("}");
		//out.getWriter(M_NODES_H).println("return ((timerVals[src_num][st_num][0] + timerVals[src_num][st_num][1]) / 2);");
		out.getWriter(M_NODES_H).println("}");

		out.getWriter(M_NODES_H).print("uint8_t srcNodes[NUMSOURCES][2] PROGMEM ={");
		Vector<Source> srcs = g.getProgram().getSources();
		i = 0;
		for (Source s : srcs) {
			out.getWriter(M_NODES_H).print("{");
			if (g.isTimedSource(s.getSourceFunction())) {
				out.getWriter(M_NODES_H).print("TRUE,");
			} else {
				out.getWriter(M_NODES_H).print("FALSE,");
			}
			out.getWriter(M_NODES_H).print(nodeID.get(s.getSourceFunction()));
			out.getWriter(M_NODES_H).print("}");
			if (i < (srcs.size() - 1)) {
				out.getWriter(M_NODES_H).print(",");
			}
			i++;
		}
		out.getWriter(M_NODES_H).println("};");
		// generatePathEnergyCalculators(out.getWriter(M_NODES_H), paths,g);

		/*
		 * //DEBUG OUTPUT EdgeIterator myit = g.getGraph().edges(); while
		 * (myit.hasNext()) { Edge e = (Edge)myit.nextEdge(); Vertex src,dest;
		 * GraphNode srcnode,destnode; TaskDeclaration srctd, desttd; src =
		 * g.getGraph().origin(e); dest = g.getGraph().destination(e); srcnode =
		 * (GraphNode)src.element(); destnode = (GraphNode)dest.element();
		 *
		 * //System.out.print("Edge from
		 * ("+srcnode+")["+srcnode.getNodeType()+"] to
		 * ("+destnode+")["+destnode.getNodeType()+"][");
		 * //System.out.println(e.get("count")+"]"); } //END DEBUG
		 */

		printHFooter(M_NODES_H, out.getWriter(M_NODES_H));

	}

	public  String getProperState(String state) {
		if (state == null || state.equals(" ") || state.equals("*")) {
			return "BASE";
		}
		return state;
	}

	public  Vector<SimpleFlowStatement> getFlowList(FlowStatement flow) {
		Vector<SimpleFlowStatement> result = new Vector<SimpleFlowStatement>();
		if (flow instanceof SimpleFlowStatement) {
			result.add((SimpleFlowStatement) flow);
			return result;
		}
		if (flow instanceof TypedFlowStatement) {
			Vector<FlowStatement> stmts = ((TypedFlowStatement) flow)
					.getFlowStatements();
			for (FlowStatement fs : stmts) {
				Vector<SimpleFlowStatement> subresult = getFlowList(fs);
				result.addAll(subresult);
			}
			return result;
		}

		System.out
				.println("ERROR! We only support Simple and Typed Flow Statements.");
		return null;
	}

	public  void generateAbstractDeciders(ProgramGraph g,
			VirtualDirectory out) {
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		Program p = g.getProgram();

		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();

			if (isNodeAbstract(g, td.getName())) {
				//System.out.println("Abstract Decider: "+td.getName());
				out.getWriter(M_CALLS_H).println(
						"uint16_t decide" + td.getName()
								+ "(void *invar, uint16_t *wt)");
				out.getWriter(M_CALLS_H).println("{");

				Vector<Argument> inputs = td.getInputs();
				FlowStatement flow = g.getProgram().getFlow(td.getName());
				Vector<SimpleFlowStatement> paths = getFlowList(flow);

				for (SimpleFlowStatement sfs : paths) {
					//System.out.println("\tpath : "+sfs.toString());
					Vector<String> types = sfs.getTypes();
					Vector<String> args = sfs.getArguments();
					String state = getProperState(sfs.getState());

					String target = null;
					if (args.size() > 0)
					{
						target = args.get(0);
					}

					if (types == null) {
						// System.out.println("getting args for
						// "+td.getName()+":"+sfs);
						out.getWriter(M_CALLS_H).println(
								"if (isFunctionalState(STATE_"
										+ state.toUpperCase() + "))");

					} else {
						if (types.size() != inputs.size()) {
							System.out
									.println("Task("
											+ td
											+ "): inputs and types of different arrity.");
							System.out
									.println("Fix it.  Bad things will probably happen if you don't.");
						}
						out.getWriter(M_CALLS_H).print("if (");

						int count = 0;
						for (String s : types) {
							if (s.equals("*")) {
								out.getWriter(M_CALLS_H).print("TRUE");
							} else {
								Argument arg = inputs.get(count);
								out.getWriter(M_CALLS_H).print(
										p.getType(s).getFunction() + "(");
								out.getWriter(M_CALLS_H).print(
										"((" + td.getName() + "_in*)");
								out.getWriter(M_CALLS_H).print(
										"invar)->" + arg.getName() + ")");
							}
							out.getWriter(M_CALLS_H).print(" && ");
							count++;
						}
						out.getWriter(M_CALLS_H).println(
								"isFunctionalState(STATE_"
										+ state.toUpperCase() + "))");

					}

					out.getWriter(M_CALLS_H).println("{");

					int weight = getEdgeWeight(g, td.getName(), target, types,
							state);
					out.getWriter(M_CALLS_H).println("*wt = " + weight + ";");

					// end weight
					out.getWriter(M_CALLS_H).println(
							"return " + target.toUpperCase() + "_NODEID;");
					out.getWriter(M_CALLS_H).println("}");

				}

				out.getWriter(M_CALLS_H).println(
						"return NO_NODEID; //Error state");
				out.getWriter(M_CALLS_H).println("}\n");

			}
		}
		out.getWriter(M_CALLS_H).println("//end deciders");

	}

	private  int getEdgeWeight(ProgramGraph g, String source,
			String target, Vector<String> typesVector, String state) {
		String types = "";
		String signature = "[]";
		state = state.trim();
		if (state.equals("BASE"))
			state = "*";


		if (typesVector != null) {
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

	public  void generateCallHandlers(ProgramGraph g, VirtualDirectory out) {
		Collection fns = g.getFunctions();
		Iterator it = fns.iterator();
		// Program p = g.getProgram();
		// Collection<Source> sources = g.getSources();

		printHHeader(M_CALLS_H, out.getWriter(M_CALLS_H));

		out.getWriter(M_CALLS_H).println("#include \"" + M_NODES_H + "\"\n");
		out.getWriter(M_CALLS_H).println("#include \"" + M_TYPES_H + "\"\n");
		out.getWriter(M_CALLS_H).println("#include \"fluxhandler.h\"\n");

		generateAbstractDeciders(g, out);

		
		// generate getRTData
		out.getWriter(M_CALLS_H).println("rt_data* getRTData(uint16_t nodeid)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("switch(nodeid)");
		out.getWriter(M_CALLS_H).println("{");
		it = fns.iterator();
		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();

			if (!this.isNodeAbstract(g,td.getName()) && !g.isSource(td.getName()))
			{
				out.getWriter(M_CALLS_H).print(
						"case " + td.getName().toUpperCase() + "_NODEID: ");

				out.getWriter(M_CALLS_H).println("return &__"+td.getName()+"_rtdata;");
			}

		}

		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return NULL;");
		out.getWriter(M_CALLS_H).println("}//getRTData");
		out.getWriter(M_CALLS_H).println("");
		
		// generate getOutQueue
		out.getWriter(M_CALLS_H).println("void* getOutQueue(uint16_t srcid, uint8_t entry)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("switch(srcid)");
		out.getWriter(M_CALLS_H).println("{");
		it = fns.iterator();
		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();

			if (g.isSource(td.getName()))
			{
				out.getWriter(M_CALLS_H).print(
						"case " + td.getName().toUpperCase() + "_NODEID: ");

				out.getWriter(M_CALLS_H).println("return (void*)&__"+td.getName()+"_out_queue[entry];");
			}

		}

		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return NULL;");
		out.getWriter(M_CALLS_H).println("}//getOutQueue");
		out.getWriter(M_CALLS_H).println("");
		
		// generate getSrcWeight
		out.getWriter(M_CALLS_H).println("int16_t getSrcWeight(uint16_t srcid)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("switch(srcid)");
		out.getWriter(M_CALLS_H).println("{");
		it = fns.iterator();
		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();

			if (g.isSource(td.getName()))
			{
				int weight=0;
				
				out.getWriter(M_CALLS_H).print(
						"case " + td.getName().toUpperCase() + "_NODEID: ");
				
				//FIRST GET THE WEIGHT OF THE INCOMING EDGE (From ENTRY ->)
				Vertex vert = g.getVertex(td.getName());
				EdgeIterator inedges = g.getGraph().incidentEdges(vert,EdgeDirection.IN);
				if (inedges.hasNext()) {
					Edge e = inedges.nextEdge();
					System.out.println("In Edge Wt=" + e.get("count"));
					//out.getWriter(M_CALLS_H).println("return " + e.get("count") + ";");
					weight = Integer.parseInt(e.get("count").toString());
				} else {
					System.out.println("ERROR.  NO EDGE FROM ENTRY -> " + td.getName());
					System.exit(1);
				}
				//NOW GET THE OUTGOING EDGE
				EdgeIterator outedges = g.getGraph().incidentEdges(vert,EdgeDirection.OUT);
				while (outedges.hasNext()) 
				{
					Edge e = outedges.nextEdge();
					
					Vertex src, dest;
					GraphNode srcnode, destnode;
					TaskDeclaration srctd, desttd;
					src = g.getGraph().origin(e);
					dest = g.getGraph().destination(e);
					srcnode = (GraphNode) src.element();
					destnode = (GraphNode) dest.element();

					if (destnode.getNodeType() != GraphNode.ERROR
						&& destnode.getNodeType() != GraphNode.ERROR_HANDLER
						&& dest != g.getVertexExit()) 
					{
						weight += Integer.parseInt(e.get("count").toString());
					} 
				}
				
				out.getWriter(M_CALLS_H).println("return "+weight+";");
				
			}

		}

		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return -1;");
		out.getWriter(M_CALLS_H).println("}//getSrcWeight");
		out.getWriter(M_CALLS_H).println("");
		
		// generate getOutValid
		out.getWriter(M_CALLS_H).println("bool* getOutValid(uint16_t srcid)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("switch(srcid)");
		out.getWriter(M_CALLS_H).println("{");
		it = fns.iterator();
		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();

			if (g.isSource(td.getName()))
			{
				out.getWriter(M_CALLS_H).print(
						"case " + td.getName().toUpperCase() + "_NODEID: ");

				out.getWriter(M_CALLS_H).println("return __"+td.getName()+"_out_valid;");
			}

		}

		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return NULL;");
		out.getWriter(M_CALLS_H).println("}//getOutValid");
		out.getWriter(M_CALLS_H).println("");
		
		// generate getInVar
		out.getWriter(M_CALLS_H).println("void* getInVar(uint16_t nodeid)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("switch(nodeid)");
		out.getWriter(M_CALLS_H).println("{");
		it = fns.iterator();
		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();

			if (!this.isNodeAbstract(g,td.getName()) && !g.isSource(td.getName()))
			{
				out.getWriter(M_CALLS_H).print(
						"case " + td.getName().toUpperCase() + "_NODEID: ");

				out.getWriter(M_CALLS_H).println("return &__"+td.getName()+"_in;");
			}

		}

		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return NULL;");
		out.getWriter(M_CALLS_H).println("}//getInVar");
		out.getWriter(M_CALLS_H).println("");


		// generate getOutVar
		out.getWriter(M_CALLS_H).println("void* getOutVar(uint16_t nodeid)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("switch(nodeid)");
		out.getWriter(M_CALLS_H).println("{");
		it = fns.iterator();
		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();

			if (!this.isNodeAbstract(g,td.getName()))
			{
				out.getWriter(M_CALLS_H).print(
						"case " + td.getName().toUpperCase() + "_NODEID: ");

				out.getWriter(M_CALLS_H).println("return &__"+td.getName()+"_out;");
			}

		}

		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return NULL;");
		out.getWriter(M_CALLS_H).println("}//getOutVar");

		// generate translateID
		out.getWriter(M_CALLS_H).println(
				"uint16_t translateID(uint16_t node_id, void *invar, uint16_t *wt)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("*wt = 0;");
		out.getWriter(M_CALLS_H).println("switch(node_id)");
		out.getWriter(M_CALLS_H).println("{");
		it = fns.iterator();
		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();


			if (isNodeAbstract(g, td.getName())) {
				out.getWriter(M_CALLS_H).print(
									"case " + td.getName().toUpperCase() + "_NODEID: ");

				out.getWriter(M_CALLS_H).println(
						"return decide" + td.getName() + "(invar,wt);");
			} /*else {
				out.getWriter(M_CALLS_H).println("return e->node_id;");
			}*/
		}
		out.getWriter(M_CALLS_H).println("}//switch");
		//out.getWriter(M_CALLS_H).println("return NO_NODEID; //should never happen");
		out.getWriter(M_CALLS_H).println("return node_id;");
		out.getWriter(M_CALLS_H).println("}//translateID\n");

		// generate translateIDAll

		out.getWriter(M_CALLS_H).println(
				"uint16_t translateIDAll(EdgeIn *e, uint16_t *wt)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("bool change=TRUE;");
		out.getWriter(M_CALLS_H).println("uint16_t result = NO_NODEID;");
		out.getWriter(M_CALLS_H).println("uint16_t nodeid = e->dst_id;");
		out.getWriter(M_CALLS_H).println("uint16_t totalwt = 0;");
		out.getWriter(M_CALLS_H).println("uint16_t nodewt = 0;");
		out.getWriter(M_CALLS_H).println("rt_data *invar = getRTData(e->src_id);");
		
		out.getWriter(M_CALLS_H).println("while (change)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("nodewt = 0;");
		out.getWriter(M_CALLS_H).println("result = translateID(nodeid, invar ,&nodewt);");
		out.getWriter(M_CALLS_H).println(
				"if (result == NO_NODEID) { return result; }");
		out.getWriter(M_CALLS_H).println("change = (result != nodeid);");
		out.getWriter(M_CALLS_H).println("if (change)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("totalwt += nodewt;");
		out.getWriter(M_CALLS_H).println("nodeid = result;");
		out.getWriter(M_CALLS_H).println("}");
		out.getWriter(M_CALLS_H).println("}");
		out.getWriter(M_CALLS_H).println("*wt = totalwt;");
		out.getWriter(M_CALLS_H).println("return nodeid;");
		out.getWriter(M_CALLS_H).println("}\n");

		//generate fullTranslate
		/*(out.getWriter(M_CALLS_H).println("uint16_t fullTranslate(EdgeIn *e)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("uint16_t wt;");
		out.getWriter(M_CALLS_H).println("uint8_t *newin;");
		out.getWriter(M_CALLS_H).println(
				"uint16_t dest = translateIDAll(e,&wt);");
		out.getWriter(M_CALLS_H).println("e->node_id = dest;");
		out.getWriter(M_CALLS_H).println(
				"((GenericNode*)(e->invar))->_pdata.weight += wt;");
		out.getWriter(M_CALLS_H).println("return dest;");
		out.getWriter(M_CALLS_H).println("}");
		out.getWriter(M_CALLS_H).println("");*/

		// generate isReadyByID
		/*out.getWriter(M_CALLS_H).println("bool isReadyByID(EdgeIn *e)");
		out.getWriter(M_CALLS_H).println("{");

		out.getWriter(M_CALLS_H).println("switch(e->node_id)");
		out.getWriter(M_CALLS_H).println("{");
		it = fns.iterator();
		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();

			if (!isNodeAbstract(g, td.getName()) && !g.isSource(td.getName())
					&& td.getPlatformName().equals(MyName)) {
				out.getWriter(M_CALLS_H).print(
						"case " + td.getName().toUpperCase() + "_NODEID: ");
				//out.getWriter(M_CALLS_H).println(
				//		"return call I" + td.getName() + ".ready();");
				out.getWriter(M_CALLS_H).println(
						"return __try_node_lock(" + td.getName().toUpperCase() + "_NODEID);");
			}
		}
		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return TRUE; //should never happen");
		out.getWriter(M_CALLS_H).println("}//isReadyByID\n");
		*/
		// generate getOutSize
		out.getWriter(M_CALLS_H).println("int16_t getOutSize(uint16_t nodeid)");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("uint16_t dest = nodeid;");
		out.getWriter(M_CALLS_H).println("switch(dest)");
		out.getWriter(M_CALLS_H).println("{");
		it = fns.iterator();
		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();

			//if (!isNodeAbstract(g, td.getName()) && !g.isSource(td.getName())
			if (!isNodeAbstract(g, td.getName())
					&& td.getPlatformName().equals(MyName)) {
				out.getWriter(M_CALLS_H).println(
						"case " + td.getName().toUpperCase() + "_NODEID: ");
				out.getWriter(M_CALLS_H).println(
						"return sizeof(" + td.getName() + "_out);");

			}
		}
		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return -1; //should never happen");
		out.getWriter(M_CALLS_H).println("}//getOutSize\n");

		//generate callSetInterval
		out.getWriter(M_CALLS_H).println("result_t callSetInterval(uint16_t srcid, int32_t interval)");
		out.getWriter(M_CALLS_H).println("{");

		out.getWriter(M_CALLS_H).println("switch(srcid)");
		out.getWriter(M_CALLS_H).println("{");

		Vector<Source> sources = g.getProgram().getSources();
		for (Source src : sources)
		{
			if (g.isTimedSource(src.getSourceFunction()))
			{
				out.getWriter(M_CALLS_H).print("case SOURCE_NUMBER_" + src.source_fn.toUpperCase()+":");
				out.getWriter(M_CALLS_H).print("\treturn call I"+src.source_fn+".setInterval(interval);");
			}
		}
		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return FAIL; //should never happen");
		out.getWriter(M_CALLS_H).println("}//callSetInterval\n");


		//generate adjustIntervals
		out.getWriter(M_CALLS_H).println("result_t adjustIntervals()");
		out.getWriter(M_CALLS_H).println("{");
		out.getWriter(M_CALLS_H).println("int32_t minval, maxval, newval;");
		out.getWriter(M_CALLS_H).println("double intermed;");

		sources = g.getProgram().getSources();
		for (Source src : sources)
		{
			if (g.isTimedSource(src.getSourceFunction()))
			{
				out.getWriter(M_CALLS_H).println("//adjust " + src.source_fn);
				out.getWriter(M_CALLS_H).println("minval = get_timer_interval(SOURCE_NUMBER_" +src.source_fn.toUpperCase()+",curstate, TRUE);");
				out.getWriter(M_CALLS_H).println("maxval = get_timer_interval(SOURCE_NUMBER_" +src.source_fn.toUpperCase()+",curstate, FALSE);");
				out.getWriter(M_CALLS_H).println("intermed = (double)(minval-maxval);");
				out.getWriter(M_CALLS_H).println("intermed = curgrade * intermed;");
				out.getWriter(M_CALLS_H).println("newval = minval - ((int32_t)intermed);");
				out.getWriter(M_CALLS_H).println("callSetInterval(SOURCE_NUMBER_" + src.source_fn.toUpperCase()+", newval);");
				out.getWriter(M_CALLS_H).println("//end "+src.source_fn);

			}
		}

		out.getWriter(M_CALLS_H).println("return SUCCESS;");
		out.getWriter(M_CALLS_H).println("}//adjustIntervals\n");


		// generate callEdge
		out.getWriter(M_CALLS_H).println("result_t callEdge(uint16_t dest, void *invar, void* outvar)");
		out.getWriter(M_CALLS_H).println("{");
		
		out.getWriter(M_CALLS_H).println("switch(dest)");
		out.getWriter(M_CALLS_H).println("{");
		it = fns.iterator();
		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();

			if (!isNodeAbstract(g, td.getName()) && !g.isSource(td.getName())
					&& td.getPlatformName().equals(MyName)) {
				out.getWriter(M_CALLS_H).println(
						"case " + td.getName().toUpperCase() + "_NODEID: ");
				out.getWriter(M_CALLS_H).print(
						"return call I" + td.getName() + ".nodeCall(");
				out.getWriter(M_CALLS_H).print(
						"(" + td.getName() + "_in*)invar,");
				out.getWriter(M_CALLS_H).println(
						"(" + td.getName() + "_out*)outvar);");
			}
		}
		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return ERR_NONODE; //should never happen");
		out.getWriter(M_CALLS_H).println("}//callEdge\n");

		// generate callError
		out
				.getWriter(M_CALLS_H)
				.println(
						"result_t callError(uint16_t nodeid, uint8_t error)");
		out.getWriter(M_CALLS_H).println("{");

		out.getWriter(M_CALLS_H).println("switch(nodeid)");
		out.getWriter(M_CALLS_H).println("{");

		Vector<ErrorHandler> errs = g.getProgram().getErrorHandlers();
		it = errs.iterator();
		while (it.hasNext()) {
			ErrorHandler eh = (ErrorHandler) it.next();
			TaskDeclaration target = g.getProgram().getTask(eh.getTarget());

			if (target.getPlatformName().equals(MyName)) {
				out.getWriter(M_CALLS_H).println(
						"case " + eh.getTarget().toUpperCase() + "_NODEID: ");
				out.getWriter(M_CALLS_H).print(
						"return call I" + eh.getFunction() + ".errCall(");
				out.getWriter(M_CALLS_H).println(
						"(" + target.getName() + "_in*)NULL,error);");
				//TODO:  Need to fix this so it actually passes in the variables.
			}
		}

		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return handle_exit(nodeid);");
		out.getWriter(M_CALLS_H).println("}//callError\n");

		// generate getErrorWeight
		out.getWriter(M_CALLS_H).println(
				"uint16_t getErrorWeight(uint16_t nodeid)");
		out.getWriter(M_CALLS_H).println("{");

		out.getWriter(M_CALLS_H).println("switch(nodeid)");
		out.getWriter(M_CALLS_H).println("{");

		it = fns.iterator();
		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();

			Vertex src = g.getVertex(td.getName());
			Vertex dest = null;
			Vector<ErrorHandler> errhs = g.getProgram().getErrorHandlers();

			for (ErrorHandler err : errhs) {
				if (err.getTarget().equals(td.getName())) {
					dest = g.getVertex(err.getFunction());
					break;
				}
			}
			if (dest == null) {
				dest = g.getVertexError();
			}
			// System.out.println("about to connect: " + src.toString() + " to "
			// + dest.toString());
			int weight = g.getEdgeWeight(src, dest, null);

			out.getWriter(M_CALLS_H).println(
					"case " + td.getName().toUpperCase() + "_NODEID: ");
			out.getWriter(M_CALLS_H).println("return " + weight + ";");

		}

		out.getWriter(M_CALLS_H).println("}//switch");
		out.getWriter(M_CALLS_H).println("return 0;//This is an error");
		out.getWriter(M_CALLS_H).println("}//callError\n");

		printHFooter(M_CALLS_H, out.getWriter(M_CALLS_H));

	}

	public  void generateStruct(ProgramGraph g, TaskDeclaration td, PrintWriter out,
			String trail, boolean in) {
		Vector<Argument> args;

		if (in) {
			args = td.getInputs();
		} else {
			args = td.getOutputs();
		}

		// if the ins are greater than zero, it can't be a source node?
		// if (ins.size() > 0) {
		out.println("typedef struct " + td.getName() + trail);
		out.println("{");
		//out.println("\trt_data _pdata;");

		for (Argument a : args)
			out.println("\t" + a.getType() + " " + a.getName() + ";");
		out.println("} " + td.getName() + trail + ";");
		out.println();
		if (!this.isNodeAbstract(g,td.getName()))
		{
			out.println(td.getName() + trail + " __"+td.getName() + trail+";");
			if (g.isSource(td.getName()) && trail.equals("_out"))
			{
				out.println(td.getName() + trail + " __"+td.getName() + trail+"_queue[SRC_QUEUE_SIZE];");
				out.println("bool __"+td.getName() + trail+"_valid[SRC_QUEUE_SIZE];");
			}
			out.println();
		}
		// }
	}

	public  boolean isNodeAbstract(ProgramGraph g, String name) {
		FlowStatement flow = g.getProgram().getFlow(name);
		if (flow == null)
			return false;
		return true;

	}

	public  void generateOutStruct(ProgramGraph g, TaskDeclaration td, PrintWriter out) {
		generateStruct(g, td, out, "_out", false);
	}

	public  void generateInStruct(ProgramGraph g, TaskDeclaration td, PrintWriter out) {
		generateStruct(g, td, out, "_in", true);
	}

	public  void getNodeIDs(ProgramGraph pg) {
		int id = 0;
		Collection fns = pg.getFunctions();
		Iterator it = fns.iterator();

		nodeID.clear();

		while (it.hasNext()) {
			TaskDeclaration td = (TaskDeclaration) it.next();
			// printStructs(td, out.getWriter(M_STRUCT_H));
			nodeID.put(td.getName(), id);
			id++;

		}
		// System.out.println("id="+nodeID.size());

	}

	/*public void generate(String root, ProgramGraph pg, Program pm,
			boolean stubbs) throws IOException {

			TinyOSGenerator.generate(root,pg,pm,stubbs);
	} */

	public void generate(String root, ProgramGraph pg, Program pm,
			boolean stubbs) {
		// totalStages = h.size();
		// stageNumber = h;
		try {
			generate(root, pg, stubbs);
		}
		catch (Exception e)
		{
			System.out.println("Generate FAILED! : ");
			e.printStackTrace();
			System.exit(3);
		}

	}

	/**
	 * Generate a threaded program
	 *
	 * @param root
	 *            The root directory to output into
	 * @param g
	 *            The program graph
	 */
	public  void generate(String root, ProgramGraph g, boolean stubbs)
			throws IOException {

		// ProgramGraph progGraph = g;
		VirtualDirectory out = new VirtualDirectory(root);

		// prologue(g, out);
		defined.clear();
		getNodeIDs(g);
		if (stubbs) {
			out.getWriter("userstructs.h").println("//empty stubb header");
			generateNodes(g, out);
			generateErrHandlers(g, out);
		}

		generateStructs(g, out);
		generateNodesHeader(g, out, false);
		generateCallHandlers(g, out);

		generateRuntimeModule(g, out);
		generateRuntimeConfig(g, out);
		if (stubbs) {
			generateTypeChecks(g, out);
		}
		//generateMarshallers(g, out);

		generateMakefile(g, out);
		// epilogue(out);
		out.flushAndClose();
		callBash("indent " + root + "/*.nc");
		callBash("indent " + root + "/*.h");
		callBash("rm " + root + "/*~");
	}

	public  int callBash(String s) {
		int result = -1;

		System.out.println("BASH(" + s + ")");

		try {
			String[] CMD = { "/bin/bash", "-c", s };
			ProcessBuilder pb = new ProcessBuilder(CMD);
			pb.redirectErrorStream(true);
			Process p = pb.start();
			int data = 0;
			while (data >= 0) {
				data = p.getInputStream().read();
				if (data >= 0) {
					char c = (char) data;
					System.out.print(c);
				}
			}

			p.waitFor();
			result = p.exitValue();
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		}
		return result;

	}

	public  void generateMakefile(ProgramGraph g, VirtualDirectory out) {
		out.getWriter(M_MAKEFILE).println("COMPONENT = Runtime");
		out.getWriter(M_MAKEFILE).println("PFLAGS +=-I%T/lib/TinyRely");
		//out.getWriter(M_MAKEFILE).println("PFLAGS +=-Iruntime");
		out.getWriter(M_MAKEFILE).println("MSG_SIZE = 60");
		out.getWriter(M_MAKEFILE).println("include ../Makerules");
		out.getWriter(M_MAKEFILE).println("");

	}

	/*
	 * protected  int getStageNumber(String name) { Integer stg =
	 * stageNumber.get(name); if (stg == null) { stg = new Integer(totalStages);
	 * totalStages++; stageNumber.put(name, stg); } return stg.intValue(); }
	 */

	/*
	 * public  void generateSimpleStatement (SimpleFlowStatement sfs,
	 * Program p, VirtualDirectory out) { Vector<String> args =
	 * sfs.getArguments();
	 *
	 * for (int i=args.size()-1;i>=0;i--) { int stg =
	 * getStageNumber(args.get(i)); out.getWriter(M_LOGIC_CPP).println
	 * ("\t\tev->push("+stg+"); // "+args.get(i)); } }
	 */

}
