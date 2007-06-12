package com.rincon.tunit.report.charts;

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
