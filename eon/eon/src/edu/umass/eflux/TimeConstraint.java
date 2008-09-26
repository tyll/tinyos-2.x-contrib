package edu.umass.eflux;

import java.util.Collection;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;
import java.util.HashMap;

/**
 * The TimeConstraint class represents the bounds of a timer for a given state
 * 
 * @author
 * @version 0.1
 */
public class TimeConstraint {
	protected String timer;

	protected String state;

	protected Integer high_val;

	protected Integer low_val;

	protected TimeValue max;

	protected TimeValue min;

	/**
	 * Constructor
	 */
	/*
	 * public TimeConstraint(String timer, String target) { //this(source, null,
	 * target, false); }
	 */

	/**
	 * @param timer
	 * @param state
	 * @param high_string
	 * @param low_string
	 */
	public TimeConstraint(String timer, Vector<String> state,
			String high_string, String low_string) throws Exception {
		this.timer = timer;

		if (state.size() != 1)
			throw new Exception(
					"Error: Multiple states for one time constraint");

		this.state = (String) state.firstElement();

		if (this.state.equals("*")) {
			this.state = "BASE";
		}

		this.max = new TimeValue(high_string);
		this.min = new TimeValue(low_string);
		this.high_val = this.max.getMSValue();
		this.low_val = this.min.getMSValue();
		System.out.print("TimeConstraint: " + timer + "[" + this.state + "]");
		System.out.println("(" + max + "," + min + ")");
	}

	public String getTimer() {
		return this.timer;
	}

	public String getState() {
		return this.state;
	}

	public Integer getHiVal() {
		return this.high_val;
	}

	public Integer getLoVal() {
		return this.low_val;
	}

	public boolean equals(Object o) {
		if (o instanceof Source) {
			// TODO: check
		}
		return false;
	}

	public int hashCode() {
		// TODO: implement
		// return (source_fn+target).hashCode();
		return 0;
	}
	
	public String toString()
	{
		return timer + " " + state + " " + high_val + " " + low_val ;
	}

}
