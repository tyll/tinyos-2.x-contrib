package com.rincon.tunit.report.charts;

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
