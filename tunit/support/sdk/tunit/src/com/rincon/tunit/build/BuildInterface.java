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

import com.rincon.tunit.report.TestResult;

/**
 * Implement different build methods by using this interface.
 * The build implementation is not responsible for determining whether or not
 * the target platform or arguments is valid.  It is responsible for running
 * the command, building the project, gathering results as much as it can,
 * and returning information about whether or not the compile was successful.
 * @author David Moss
 *
 */
public interface BuildInterface {
  
  /**
   * Compile the project for the given target with the given arguments
   * from the current working directory
   * @param buildDir The directory to build
   * @param target The target to compile for
   * @param extras Arguments to pass into the build process
   * @return true if the project compiled correctly
   */
  public TestResult build(File buildDir, String target, String extras, String env);
  
  /**
   * 
   * @return the approximate size of the compiled ROM, if it can be deduced
   */
  public long getRomSize();
  
  /**
   * 
   * @return the approximate size of the compiled RAM, if it can be deduced
   */
  public long getRamSize();
  
  /**
   * 
   * @return "build/telosb/app.c" so you can tack it onto your build directory
   */
  public String getAppcLocation();
  
  /**
   * Erase and clean up any previous builds
   *
   */
  public TestResult clean(File buildDir);

}
