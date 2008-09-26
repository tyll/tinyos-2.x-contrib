package edu.umass.eflux;

import java.util.Collection;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;
import java.util.HashMap;

/**
 * The TimerSource class represents a source which periodically kicks off activity in
 * a Markov program.
 * @author 
 * @version 0.1
 **/
public class TimerSource extends Source {
    protected HashMap<String, Vector> constraints;
	protected boolean sync;
    
    public TimerSource (String source, String session, String target, boolean sync) {
    	super(source, session, target);
		this.sync = sync;
/*    	
    	this.source_fn = source;
		this.session_fn = session;
		this.target = target;
		
	*/	
		//this.mayblock = mayblock;
    }

	// RESULT = (s==null)?(new TimerSource(i, d)):(new TimerSource(i,s,d)); 
	public TimerSource (String source, String target, boolean sync) {
		super (source, target);
		this.sync = sync;
		/*
		this.source_fn = source;
		this.session_fn = null;
		this.target = target;
		*/	
	}
	
	//TODO: addConstraints function

	public void addConstraint(String state, Integer hi, Integer low) {
		System.out.println("adding constraint..."+state+","+hi+","+low);
	}


}
