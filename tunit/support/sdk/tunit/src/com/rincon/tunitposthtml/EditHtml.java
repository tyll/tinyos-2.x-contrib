package com.rincon.tunitposthtml;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.PrintWriter;

import com.rincon.tunit.TUnit;

public class EditHtml {

  /**
   * Insert all the PNG's found in the png directory into the given HTML file
   * 
   * @param htmlFile
   * @param pngDir
   */
  public static void insert(File htmlFile, File pngDir) {
    if (!htmlFile.exists() || !htmlFile.isFile() || !pngDir.exists()) {
      System.err.println("Couln't locate one of the paths:");
      System.err.println(htmlFile.getAbsolutePath());
      System.err.println(pngDir.getAbsolutePath());
      return;
    }

    /*
     * 1. See if this HTML file even needs to be edited
     */
    File[] pngFiles = pngDir.listFiles(new FilenameFilter() {
      public boolean accept(File dir, String name) {
        return name.endsWith(".png");
      }
    });

    if (pngFiles.length == 0) {
      return;
    }
    
    /*
     * 2. Read in the current HTML file, without the </body> or </html> tags
     */
    String fileContents = "";

    try {
      BufferedReader in = new BufferedReader(new FileReader(htmlFile));
      String line;

      // Read in everything from the file except for </body> and </html>
      while ((line = in.readLine()) != null) {
        if (!line.contains("</body>") && !line.contains("</html>")) {
          fileContents += line + "\n";
        }
      }

      in.close();

    } catch (IOException e) {
      System.err.println(e.getMessage());
    }

    /*
     * 3. Add in image tags to our .png files
     */
    fileContents += "<center>\n";

    for (int i = 0; i < pngFiles.length; i++) {
      fileContents += "  <br><br>\n";
      fileContents += "  <img src=\"" + getRelativePath(htmlFile, pngFiles[i]) + "\">\n";
    }

    fileContents += "</center>\n";
    fileContents += "</body>\n";
    fileContents += "</html>\n";

    /*
     * Write the new file
     */
    try {
      PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(
          htmlFile)));
      out.write(fileContents);
      out.close();

    } catch (IOException e) {
      System.err.println(e.getMessage());
    }
  }
  
  /**
   * Produce a relative path 
   * @param htmlFile
   * @param pngFile
   * @return
   */
  private static String getRelativePath(File htmlFile, File pngFile) {
    File htmlPath = new File(htmlFile.getParent());
    
    String path = "";
    while(TUnit.getBaseReportDirectory().compareTo(htmlPath) != 0) {
      path += "../";
      htmlPath = new File(htmlPath.getParent());
    }
    
    path += pngFile.getAbsolutePath().substring(
        TUnit.getBaseReportDirectory().getAbsolutePath().length() + 1).replace('\\', '/');
    
    return path;
  }
  
}
