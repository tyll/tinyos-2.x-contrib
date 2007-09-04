package com.rincon.tunitfeedback;

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

import com.rincon.tunit.TUnit;
import com.rincon.tunit.run.RerunRegistry;
import com.rincon.tunitfeedback.poweroutlet.PowerOutletFeedback;

/**
 * Use some of TUnit's funtionality to parse the rerun registry file
 * and determine if any tests failed on our last run.  If tests failed, we
 * give feedback through some external method.  Like lava lamps for example.
 * Or we could be a little more complex and sinister, tracking down the person
 * who checked in code that caused the tests to fail.. but that would be tough.
 * 
 * @author David Moss
 *
 */
public class FeedbackGenerator {
  
  /** The implementation that will handle our feedback */
  private FeedbackHandler feedback;

  /** TUnit class to borrow some of its methods */
  private TUnit tunit;
  
  /**
   * Default Constructor
   * 
   */
  @SuppressWarnings("static-access")
  public FeedbackGenerator() {
    feedback = new PowerOutletFeedback();
    tunit = new TUnit(new String[]{});
  }
  
  /**
   * Constructor
   * @param feedbackHandler the feedback handler to use
   */
  public FeedbackGenerator(FeedbackHandler feedbackHandler) {
    feedback = feedbackHandler;
    tunit = new TUnit(new String[]{});
  }

  /**
   * Give feedback through our feedback mechanism based on the results of our
   * last TUnit test run
   *
   */
  @SuppressWarnings("static-access")
  public void giveFeedback() {
    RerunRegistry reruns = new RerunRegistry(tunit.getTunitDirectory());
    reruns.enableRerun();
    if (reruns.getTotalReruns() == 0) {
      feedback.testsPassed();
    } else {
      feedback.testsFailed();
    }
  }
}
