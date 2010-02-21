package com.rincon.tunit.build;

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
import java.io.IOException;
import java.util.StringTokenizer;

import org.apache.log4j.Logger;

import com.rincon.tunit.exec.CmdExec;
import com.rincon.tunit.report.TestResult;

/**
 * Make implements the BuildInterface to compile a project using the make
 * system. The compile is successful if we can locate the phrase "bytes in ROM"
 * within the output. All output is included in the TUnitResult passed back.
 *
 * @author David Moss
 *
 */
public class Make implements BuildInterface {

  /** Logging */
  private static Logger log = Logger.getLogger(Make.class);

  /** Bytes in ROM */
  private long romBytes = 0;

  /** Bytes in RAM */
  private long ramBytes = 0;

  /** Text that was printed to the screen on make */
  private String appcLocation;

  /**
   * Constructor
   *
   */
  public Make() {
    log = Logger.getLogger(getClass());
  }

  /**
   * Compile the project for the given target with the given arguments from the
   * current working directory
   *
   * @param target
   *          The target to compile for
   * @param extras
   *          Arguments to pass into the build process
   * @return true if the project compiled correctly
   */
  public TestResult build(File buildDir, String target, String extras,
      String env) {
    log.trace("Entering make build");
    log.info("Building platform " + target + " in "
        + buildDir.getAbsolutePath());
    TestResult result;

    if(env == null) {
      env = "";
    }

    String buildArgs = target + " " + extras;
    String largeOutput;

    try {
      String[] display = CmdExec.runBlockingCommand(" make -C "
          + buildDir.getAbsolutePath().replace(File.separatorChar, '/') + " "
          + buildArgs, env);

      largeOutput = "";
      int exitVal = CmdExec.lastExitVal;
      boolean compileSuccessful = false;

      if (extras.contains("reinstall")) {
        // Assume the reinstall was successful.. Is that a valid assumption?
        // Or, how can we test to see if it wasn't?
        compileSuccessful = (exitVal == 0);
        result = new TestResult("__Reinstall " + target + " " + extras);
        for (int i = 0; i < display.length; i++) {
          largeOutput += display[i] + "\n";
        }

      } else {
        for (int i = 0; i < display.length; i++) {
          largeOutput += display[i] + "\n";
          if (display[i].contains("bytes in ROM")) {
            log.info(display[i]);
            compileSuccessful = true;
            romBytes = parseBytes(display[i]);

          } else if (display[i].contains("bytes in RAM")) {
            log.info(display[i]);
            ramBytes = parseBytes(display[i]);
          }
        }

        result = new TestResult("__Build " + target + " " + extras + " " + env + " (ROM="
            + romBytes + "; RAM=" + ramBytes + ")");
      }

      log.info(largeOutput);

      String[] word = largeOutput.replace("=", " ").split(" ");
      for (int i = 0; i < word.length; i++) {
        if (word[i].contains("app.c")) {
          log.info("Found app.c in " + word[i]);
          appcLocation = word[i];
          break;
        }
      }

      if (!compileSuccessful) {
        result.error("Make Error", largeOutput);
      }

    } catch (IOException e) {
      log.fatal("Fatal error running make in " + System.getProperty("user.dir")
          + "\n" + e.getMessage() + "\n" + e.getStackTrace());
      result = new TestResult("__Build " + target + " " + extras);
      result.error("Compile Error", "Fatal error running make");
    }

    return result;
  }

  /**
   *
   * @return the approximate size of the compiled ROM
   */
  public long getRomSize() {
    return romBytes;
  }

  /**
   *
   * @return the approximate size of the compiled RAM
   */
  public long getRamSize() {
    return ramBytes;
  }

  /**
   * Erase and clean up any previous builds
   *
   */
  public TestResult clean(File buildDir) {
    log.trace("Entering make clean");
    log.info("Cleaning build files in " + buildDir.getAbsolutePath());

    TestResult result = new TestResult("__Clean");

    try {
      String[] display = CmdExec.runBlockingCommand("make -C "
          + buildDir.getAbsolutePath().replace(File.separatorChar, '/')
          + " clean");

      String largeOutput = "";
      for (int i = 0; i < display.length; i++) {
        largeOutput += display[i] + "\n";
      }

    } catch (IOException e) {
      log.fatal("Fatal error running clean in "
          + System.getProperty("user.dir") + "\n" + e.getMessage() + "\n"
          + e.getStackTrace());
      result.error("Clean Error", "Fatal error running clean");
    }

    return result;
  }

  /**
   * Parse the bytes out of a string coming from the compile command line. The
   * first token of the line happens to be the byte value we want
   *
   * @param compileLine
   * @return bytes first number found on the line
   */
  private long parseBytes(String compileLine) {
    return Long.decode(new StringTokenizer(compileLine).nextToken())
        .longValue();
  }

  /**
   *
   * @return "build/telosb/app.c" so you can tack it onto your build directory
   */
  public String getAppcLocation() {
    return appcLocation;
  }
}
