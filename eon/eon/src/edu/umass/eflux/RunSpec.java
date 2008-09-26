package edu.umass.eflux;

/**
 * This class specifies the conditions underwhich a task may run
 * the three basic classes are Free, non-reentrant and non-replicable
 * @author Brendan Burns
 **/
public class RunSpec {
	private boolean reentrant;
	private boolean replicable;
    private boolean mayblock;
    
	/**
	 * Constructor
	 * @param reentrant Is this task reentrant?
	 * @param replicable Is this task replicable?
	 * @param mayblock Does this task block? (e.g. potentially run forever?)
	 **/
    public RunSpec(boolean reentrant, boolean replicable, boolean mayblock) {
	this.reentrant = reentrant;
	this.replicable = replicable;
	this.mayblock = mayblock;
    }
	
	/**
	 * Is this task reentrant?
	 * @return true if the task can be called multiple times simultaneously
	 *   from the same process
	 **/
	public boolean isReentrant() {
		return this.reentrant;
	}
	
	/**
	 * Is this task replicable?
	 * @return true if the task can be called multiple times simultaneously
	 *   from the different processes/contexts
	 **/
	public boolean isReplicable() {
		return this.replicable;
	}

    /**
     * May this spec block?
     * @return true if the task will block indefinitely if there is nothing to
     * return
     **/
    public boolean mayBlock() {
	return mayblock;
    }
}
