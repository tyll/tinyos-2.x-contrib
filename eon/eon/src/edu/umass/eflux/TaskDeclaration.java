package edu.umass.eflux;

import java.util.Vector;

/**
 * The functional declaration of a task
 * 
 * @author Brendan Burns
 * @version $version: $
 */
public class TaskDeclaration {
	private Vector<Argument> in;

	private String name;

	private Vector<Argument> out;

	private String ErrorHandler = null;

	private boolean reentrant, replicable, mayblock;

	private boolean isSrc = false, isSrcEnd = false;

	private boolean isSrcTimer = false;

	private String srcName = null;

	private String platformName = null;

	/**
	 * Constructor
	 * 
	 * @param inputs
	 *            The set of inputs
	 * @param functionName
	 *            The name of the function, a Vector of Argument
	 * @param outputs
	 *            The set of outputs, a Vector of Argument
	 * @param r
	 *            The specification of the runtime environment
	 */
	public TaskDeclaration(Vector<Argument> inputs, String functionName,
			Vector<Argument> outputs, RunSpec r) {
		this.in = inputs;
		this.out = outputs;
		this.name = functionName;
		this.reentrant = r.isReentrant();
		this.replicable = r.isReplicable();
		this.mayblock = r.mayBlock();
		this.isSrcTimer = false;
	}

	public TaskDeclaration(Vector<Argument> inputs, String functionName,
			Vector<Argument> outputs) {
		this.in = inputs;
		this.out = outputs;
		this.name = functionName;
		this.isSrcTimer = false;
	}

	public void setErrorHandler(String errorHandler) {
		this.ErrorHandler = errorHandler;
	}

	public String getErrorHandler() {
		return this.ErrorHandler;
	}

	/**
	 * Constructor
	 * 
	 * @param inputs
	 *            The set of inputs
	 * @param functionName
	 *            The name of the function, a Vector of Argument
	 * @param outputs
	 *            The set of outputs, a Vector of Argument
	 */
	public TaskDeclaration(Vector<Argument> inputs, String functionName,
			Vector<Argument> outputs, String platform) {
		this.in = inputs;
		this.out = outputs;
		this.name = functionName;
		this.reentrant = true;
		this.replicable = true;
		this.mayblock = false;
		this.platformName = platform;
	}

	/**
	 * Constructor for the TaskDeclaration of a Timer Source Node Note that it
	 * has NO inputs
	 * 
	 * @param functionName
	 *            The name of the function
	 * @param outputs -
	 *            the signature of the outputs
	 */
	public TaskDeclaration(String functionName) {
		this.in = new Vector<Argument>();
		this.out = new Vector<Argument>();
		this.name = functionName;
		this.isSrcTimer = true;
	}

	public void setIsSrcEnd(boolean isSrcEnd) {
		this.isSrcEnd = isSrcEnd;
	}

	public boolean getIsSrcEnd() {
		return isSrcEnd;
	}

	public void setIsSrc(boolean isSrc) {
		this.isSrc = isSrc;
	}

	public boolean getIsSrc() {
		return this.isSrc;
	}

	public void setSrcName(String srcName) {
		this.srcName = srcName;
	}

	public String getSrcName() {
		return this.srcName;
	}

	public boolean isReentrant() {
		return this.reentrant;
	}

	public boolean isReplicable() {
		return this.replicable;
	}

	public boolean mayBlock() {
		return this.mayblock;
	}

	/**
	 * Get the input set for this task
	 * 
	 * @see Argument
	 * @return The inputs, a Vector of Argument
	 */
	public Vector<Argument> getInputs() {
		return this.in;
	}

	/**
	 * Get the output set for this task
	 * 
	 * @see Argument
	 * @return The outputs, a Vector of Argument
	 */
	public Vector<Argument> getOutputs() {
		return this.out;
	}

	/**
	 * Get the name for this task
	 * 
	 * @return The name of the function implementing this task
	 */
	public String getName() {
		return this.name;
	}

	/**
	 * Do the inputs of the specified task match this task's inputs?
	 * 
	 * @param td
	 *            The task to test against
	 * @return true if the inputs match, false otherwise
	 */
	public boolean isInMatch(TaskDeclaration td) {
		return isArgMatch(getInputs(), td.getInputs());
	}

	/**
	 * Do the outputs of the specified task match this task's outputs?
	 * 
	 * @param td
	 *            The task to test against
	 * @return true if the outputs match, false otherwise
	 */
	public boolean isOutMatch(TaskDeclaration td) {
		return isArgMatch(getOutputs(), td.getOutputs());
	}

	/**
	 * Do the outputs of the specified task match this task's inputs?
	 * 
	 * @param td
	 *            The task to test against
	 * @return true if the outputs match the inputs, false otherwise
	 */
	public boolean isInOutMatch(TaskDeclaration td) {
		return isArgMatch(getInputs(), td.getOutputs());
	}

	/**
	 * Do the inputs of the specified task match this task's outputs?
	 * 
	 * @param td
	 *            The task to test against
	 * @return true if the inputs match the outputs, false otherwise
	 */
	public boolean isOutInMatch(TaskDeclaration td) {
		return isArgMatch(getOutputs(), td.getInputs());
	}

	/**
	 * Do the arguments match?
	 * 
	 * @param v1
	 *            A Vector of Argument
	 * @param v2
	 *            A Vector of Argument
	 * @return true if the arguments match, false otherwise
	 */
	protected static boolean isArgMatch(Vector<Argument> v1, Vector<Argument> v2) {
		if (v1.size() != v2.size())
			return false;

		for (int i = 0; i < v1.size(); i++) {
			if (!(v1.get(i)).getType().equals((v2.get(i)).getType())) {
				return false;
			}
		}
		return true;
	}

	/**
	 * String-i-fy this object
	 * 
	 * @return The string representation of this object
	 */
	public String toString() {
		return this.in.size() + "=>" + this.name + "=>" + this.out.size();
	}

	public boolean equals(Object o) {
		if (o instanceof TaskDeclaration) {
			TaskDeclaration task = (TaskDeclaration) o;
			return task.getName().equals(getName()) && task.isInMatch(this)
					&& task.isOutMatch(this);
		}
		return false;
	}

	/**
	 * set the platform
	 * 
	 * @param plat
	 *            String that specifies the platform
	 */
	public void setPlatformName(String plat) {
		
		platformName = plat;
	}

	/**
	 * @return Returns the platformName.
	 */
	public String getPlatformName() {
		if (platformName == null)
		{
			return "";
		} else {
			return platformName;
		}
	}
}
