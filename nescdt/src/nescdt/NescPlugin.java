package nescdt;

import nescdt.completor.NesCComletionJob;
import nescdt.completor.NescCompletionProcessor;
import nescdt.completor.NescParser;
import nescdt.constants.NescKeywords;
import nescdt.editor.NescFileChangeListener;

import org.eclipse.core.resources.IFolder;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IProjectDescription;
import org.eclipse.core.resources.IResourceChangeEvent;
import org.eclipse.core.resources.IResourceChangeListener;
import org.eclipse.core.resources.IWorkspace;
import org.eclipse.core.resources.IWorkspaceRoot;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.jface.resource.ImageDescriptor;
import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.osgi.framework.BundleContext;

/**
 * The activator class controls the plug-in life cycle
 */
public class NescPlugin extends AbstractUIPlugin {

	// The plug-in ID
	public static final String PLUGIN_ID = "nescdt";

	// The shared instance
	private static NescPlugin plugin;

	private static ColorManager colorManager;

	/**
	 * The completion processor, which scans the whole document and adds
	 * completion proposals to the tooltips.
	 */
	private static NescCompletionProcessor compProc;;

	public static NescCompletionProcessor getCompProc() {
		return compProc;
	}

	/**
	 * The constructor
	 */
	public NescPlugin() {
		// System.out.println("Starting");
		compProc = new NescCompletionProcessor();

		compProc.addProposals(NescKeywords.getKeyWordsasStringArray());
		new NesCComletionJob("Completion Scanner Job").schedule();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.eclipse.ui.plugin.AbstractUIPlugin#start(org.osgi.framework.BundleContext)
	 */
	public void start(BundleContext context) throws Exception {
		super.start(context);
		plugin = this;
		IWorkspace workspace = ResourcesPlugin.getWorkspace();
		IResourceChangeListener listener = new NescFileChangeListener();
		workspace.addResourceChangeListener(listener,
				IResourceChangeEvent.POST_CHANGE);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.eclipse.ui.plugin.AbstractUIPlugin#stop(org.osgi.framework.BundleContext)
	 */
	public void stop(BundleContext context) throws Exception {
		plugin = null;
		super.stop(context);
	}

	/**
	 * Returns the shared instance
	 * 
	 * @return the shared instance
	 */
	public static NescPlugin getDefault() {
		return plugin;
	}

	/**
	 * Returns an image descriptor for the image file at the given plug-in
	 * relative path
	 * 
	 * @param path
	 *            the path
	 * @return the image descriptor
	 */
	public static ImageDescriptor getImageDescriptor(String path) {
		return imageDescriptorFromPlugin(PLUGIN_ID, path);
	}

	public static ColorManager getColorManager() {
		return colorManager;
	}

	public static void setColorManager(ColorManager colorManager) {
		NescPlugin.colorManager = colorManager;
	}

	public static boolean isNescdtProject(IProject ip) {
		boolean res = false;
		IProjectDescription ipd = null;
		if (ip.exists() && ip.isOpen()) {
			try {
				ipd = ip.getDescription();
			} catch (CoreException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			if (ipd != null) {
				String nats[] = ipd.getNatureIds();

				for (int i = 0; i < nats.length; i++) {
					if (nats[i].equals(NescPlugin.getNatureID())) {
						res = true;
						break;
					}
				}
			}
		}
		return res;
	}

	public static String getNatureID() {
		return NescPlugin.PLUGIN_ID + ".nescdtNature";
	}

}
