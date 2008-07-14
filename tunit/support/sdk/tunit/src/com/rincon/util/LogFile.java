package com.rincon.util;

import java.io.IOException;
import java.io.FileWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

/*
 * Copyright (c) 2004-2007 Rincon Research Corporation.  
 * All rights reserved.
 * 
 * Rincon Research will permit distribution and use by others subject to
 * the restrictions of a licensing agreement which contains (among other things)
 * the following restrictions:
 * 
 *  1. No credit will be taken for the Work of others.
 *  2. It will not be resold for a price in excess of reproduction and 
 *      distribution costs.
 *  3. Others are not restricted from copying it or using it except as 
 *      set forward in the licensing agreement.
 *  4. Commented source code of any modifications or additions will be 
 *      made available to Rincon Research on the same terms.
 *  5. This notice will remain intact and displayed prominently.
 * 
 * Copies of the complete licensing agreement may be obtained by contacting 
 * Rincon Research, 101 N. Wilmot, Suite 101, Tucson, AZ 85711.
 * 
 * There is no warranty with this product, either expressed or implied.  
 * Use at your own risk.  Rincon Research is not liable or responsible for 
 * damage or loss incurred or resulting from the use or misuse of this software.
 */

/**
 * Provides the ability to easily create an output log file for an application.
 * 
 * @author Jon Wyant (jrwy@rincon.com)
 * 
 */

public class LogFile {

  /** File Writer */
  private FileWriter log;

  /** log file name */
  private String fileName;

  /** current indent level */
  private int numIndent;

  /** number of spaces to use for an indent */
  private int spaces;

  /** flag specifying whether to have debug messages on or not */
  private boolean debug;

  /** flag specifying whether to flush output after each write or not */
  private boolean flush;

  /**
   * Constructor
   * 
   * @param String -
   *          log file name to open/create
   * @param boolean -
   *          false to overwrite/create file, true to append
   */
  public LogFile(String file, boolean mode) {
    fileName = file;
    numIndent = 0;
    spaces = 2; // default number of spaces to use for an indent
    debug = false; // default debug messages off
    try {
      log = new FileWriter(fileName, mode);
    } catch (IOException ioe) {
    }
  }

  /**
   * Write string message to the log file
   * 
   * @param String -
   *          string to write to the log file
   */
  public void write(String msg) {
    try {
      // if no new line added then add one
      if (!msg.endsWith("\n")) {
        msg += "\n";
      }

      // write message to file and flush instantly
      log.write(msg);

      // only flush each write if flag is set
      if (flush) {
        log.flush();
      }

      // display message to standard out if debug is on
      if (debug) {
        System.out.print(msg);
      }

    } catch (IOException ioe) {
    }
  }

  /**
   * Write string message to the log file using indents
   * 
   * @param String -
   *          string to write to the log file
   */
  public void iWrite(String msg) {
    String indentMsg = "";
    int i;

    // first print out the indents using spaces
    try {
      for (i = 0; i < numIndent * spaces; i++) {
        indentMsg += " ";
      }
      log.write(indentMsg);
    } catch (IOException ioe) {
    }

    // now print out the actual message
    write(msg);
  }

  /**
   * Write string message to the log file using indents
   * 
   * @param String -
   *          string to write to the log file
   * @param int -
   *          number of indents to print
   */
  public void iWrite(String msg, int indents) {
    String indentMsg = "";
    int i;

    // first print out the indents using spaces
    try {
      for (i = 0; i < indents * spaces; i++) {
        indentMsg += " ";
      }
      log.write(indentMsg);
    } catch (IOException ioe) {
    }

    // now print out the actual message
    write(msg);
  }

  /**
   * Get the current indent level being used
   * 
   * @return current indent level
   */
  public int getIndent() {
    return numIndent;
  }

  /**
   * Set the current indent level to use
   * 
   * @param int -
   *          indent level
   */
  public void setIndent(int indent) {
    numIndent = indent;
    if (numIndent < 0) {
      numIndent = 0;
    }
  }

  /**
   * Set the number of spaces to use for an indent
   * 
   * @param int -
   *          number of spaces to use for indents
   */
  public void setSpaces(int numSpaces) {
    spaces = numSpaces;
    if (spaces < 1) {
      spaces = 2;
    }
  }

  /**
   * Increments the current indent level by 1
   */
  public void incIndent() {
    numIndent++;
  }

  /**
   * Decrements the current indent level by 1
   */
  public void decIndent() {
    numIndent--;
    if (numIndent < 0) {
      numIndent = 0;
    }
  }

  /**
   * Returns a string containing the date and time in default format
   * 
   * @return a formated date/time String
   */
  public String DateTime() {
    return DateTime("MMM dd, yyyy, hh:mm:ss a");
  }

  /**
   * Returns a string containing the date and time using specified format
   * 
   * @param String -
   *          format string to use for date/time string
   */
  public String DateTime(String format) {
    SimpleDateFormat sdf = new SimpleDateFormat(format);
    return sdf.format(new Date());
  }

  /**
   * Close the log file
   */
  public void close() {
    try {
      log.close();
    } catch (IOException ioe) {
    }
  }

  /**
   * Sets debug mode on or off
   * 
   * @param boolean -
   *          true for debug on, false for debug off
   */
  public void debug(boolean mode) {
    debug = mode;
  }

  /**
   * Sets flush mode on or off
   * 
   * @param boolean -
   *          true for flush instantly, false for no flush
   */
  public void flush(boolean f) {
    flush = f;
  }

  /**
   * Clears the log file of all existing data
   */
  public void clearLog() {
    try {
      // close log file
      log.close();

      // re-open file
      log = new FileWriter(fileName, false);
    } catch (IOException ioe) {
    }
  }
}
