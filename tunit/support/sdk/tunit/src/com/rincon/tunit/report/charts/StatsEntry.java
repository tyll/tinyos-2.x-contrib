package com.rincon.tunit.report.charts;


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

import java.util.Date;

/**
 * An individual entry read from a statistics log file
 * @author David Moss
 *
 */
public class StatsEntry {

  private Date date;
  
  private long value1;

  private long value2;

  
  /**
   * 2-Dimensional constructor
   * 
   * @param myDate
   * @param units1
   * @param value1
   * @param units2
   * @param value2
   */
  public StatsEntry(Date myDate, long myValue1, long myValue2) {
    date = myDate;
    value1 = myValue1;
    value2 = myValue2;
  }

  /**
   * 1-dimensional constructor
   * 
   * @param myDate
   * @param units
   * @param value1
   */
  public StatsEntry(Date myDate, long myValue) {
    date = myDate;
    value1 = myValue;
  }

  public Date getDate() {
    return date;
  }

  public long getValue1() {
    return value1;
  }

  public long getValue2() {
    return value2;
  }
  
  
}
