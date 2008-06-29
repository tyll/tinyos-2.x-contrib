package nescdt.decorator;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IFolder;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IAdaptable;
import org.eclipse.jface.resource.ImageDescriptor;
import org.eclipse.jface.viewers.IDecoration;
import org.eclipse.jface.viewers.ILabelProviderListener;
import org.eclipse.jface.viewers.ILightweightLabelDecorator;
import org.eclipse.jface.viewers.LabelProvider;
import org.eclipse.jface.viewers.LabelProviderChangedEvent;
import org.eclipse.swt.widgets.Display;
import org.eclipse.ui.IDecoratorManager;

import nescdt.NescPlugin;
import nescdt.completor.NescParser;
import nescdt.constants.NescImages;
import nescdt.constants.NescKeywords;

/**
 * Decorates the navigator icons.
 */
public class NescLightWeightDecorator extends LabelProvider implements
		ILightweightLabelDecorator {
	/** The images for file type and safe code. */
	private static NescImages nescImages = new NescImages();

	private static NescLightWeightDecorator nescLigheWeightDecorator;

	// nc ressources with decorator
	private static HashMap ncRes = new HashMap();

	public NescLightWeightDecorator() {
		super();
		nescLigheWeightDecorator = this;
	}

	/**
	 * Gets the decoration manager for this plugin.
	 * 
	 * @return the decorator manager
	 */
	public static IDecoratorManager getDecorator() {
		IDecoratorManager decoratorManager = NescPlugin.getDefault()
				.getWorkbench().getDecoratorManager();
		return decoratorManager;
	}

	/**
	 * Get the static instance of DemoDecorator
	 * 
	 * @return Demo decorator object
	 */
	public static NescLightWeightDecorator getNescDecorator() {
		return nescLigheWeightDecorator;
	}

	/**
	 * This method is called lazily every time a folder containing file
	 * resources is expanded in a viewer like the Package Explorer or the
	 * Navigator. If the object is a <code>IResource.File</code> type then the
	 * extension is checked to see if it is a <code>nc</code> file. If that is
	 * a match then the overlay is added for the type of nc file (module,
	 * generic configuration etc.). This method also checks for safe annotation.
	 * 
	 * It is also reasonsible for decorating a project folder.
	 * 
	 * @see org.eclipse.jface.viewers.ILightweightLabelDecorator#decorate(java.lang.Object,
	 *      org.eclipse.jface.viewers.IDecoration)
	 */
	public void decorate(Object object, IDecoration decoration) {
		IResource objectResource;

		// Get the resource using the adaptable mechanism.
		objectResource = getResource(object);

		if (objectResource == null) {
			return;
		}

		if (objectResource.getType() == IResource.PROJECT) {
			IProject proj = (IProject) objectResource;
			if (NescPlugin.isNescdtProject(proj)) {
				ImageDescriptor imgnc = getNescProjectImage();
				if (imgnc != null) {
					decoration.addOverlay(imgnc, IDecoration.TOP_RIGHT);
				}
			}
		}

		if (objectResource.getType() == IResource.FILE) {
			IFile fileobj = (IFile) objectResource;
			String name = fileobj.getName();
			String ext = fileobj.getFileExtension();
			// System.out.println("file name:"+name);

			if (ext == null)
				return;
			// System.out.println(file=" + name + "." + ext);

			// only interested in nc files
			if (!ext.equalsIgnoreCase("nc")) {
				// System.out.println("Skipping non nc file");
				return;
			}

			// Parse
			NescParser.parse(fileobj);

			// the the correct image
			ImageDescriptor imgnc = getNescImageType(fileobj);

			// if we found the image then add the decoration overlay
			if (imgnc != null) {
				decoration.addOverlay(imgnc, IDecoration.TOP_LEFT);
				ncRes.put(fileobj, decoration);
			} else {
				// System.out.println("file nametes :"+name);
				// System.out.println("Image is null!");
			}

			// if the file is a safe type then we get the image
			imgnc = getNescSafeImageType(fileobj);

			// add the safe overlay if we have such a file
			if (imgnc != null) {
				decoration.addOverlay(imgnc, IDecoration.TOP_RIGHT);
				// System.out.println("safe file name :"+name);
			} else {
				// System.out.println("not a safe file name :"+name);
				// System.out.println("safe Image is null!");
			}

		}
	}

	private ImageDescriptor getNescProjectImage() {
		return NescImages.projDescriptor;
	}

	/**
	 * Decide which type the nc file is and return the corresponding image.
	 * 
	 * @param fileobj
	 *            the nc file
	 * @return the image
	 */
	private ImageDescriptor getNescImageType(IFile fileobj) {
		ImageDescriptor imgdescr = null;

		// read the nc file line by line and look for the file type like
		// "module" etc.
		try {
			BufferedReader nccontent = new BufferedReader(
					new InputStreamReader(fileobj.getContents()));
			try {
				// Read a line of the file as long as there are lines to read
				// or until it matches a rule
				imgdescr = null;
				String ncline;
				while ((ncline = nccontent.readLine()) != null) {
					if (ncline.trim().startsWith(NescKeywords.DECO_INTERFACE)) {
						imgdescr = NescImages.interDescriptor;
						break;
					} else if (ncline.trim().startsWith(
							NescKeywords.DECO_CONFIGURATION)) {
						imgdescr = NescImages.confDescriptor;
						break;
					} else if (ncline.trim().startsWith(
							NescKeywords.DECO_GENERIC_CONFIGURATION)) {
						imgdescr = NescImages.genconfDescriptor;
						break;
					} else if (ncline.trim().startsWith(
							NescKeywords.DECO_GENERIC_MODULE)) {
						imgdescr = NescImages.genmodDescriptor;
						break;
					} else if (ncline.trim().startsWith(
							NescKeywords.DECO_MODULE)) {
						imgdescr = NescImages.modDescriptor;
						break;
					}
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
			nccontent.close();
		} catch (CoreException ce) {
			ce.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return imgdescr;
	}

	/**
	 * Get the image for the safe type if the file has safe annotation.
	 * 
	 * @param fileobj
	 *            the nc file
	 * @return an image descriptor or null if the file is not safe
	 */
	private ImageDescriptor getNescSafeImageType(IFile fileobj) {
		ImageDescriptor imgdescr = null;
		try {
			BufferedReader nccontent = new BufferedReader(
					new InputStreamReader(fileobj.getContents()));
			try {
				// Read a line of the file as long as there are lines to read
				// or until it matches a rule
				imgdescr = null;
				String ncline;
				while ((ncline = nccontent.readLine()) != null) {
					if (ncline.trim().startsWith(NescKeywords.SAFE_COUNT)
							|| ncline.trim().startsWith(NescKeywords.SAFE_SAFE)
							|| ncline.trim().startsWith(NescKeywords.SAFE_SIZE)
							|| ncline.trim().startsWith(NescKeywords.AT_SAFE)) {
						imgdescr = NescImages.safeDescriptor;
						break;
					}
				}
				nccontent.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		} catch (CoreException ce) {
			ce.printStackTrace();
		}

		return imgdescr;
	}

	/**
	 * @see org.eclipse.jface.viewers.IBaseLabelProvider#addListener(org.eclipse.jface.viewers.ILabelProviderListener)
	 */
	public void addListener(ILabelProviderListener arg0) {

	}

	/**
	 * @see org.eclipse.jface.viewers.IBaseLabelProvider#dispose()
	 */
	public void dispose() {
		// Disposal of images present in the image registry can be performed in
		// this
		// method
	}

	/**
	 * @see org.eclipse.jface.viewers.IBaseLabelProvider#isLabelProperty(java.lang.Object,
	 *      java.lang.String)
	 */
	public boolean isLabelProperty(Object arg0, String arg1) {
		return false;
	}

	/**
	 * @see org.eclipse.jface.viewers.IBaseLabelProvider#removeListener(org.eclipse.jface.viewers.ILabelProviderListener)
	 */
	public void removeListener(ILabelProviderListener arg0) {
	}

	/**
	 * Refresh the project. This is used to refresh the label decorators of of
	 * the resources.
	 * 
	 */
	public void refresh() {

	}

	/**
	 * Refresh all the resources in the project
	 */
	public void refreshAll(boolean displayTextLabel, boolean displayProject) {

	}

	public void refresh(List resourcesToBeUpdated) {
		IFile[] ncFiles = (IFile[]) resourcesToBeUpdated.toArray();
		Iterator itr = resourcesToBeUpdated.iterator();
		while (itr.hasNext()) {
			IFile ncFile = (IFile) itr.next();
			if (ncRes.containsKey(ncFile)) {
				String name = ncFile.getName();
				System.out.println("file name:" + name);
				IDecoration decoration = (IDecoration) ncRes.get(ncFile);
				decoration.addOverlay(getNescImageType(ncFile));

			}

		}
		/*
		 * NescLightWeightDecorator nlwd = getNescDecorator(); fireLabelEvent(
		 * new LabelProviderChangedEvent( nlwd,
		 * resourcesToBeUpdated.toArray()));
		 */
	}

	public void refreshRes(final IFile ncFile) {
		/*
		 * if(ncRes.containsKey(ncFile)){ Display.getDefault().asyncExec(new
		 * Runnable() { public void run() { String name = ncFile.getName();
		 * System.out.println("file name:"+name); IDecoration decoration =
		 * (IDecoration)ncRes.get(ncFile);
		 * decoration.addOverlay(NescImages.ringDescriptor); } }); }
		 */
	}

	/**
	 * Fire a Label Change event so that the label decorators are automatically
	 * refreshed.
	 * 
	 * @param event
	 *            LabelProviderChangedEvent
	 */
	private void fireLabelEvent(final LabelProviderChangedEvent event) {
		// We need to get the thread of execution to fire the label provider
		// changed event , else WSWB complains of thread exception.
		Display.getDefault().asyncExec(new Runnable() {
			public void run() {
				fireLabelProviderChanged(event);
			}
		});
	}

	/**
	 * Returns the resource for the given input object, or null if there is no
	 * resource associated with it.
	 * 
	 * @param object
	 *            the object to find the resource for
	 * @return the resource for the given object, or null
	 */
	private IResource getResource(Object object) {
		if (object instanceof IResource) {
			return (IResource) object;
		}
		if (object instanceof IAdaptable) {
			return (IResource) ((IAdaptable) object)
					.getAdapter(IResource.class);
		}
		return null;
	}

}
