package com.rincon.tunitposthtml;

import java.io.File;
import java.io.FilenameFilter;

import com.rincon.tunit.TUnit;

/**
 * Recursively traverse through TUnitReport html output (from JUnit Report) and
 * add in TUnit's handsome .png charts to the HTML.  If we were in charge of the
 * JUnitReport source code, this would be built in.  But we're not, so we hack
 * it.  Fortunately it's easy enough.
 * 
 * @author David Moss
 *
 */
public class TraverseHtml {

  public TraverseHtml(File htmlDir) {
    File editFile;

    /*
     * The overview-summary is a special case
     */
    if ((editFile = new File(htmlDir, "overview-summary.html")).exists()) {
      EditHtml.insert(editFile, TUnit.getStatsReportDirectory());
    }

    /*
     * Look for all HTML files that we would stick .png's into 
     */
    File[] htmlFiles = htmlDir.listFiles(new FilenameFilter() {
      public boolean accept(File dir, String name) {
        return name.contains("_") && name.endsWith(".html");
      }
    });

    /*
     * Locate the corresponding png directory for each HTML file, and insert
     * png's if we can.
     */
    File pngDir;
    for (int i = 0; i < htmlFiles.length; i++) {
      // Take a silly html filename and convert it to the final name of a 
      // directory on the stats side that would contain corresponding png files
      String finalDirName = htmlFiles[i].getName().replaceFirst("_", " ")
          .replace(".html", "").replace("-fails", "").replace("-errors", "")
          .split(" ")[1];

      // Take the png directory, replace the /html/ to /stats/ and look for
      // the final directory name we just calculated
      pngDir = new File(htmlFiles[i].getParent().replaceFirst("html", "stats"),
          finalDirName);
      
      EditHtml.insert(htmlFiles[i], pngDir);
    }

    /*
     * Locate sub-directories to our current directory
     */
    File[] subDirs = htmlDir.listFiles(new FilenameFilter() {
      public boolean accept(File dir, String name) {
        return new File(dir, name).isDirectory();
      }
    });

    /*
     * Traverse!
     */
    for (int i = 0; i < subDirs.length; i++) {
      new TraverseHtml(subDirs[i]);
    }
  }

}
