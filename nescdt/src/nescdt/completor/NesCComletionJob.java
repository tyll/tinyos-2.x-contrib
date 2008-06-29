package nescdt.completor;

import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.core.runtime.jobs.Job;

public class NesCComletionJob extends Job{

	public NesCComletionJob(String name) {
		super(name);
		// TODO Auto-generated constructor stub
	}

	@Override
	protected IStatus run(IProgressMonitor monitor) {
		
		
		
		NescParser.parse(monitor);
		
		
		
		return Status.OK_STATUS;
	}

}
