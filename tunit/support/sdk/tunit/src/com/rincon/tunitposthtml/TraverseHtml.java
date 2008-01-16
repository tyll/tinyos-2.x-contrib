package com.rincon.tunitposthtml;


/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

import java.io.File;
import java.io.FilenameFilter;

import com.rincon.tunit.TUnit;

/**
 * Recursively traverse through TUnitReport html output (from JUnit Report) and
 * add in TUnit's handsome .png charts to the HTML.  If we were in charge of the
 * JUnitReport source code, this would be built in.  But we're not, so we hack
 * it.
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
     * Oh, and so is the overview-frame.
     */
    if ((editFile = new File(htmlDir, "overview-frame.html")).exists()) {
      OverviewFrameEdit.hackTheOverviewFrame(editFile);
    }
    
    /*
     * Look for all HTML files that we would stick .png's into 
     */
    File[] htmlFiles = htmlDir.listFiles(new FilenameFilter() {
      public boolean accept(File dir, String name) {
        return name.contains("_") && name.endsWith(".html");
      }
    });

    if(htmlFiles == null) {
      System.err.println("No HTML files found!");
      System.err.println("Please run the ant tunitreport task to generate HTML files");
      System.exit(1);
    }
    
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
