package com.rincon.tunit.run;

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

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertEquals;

import java.io.File;

import junit.framework.JUnit4TestAdapter;

import org.junit.Before;
import org.junit.Test;


public class TestRerunRegistry {

  private RerunRegistry rerun;
  
  public static junit.framework.Test suite() {
    return new JUnit4TestAdapter(TestRerunRegistry.class);
  }
  
  @Before public void setUp() {
    rerun = new RerunRegistry(new File(System.getProperty("user.dir")));
    rerun.clean();
  }
  
  
  /**
   * There is really only one test for this class, because it's static and it
   * prevents you from re-parsing the log file after you've parsed it once.
   * So we log a few failures, parse it back, and check what we got. The end.
   *
   */
  @Test public void testReruns() {
    rerun.logFailure("myPackage.id1");
    rerun.logFailure("myPackage.id2");
    rerun.logFailure("myReally.Long.Package.id3");
    
    rerun.enableRerun();
    
    assertEquals("Expected 3 reruns", 3, rerun.getTotalReruns());
    assertFalse("Shouldn't have run 'nullpackage'", rerun.shouldRun("nullpackage"));
    assertFalse("Shouldn't have run 'myPackage.id10'", rerun.shouldRun("myPackage.id10"));
    
    assertTrue("Should have run 'myPackage.id1'", rerun.shouldRun("myPackage.id1"));
    assertTrue("Should have run 'myPackage.id2'", rerun.shouldRun("myPackage.id2"));
    assertTrue("Should have run 'myReally.Long.Package.id3'", rerun.shouldRun("myReally.Long.Package.id3"));
    
  }
}
