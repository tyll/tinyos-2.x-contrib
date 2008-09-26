package edu.umass.eflux;

import java.util.Vector;

import edu.umass.eflux.FlowStatement;

/**
 * A compound flow statement containing a number of typed SimpleFlowStatements
 * all of which share the same left hand side.
 * 
 * @author Brendan Burns
 * @version $version: $
 */
public class TypedFlowStatement extends FlowStatement {
	private Vector<FlowStatement> statements;

	/**
	 * Constructor
	 * 
	 * @param lhs
	 *            The left hand side of this statement
	 */
	public TypedFlowStatement(String lhs) {
		super(lhs);
		this.statements = new Vector<FlowStatement>();
		//System.out.println("Made a TypedFlowStatement: " + lhs);
	}

	/**
	 * Add a flow statement to this comound statement
	 * 
	 * @param fs
	 *            The statement to add
	 */
	public void addFlowStatement(FlowStatement fs) {
		if (fs.getAssignee().equals(this.assignee))
			this.statements.add(fs);
		else {
			// This should really throw an exception...
			System.err.println("Assignee's don't match...");
		}
	}

	/**
	 * Get the flow statements which make up this typed expression
	 * 
	 * @return A Vector of FlowStatement
	 */
	public Vector<FlowStatement> getFlowStatements() {
		return this.statements;
	}

	/**
	 * Test for presence in the right hand side
	 * 
	 * @param name
	 *            The name to test
	 * @return true if name appears in the right hand side of this statement
	 */
	public boolean inRightHandSide(String name) {
		for (int i = 0; i < this.statements.size(); i++) {
			if ((this.statements.get(i)).inRightHandSide(name))
				return true;
		}
		return false;
	}

	/**
	 * Return a string representation of this statement
	 * 
	 * @return The string-i-fied version of this statement
	 */
	public String toString() {
		StringBuffer buff = new StringBuffer(this.assignee);
		buff.append("\n");
		for (int i = 0; i < this.statements.size(); i++) {
			buff.append("\t");
			buff.append(this.statements.get(i).toString());
			// buff.append(" ");
			// buff.append()
		}
		return buff.toString();
	}
}
