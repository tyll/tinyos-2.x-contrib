package nescdt.editor;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import nescdt.decorator.NescLightWeightDecorator;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.IResourceChangeEvent;
import org.eclipse.core.resources.IResourceChangeListener;
import org.eclipse.core.resources.IResourceDelta;
import org.eclipse.core.resources.IResourceDeltaVisitor;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.swt.widgets.Display;


/**
 * Listens to Eclipse for changes to *.nc files. It monitors the post change event
 * for file resources. 
 */
public class NescFileChangeListener implements IResourceChangeListener {
	/**
	 * The changed event.
	 */
	public void resourceChanged(IResourceChangeEvent event) {

		//we are only interested in POST_CHANGE events
       if (event.getType() != IResourceChangeEvent.POST_CHANGE)
          return;
       
       IResourceDelta rootDelta = event.getDelta();

       if (rootDelta == null)
          return;

       final ArrayList changed = new ArrayList();

       IResourceDeltaVisitor visitor = new IResourceDeltaVisitor() {

    	   // The event kind is IResourceDelta.CHANGED all the time.
    	   // The rootDelta starts from the IResource.ROOT resource. Then it 
    	   // drills down to IResource.FOLDER and continues doing this until 
    	   // it reaches the folder where the changed .nc file is. The type of 
    	   // the .nc file is IResourceDelta.FILE and the IResourceDelta.CONTENT 
    	   // flag is set (using delta.getFlags), but it is not set for the IResource.FOLDER. 
    	   public boolean visit(IResourceDelta delta) {
        	 
    		 // Enable to see what is going on
    		 debugListener(delta);    		   
        	       	  
             //only interested in changed resources (not added or removed)
             if (delta.getKind() != IResourceDelta.CHANGED)
                return false;

             //only interested in content changes
             if ((delta.getFlags() & IResourceDelta.CONTENT) != 0) {
	             IResource resource = delta.getResource();
	             
	             //only interested in files with the "nc" extension
	             if (resource.getType() == IResource.FILE && 
					"nc".equalsIgnoreCase(resource.getFileExtension())) {
	            	IFile fileobj = (IFile)resource;
	                
	            	// Debug output
	            	//System.out.println("nc change:"+fileobj.getName()+":"+fileobj.getFileExtension());
	                NescLightWeightDecorator nlwd = NescLightWeightDecorator.getNescDecorator();
	                
	                if(nlwd != null){
	                	nlwd.refreshRes(fileobj);
	                }
	             }
	           
	             // done and the file does not have any children anyway
	             return false;
	           }
             
             // OK to look at children as this resourcedelta is of kind IResourceDelta.CHANGED
             return true;
          }
       };
       
       try {
          rootDelta.accept(visitor);
       } catch (CoreException e) {
          //open error dialog with syncExec or print to plugin log file
       }
       
       //nothing more to do if there were no changed text files
       if (changed.size() == 0)
          return;
       //post this update to the table
       /*
       Display display = table.getControl().getDisplay();
       
       if (!display.isDisposed()) {
          display.asyncExec(new Runnable() {
             public void run() {
                //make sure the table still exists
                if (table.getControl().isDisposed())
                   return;
                table.update(changed.toArray(), null);
             }
          });
       }
       */
    }
	
	// little helper method to see what it going on
 	void debugListener(IResourceDelta delta){ 
/* 		
	  System.out.println("visit, "
			 + " kind:" + delta.getKind()
			 + " type:" + delta.getResource().getType()
			 + " flags: " + delta.getFlags()
			 + " info: "+delta.getResource().toString()); 
	 
	  System.out.println(" (kind) IResourceDelta.CHANGED:" + IResourceDelta.CHANGED +
			 " (kind) IResourceDelta.CONTENT:" + IResourceDelta.CONTENT + 
			 " (type) IResource.ROOT:" + IResource.ROOT +
	         " (type) IResource.PROJECT:" + IResource.PROJECT +
			 " (type) IResource.FOLDER:" + IResource.FOLDER +
	         " (type) IResource.FILE:" + IResource.FILE+ 
	         " (flags) IResourceDelta.CONTENT:" + IResourceDelta.CONTENT);
*/
    }
 }