package nescdt.constants;

import nescdt.NescPlugin;

import org.eclipse.jface.resource.ImageDescriptor;

/**
 * Set of images that are used for decorating resources are maintained
 * here. The file type images can be placed in upper left corner. The safe notation 
 * image (diamond) is placed in the upper left corner. 
 */
public class NescImages
{
  /** nesC configuration image descriptor */ 
  public static final ImageDescriptor confDescriptor 
  = NescPlugin.getImageDescriptor("icons/conf.gif");
  
  /** nesC generic configuration image descriptor */
  public static final ImageDescriptor genconfDescriptor 
  = NescPlugin.getImageDescriptor("icons/genconf.gif");
  
  /** nesC module image descriptor */
  public static final ImageDescriptor modDescriptor 
  = NescPlugin.getImageDescriptor("icons/mod.gif");
  
  /** nesC generic module image descriptor */
  public static final ImageDescriptor genmodDescriptor 
  = NescPlugin.getImageDescriptor("icons/genmod.gif");
  
  /** nesC interface image descriptor */
  public static final ImageDescriptor interDescriptor 
  = NescPlugin.getImageDescriptor("icons/inter.gif");
  
  /** nesC safe notation image descriptor */
  public static final ImageDescriptor safeDescriptor 
  = NescPlugin.getImageDescriptor("icons/safe.gif");
  
  /** nesC project folder image descriptor */
  public static final ImageDescriptor projDescriptor 
  = NescPlugin.getImageDescriptor("icons/proj.gif");
}
