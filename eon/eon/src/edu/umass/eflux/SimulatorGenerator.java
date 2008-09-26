package edu.umass.eflux;

import java.io.BufferedWriter;
import java.io.PrintWriter;
import java.util.Collection;
import java.util.Iterator;
import java.util.Vector;

import jdsl.graph.api.Edge;
import jdsl.graph.api.EdgeDirection;
import jdsl.graph.api.EdgeIterator;
import jdsl.graph.api.Vertex;
import jdsl.graph.ref.IncidenceListGraph;
import java.util.Hashtable;

import edu.umass.eflux.ErrorHandler;
import edu.umass.eflux.FlowStatement;
import edu.umass.eflux.GraphNode;
import edu.umass.eflux.VirtualDirectory;


public class SimulatorGenerator extends TinyOSGenerator 
{
	

	ProgramGraph programGraph;
	Collection<TaskDeclaration> functions;
	Collection<Source> sources;
	Collection<ErrorHandler> errors;
	IncidenceListGraph graph;
	Program program;
	int threadPoolSize = -1;
	Vector<String> sourceNames = new Vector<String>();
	Vector<String> printedFunctions = new Vector<String>();
	
	
	StateOrder stateOrder;
/*
 * private Hashtable<String, SimpleFlowStatement> simpleFlowHashtable = new
 * Hashtable<String, SimpleFlowStatement>();
 */

	private Hashtable<String, Vector<Signature>> signatureHashtable
		=  new Hashtable<String, Vector<Signature>>();
	
	
	public SimulatorGenerator()
	{
	
	}
		
	public void generator(String root, ProgramGraph pg, Program p, boolean stubbs)
	{
		stateOrder = p.getStates();
		// System.out.println(stateOrder.toString());
		program = p;
		programGraph = pg;
		
		functions = programGraph.getProgram().getFunctions();
		sources = programGraph.getSources();
		errors = programGraph.getErrors();
		graph = programGraph.graph;

		generateFlowStatementMap();
		
		makeSimulationProgram(root);
		
		copyHeaderFiles(root);
	}
	
	private void printIncludes(PrintWriter out)
	{
		out.println("#include <string>");
		out.println("#include <sys/types.h> ");
		out.println("#include <sys/stat.h> ");
		out.println("#include <unistd.h>");
		out.println("#include <fcntl.h>");
		out.println("#include <sys/mman.h>");
		out.println("#include <limits.h>");
		out.println("#include <float.h>");
		out.println("#include <iostream>");
		out.println("#include <fstream>");
		out.println("#include \"simulator.h\"");
		out.println("#include \"evaluator.h\"");
		out.println("\n\n");
	}
	
	private void printConstants(PrintWriter out)
	{
		// out.println("#define BATTERY_CAPACITY 27000");
		
		out.println("#define SOLAR_PANEL_EFFICIENCY	.20");	
		// out.println("#define LOSS_PER_UNIT_TIME 3");
		
		out.println("\n");
		
		for (Source src: sources)
		{
			out.print("#define SOURCE_" + src.source_fn.toUpperCase());
			out.println("\t" + ProgramGraph.getStageNumber(src.source_fn));
		}
		
		out.println("\n");
		
		printStateOrderDefinies(out);
		
		out.println("\n\n");
	}
	
	private void printStateOrderDefinies(PrintWriter out)
	{
		for (Vector<String> ordering: stateOrder.getOrdering())
		{
			for(String currStr: ordering)
			{
				out.print("#define POWER_STATE_" + currStr.toUpperCase());
				out.println("\t " + stateOrder.GetStateLevel(currStr));
			}
		}
	}
	
	private void printGlobalVariables (PrintWriter out)
	{
		out.println("int64_t current_time;");
		out.println("int64_t current_battery_fullness;");
		out.println("int current_power_state;");
		out.println("double current_state_grade;");
		out.println("int64_t battery_capacity;");
		out.println("int64_t loss_per_unit_time;");
		out.println("int64_t energy_reeval_interval;");
		out.println("string output_file;");
		out.println("string tmp_file;");
		out.println("vector<string>* str_vector;");
		out.println("requests_in_t *requests_in;");
		out.println("energy_in_t *energy_in;");
		
		out.println("FILE *fp;");
		
		
	}
	
	private void printDecrementPowerLevel(PrintWriter out)
	{
		out.println("void decrement_power_level (int path_sum ){");
		out.println("}");
	}
	
	private void printMain(PrintWriter out)
	{
		out.println("int main(int argc, char **argv){");
				
		out.println("int64_t initialfullness = 0;");
		out.println("if (argc != 9){");
			
		out.print("printf(\"usage: <input energy file> <input request file> <output file> ");
		out.println("<battery_capacity> <initial_battery> <loss_per_unit_time> <energy_reeval_interval> <sim_time>\\n\");");
		out.println("exit(1);");
		out.println("}");
			
		out.println("string input_energy_file (argv[1]);");
		out.println("string input_request_file (argv[2]);");
		out.println("output_file = argv[3];");
		out.println("char form[256] = \"/tmp/simXXXXXX\";");
		
		// out.println("tmp_file = tempnam(\"/tmp/\",NULL);");
		out.println("mkstemp(form);");
		out.println("tmp_file = form;");
		out.println("battery_capacity = atoll(argv[4]);");
		out.println("initialfullness = atoll(argv[5]);");
		out.println("double loss = atof(argv[6]);");
		out.println("loss_per_unit_time = (int64_t)(loss * 60000.0);");
		out.println("energy_reeval_interval = atoll(argv[7]);");
		out.println("int64_t sim_time = atoll(argv[8]);");
		out.println("fp = fopen(tmp_file.c_str(), \"w\");");
		out.println("fclose(fp);");
		
		out.println("energy_in =  read_energy_in((char *) input_energy_file.c_str());");
		out.println("requests_in = read_requests_in((char *)input_request_file.c_str());"); 
		// out.println("make_timeline(energy_in, requests_in, (char *)
		// output_file.c_str());");
		
		out.println("load_path_costs();");
		out.println("str_vector= make_timeline(energy_in, requests_in);");
		
		out.println("init(initialfullness);");
		out.println("parse_timeline(str_vector, sim_time);");

		out.println("string cmd = \"cp \";");
		out.println("cmd = cmd + tmp_file + \" \" + output_file;");
		out.println("printf(\"%s\\n\",cmd.c_str());");
		out.println("system(cmd.c_str());");
		out.println("cmd = \"rm \"+tmp_file;");
		out.println("printf(\"%s\",cmd.c_str());");
		out.println("system(cmd.c_str());");
		out.println("return 0;");
		out.println("}");

	}
	
	private int copyHeaderFiles(String root)
	{
		int result = -1;
		try
		{
			
			String[] CMD = {"/bin/bash", "-c", "cp src/simulator/*.h " + root + "/simulator/."};
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
			

			String[] CMD2 = {"/bin/bash", "-c", "cp src/simulator/evaluator.h " + root + "/simulator"};
			pb = new ProcessBuilder(CMD2);
			pb.redirectErrorStream(true);
			p = pb.start();
			data = 0;
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
			System.out.println("Exception: "+e.getMessage() + " result: " + result);
		}
		
		return result;
	}
	
	private void makeSimulationProgram(String root)
	{
		try 
		{
			System.out.println(root);
			VirtualDirectory virtDir = new VirtualDirectory(root + "/simulator");

			
			getNodeIDs(this.programGraph);
			generateNodesHeader(this.programGraph, virtDir, true);
			
			
			// PrintWriter out = new PrintWriter(new BufferedWriter(virtDir
			// .getWriter("simulator.cpp")));
			PrintWriter out = virtDir.getWriter("simulator.cpp");

			printIncludes(out);
			printConstants(out);

			this.printGlobalVariables(out);  
			
			this.printSimulationFunctionStubs(out);
			
			out.println("// Task Declaration Stubs");
			printTaskDeclarations(out);

			this.printAddLogFunction(out);
			
			// this.printIncreaseBattery(out);
			// this.printDecrementIdle(out);
			// this.printDecrementPowerLevel(out);
			// this.printReplenishBattery(out);
			
			// this.printParseTimeline(out);
			
			printRunRequest(out);
			
			this.printInit(out);
			
			out.println("// Main function here");
			printMain(out);
			
			out.println("// Actual Source Wrapper Functions...");
			printSourceWrapperFunctions(out);
			
			out.println("// Actual Simulation Functions...");
			printFunctions(out);
			
			out.println("// Actual Error Functions...");
			printErrors(out);
			
			// out.flush();
			// out.close();
			virtDir.flushAndClose();
		}
		catch (Exception e) 
		{
			System.out.println(e.toString());
		}
	}
	
	private void printFunctions(PrintWriter out)
	{
		for (TaskDeclaration td : functions)
		{
			printFunction(out, td.getName());
		}
	}

	private void printErrors(PrintWriter out)
	{
		for (TaskDeclaration td : functions)
		{
			if (td.getErrorHandler() != null)
			{
				String errorHandler = td.getErrorHandler();
				out.println("void " + errorHandler + " (int current_path_sum, string typedefs){");
				out.println("}");
			}
		}
	}
	
	private Signature extractSignature (SimpleFlowStatement sfs)
	{
		Signature ret = new Signature (sfs.getTypes(), sfs.getState(), sfs.assignee, sfs.getArguments().firstElement());
		return ret;
	}
	
	private void generateFlowStatementMap()
	{
		for(TaskDeclaration td: functions)
		{
			if (TelosGenerator.isNodeAbstract(programGraph, td.getName()))
			{
				
				FlowStatement flow = programGraph.getProgram().getFlow(td.getName());
				Vector<SimpleFlowStatement> paths = TelosGenerator.getFlowList(flow);
				if(paths.size() > 0)
					System.out.println(td.getName());
				
				for (SimpleFlowStatement sfs: paths)
				{
					if (sfs.state != null && sfs.types != null)
					{
						Vector<Signature> sigVector = signatureHashtable.get(td.getName());
						if (sigVector == null)
						{
							sigVector = new Vector<Signature>();
						}
						
						sigVector.add(extractSignature(sfs));
						signatureHashtable.put(td.getName(), sigVector);
					}
				}
			}
		}
		System.out.println(signatureHashtable.toString());
	}
	
	private void printFunction(PrintWriter out, String fnName, Vector<Signature> signatures)
	{
		out.println("string::size_type loc;");
		for (Signature sig: signatures)
		{
			
			Vector<String> types = sig.getTypes();
			out.print("if (");
			for (String str: types)
			{
				if(str.equals("*"))
				{
					out.print(" (1) ");
				}
				else
				{
					out.print(" ( typedefs.find( \"" + str + "\") != string::npos )");
				}
				out.print(" && ");
			}
			if (sig.getState().equals("*"))
				out.print("(1)");
			else
			{
				out.print("(current_power_state <= POWER_STATE_" + sig.getState().toUpperCase() + "  )");
			}
			
			out.println("){");
			// out.println("loc = typedefs.find(\"Video_LoBR\", 0);");
			// out.println("if (loc != string::npos){");
			out.println("// From: " + fnName + " To: " + sig.getTarget() + " Path Signature: " + sig.getSignature());
			out.println("current_path_sum +="  + programGraph.getEdgeWeight(fnName, sig.getTarget(), sig.getSignature()) + ";" );
			// out.println("current_path_sum +=" +
			// TelosGenerator.getEdgeWeight(programGraph, fnName,
			// sig.getTarget(), sig.getSignature()));
			
			out.println(sig.getTarget() + "(current_path_sum, typedefs);");
			out.println("return;");
			out.println("}");
		}
	}
	
	private void printFunction(PrintWriter out, String fnName)
	{
		out.println("void " + fnName + "(int current_path_sum, string typedefs){");
  
		Vertex vertex = (Vertex) programGraph.vertex_map.get(fnName);
// int degree = this.graph.degree(vertex, EdgeDirection.OUT);
		
		if (vertex.element() instanceof GraphNode)
		{
			// is this a branching node?
			if (signatureHashtable.get(fnName) != null)
			{
				printFunction(out, fnName, signatureHashtable.get(fnName));
			}
			// is this an end node ?
			else if(this.graph.areAdjacent(vertex, programGraph.getVertexExit()))
			{
				out.println("// this is an end node of some kind!");
				out.println("decrement_power_level(current_path_sum);");
				
			}
			// is this anything else ? (it better be)
			else
			{
				EdgeIterator edgeIterator = this.graph.incidentEdges(vertex, EdgeDirection.OUT);
				while(edgeIterator.hasNext())
				{
					Edge edge = edgeIterator.nextEdge();
					Vertex destination = this.graph.destination(edge);
					GraphNode graphNode = (GraphNode) destination.element();
					
					int nodeType = graphNode.getNodeType();
					if (nodeType != GraphNode.ENTRY && nodeType != GraphNode.EXIT && nodeType != GraphNode.ERROR) 
					{
						out.println("// From: " + fnName + " To: " + graphNode.toString());
						out.println("current_path_sum +="  + programGraph.getEdgeWeight(fnName, graphNode.toString(), "[]") + ";" );

						out.println(graphNode.toString() + "(current_path_sum, typedefs);");
					}

				}
			}
			out.println("}\n");

		}
		else
		{
			System.err.println("ERROR: element is not a GraphNode!");
			System.exit(1);
		}
	}
	
	private void printSourceWrapperFunctions(PrintWriter out)
	{
		for (Source src: sources)
		{
			out.println("void " + src.source_fn + "_wrapper(string typedefs){");
			
			int edgeValue = programGraph.getEdgeWeight(
					programGraph.getVertexEntry(), 
					programGraph.getVertex(src.source_fn), "[]");
			out.println("// From: ENTRY to " + src.source_fn);
			out.println("int current_path_sum = " +  edgeValue + ";");
			
			out.println(src.source_fn + "(current_path_sum, typedefs);");
			out.println("}");
		}
	}
	
	private void printSimulationFunctionStubs(PrintWriter out)
	{
		out.println("\n //Internal Functions");
		out.println("void init(int64_t fullness);");
		out.println("void increase_battery(int64_t energy);");
		out.println("void decrement_idle(string time_stamp);");
		out.println("void decrement_power_level (int path_sum );");
		out.println("void update_power_level(string str);");
		out.println("void run_request(string request_info);");
		out.println("void parse_timeline(vector<string>* time_line);");
		out.println();
	}
	
	private void printTaskDeclarations(PrintWriter out)
	{
		out.println("//Task Declarations");
		for (TaskDeclaration td : functions)
		{
			out.println("void " + td.getName() + "(int current_path_sum, string typedefs);");
		}
		
		for (ErrorHandler e: errors)
		{
			out.println("void " + e.getFunction() + "(int current_path_sum, string typedefs);");
		}
		
		/*
		 * Source Wrapper Function void <source_fn_name>_wrapper();
		 */
		out.println("\n//Source Wrapper Functions");
		for(Source s: sources)
		{
			out.println("void " + s.getSourceFunction() + "_wrapper(string typedefs);");
		}
		

		out.println("\n");
	}
	
	private void printDecrementIdle(PrintWriter out)
	{
		/*
		 * This function takes a string of the time at which an event happens.
		 * It then proceeds to find out how much time has passed since the last
		 * call to this function and it decrements battery appropriately.
		 */
		out.println("void decrement_idle(string time_stamp){");
		out.println("\tint64_t time = atoll(time_stamp.c_str());");
		out.println("\tint64_t diff = current_time - time;");
		out.println("\tcurrent_battery_fullness -= diff*loss_per_unit_time;");
		out.println("\tcurrent_time = time;");
		out.println("}\n");
	}
	
	private void printIncreaseBattery(PrintWriter out)
	{
		out.println("void increase_battery(int64_t energy){");
		out.println("\tcurrent_battery_fullness += energy;");
		out.println("\tif (current_battery_fullness > battery_capacity)");
		out.println("\t\tcurrent_battery_fullness = battery_capacity;");
		out.println("\tif (current_battery_fullness <= 0){");
		out.println("\t\tcurrent_battery_fullness=  0;");
		out.println("\t\tprintf(\"out of power at time: %ld\\n\", current_time);");
		out.println("\t}");
		out.println("}");
		out.println("\n\n");
	}
	
	/*
	 * Format of Input String: <time stamp> : <energy value>
	 */
	private void printReplenishBattery(PrintWriter out)
	{
		out.println("void update_power_level(string str){");
		out.println("\tstring::size_type loc = str.find(\":\", 0);");
		out.println("\tif(loc != string::npos){");
		out.println("\t\tstring power_time_string = str.substr(0, loc);");
		out.println("\t\t//decrement_idle(power_time_string);");
		out.println("\t\tstring energy_source_power_str = str.substr(loc+1);");
		out.println("\t\tint64_t energy_source_power = atoll(energy_source_power_str.c_str());");
		out.println("\t\tincrease_battery(energy_source_power);");
		out.println("\t}");
		out.println("}");
		out.println("\n\n");
	}

	private void printRunRequest(PrintWriter out)
	{
		out.println("void run_request(int64_t request_time, int node_id, string request_types){");
		// out.println("\tstring::size_type loc = request_info.find(\":\",
		// 0);");
		out.println("\tif (current_battery_fullness <= 0) return;");
		// out.println("\t\tif(loc != string::npos){");
		// out.println("\t\t\tstring time_string = request_info.substr(0,
		// loc);");
		// out.println("// now we find out what source node we ");
		// out.println("\t\t\tstring::size_type loc2 = request_info.find(\":\",
		// loc+1);");
		// out.println("\t\t\tif (loc2 != string::npos){");
		// out.println("\t\t\t\tstring src_node_str = request_info.substr(loc+1,
		// loc2 - loc -1 );");
		// out.println("\t\t\t\tint node_number = atoi(src_node_str.c_str());");
		out.println("\tswitch (node_id){");
		for (Source src: sources)
		{
			out.println("\t\tcase SOURCE_" + src.source_fn.toUpperCase() + ":");
			out.println("\t\t\t" + src.source_fn + "_wrapper( request_types );");
			out.println("\t\t\tbreak;");
		}
		
		out.println("\t\tdefault: ");
		out.println("\t\t\tprintf(\"Invalid option selected\\n\");");
		out.println("\t\t\tbreak;");
		out.println("}");
		out.println("}\n");

	}
	
	private void printParseTimeline(PrintWriter out)
	{
		/**
		 * This function goes through the time-line that is generated in
		 * <code>"make_timeline"</code> and executes all the events one at a
		 * time.
		 * 
		 * @param time_line -
		 *            a vector of C++ strings that represents the chain of
		 *            events
		 */
		out.println("void parse_timeline(vector<string>* time_line){");
		out.println("int size = time_line->size();");
		out.println("for(int i = 0; i < size; i++) {");
		out.println("string current_string = time_line->at(i);");
		out.println("// now we get the type of the event");
		out.println("string::size_type loc = current_string.find(\":\", 0);");
		out.println("if(loc != string::npos){");
		out.println("string event_type_string = current_string.substr(0, loc);");
		out.println("int event_type = atoi(event_type_string.c_str());");
		out.println("switch (event_type){");
		out.println("case UPDATE_BATTERY:");
		out.println("update_power_level(current_string.substr(loc+1));");	
		out.println("break;");
		out.println("case SERVICE_REQUEST:");
		out.println("run_request(current_string.substr(loc+1));");
		out.println("break;");
		
	out.println("case EVALUATE_ENERGY_POLICY:");
	out.println("{");
	out.println("\t\t\t\tenergy_evaluation_struct_t *eval_result ="); 
	out.println("\t\t\t\t\treevaluate_energy_level(str_vector, i, current_battery_fullness);");
	out.println("\t\t\t\t\t\tcurrent_power_state = eval_result->energy_state;");
	out.println("\t\t\t\t\tcurrent_battery_fullness -= eval_result->cost_of_reevaluation;");
	out.println("\t\t\t\t\tdelete eval_result;");
	
	out.println("\t\t\t\t\tbreak;");
	out.println("}");	
		out.println("default: ");
		out.println("printf(\"Invalid option selected\\n\");");
		out.println("break;");
		out.println("}");
		out.println("}");	
		out.println("}");
		out.println("printf(\"Simmulation Over \\n\");");
		out.println("printf(\"battery left: %f\\n\", current_battery_fullness);");
		out.println("printf(\"Percentage battery left: %f\\n\", (double) (current_battery_fullness / battery_capacity) );");
		out.println("}");
		out.println("\n\n");
		
	}
	
	private void printInit(PrintWriter out)
	{
		out.println("void init(int64_t fullness){");
		
		out.println("current_time = 0;");
		out.println("current_battery_fullness = fullness;");
		out.println("current_power_state = 0;");
		out.println("}\n");
	}
	
	private void printAddLogFunction(PrintWriter out)
	{
		out.println("void enter_into_log(string log_entry)");
		out.println("{");
		out.println("fp = fopen(tmp_file.c_str(), \"a\");");
		out.println("\tfprintf(fp, \"%s\\n\", log_entry.c_str());");
		out.println("\tfflush(fp);");
		out.println("fclose(fp);");
		out.println("}\n");
	}
	
	
	
	public class Signature
	{
		private Vector<String> types;
		private String state;
		private String assignee;
		private String target;
		
		public Signature(Vector<String> types, String state, String assignee, String target)
		{
			this.types = types;
			this.state = state;
			this.assignee = assignee;
			this.target = target;
		}
		
		public String getTarget()
		{
			return target;
		}
		
		public Vector<String> getTypes()
		{
			return types;
		}
		
		public String getState()
		{
			return state;
		}
		
		public String getAssignee()
		{
			return assignee;
		}
		
		
		public String getSignature()
		{
			if (types == null && state == null)
			{
				return "[]";
			}
			
			String sig = types.toString();
			if(sig != null)
			{
				sig = sig.replace("[", " ");
				sig = sig.replace("]", " ");
				sig = sig.trim();
			}

			return "[" + sig + " | " + state + "]";
		}
		
		/*
		 * format: [ signature | powerstate] destination
		 */
		public String toString()
		{
			String sig = types.toString();
			if(sig != null)
			{
			sig = sig.replace("[", " ");
			sig = sig.replace("]", " ");
			sig = sig.trim();
			}
			return "[" + sig + " |" + state + "] " + assignee;
		}
	}
	
}