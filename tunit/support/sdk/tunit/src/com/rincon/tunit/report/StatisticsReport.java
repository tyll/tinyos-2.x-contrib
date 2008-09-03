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

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.apache.log4j.Logger;

import com.rincon.tunit.TUnit;
import com.rincon.tunit.report.charts.StatisticsLogData;
import com.rincon.tunit.report.charts.StatsEntry;

/**
 * Gathers all the test result information about a single test suite
 * 
 * @author David Moss
 * 
 */
public class StatisticsReport {

  /** Logging */
  private static Logger log = Logger.getLogger(StatisticsReport.class);

  /** The format our .csv file saves dates in */
  public static final String DATE_FORMAT = "MM/dd/yyyy k:mm";
  
  /**
   * Public method for logging two-dimensional results
   * @param packageId
   * @param name
   * @param units
   * @param value1
   * @param value2
   * @throws IOException 
   * @throws ParseException 
   */
  public static StatisticsLogData log(String testRunName, File buildDirectory, String name, String units1,
      long value1, String units2, long value2) throws IOException, ParseException {
    return log(testRunName, buildDirectory, name, units1, new Long(value1), units2, new Long(value2));
  }
  
  /**
   * Public method of logging one-dimensional results
   * 
   * @param packageId
   * @param name
   * @param units
   * @param value1
   * @throws IOException 
   * @throws ParseException 
   */
  public static StatisticsLogData log(String testRunName, File buildDirectory, String name, String units, long value1) throws IOException, ParseException {
    return log(testRunName, buildDirectory, name, units, new Long(value1), null, null);
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
   * @throws ParseException 
   */
  private static StatisticsLogData log(String testRunName, File buildDirectory, String name, String units1, Long value1,
      String units2, Long value2) throws IOException, ParseException {
    
    boolean newFile = false;
    
    File reportDir = new File(TUnit.getStatsReportDirectory(), generateStatsSubDirectory(testRunName, buildDirectory));
    reportDir.mkdirs();
    
    File reportFile = new File(reportDir, name + ".csv");
    log.info("Statistics log file: " + reportFile.getAbsolutePath());
    
    if (!reportFile.exists()) {
      newFile = true;
      try {
        reportFile.createNewFile();
      } catch (IOException e) {
        throw e;
      }
    }

    StatisticsLogData data = new StatisticsLogData(name, reportDir, units1, units2);
    
    if(units1 == null) {
      units1 = "[Units]";
    }
    
    if(units2 == null) {
      units2 = "[Units]";
    }

    log.info("LOGGING STATISTICS: ");
    log.info("Name = " + name); 
    log.info("Location = " + reportDir.getAbsolutePath());
    if(value1 != null) {
      log.info(units1 + " = " + value1.longValue());
    }
    if(value2 != null) {
      log.info(units2 + " = " + value2.longValue());
    }

    
    /*
     * Write the new entry to the file
     */
    try {
      BufferedWriter out = new BufferedWriter(new FileWriter(reportFile, true));
      if (newFile) {
        String logName = name;
        String columnNames = "Date";
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
      // the form "MM/dd/yyyy k:mm"

      String dateStamp = new SimpleDateFormat(DATE_FORMAT)
          .format(Calendar.getInstance().getTime());

      out.write(dateStamp);
      
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
    
    
    /*
     * Read back all entries from the file and into our StatisticsLogData
     */
    try {
      BufferedReader in = new BufferedReader(new FileReader(reportFile));
      String line;
      line = in.readLine(); // The title
      line = in.readLine(); // The units
      
      while ((line = in.readLine()) != null) {
        if(line.contains(",")) {
          data.addEntry(parseEntry(line));
        }
      }
      
      in.close();
      
    } catch (IOException e) {
      throw e;
    }
    
    return data;
  }

  /**
   * Create a string containing the name of the statistics sub-directory
   * where statistics information will be stored.  
   * 
   * This method keeps the tinyos-2/x/ structure but is compatible with our
   * external post TUnit HTML processing based on package name.
   * 
   * @param packageId
   * @return
   */
  public static String generateStatsSubDirectory(String testRunName, File buildDirectory) {
    String directory = "";
    
    if(testRunName == null) {
      testRunName = "";
    }
    
    if(buildDirectory == null) {
      return testRunName;
    }
    
    for(File currentDirectory = buildDirectory; currentDirectory.compareTo(TUnit.getBasePackageDirectory()) != 0; currentDirectory = currentDirectory.getParentFile()) {
      directory = currentDirectory.getName() + File.separatorChar + directory;
    }
    
    // The replaceAll here will turn tinyos-2.x into tinyos-2/x, but is
    // compatible with the post HTML editing performed externally that only
    // relies on a package name and doesn't understand the directory structure
    // it came from.
    return (testRunName + File.separatorChar + directory).replace('.', File.separatorChar);
  }
  

  /**
   * Parse a line from a .csv file into a StatsEntry object
   * @param line
   * @return
   * @throws ParseException 
   */
  private static StatsEntry parseEntry(String line) throws ParseException {
    String columns[] = line.split(",");
    
    DateFormat formatter = new SimpleDateFormat(DATE_FORMAT);
    Date date = (Date) formatter.parse(columns[0]);
    
    long value1 = Long.parseLong(columns[1]);
    
    if(columns.length == 3) {
      return new StatsEntry(date, value1, Long.parseLong(columns[2]));
    } else {
      return new StatsEntry(date, value1);
    }
  }
}
