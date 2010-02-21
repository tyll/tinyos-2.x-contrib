package com.rincon.tunit.parsers.makefile;

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

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertFalse;

import org.junit.Before;
import org.junit.Test;

import com.rincon.tunit.parsers.makefileparser.MakefileParser;

import junit.framework.JUnit4TestAdapter;

/**
 * 
 * @author David Moss
 *
 */
public class TestMakefileParser {

  /** Bad makefile */
  private File badMakefile;
  
  /** Good makefile */
  private File goodMakefile;
  
  public static junit.framework.Test suite() {
    return new JUnit4TestAdapter(TestMakefileParser.class);
  }
  
  @Before public void setUp() {
    badMakefile = new File("Bad.Makefile");
    goodMakefile = new File("Good.Makefile");
  }
  
  @Test public void testMakefilesExist() {
    assertTrue("Bad.Makefile doesn't exist", badMakefile.exists());
    assertTrue("Good.Makefile doesn't exist", goodMakefile.exists());
  }
  
  @Test public void testBadMakefile() {
    MakefileParser parser = new MakefileParser(badMakefile);
    assertFalse("Bad.Makefile says its compileable", parser.canCompile());
  }
  
  @Test public void testGoodMakefile() {
    MakefileParser parser = new MakefileParser(goodMakefile);
    assertTrue("Good.Makefile says it is not compilable", parser.canCompile());
  }
}