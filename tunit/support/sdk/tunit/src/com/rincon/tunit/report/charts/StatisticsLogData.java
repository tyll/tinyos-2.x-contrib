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

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * Contains all history information of a given statistics log
 * @author David Moss
 *
 */
public class StatisticsLogData {

  private String title;
  
  private File reportDir;
  
  private String units1;

  private String units2;

  private List statsEntries;
  
  
  /**
   * Plot two values per entry
   * 
   * @param myTitle
   * @param myUnits1
   * @param myUnits2 - can be null
   */
  public StatisticsLogData(String myTitle, File myReportDir, String myUnits1, String myUnits2) {
    title = myTitle;
    reportDir = myReportDir;
    units1 = myUnits1;
    units2 = myUnits2;
    statsEntries = new ArrayList();
  }
  
  @SuppressWarnings("unchecked")
  public void addEntry(StatsEntry entry) {
    statsEntries.add(entry);
  }
  
  public int size() {
    return statsEntries.size();
  }
  
  public StatsEntry get(int entry) {
    if(entry < statsEntries.size()) {
      return (StatsEntry) statsEntries.get(entry);
    } else {
      return null;
    }
  }
  
  public boolean hasTwoUnits() {
    return units2 != null;
  }
  
  public String getTitle() {
    return title;
  }
  
  public String getUnits1() {
    return units1;
  }
  
  public String getUnits2() {
    return units2;
  }

  public File getReportDir() {
    return reportDir;
  }
  
}
