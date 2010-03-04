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

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

import com.rincon.tunit.TUnit;

/**
 * Add some TUnit links to the overview-frame.html stuff.
 * 
 * @author DEV
 * 
 */
public class OverviewFrameEdit {

  
  /**
   * This is just a hack, and nothing more.
   * 
   * @param htmlFile
   */
  public static void hackTheOverviewFrame(File htmlFile) {
    String fileContents = "";

    try {
      BufferedReader in = new BufferedReader(new FileReader(htmlFile));
      String line;
      String logo = "";

      while ((line = in.readLine()) != null) {
        if(line.contains("Home</a>")) {
          line += "<br><br>";
          line += "<a href=\"http://docs.tinyos.net/index.php/TUnit\" target=\"classFrame\">TUnit Documentation</a><br>";
          
          if(ArchivesLink.getArchivesLink() != null) {
            line += "<a href=\"" + ArchivesLink.getArchivesLink() + "\" target=\"classFrame\">Test Archives</a>";
          }
          
          // Undocumented features. Congrats on reading the code. 
          // Use this trick to skin your HTML reports.
          // Drop a file called "logo.jpg" into the /reports directory
          // before running the PostHtmlEdit app to generate the HTML for those
          // reports.
          if(new File(TUnit.getBaseReportDirectory(), "logo.jpg").exists()) {
            // Prepend the logo so it's at the top.
            line = "<center>"
              + "<a href=\"overview-summary.html\" target=\"classFrame\">" 
              + "<img src=\"./../logo.jpg\" BORDER=0>" 
              + "</a>"
              + "</center><br>" 
              + line;
          }
          
        }
        
        fileContents += line + "\n";        
      }

      in.close();

    } catch (IOException e) {
      System.err.println(e.getMessage());
    }

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
}
