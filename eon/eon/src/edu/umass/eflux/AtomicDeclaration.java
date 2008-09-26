package edu.umass.eflux;

import java.util.Vector;

public class AtomicDeclaration {
    protected String name;
    protected Vector<Lock> locks;

    public AtomicDeclaration(String node, Vector<Lock> locks) {
    	this.name=node;
    	this.locks = locks;
    }

    Vector<Lock> getLocks() {
    	return this.locks;
    }

    String getName() {
    	return this.name;
    }
}
