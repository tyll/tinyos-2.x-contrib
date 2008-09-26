package edu.umass.eflux;

/**
 * The Source class represents a source which kicks off activity in
 * a Markov program.
 * @author Brendan burns
 * @version 0.1
 **/
public class Source {
    protected String source_fn;
    protected String energystate;
    protected String target;

    /**
     * Constructor
     * @param source The name of the source function.
     * @param target The name of the target unit.
     **/
    public Source(String source, String target) {
    	this(source, null, target, false);
    }

    /**
     * Constructor
     * @param source The name of the source function.
     * @param energystate The name of the attached energy state
     * @param target The name of the target unit.
     **/
    public Source(String source, String estate, String target) {
    	this(source, estate, target, false);
    }

    public void setTarget(String target)
    {
    	this.target = target;
    }

    /**
     * @param source The name of the source function.
     * @param target The name of the target unit.
     * @param mayblock Might this source block?
     **/
    public Source (String source, String target, boolean mayblock)
    {
    	this(source, null, target, mayblock);
    }

    /**
     * @param source The name of the source function.
     * @param energystate The name of the attached energy state
     * @param target The name of the target unit.
     * @param mayblock Might this source block?
     **/
    public Source
	(String source, String estate, String target, boolean mayblock)
    {
	this.source_fn = source;
	this.energystate = estate;
	this.target = target;
	//this.mayblock = mayblock;
    }

    /**
     * might this source block?
     * @returns true If this source may block
     **/
			// TODO: this needs to go!
    public boolean mayBlock() {
		return false;
    }

    public String getEnergyState() {
	return energystate;
    }

    /**
     * Get the source function
     * @return The name of the source function
     **/
    public String getSourceFunction() {
	return source_fn;
    }

    /**
     * Get the target unit
     * @return The name of the target unit
     **/
    public String getTarget() {
	return target;
    }

    public boolean equals(Object o) {
	if (o instanceof Source) {
	    Source s = (Source)o;
	    return s.source_fn.equals(source_fn) &&
		s.target.equals(target);
	}
	return false;
    }

    public int hashCode() {
	return (source_fn+target).hashCode();
    }

    public String toString() {
	return source_fn +"=>"+target;
    }
}
