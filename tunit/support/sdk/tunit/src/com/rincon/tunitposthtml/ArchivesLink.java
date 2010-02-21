package com.rincon.tunitposthtml;

/**
 *  
 * @author David
 *
 */
public class ArchivesLink {

  /** The address for the archives link on the HTML pages */
  private static String archives = null;
  
  
  /**
   * Parse the command line arguments to see if there is an argument to 
   * make a link to the archives directory, which may be different
   * from the location where we're storing the archives for the current build.
   * 
   * @param args
   */
  public static void parseArgs(String[] args) {
    for(int i = 0; i < args.length; i++) {
      if(args[i].contains("?")) {
        printSyntax();
      } else if(args[i].equalsIgnoreCase("-archivesLink")) {
        i++;
        
        if(i >= args.length) {
          printSyntax();
          System.exit(1);
        }
        
        archives = args[i];
        
        System.out.println("Setting the Archives link to " + archives);
      }
    }
  }
  
  /**
   * 
   * @return the link to the archives, null if it wasn't defined
   */
  public static String getArchivesLink() {
    return archives;
  }
  
  /**
   * Print some command line syntax
   *
   */
  public static void printSyntax() {
    System.out.println("PostHtmlEdit Syntax");
    System.out.println("\t-archivesLink [browser address]");
    System.out.println("\t\tThis edits/creates an HTML link that point to your archives.");
    System.out.println();
  }
}
