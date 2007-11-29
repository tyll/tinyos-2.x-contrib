package com.rincon.tunit.report;

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

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.apache.log4j.Logger;

import com.rincon.tunit.TUnit;

/**
 * Gathers all the test result information about a single test suite
 * 
 * @author David Moss
 * 
 */
public class StatsReport {

  /** Logging */
  private static Logger log = Logger.getLogger(StatsReport.class);

  /**
   * Public method for logging two-dimensional results
   * @param packageId
   * @param name
   * @param units
   * @param value1
   * @param value2
   * @throws IOException 
   */
  public static void log(String packageId, String name, String units1,
      long value1, String units2, long value2) throws IOException {
    log(packageId, name, units1, new Long(value1), units2, new Long(value2));
  }
  
  /**
   * Public method of logging one-dimensional results
   * 
   * @param packageId
   * @param name
   * @param units
   * @param value1
   * @throws IOException 
   */
  public static void log(String packageId, String name, String units, long value1) throws IOException {
    log(packageId, name, units, new Long(value1), null, null);
  }

  
  /**
   * Log results
   * 
   * @param packageId
   * @param name
   * @param units
   * @param value11
   * @param value12
   * @throws IOException 
   */
  private static void log(String packageId, String name, String units1, Long value1,
      String units2, Long value2) throws IOException {
    
    boolean newFile = false;

    if(units1 == null) {
      units1 = "[Units]";
    }
    
    if(units2 == null) {
      units2 = "[Units]";
    }

    log.info("LOGGING STATISTICS: ");
    log.info("Name = " + name); 
    if(value1 != null) {
      log.info(units1 + " = " + value1.longValue());
    }
    if(value2 != null) {
      log.info(units2 + " = " + value2.longValue());
    }

    // TODO This replaces tinyos-2.x with tinyos-2/x!
    File reportDir = new File(TUnit.getStatsReportDirectory(), packageId
        .replace('.', File.separatorChar));
    reportDir.mkdirs();
    
    File reportFile = new File(reportDir, name + ".csv");
    if (!reportFile.exists()) {
      newFile = true;
      try {
        reportFile.createNewFile();
      } catch (IOException e) {
        throw e;
      }
    }

    try {
      BufferedWriter out = new BufferedWriter(new FileWriter(reportFile, true));
      if (newFile) {
        String logName = name;
        String columnNames = "Date,Time";
        if(value1 != null) {
          columnNames += "," + units1;
        }
        
        if(value2 != null) {
          columnNames += "," + units2;
        }
        
        out.write(logName + "\n");
        out.write(columnNames + "\n");
      }
      
      // Using Excel as a reference, it accepts CSV date/time formats of
      // the form "mm/dd/yyyy hh:mm" where the hours are 24-hour based.

      String dateStamp = new SimpleDateFormat("MM/dd/yyyy")
          .format(Calendar.getInstance().getTime());
      String timeStamp = new SimpleDateFormat("k:mm").format(Calendar.getInstance().getTime());

      out.write(dateStamp + "," + timeStamp);
      if(value1 != null) {
        out.write("," + value1.longValue());
      }
      
      if(value2 != null) {
        out.write("," + value2.longValue());
      }
      
      out.newLine();
      out.flush();
      out.close();

    } catch (IOException e) {
      throw e;
    }
  }

}
