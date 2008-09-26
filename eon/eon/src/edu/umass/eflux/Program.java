package edu.umass.eflux;


import java.util.*;

import edu.umass.eflux.AtomicDeclaration;
import edu.umass.eflux.ErrorHandler;
import edu.umass.eflux.FlowStatement;


/**
 * The top level representation of a Flux program
 * @author Brendan Burns
 * @version $version: $
 * @revised Matt Brennan
 **/
public class Program {
    private Vector<Source> sources;
	private	Vector<TimerSource> timersources;
	private	Vector<Platform> platforms;
    private Vector<TimeConstraint> time_bounds;
    private Vector<FlowStatement> exps;
    private Vector<ErrorHandler> errors;
    private Hashtable<String, TaskDeclaration> decls;
    private Hashtable<String, TypeDeclaration> type_decs;
    private Hashtable<String, AtomicDeclaration> atomic_defs;
	private StateOrder stateorder;

	public final String EonSend = "EonSend";
	public final String EonRecv = "EonRecv";

    /**
     * Constructor
     * @param kick The function which kicks off this program
     * @param types A Vector of TypeDeclarations defining types.
     * @param decl_list A Vector of TaskDeclarations defining functions
     * @param program A Vector of FlowStatements defining the program
     **/
	public Program(Vector<Source> sources,
			Vector<Platform> platforms,
			Vector<TimeConstraint> times,
			Vector<TypeDeclaration> types,
			Vector<Vector<String>> states,
			Vector<FlowStatement> program,
			Vector<AtomicDeclaration> atomic_decls,
			Vector<ErrorHandler> errors)
	throws Exception
	{


		this.platforms = platforms;
		this.sources = sources;
		this.exps = program;
		this.errors = errors;
		this.stateorder = new StateOrder(states);
		this.time_bounds = times;
		this.timersources = new Vector<TimerSource>();
		this.decls = new Hashtable<String, TaskDeclaration>();

		//System.out.println("\n\n ");
		//include network code?
		boolean sends, recvs;
		sends = false;
		recvs = false;
		for (FlowStatement exp : this.exps)
		{
			if (exp.inRightHandSide(this.EonSend))
			{
				sends = true;
			}
			if (exp.getAssignee().equals(this.EonRecv))
			{
				recvs = true;
			}
		}
		
		
		
		for (Platform platform: platforms)
		{
			//TODO: make sure that we don't have duplicate names... for now we ignore this problem.
			for (int i=0;i<platform.tasks.size();i++) {
				platform.tasks.get(i).setPlatformName(platform.getName());
				this.decls.put((platform.tasks.get(i)).getName(), platform.tasks.get(i));
			}
			if (sends)
			{
				this.decls.put(this.EonSend, getNetworkSendTD(platform));
			}
			if (recvs)
			{
				this.decls.put(this.EonRecv, getNetworkRecvTD(platform));
			}

		}

		for (Source s: sources) {
			if (s instanceof TimerSource) {
				this.timersources.add((TimerSource)s);
				//TaskDeclaration
				TaskDeclaration newTD = new TaskDeclaration(s.getSourceFunction());
				TaskDeclaration target = this.decls.get(s.getTarget());
				if (target == null)
				{
					System.out.println("ERROR:  Abstract node "+s.getTarget()+" is used but not declared!");
					System.exit(1);
				}
				newTD.setPlatformName(target.getPlatformName());
				this.decls.put(s.getSourceFunction(),newTD);

			}
		}

		this.type_decs = new Hashtable<String, TypeDeclaration>();
		for (int i=0;i<types.size();i++) {
			this.type_decs.put((types.get(i)).getName(),
					types.get(i));
		}
		this.atomic_defs = new Hashtable<String, AtomicDeclaration>();
		for (AtomicDeclaration ad : atomic_decls) {
			this.atomic_defs.put(ad.getName(), ad);
		}
	}

	private TaskDeclaration getNetworkSendTD(Platform plat)
	{
		Vector<Argument> inputs = new Vector<Argument>();
		Vector<Argument> outputs = new Vector<Argument>();
		inputs.add(new Argument("eon_message_t", "msg"));
		inputs.add(new Argument("uint16_t", "addr"));
		return new TaskDeclaration(inputs, this.EonSend, outputs, plat.getName());

	}

	private TaskDeclaration getNetworkRecvTD(Platform plat)
	{
		Vector<Argument> inputs = new Vector<Argument>();
		Vector<Argument> outputs = new Vector<Argument>();
		outputs.add(new Argument("eon_message_t", "msg"));
		outputs.add(new Argument("uint16_t", "addr"));
		return new TaskDeclaration(inputs, this.EonRecv, outputs, plat.getName());

	}

	public Source getSessionStart(FlowStatement fs) {
		for (Source s : sources) {
			if (s.getTarget().equals(fs.getAssignee()))
				return s;
		}
		return null;
	}

    /**
     * Get the set of atomic declarations
     * @return a Vector of AtomicDeclarations
     **/
    public Collection<AtomicDeclaration> getAtomicDeclarations() {
	return atomic_defs.values();
    }

    /**
     * Get a particular atomic declaration
     * @param name The name of the fn
     * @return The named atomic declaration
     **/
    public AtomicDeclaration getAtomicDeclaration(String name) {
	return atomic_defs.get(name);
    }

    /**
     * Get the set of error handlers
     * @return A Vector of ErrorHandlers
     * @see ErrorHandler
     **/
    public Vector<ErrorHandler> getErrorHandlers() {
	return errors;
    }

    /**
     * Get the set of sources for this Eon program
     * @return A vector of the String names of the sources
     * @see getTask
     **/
    public Vector<Source> getSources() {
	return sources;
    }

    /**
     * Get the set of sources for this Markov program
     * @return A vector of the String names of the sources
     * @see getTask
     **/
    public StateOrder getStates() {
	return this.stateorder;
    }

    /**
     * Get all of the functions in this Program
     * @return A Collection containing the TaskDeclarations in the program
     **/
    public Collection<TaskDeclaration> getFunctions() {
        return this.decls.values();
    }

    public Vector<Platform> getPlatforms()
	{
		return this.platforms;
	}
    /**
     * Get all of the types in this program
     * @return A Collection containing the TypeDeclarations
     **/
    public Collection getTypes() {
        return this.type_decs.values();
    }

    /**
     * Get the main function.  The main function (not to be confused with
     * the kickstart) is the expression whose left-hand side appears in
     * no right hand sides.
     * @return The FlowStatement which is the main expression for this program
     **/
    public FlowStatement getMain() {
        Vector stmts = (Vector) this.exps.clone();
        Iterator it = stmts.iterator();
        while (it.hasNext()) {
            FlowStatement stmt = (FlowStatement)it.next();
            String name = stmt.getAssignee();
            for (int i=0; i < this.exps.size(); i++) {
                FlowStatement temp = this.exps.get(i);
                if (temp.inRightHandSide(name)) {
                    System.err.println("Removing: " + it.toString());
                	it.remove();
                }
            }
        }
        //System.out.println(stmts.toString());
        return (FlowStatement)stmts.get(0);
    }

    /**
     * Get a named type
     * @param name The name of the type
     * @return The type, or null if it can't be found.
     **/
    public TypeDeclaration getType(String name) {
        return this.type_decs.get(name);
    }

    /**
     * Get a named task
     * @param name The name of the type
     * @return The task, or null if it can't be found.
     **/
    public TaskDeclaration getTask(String name) {
        return this.decls.get(name);
    }

    public Vector<TimeConstraint> getTimeConstraints()
    {
    	return this.time_bounds;
    }

    /**
     * Get all expressions
     * @return a Vector of FlowStatements containing all expressions
     **/
    public Vector getExpressions() {
        return this.exps;
    }

    /**
     * Get an indexe expression
     * @param ix The index of the expression
     * @return The expression
     **/
    public FlowStatement getExpression(int ix) {
        return this.exps.get(ix);
    }

    /**
     * Get a named flow statement
     * @param name The name of the left-hand side of the statement
     * @return The FlowStatement whose left-hand side matches name, or null
     **/
    public FlowStatement getFlow(String name) {
        for (int i=0; i < this.exps.size(); i++) {
            if ((this.exps.get(i)).getAssignee().equals(name))
                return this.exps.get(i);
        }
        return null;
    }

    /**
     * Find all instances of SimpleFlowStatements matching the left-hand
     * side of the specified statement, remove them from the program
     * and create a TypedFlowStatement containing them.
     * @param stmt The statement to unify
     * @return The new compound TypedFlowStatement
     **/
    public TypedFlowStatement unifyExpression(FlowStatement stmt) {
    	//System.out.println("Unifying statement : "+stmt.toString());
        TypedFlowStatement result = new TypedFlowStatement(stmt.getAssignee());
        result.addFlowStatement(stmt);
        Iterator it = this.exps.iterator();
        while (it.hasNext()) {
            FlowStatement fs = (FlowStatement)it.next();
            //System.out.println("Now unifying: " + fs.toString());
            if (fs != stmt) {
                if (fs.getAssignee().equals(result.getAssignee())) {
                    it.remove();
                    result.addFlowStatement(fs);
                }
            }
        }
        System.out.println("TypedFlowStatement: " + result.toString());
        return result;
    }

    /**
     * Find all instances of typed SimpleFlowStatements and merge them into
     * compound TypedFlowStatements
     * @see TypedFlowStatement
     **/
    public void unifyExpressions() {
        for (int i=0; i < this.exps.size(); i++)
        {
            if (this.exps.get(i) instanceof SimpleFlowStatement)
            {
                SimpleFlowStatement fs = (SimpleFlowStatement) this.exps.get(i);
                //System.out.println("SFS: " + fs.toString());
                if (fs.getTypes() != null || fs.getState() != null)
                {
                    TypedFlowStatement tfs = unifyExpression(fs);
                    this.exps.set(i, tfs);
                }
            }
        }
        //System.out.println("\n\n\n");
    }

    /**
     * Verify an expression to insure that input types match output types
     * @param stmt The expression to verify
     * @return true if the expression is valid, false otherwise
     **/
    public boolean verifyExpression(SimpleFlowStatement stmt) {
        Vector types = stmt.getTypes();
        Vector args  = stmt.getArguments();
        String left = stmt.getAssignee();

        TaskDeclaration td = this.decls.get(left);
        if (td == null) {
            System.err.println("Error, "+left+" is undefined.");
            return false;
        }

        if (types != null) {
            if (types.size()  != td.getInputs().size()) {
                System.err.println("Type specification for "+
                        stmt.getAssignee()+
                        " doesn't match arguments ("+
                        types.size()+":"+td.getInputs().size()+")");
                return false;
            }
            for (int i=0;i<types.size();i++) {
            	String type = (String)types.get(i);
            	if (!type.equals("*") && this.type_decs.get(type)==null) {
            		System.err.println("Type "+type+" is undefined.");
            		return false;
            	}
            }
        }

        if (args.size() > 0) {
            String now = (String)args.get(0);
            TaskDeclaration current = this.decls.get(now);
            if (current == null) {
                System.err.println("Error, "+now+" is undefined.");
                return false;
            }
            if (!current.isInMatch(td)) {
                System.err.println("Inputs  of "+now+" don't match inputs of "+
                        left);
                return false;
            }
            int i=1;
            while (i<args.size()) {
                String next = (String)args.get(i++);
                TaskDeclaration next_td = this.decls.get(next);
                if (next_td == null) {
                    System.err.println("Error, "+next+" is undefined.");
                    return false;
                }
                if (!current.isOutInMatch(next_td)) {
                    System.err.println("Outputs of "+now+
                            " don't match inputs of "+next+".");
                    return false;
                }
                now = next;
                current = next_td;
            }
            if (!current.isOutMatch(td)) {
                System.err.println("Outputs of "+now+
                        " don't match inputs of "+left+".");
                return false;
            }
        }
        return true;
    }

    /**
     * Verify all expression to insure that input types match output types
     * @return true if the expression is valid, false otherwise
     **/
    public boolean verifyExpressions() {
        for (int i=0; i < this.exps.size(); i++) {
            if (!verifyExpression((SimpleFlowStatement)this.exps.get(i))) {
                return false;
            }
        }
        return true;
    }

    /**
     * String representation of this program
     * @return The string representing this program
     **/
    public String toString() {
        return this.decls+"\n::\n"+this.exps;
    }

    /**
     * Get a source by name
     * @param name The name
     * @param srcs The list of sources
     **/
    Source getSource(String name) {
	for (Source src : sources) {
	    if (src.getSourceFunction().equals(name))
		return src;
	}
	return null;
    }

        /**
     * Is this task declaration a source?
     * @param task The task
     * @return true if the task declaration is a source
     **/
    boolean isSource(TaskDeclaration td) {
	String name = td.getName();
	for (Source src : sources) {
	    if (src.getSourceFunction().equals(name))
		return true;
	}
	return false;
    }

}
